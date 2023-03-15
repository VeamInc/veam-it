<?php

class encodeVideoTask extends sfBaseTask
{
  protected function configure()
  {
    // // add your own arguments here
    // $this->addArguments(array(
    //   new sfCommandArgument('my_arg', sfCommandArgument::REQUIRED, 'My argument'),
    // ));

    $this->addOptions(array(
      new sfCommandOption('application', null, sfCommandOption::PARAMETER_REQUIRED, 'The application name'),
      new sfCommandOption('env', null, sfCommandOption::PARAMETER_REQUIRED, 'The environment', 'dev'),
      new sfCommandOption('connection', null, sfCommandOption::PARAMETER_REQUIRED, 'The connection name', 'propel'),
      // add your own options here
    ));

    $this->namespace        = '';
    $this->name             = 'encodeVideo';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [encodeVideo|INFO] task does things.
Call it with:

  [php symfony encodeVideo|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$libDir = sfConfig::get("sf_lib_dir") ; 
		preg_match('/console.*\.veam.co/',$libDir,$matches) ;

		$_SERVER['SERVER_NAME'] = $matches[0] ;



		// upload check
		$c = new Criteria() ;
		$c->add(VideoSourcePeer::STATUS,5) ; // uploading
		$c->addAscendingOrderByColumn(VideoSourcePeer::ID) ;
		$videoSources = VideoSourcePeer::doSelect($c) ;
		if($videoSources){
			$commandDir = sprintf("%s/../../bin/encode",$libDir) ;
			foreach($videoSources as $videoSource){
				$filePath = sprintf('%s/%s_%s',$commandDir,$videoSource->getAppId(),$videoSource->getUrl()) ;
				if(file_exists($filePath)){
					$videoSource->setStatus(0) ; // waiting
					$videoSource->save() ;
				}
			}
		}


		//status 0:waiting 1:encoded 2:failed 3:skipped 4:encoding 5:uploading
		$c = new Criteria() ;
		$c->add(VideoSourcePeer::STATUS,4) ;
		$videoSource = VideoSourcePeer::doSelectOne($c) ;
		if($videoSource){
			// There is a encoding video source
		} else {
			$c = new Criteria() ;
			$c->add(VideoSourcePeer::STATUS,0) ; // waiting
			$c->addAscendingOrderByColumn(VideoSourcePeer::ID) ;
			$videoSource = VideoSourcePeer::doSelectOne($c) ;
			if($videoSource){
				$videoId = $videoSource->getVideoId() ;

				$c = new Criteria() ;
				$c->add(VideoSourcePeer::STATUS,0) ; // waiting
				$c->add(VideoSourcePeer::VIDEO_ID,$videoId) ;
				$c->addAscendingOrderByColumn(VideoSourcePeer::ID) ;
				$videoSources = VideoSourcePeer::doSelectOne($c) ;
				$count = count($videoSources) ;
				if($count > 1){
					// There are 
					for($index = 0 ; $index < ($count - 1) ; $index++){
						$skipVideoSource = $videoSources[$index] ;
						$skipVideoSource->setStatus(3) ; // skipped
						$skipVideoSource->save() ;
					}
					$videoSourceToBeEncoded = $videoSources[$count-1] ;
				} else {
					$videoSourceToBeEncoded = $videoSource ;
				}



				$appId = $videoSourceToBeEncoded->getAppId() ;
				$videoId = $videoSourceToBeEncoded->getVideoId() ;
				$video = VideoPeer::retrieveByPk($videoId) ;
				if($video){
					$url = $videoSourceToBeEncoded->getUrl() ;
					if(preg_match('/^s/',$url)){
						$url = sprintf('%s_%s',$appId,$url) ;
					} else {
						if(!preg_match('/dl=1/',$url)){
							$url .= '?dl=1' ;
						}
					}

					$imageSourceUrl = $videoSourceToBeEncoded->getImageUrl() ;
					if($imageSourceUrl){
						if($imageSourceUrl != 'NOIMAGE'){
							if(!preg_match('/dl=1/',$imageSourceUrl)){
								$imageSourceUrl .= '?dl=1' ;
							}
						}
					}

					$commandDir = sprintf("%s/../../bin/encode",$libDir) ;


					// TODO status ‚ð4(encoding)‚ÉØ‚è‘Ö‚¦
					$videoSourceToBeEncoded->setStatus(4) ;
					$videoSourceToBeEncoded->save() ;


					$circleImageUrl = "" ;
					$rectangleImageUrl = "" ;
					if($imageSourceUrl){
						if($imageSourceUrl == 'NOIMAGE'){
							$command = sprintf("perl %s/do_make_image.pl %s %s",$commandDir,$videoId,$url) ;
							print("$command\n") ;
							system($command) ;
						} else {
							$command = sprintf("perl %s/do_crop_image.pl %s %s",$commandDir,$videoId,$imageSourceUrl) ;
							print("$command\n") ;
							system($command) ;
						}

						// circle
						$sourceImageFilePath = sprintf("%s/encoded/image%d.png",$commandDir,$videoId) ;
						if(file_exists($sourceImageFilePath)){

							$fileName = sprintf("i%s_%s_%04d.png",$videoId,date('YmdHis'),rand(0,9999)) ;
							$renamedImageFilePath = sprintf("%s/encoded/%s",$commandDir,$fileName) ;
							rename($sourceImageFilePath,$renamedImageFilePath) ;


							$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/videos',$commandDir,$renamedImageFilePath,$appId) ;
							print("$commandLine\n") ;
							exec($commandLine,$outputs) ;
							if($outputs[0] == '1'){
								$circleImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/videos/%s",$appId,$fileName) ;
								print(sprintf('imageUrl=%s',$circleImageUrl));
							}
							unlink($renamedImageFilePath) ;
						}

						// 240x180
						$sourceImageFilePath = sprintf("%s/encoded/image%d_16x9.jpg",$commandDir,$videoId) ;
						if(file_exists($sourceImageFilePath)){

							$rectangleImagefileSize = filesize($sourceImageFilePath) ;
							$fileName = sprintf("i%s_%s_%04d_16x9.jpg",$videoId,date('YmdHis'),rand(0,9999)) ;
							$renamedImageFilePath = sprintf("%s/encoded/%s",$commandDir,$fileName) ;
							rename($sourceImageFilePath,$renamedImageFilePath) ;


							$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/videos',$commandDir,$renamedImageFilePath,$appId) ;
							print("$commandLine\n") ;
							exec($commandLine,$outputs) ;
							if($outputs[0] == '1'){
								$rectangleImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/videos/%s",$appId,$fileName) ;
								print(sprintf('imageUrl=%s',$rectangleImageUrl));
							}
							unlink($renamedImageFilePath) ;
						}

					}

					// encode
					//print(sprintf("encode %s %s %s",$videoSourceToBeEncoded->getId(),$videoSourceToBeEncoded->getVideoId(),$videoSourceToBeEncoded->getUrl())) ;
					$command = sprintf("perl %s/do_encode.pl %s %s",$commandDir,$videoId,$url) ;
					print("$command\n") ;
					system($command) ;

					$videoFilePath = sprintf("%s/encoded/p%s.mp4",$commandDir,$videoId) ;
					$infoFilePath = sprintf("%s/encoded/p%s.txt",$commandDir,$videoId) ;
					$outputs = array() ;
					$commandLine = sprintf('ffmpeg -i %s 2> %s',$videoFilePath,$infoFilePath) ;
					print("$commandLine\n") ;
					exec($commandLine,$outputs) ;
					$info = file_get_contents($infoFilePath) ;

					//  Duration: 00:01:06.47
					preg_match('/Duration: ([0-9][0-9]):([0-9][0-9]):([0-9][0-9])/',$info,$matches) ;
					$duration = $matches[1] * 3600 + $matches[2] * 60 + $matches[3] ;


					$encodedVideoFilePath = sprintf("%s/encoded/p%s.mp4.AES",$commandDir,$videoId) ;
					if(file_exists($encodedVideoFilePath)){
						$encodedKeyFilePath = sprintf("%s/encoded/p%s.mp4.KEY",$commandDir,$videoId) ;
						if(file_exists($encodedKeyFilePath)){
							$key = file_get_contents($encodedKeyFilePath) ;
							$fileSize = filesize($encodedVideoFilePath) ;

							$fileName = sprintf("p%s_%s_%04d.mp4.AES",$videoId,date('YmdHis'),rand(0,9999)) ;
							$renamedVideoFilePath = sprintf("%s/encoded/%s",$commandDir,$fileName) ;
							rename($encodedVideoFilePath,$renamedVideoFilePath) ;

							$outputs = array() ;
							$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/videos',$commandDir,$renamedVideoFilePath,$appId) ;

							print("$commandLine\n") ;
							exec($commandLine,$outputs) ;
							if($outputs[0] == '1'){
								$videoUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/videos/%s",$appId,$fileName) ;
								print(sprintf('videoUrl=%s',$videoUrl));

								$video->setDuration($duration) ;
								$video->setDrmPreviewUrl($videoUrl) ;
								$video->setDrmPreviewSize($fileSize) ;
								$video->setDrmPreviewKey($key) ;
								$video->setStatus(0) ; // Ready

								// set mixed status
								$c = new Criteria() ;
								$c->add(MixedPeer::STATUS,2) ; // preparing
								$c->add(MixedPeer::CONTENT_ID,$videoId) ;
								$c->add(MixedPeer::KIND,array(5,7,8),Criteria::IN) ;
								$mixeds = MixedPeer::doSelect($c) ;
								foreach($mixeds as $mixed){
									$mixed->setStatus(0) ; // Ready
									if($circleImageUrl){
										$mixed->setThumbnailUrl($circleImageUrl) ;
									}
									$mixed->save() ;
								}


								// set sellVideo status
								$c = new Criteria() ;
								$c->add(SellVideoPeer::STATUS,2) ; // preparing
								$c->add(SellVideoPeer::VIDEO_ID,$videoId) ;
								$sellVideos = SellVideoPeer::doSelect($c) ;
								foreach($sellVideos as $sellVideo){
									$sellVideo->setStatus(3) ; // Submitting
									$sellVideo->setStatusText('Waiting for approval') ; // Submitting
									if($rectangleImageUrl){
										$video->setThumbnailUrl($rectangleImageUrl) ;
										$video->setThumbnailSize($rectangleImagefileSize) ;
									}
									$sellVideo->save() ;

									$app = AppPeer::retrieveByPk($appId) ;
									if($app){
										if($app->getStatus() == 0){
											$appName = $app->getName() ;
											$title = $video->getTitle() ;
											$productId = $sellVideo->getProduct() ;
											$priceText = $sellVideo->getPriceText() ;

											$message = sprintf("The following content has been uploaded.\n\nApp : %s \nKind : Video \nTitle : %s \nPrice : %s \nProductID : %s \n",$appName,$title,$priceText,$productId) ;
											ConsoleTools::sendInfoMail("[VEAMIT] PPC content uploaded","ppc_notification@veam.co",$message) ;
										}
									}
								}

								// set sellSectionItem status
								$c = new Criteria() ;
								$c->add(SellSectionItemPeer::STATUS,2) ; // preparing
								$c->add(SellSectionItemPeer::KIND,1) ; // Video
								$c->add(SellSectionItemPeer::CONTENT_ID,$videoId) ;
								$sellSectionItems = SellSectionItemPeer::doSelect($c) ;
								foreach($sellSectionItems as $sellSectionItem){
									$sellSectionItem->setStatus(0) ; // Ready
									$sellSectionItem->setStatusText('Ready') ; // 
									if($rectangleImageUrl){
										$video->setThumbnailUrl($rectangleImageUrl) ;
										$video->setThumbnailSize($rectangleImagefileSize) ;
									}
									$sellSectionItem->save() ;
								}

								$video->save() ;


								$videoSourceToBeEncoded->setStatus(1) ;
								$videoSourceToBeEncoded->setInfo($info) ;
								$videoSourceToBeEncoded->save() ;

								ConsoleTools::consoleContentsChanged($videoSourceToBeEncoded->getAppId()) ;

							} else {
								print(sprintf('result=%s',implode(" - ",$outputs)));
								$videoSourceToBeEncoded->setStatus(2) ; // failed
								$videoSourceToBeEncoded->setResult(sprintf('upload failed %s:%d',__FILE__,__LINE__)) ;
								$videoSourceToBeEncoded->save() ;
							}
							unlink($renamedVideoFilePath) ;
						}
					} else {
						// no encoded file
						$videoSourceToBeEncoded->setStatus(2) ; // failed
						$videoSourceToBeEncoded->setResult(sprintf('no encoded file %s:%d',__FILE__,__LINE__)) ;
						$videoSourceToBeEncoded->save() ;
						//ConsoleTools::assert(false,"Failed to encode",__FILE__,__LINE__) ;
						ConsoleTools::assert(false,sprintf("Failed to encode\n\nvideo url=%s\n\napp=%s\n\nvideoId=%s",$url,$appId,$videoId),__FILE__,__LINE__) ;
					}
					// send result mail
				} else {
					// no video found
					$videoSourceToBeEncoded->setStatus(3) ; // skipped
					$videoSourceToBeEncoded->setResult(sprintf('no video found %s:%d',__FILE__,__LINE__)) ;
					$videoSourceToBeEncoded->save() ;
				}
			} else {
				// no video source to be encoded
			}
		}
	}


}
