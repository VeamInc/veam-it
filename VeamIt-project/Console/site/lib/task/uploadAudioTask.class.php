<?php

class uploadAudioTask extends sfBaseTask
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
    $this->name             = 'uploadAudio';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [uploadAudio|INFO] task does things.
Call it with:

  [php symfony uploadAudio|INFO]
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

		//status 0:waiting 1:encoded 2:failed 3:skipped 4:encoding
		$c = new Criteria() ;
		$c->add(AudioSourcePeer::STATUS,4) ;
		$audioSource = AudioSourcePeer::doSelectOne($c) ;
		if($audioSource){
			// There is a encoding audio source
		} else {
			$c = new Criteria() ;
			$c->add(AudioSourcePeer::STATUS,0) ; // waiting
			$c->addAscendingOrderByColumn(AudioSourcePeer::ID) ;
			$audioSource = AudioSourcePeer::doSelectOne($c) ;
			if($audioSource){
				$audioId = $audioSource->getAudioId() ;

				$c = new Criteria() ;
				$c->add(AudioSourcePeer::STATUS,0) ; // waiting
				$c->add(AudioSourcePeer::AUDIO_ID,$audioId) ;
				$c->addAscendingOrderByColumn(AudioSourcePeer::ID) ;
				$audioSources = AudioSourcePeer::doSelectOne($c) ;
				$count = count($audioSources) ;
				if($count > 1){
					// There are 
					for($index = 0 ; $index < ($count - 1) ; $index++){
						$skipAudioSource = $audioSources[$index] ;
						$skipAudioSource->setStatus(3) ; // skipped
						$skipAudioSource->save() ;
					}
					$audioSourceToBeEncoded = $audioSources[$count-1] ;
				} else {
					$audioSourceToBeEncoded = $audioSource ;
				}



				$appId = $audioSourceToBeEncoded->getAppId() ;
				$audioId = $audioSourceToBeEncoded->getAudioId() ;
				$audio = AudioPeer::retrieveByPk($audioId) ;
				if($audio){

				  	$c = new Criteria() ;
				  	$c->add(MixedPeer::DEL_FLG,0) ;
				  	$c->add(MixedPeer::CONTENT_ID,$audio->getId()) ;
				  	$c->add(MixedPeer::KIND,9) ;
				  	$c->addOr(MixedPeer::KIND,10) ;
					$mixed = MixedPeer::doSelectOne($c) ;
					if($mixed){
						$mixedId = $mixed->getId() ;
					} else {
						$mixedId = 0 ; 
					}



					$dataUrl = $audioSourceToBeEncoded->getDataUrl() ;
					if(!preg_match('/dl=1/',$dataUrl)){
						$dataUrl .= '?dl=1' ;
					}

					$linkDataSourceUrl = $audioSourceToBeEncoded->getLinkDataUrl() ;
					if(!preg_match('/dl=1/',$linkDataSourceUrl)){
						$linkDataSourceUrl .= '?dl=1' ;
					}

					$imageUrl = $audioSourceToBeEncoded->getImageUrl() ;
					if($imageUrl){
						$noImage = false ;
					} else {
						$noImage = true ;
					}
					if(!preg_match('/dl=1/',$imageUrl)){
						$imageUrl .= '?dl=1' ;
					}


					$commandDir = sprintf("%s/../../bin/audio",$libDir) ;


					// status ‚ð4(encoding)‚ÉØ‚è‘Ö‚¦
					$audioSourceToBeEncoded->setStatus(4) ;
					$audioSourceToBeEncoded->save() ;

					// encode
					//print(sprintf("encode %s %s %s",$audioSourceToBeEncoded->getId(),$audioSourceToBeEncoded->getAudioId(),$audioSourceToBeEncoded->getUrl())) ;
					$command = sprintf("perl %s/do_data_download.pl %s %s %s %s %s",$commandDir,$audioId,$mixedId,$dataUrl,$imageUrl,$linkDataSourceUrl) ;
					print("$command\n") ;
					system($command) ;

					//$encodedAudioFilePath = sprintf("%s/audio%s_SOURCE.dat",$commandDir,$audioId) ;
					$smallImageFilePath = sprintf("%s/image%s/i3.png",$commandDir,$audioId) ;
					$largeImageFilePath = sprintf("%s/image%s/i2.png",$commandDir,$audioId) ;
					$rectangleImageFilePath = sprintf("%s/image%s/i4.jpg",$commandDir,$audioId) ;
					$encodedAudioFilePath = sprintf("%s/audio%s_SOURCE.dat",$commandDir,$audioId) ;
					$linkDataFilePath = sprintf("%s/audio%s_LINK.dat",$commandDir,$audioId) ;
					$infoFilePath = sprintf("%s/audio%s_INFO.txt",$commandDir,$audioId) ;


					$linkDataUrl = "" ;
					if(file_exists($linkDataFilePath)){
						$fileSize = filesize($linkDataFilePath) ;
						if($fileSize > 0){
							$fileName = sprintf("a_%s_link_%s_%04d.dat",$audioId,date('YmdHis'),rand(0,9999)) ;
							$renamedLinkFilePath = sprintf("%s/%s",$commandDir,$fileName) ;
							rename($linkDataFilePath,$renamedLinkFilePath) ;

							$outputs = array() ;
							$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/audios',$commandDir,$renamedLinkFilePath,$appId) ;
							print("$commandLine\n") ;
							exec($commandLine,$outputs) ;

							if($outputs[0] == '1'){
								$linkDataUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/audios/%s",$appId,$fileName) ;
								print(sprintf('linkDataUrl=%s',$linkDataUrl));
							}
						}
					}

					if(file_exists($encodedAudioFilePath)){

						$info = file_get_contents($infoFilePath) ;
						//  Duration: 00:01:06.47
						preg_match('/Duration: ([0-9][0-9]):([0-9][0-9]):([0-9][0-9])/',$info,$matches) ;
						$duration = $matches[1] * 3600 + $matches[2] * 60 + $matches[3] ;


						$fileSize = filesize($encodedAudioFilePath) ;
						$fileName = sprintf("a%s_%s_%04d.dat",$audioId,date('YmdHis'),rand(0,9999)) ;
						$renamedAudioFilePath = sprintf("%s/%s",$commandDir,$fileName) ;
						rename($encodedAudioFilePath,$renamedAudioFilePath) ;

						$outputs = array() ;
						$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/audios',$commandDir,$renamedAudioFilePath,$appId) ;
						print("$commandLine\n") ;
						exec($commandLine,$outputs) ;

						if($outputs[0] == '1'){
							$audioUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/audios/%s",$appId,$fileName) ;
							print(sprintf('audioUrl=%s',$audioUrl));


							if(file_exists($smallImageFilePath)){
								$fileName = sprintf("s%s_%s_%04d.png",$audioId,date('YmdHis'),rand(0,9999)) ;
								$renamedSmallImageFilePath = sprintf("%s/image%s/%s",$commandDir,$audioId,$fileName) ;
								rename($smallImageFilePath,$renamedSmallImageFilePath) ;

								$outputs = array() ;
								$commandLine = sprintf('php %s/UploadToS3Directory.php %s audio/%s',$commandDir,$renamedSmallImageFilePath,$audioId) ;
								print("$commandLine\n") ;
								exec($commandLine,$outputs) ;
								if($outputs[0] == '1'){
									$smallImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/audio/%s/%s",$audioId,$fileName) ;
									print(sprintf('smallImageUrl=%s',$smallImageUrl));
								}
							}

							if(file_exists($largeImageFilePath)){
								$fileName = sprintf("l%s_%s_%04d.png",$audioId,date('YmdHis'),rand(0,9999)) ;
								$renamedLargeImageFilePath = sprintf("%s/image%s/%s",$commandDir,$audioId,$fileName) ;
								rename($largeImageFilePath,$renamedLargeImageFilePath) ;

								$outputs = array() ;
								$commandLine = sprintf('php %s/UploadToS3Directory.php %s audio/%s',$commandDir,$renamedLargeImageFilePath,$audioId) ;
								print("$commandLine\n") ;
								exec($commandLine,$outputs) ;
								if($outputs[0] == '1'){
									$largeImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/audio/%s/%s",$audioId,$fileName) ;
									print(sprintf('largeImageUrl=%s',$largeImageUrl));
								}
							}

							if(file_exists($rectangleImageFilePath)){
								$fileName = sprintf("r%s_%s_%04d.png",$audioId,date('YmdHis'),rand(0,9999)) ;
								$renamedRectangleImageFilePath = sprintf("%s/image%s/%s",$commandDir,$audioId,$fileName) ;
								rename($rectangleImageFilePath,$renamedRectangleImageFilePath) ;

								$outputs = array() ;
								$commandLine = sprintf('php %s/UploadToS3Directory.php %s audio/%s',$commandDir,$renamedRectangleImageFilePath,$audioId) ;
								print("$commandLine\n") ;
								exec($commandLine,$outputs) ;
								if($outputs[0] == '1'){
									$rectangleImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/audio/%s/%s",$audioId,$fileName) ;
									print(sprintf('rectangleImageUrl=%s',$rectangleImageUrl));
								}
							}


							//$audio->setDuration($duration) ;
							$audio->setDataUrl($audioUrl) ;
							$audio->setDataSize($fileSize) ;
							$audio->setLinkUrl($linkDataUrl) ;
							if($largeImageUrl){
								if(!$noImage){
									$audio->setImageUrl($largeImageUrl) ;
								}
							}
							if($rectangleImageUrl){
								if(!$noImage){
									$audio->setRectangleImageUrl($rectangleImageUrl) ;
								}
							}
							if($duration){
								$audio->setDuration($duration) ;
							}
							$audio->save() ;

							if($mixed){
								if($smallImageUrl){
									if(!$noImage){
										$mixed->setThumbnailUrl($smallImageUrl) ;
									}
								}
								$mixed->setStatus(0) ; // Ready
								$mixed->save() ;
							}


							// set sellAudio status
							$c = new Criteria() ;
							$c->add(SellAudioPeer::STATUS,2) ; // preparing
							$c->add(SellAudioPeer::AUDIO_ID,$audioId) ;
							$sellAudios = SellAudioPeer::doSelect($c) ;
							foreach($sellAudios as $sellAudio){
								$sellAudio->setStatus(3) ; // Submitting
								$sellAudio->setStatusText('Waiting for approval') ; // Submitting
								$sellAudio->save() ;

								$app = AppPeer::retrieveByPk($appId) ;
								if($app){
									if($app->getStatus() == 0){
										$appName = $app->getName() ;
										$title = $audio->getTitle() ;
										$productId = $sellAudio->getProduct() ;
										$priceText = $sellAudio->getPriceText() ;

										$message = sprintf("The following content has been uploaded.\n\nApp : %s \nKind : Audio \nTitle : %s \nPrice : %s \nProductID : %s \n",$appName,$title,$priceText,$productId) ;
										ConsoleTools::sendInfoMail("[VEAMIT] PPC content uploaded","ppc_notification@veam.co",$message) ;
									}
								}
							}

							// set sellSectionItem status
							$c = new Criteria() ;
							$c->add(SellSectionItemPeer::STATUS,2) ; // preparing
							$c->add(SellSectionItemPeer::KIND,3) ; // Audio
							$c->add(SellSectionItemPeer::CONTENT_ID,$audioId) ;
							$sellSectionItems = SellSectionItemPeer::doSelect($c) ;
							foreach($sellSectionItems as $sellSectionItem){
								$sellSectionItem->setStatus(0) ; // Ready
								$sellSectionItem->setStatusText('Ready') ; // 
								$sellSectionItem->save() ;
							}



							$audioSourceToBeEncoded->setStatus(1) ;
							//$audioSourceToBeEncoded->setInfo($info) ;
							$audioSourceToBeEncoded->save() ;

							ConsoleTools::consoleContentsChanged($audioSourceToBeEncoded->getAppId()) ;

						} else {
							print(sprintf('result=%s',implode(" - ",$outputs)));
							$audioSourceToBeEncoded->setStatus(2) ; // failed
							$audioSourceToBeEncoded->setResult(sprintf('upload failed %s:%d',__FILE__,__LINE__)) ;
							$audioSourceToBeEncoded->save() ;
						}
						unlink($renamedAudioFilePath) ;
						unlink($renamedLinkFilePath) ;
					} else {
						// no encoded file
						$audioSourceToBeEncoded->setStatus(2) ; // failed
						$audioSourceToBeEncoded->setResult(sprintf('no encoded file %s:%d',__FILE__,__LINE__)) ;
						$audioSourceToBeEncoded->save() ;
						//ConsoleTools::assert(false,"Failed to encode",__FILE__,__LINE__) ;
						ConsoleTools::assert(false,sprintf("Failed to encode\n\naudio url=%s\n\napp=%s\n\naudioId=%s",$dataUrl,$appId,$audioId),__FILE__,__LINE__) ;
					}
					// send result mail
				} else {
					// no audio found
					$audioSourceToBeEncoded->setStatus(3) ; // skipped
					$audioSourceToBeEncoded->setResult(sprintf('no audio found %s:%d',__FILE__,__LINE__)) ;
					$audioSourceToBeEncoded->save() ;
				}
			} else {
				// no audio source to be encoded
			}
		}
	}


}
