<?php

class updateConceptcolorTask extends sfBaseTask
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
    $this->name             = 'updateConceptcolor';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [updateConceptcolor|INFO] task does things.
Call it with:

  [php symfony updateConceptcolor|INFO]
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
		  	$c = new Criteria() ;
		  	$c->add(RemoteCommandPeer::APP_ID,$appId) ;
		  	$c->add(RemoteCommandPeer::NAME,$commandName) ;
		  	$c->add(RemoteCommandPeer::STATUS,3) ;
			$workingRemoteCommand = RemoteCommandPeer::doSelectOne($c) ;
			$retry++ ;
		} while($workingRemoteCommand && ($retry < 100)) ;


		if($workingRemoteCommand){
			ConsoleTools::assert(false,sprintf("remote command is still working commandname=%s id=%s appid=%s",$commandName,$remoteCommandId,$appId),__FILE__,__LINE__) ;
		} else {

			$remoteCommand->setStatus(3) ; // executing
			$remoteCommand->save() ;

			$status = 1 ;
			$result = '' ;

			$appId = $remoteCommand->getAppId() ;

		  	$c = new Criteria() ;
		  	$c->add(AppColorPeer::DEL_FLG,0) ;
		  	$c->add(AppColorPeer::APP_ID,$appId) ;
		  	$c->add(AppColorPeer::NAME,'concept_color_argb') ;
			$appColor = AppColorPeer::doSelectOne($c) ;
			$conceptColor = substr($appColor->getColor(),2) ;

		  	$c = new Criteria() ;
		  	$c->add(AppColorPeer::DEL_FLG,0) ;
		  	$c->add(AppColorPeer::APP_ID,$appId) ;
		  	$c->add(AppColorPeer::NAME,'base_text_color_argb') ;
			$appColor = AppColorPeer::doSelectOne($c) ;
			if($appColor){
				$textColor = substr($appColor->getColor(),2) ;
			} else {
				$textColor = 'FFFFFF' ;
			}
		
			$outputs = array() ;
	 		$commandLine = sprintf("perl %s/change_color.pl %s %s %s",$commandDir,$appId,$conceptColor,$textColor) ;
			print($commandLine."\n") ;
			$result .= $commandLine."\n" ;
			exec($commandLine,$outputs) ;


			$outDir = sprintf("%s/%s/%s",$commandDir,$appId,$conceptColor) ;
			if($outDirHandle = opendir($outDir)) {
		        while(($fileName = readdir($outDirHandle)) !== false){
					if(preg_match('/\.png$/',$fileName)){
			            print("upload $fileName\n") ;

						$imageFilePath = sprintf("%s/%s",$outDir,$fileName) ;

						$outputs = array() ;
						$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/images/%s',$commandDir,$imageFilePath,$appId,$conceptColor) ;
						print("$commandLine\n") ;
						$result .= sprintf("%s\n",$commandLine) ;
						exec($commandLine,$outputs) ;
						if($outputs[0] == '1'){
							$imageUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s/%s",$appId,$conceptColor,$fileName) ;
						  	$c = new Criteria() ;
						  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
						  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
						  	$c->add(AlternativeImagePeer::FILE_NAME,$fileName) ;
							$alternativeImage = AlternativeImagePeer::doSelectOne($c) ;
							if(!$alternativeImage){
								$alternativeImage = new AlternativeImage() ;
								$alternativeImage->setAppId($appId) ;
								$alternativeImage->setFileName($fileName) ;
							}
							$alternativeImage->setUrl($imageUrl) ;
							$alternativeImage->save() ;
						}
					}
		        }
		        closedir($outDirHandle);
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
