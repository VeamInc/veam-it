<?php

class setPicturenotificationTask extends sfPropelBaseTask
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
    $this->name             = 'setPicturenotification';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [setPicturenotification|INFO] task does things.
Call it with:

  [php symfony setPicturenotification|INFO]
EOF;
  }

  protected function execute($arguments = array(), $options = array())
  {
    // initialize the database connection
    $databaseManager = new sfDatabaseManager($this->configuration);
    $connection = $databaseManager->getDatabase($options['connection'])->getConnection();

    // add your code here

		$rootDir = sfConfig::get('sf_root_dir') ;
		$libDir = sfConfig::get("sf_lib_dir") ; 
		preg_match('/console[^\/]*\.veam.co/',$libDir,$matches) ;
		$_SERVER['SERVER_NAME'] = $matches[0] ;

		$criteria = new Criteria() ;
		$criteria->add(AppPeer::DEL_FLG, 0) ;
		$criteria->add(AppPeer::PICTURE_NOTIFICATION,1) ;
		$apps = AppPeer::doSelect($criteria) ;
		$appIds = array() ;
		foreach($apps as $app){
			$appId = $app->getId() ;
			print("$appId\n") ;
			$appIds[] = $appId ;
		}

		$currentTime = time() ;
		$today = date("Y-m-d",$currentTime) ;
		$yesterdayTime = strtotime(sprintf("%s -1day",$today)) ;
		$yesterday = date("Y-m-d",$yesterdayTime) ;

		$criteria = new Criteria() ;
		$criteria->add(PictureCountPeer::DEL_FLG, 0) ;
		$criteria->add(PictureCountPeer::DATE,$yesterday) ;
		$criteria->add(PictureCountPeer::COUNT,0,Criteria::GREATER_THAN) ;
		$criteria->add(PictureCountPeer::APP_ID,$appIds,Criteria::IN) ;
		$criteria->addAscendingOrderByColumn(PictureCountPeer::COUNT) ;
		$pictureCounts = PictureCountPeer::doSelect($criteria) ;
		$launchTime = time() ;
		foreach($pictureCounts as $pictureCount){
			$targetAppId = $pictureCount->getAppId() ;
			$count = $pictureCount->getCount() ;
			if($targetAppId){
				print(sprintf("%s : %d\n",$targetAppId,$count)) ;
				$broadcastNotification = new BroadcastNotification() ;
				$broadcastNotification->setAppId($targetAppId) ;
				$broadcastNotification->setMessage("") ;
				$broadcastNotification->setBadge($count) ;
				$broadcastNotification->setStatus(0) ;
				$broadcastNotification->setStartAt(date('Y-m-d H:i:s',$launchTime)) ;
				$broadcastNotification->save() ;
				$launchTime += 600 ; // 10 minutes later
			}
		}
	}
}
