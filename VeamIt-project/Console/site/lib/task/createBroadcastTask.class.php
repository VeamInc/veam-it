<?php

class createBroadcastTask extends sfBaseTask
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
		new sfCommandOption('app_id', null, sfCommandOption::PARAMETER_REQUIRED, 'App ID'),
    ));

    $this->namespace        = '';
    $this->name             = 'createBroadcast';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [createBroadcast|INFO] task does things.
Call it with:

  [php symfony createBroadcast|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$appId = $options['app_id'] ;

		$currentTime = time() ;

		$c = new Criteria() ;
		$c->add(AppPeer::DEL_FLG,0) ;
		$c->add(AppPeer::ID,$appId) ;
		$c->add(AppPeer::STATUS,0) ; // released
		$app = AppPeer::doSelectOne($c) ;

		if($app){
			print(sprintf("%s: released:%s\n",$appId,$app->getReleasedAt())) ;
			$c = new Criteria() ;
			$c->add(MixedPeer::DEL_FLG,0) ;
			$c->add(MixedPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(MixedPeer::CREATED_AT) ;
			$mixeds = MixedPeer::doSelect($c) ;
			$numberOfMixeds = count($mixeds) ;
			if($numberOfMixeds > 0){

				$c = new Criteria() ;
				$c->add(ExclusiveUpdateInfoPeer::DEL_FLG,0) ;
				$c->add(ExclusiveUpdateInfoPeer::APP_ID,$appId) ;
				$exclusiveUpdateInfo = ExclusiveUpdateInfoPeer::doSelectOne($c) ;
				if($exclusiveUpdateInfo){
					$lastNotifiedDateTime = $exclusiveUpdateInfo->getNotifiedAt() ;
					$lastNotifiedTime = strtotime($lastNotifiedDateTime) ;
					$allowedNotificatonFrom = $lastNotifiedTime + 86400 ; // 86400 = 60 * 60 * 24
					if($exclusiveUpdateInfo->getNumberOfMixeds() < $numberOfMixeds){
						$exclusiveUpdateInfo->setNumberOfMixeds($numberOfMixeds) ;
						if($allowedNotificatonFrom <= $currentTime){
							$exclusiveUpdateInfo->setNotifiedAt(date('Y-m-d H:i:s')) ;
							print("make broadcast\n") ;
							$broadcastNotification = new BroadcastNotification() ;
							$broadcastNotification->setAppId($appId) ;
							$broadcastNotification->setMessage('New update for Premium content subscribers!') ;
							$broadcastNotification->setBadge(0) ;
							$broadcastNotification->setStatus(0) ;
							$broadcastNotification->setStartAt(date('Y-m-d H:i:s')) ;
							$broadcastNotification->save() ;
						}
						$exclusiveUpdateInfo->save() ;
					}
				} else {
					// exclusiveUpdateInfo ‚ª–³‚¢ê‡‚Íì‚Á‚ÄI‚í‚è
					$exclusiveUpdateInfo = new ExclusiveUpdateInfo() ;
					$exclusiveUpdateInfo->setAppId($appId) ;
					$exclusiveUpdateInfo->setNumberOfMixeds($numberOfMixeds) ;
					$exclusiveUpdateInfo->setNotifiedAt('2000-01-01 00:00:00') ;
					$exclusiveUpdateInfo->save() ;
				}
			}
		}
	}
}
