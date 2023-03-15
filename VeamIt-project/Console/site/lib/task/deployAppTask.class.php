<?php

class deployAppTask extends sfBaseTask
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
    $this->name             = 'deployApp';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [deployApp|INFO] task does things.
Call it with:

  [php symfony deployApp|INFO]
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
		  	//$c->add(RemoteCommandPeer::NAME,$commandName) ;
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
			AdminTools::deployApp($appId,$databaseManager) ;

			$remoteCommand->setStatus($status) ;
			$remoteCommand->setResult($result) ;
			$remoteCommand->save() ;
		}
	}

	sleep(5) ;

  }
}
