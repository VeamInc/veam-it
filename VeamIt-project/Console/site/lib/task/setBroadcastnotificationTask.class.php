<?php

class setBroadcastnotificationTask extends sfBaseTask
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
		new sfCommandOption('message', null, sfCommandOption::PARAMETER_REQUIRED, 'Message'),
		new sfCommandOption('badge', null, sfCommandOption::PARAMETER_REQUIRED, 'Badge'),
    ));

    $this->namespace        = '';
    $this->name             = 'setBroadcastnotification';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [setBroadcastnotification|INFO] task does things.
Call it with:

  [php symfony setBroadcastnotification|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$appId = $options['app_id'] ;
		if(!$appId){
			return ;
		}

		$message = $options['message'] ;
		$badge = $options['badge'] ;
		if(!$message && !$badge){
			return ;
		}

		$currentTime = time() ;

		$c = new Criteria() ;
		$c->add(AppPeer::DEL_FLG,0) ;
		$c->add(AppPeer::ID,$appId) ;
		$c->add(AppPeer::STATUS,0) ; // released
		$app = AppPeer::doSelectOne($c) ;

		if($app){
			print(sprintf("%s: released:%s\n",$appId,$app->getReleasedAt())) ;
			print("make broadcast\n") ;
			$broadcastNotification = new BroadcastNotification() ;
			$broadcastNotification->setAppId($appId) ;
			$broadcastNotification->setMessage($message) ;
			$broadcastNotification->setBadge($badge) ;
			$broadcastNotification->setStatus(0) ;
			$broadcastNotification->setStartAt(date('Y-m-d H:i:s')) ;
			$broadcastNotification->save() ;
		}
	}
}
