<?php

class updateScreenshotTask extends sfBaseTask
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
      new sfCommandOption('command_id', null, sfCommandOption::PARAMETER_REQUIRED, 'Remote Command ID', 0),
    ));

    $this->namespace        = '';
    $this->name             = 'updateScreenshot';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [updateScreenshot|INFO] task does things.
Call it with:

  [php symfony updateScreenshot|INFO]
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
	$commandDir = sprintf("%s/../../bin/image",$libDir) ;

	$remoteCommandId = $options['command_id'] ;


  	$c = new Criteria() ;
  	$c->add(RemoteCommandPeer::ID,$remoteCommandId) ;
  	$c->add(RemoteCommandPeer::STATUS,0) ;
	$remoteCommand = RemoteCommandPeer::doSelectOne($c) ;
	if($remoteCommand){
		$commandName = $remoteCommand->getName() ;
		$appId = $remoteCommand->getAppId() ;
		$retry = 0 ;
		do {
			if($retry > 0){
				sleep(5) ;
			}
			$workingRemoteCommandCount = 0 ;

		  	$c = new Criteria() ;
		  	$c->add(RemoteCommandPeer::APP_ID,$appId) ;
		  	$c->add(RemoteCommandPeer::NAME,'UPDATE_CONCEPT_COLOR') ;
		  	$c->add(RemoteCommandPeer::STATUS,array(0,3),Criteria::IN) ;
			$workingRemoteCommand = RemoteCommandPeer::doSelectOne($c) ;
			if($workingRemoteCommand){
				$workingRemoteCommandCount++ ;
			}

			if($workingRemoteCommandCount == 0){
			  	$c = new Criteria() ;
			  	$c->add(RemoteCommandPeer::APP_ID,$appId) ;
			  	$c->add(RemoteCommandPeer::STATUS,3) ;
				$workingRemoteCommand = RemoteCommandPeer::doSelectOne($c) ;
				if($workingRemoteCommand){
					$workingRemoteCommandCount++ ;
				}
			}

			$retry++ ;
		} while(($workingRemoteCommandCount > 0) && ($retry < 100)) ;


		if($workingRemoteCommand){
			ConsoleTools::assert(false,sprintf("remote command is still working commandname=%s id=%s appid=%s",$commandName,$remoteCommandId,$appId),__FILE__,__LINE__) ;
		} else {

			$remoteCommand->setStatus(3) ; // executing
			$remoteCommand->save() ;

			$status = 1 ;
			$result = '' ;

			$appId = $remoteCommand->getAppId() ;
			$ssConfig = "" ;

			$configImages = array(
				'initial_background.png'	=>	'SPLASH',
				'background.png'			=>	'BACKGROUND',
				't1_top_right.png'			=>	'YOUTUBE_RIGHT',
			) ;

			$pngFileNames = array() ;
			foreach($configImages as $imageFileName => $imageName){
				$pngFileNames[] = $imageFileName ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
		  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
		  	$c->add(AlternativeImagePeer::FILE_NAME,$pngFileNames,Criteria::IN) ;
			$alternativeImages = AlternativeImagePeer::doSelect($c) ;
			$imageUrlMap = array() ;
			foreach($alternativeImages as $alternativeImage){
				$fileName = $alternativeImage->getFileName() ;
				if($configImages[$fileName]){
					$ssConfig .= sprintf("%s=%s\n",$configImages[$fileName],$alternativeImage->getUrl()) ;
				}
			}

		  	$c = new Criteria() ;
		  	$c->add(MixedPeer::DEL_FLG,0) ;
		  	$c->add(MixedPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(MixedPeer::ID) ;
			$mixeds = MixedPeer::doSelect($c) ;
			if($mixeds){
				$mixedIndex = 0 ;
				foreach($mixeds as $mixed){
					$mixedIndex++ ;
					if($mixedIndex > 2){
						break ;
					}
					$thumbnailUrl = $mixed->getThumbnailUrl() ;
					if($thumbnailUrl){
						$ssConfig .= sprintf("GRID%d=%s\n",$mixedIndex,$thumbnailUrl) ;
					}
				}
			}

		  	$c = new Criteria() ;
		  	$c->add(AudioPeer::DEL_FLG,0) ;
		  	$c->add(AudioPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(AudioPeer::ID) ;
			$audios = AudioPeer::doSelect($c) ;
			if($audios){
				foreach($audios as $audio){
					$thumbnailUrl = $audio->getImageUrl() ;
					if($thumbnailUrl){
						$ssConfig .= sprintf("AUDIO1=%s\n",$thumbnailUrl) ;
						break ;
					}
				}
			}


		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
		  	$c->add(ForumPeer::DISPLAY_ORDER,0,Criteria::GREATER_THAN) ;
			$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
			$forums = ForumPeer::doSelect($c) ;
			if($forums){
				$forumString = '' ;
				foreach($forums as $forum){
					if($forumString){
						$forumString .= '|' ;
					}
					$forumName = AdminTools::unescapeName($forum->getName()) ;
					$forumString .= $forumName ;
				}
				$ssConfig .= sprintf("FORUMS=%s\n",$forumString) ;
			}


		  	$c = new Criteria() ;
		  	$c->add(CategoryPeer::DEL_FLG,0) ;
		  	$c->add(CategoryPeer::DISABLED,0) ;
		  	$c->add(CategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
			$categories = CategoryPeer::doSelect($c) ;
			if($categories){
				$categoryString = '' ;
				foreach($categories as $category){
					if($categoryString){
						$categoryString .= '|' ;
					}
					$categoryName = AdminTools::unescapeName($category->getName()) ;
					$categoryString .= $categoryName ;
				}
				$ssConfig .= sprintf("YOUTUBES=%s\n",$categoryString) ;
			}




			$configPath = sprintf("%s/%s/ss_config.txt",$commandDir,$appId) ;
			file_put_contents($configPath,$ssConfig) ;

		  	$c = new Criteria() ;
		  	$c->add(AppColorPeer::DEL_FLG,0) ;
		  	$c->add(AppColorPeer::APP_ID,$appId) ;
		  	$c->add(AppColorPeer::NAME,'concept_color_argb') ;
			$appColor = AppColorPeer::doSelectOne($c) ;
			$conceptColor = substr($appColor->getColor(),2) ;

			$ssDir = sprintf('ss%s_%04d',date('YmdHis'),rand(0,9999)) ;

			$outputs = array() ;
	 		$commandLine = sprintf("perl %s/create_ss.pl %s %s %s",$commandDir,$appId,$conceptColor,$ssDir) ; // create_ss.pl 31000172 3D21FF ss2015021914075679_4761
			print($commandLine."\n") ;
			$result .= $commandLine."\n" ;


			exec($commandLine,$outputs) ;


			$outDir = sprintf("%s/%s/%s",$commandDir,$appId,$ssDir) ;
			if($outDirHandle = opendir($outDir)) {
				$imageUrls = array() ;
				$fileNames = array() ;
		        while(($fileName = readdir($outDirHandle)) !== false){
					if(preg_match('/\.png$/',$fileName)){
						$fileNames[] = $fileName ;
					}
		        }

				sort($fileNames) ;
				foreach($fileNames as $fileName){
		            print("upload $fileName\n") ;

					$imageFilePath = sprintf("%s/%s",$outDir,$fileName) ;

					$outputs = array() ;
					$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/images/%s',$commandDir,$imageFilePath,$appId,$conceptColor) ;
					print("$commandLine\n") ;
					$result .= sprintf("%s\n",$commandLine) ;
					exec($commandLine,$outputs) ;
					if($outputs[0] == '1'){
						if(preg_match('/4inch/',$fileName)){
							$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s/%s",$appId,$conceptColor,$fileName) ;
						}
					}
				}

		        closedir($outDirHandle);

				$imageCount = count($imageUrls) ;
				$app = AppPeer::retrieveByPk($appId) ;
				if($app){
					if($imageCount >= 1){
						$app->setScreenShot1($imageUrls[0]) ;
					} else {
						$app->setScreenShot1('') ;
					}
					if($imageCount >= 2){
						$app->setScreenShot2($imageUrls[1]) ;
					} else {
						$app->setScreenShot2('') ;
					}
					if($imageCount >= 3){
						$app->setScreenShot3($imageUrls[2]) ;
					} else {
						$app->setScreenShot3('') ;
					}
					if($imageCount >= 4){
						$app->setScreenShot4($imageUrls[3]) ;
					} else {
						$app->setScreenShot4('') ;
					}
					if($imageCount >= 5){
						$app->setScreenShot5($imageUrls[4]) ;
					} else {
						$app->setScreenShot5('') ;
					}
					$app->save() ;
					AdminTools::deployApp($appId,$databaseManager) ;
				}
		    } else {
				$status = 2 ;
				$result .= sprintf("open dir failed : %s\n",$outDir) ;
			}

			$remoteCommand->setStatus($status) ;
			$remoteCommand->setResult($result) ;
			$remoteCommand->save() ;
		}
	}

	sleep(5) ;

  }
}
