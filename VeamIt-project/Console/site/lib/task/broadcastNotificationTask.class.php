<?php

class broadcastNotificationTask extends sfBaseTask
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
    $this->name             = 'broadcastNotification';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [broadcastNotification|INFO] task does things.
Call it with:

  [php symfony broadcastNotification|INFO]
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
		preg_match('/console.*\.veam.co/',$libDir,$matches) ;
		$_SERVER['SERVER_NAME'] = $matches[0] ;

		$currentDateTime = date('Y-m-d H:i:s') ;

		$amount = 10000 ; // number of devices per block
		$gcmAmount = 1000 ; // number of devices per block
		//$amount = 1 ; // test

		//status 0:waiting 1:sending 2:completed 3:error
		$c = new Criteria() ;
		$c->add(BroadcastNotificationPeer::STATUS,0) ;
		$c->add(BroadcastNotificationPeer::START_AT,$currentDateTime,Criteria::LESS_EQUAL) ;
		$c->addDescendingOrderByColumn(BroadcastNotificationPeer::PRIORITY) ;
		$c->addAscendingOrderByColumn(BroadcastNotificationPeer::START_AT) ;
		$broadcastNotification = BroadcastNotificationPeer::doSelectOne($c) ;
		if($broadcastNotification){
			$result = '' ; 
			$broadcastNotificationId = $broadcastNotification->getId() ;
			$appId = $broadcastNotification->getAppId() ;
			$message = $broadcastNotification->getMessage() ;
			$badge = $broadcastNotification->getBadge() ;
			$notificationGroupId = $broadcastNotification->getNotificationGroupId() ;
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$appName = $app->getName() ;
			} else {
				$appName = "" ;
			}

			$broadcastNotification->setStatus(1) ; // sending
			$broadcastNotification->save() ;

			$subject = sprintf("[VEAM_CONSOLE] Notification(%s) started : %s(%s)",$broadcastNotificationId,$appId,$appName) ;
			$body = sprintf("message : %s\nbadge : %d\n",$message,$badge) ;
			$to = 'tech@veam.co' ;
			ConsoleTools::sendInfoMail($subject,$to,$body) ;


			$options = "" ;
			if($message){
				$options .= sprintf("--message=\"%s\" ",$message) ;
			}

			if($badge > 0){
				$options .= sprintf("--badge=\"%d\" ",$badge) ;
			}

			if($options){
				$errorLogFilePaths = array() ;
				// iOS notification 
				$criteria = new Criteria() ;
				if($notificationGroupId){
					$criteria->add(UserDevicePeer::DEL_FLG, 0) ;
					$criteria->add(UserDevicePeer::APP_ID, $appId) ;
					$criteria->add(UserDevicePeer::OS, 'I') ;

					$criteria->addJoin(NotificationGroupMemberPeer::SOCIAL_USER_ID, UserDevicePeer::SOCIAL_USER_ID) ;
					$criteria->add(NotificationGroupMemberPeer::NOTIFICATION_GROUP_ID,$notificationGroupId) ;

					$criteria->addAscendingOrderByColumn(UserDevicePeer::CREATED_AT) ; 
					$pager = new sfPropelPager('UserDevice', $amount) ;
				} else {
					$criteria->add(DeviceTokenPeer::DEL_FLG, 0) ;
					$criteria->add(DeviceTokenPeer::APP_ID, $appId) ;
					$criteria->addAscendingOrderByColumn(DeviceTokenPeer::CREATED_AT) ; 
					$pager = new sfPropelPager('DeviceToken', $amount) ;
				}

				$pager->setCriteria($criteria) ;
				$pager->setPage(1) ;
				$pager->init() ;
				$lastPageNo = $pager->getLastPage() ;
				for($pageNo = 1 ; $pageNo <= $lastPageNo ; $pageNo++){
					$logFilePath = sprintf("%s/notification/notification_%s_%s_%d.log",sfConfig::get('sf_log_dir'),$appId,date('YmdHis'),$pageNo) ; 
					$errorFilePath = sprintf("%s/notification/notification_error_%s_%s_%d.log",sfConfig::get('sf_log_dir'),$appId,date('YmdHis'),$pageNo) ; 
					$errorLogFilePaths[] = $errorFilePath ;

					$command = sprintf("php %s/symfony sendNotification backend --type=\"real\" --app_id=\"%s\" --amount=\"%d\" --pageno=\"%d\" --group=\"%d\" %s >%s 2>%s",$rootDir,$appId,$amount,$pageNo,$notificationGroupId,$options,$logFilePath,$errorFilePath) ;
					//print("$command\n") ;
					$return = system($command) ;
				}

				if($message){
					// gcm notification
					if($notificationGroupId){
						$criteria->add(UserDevicePeer::DEL_FLG, 0) ;
						$criteria->add(UserDevicePeer::APP_ID, $appId) ;
						$criteria->add(UserDevicePeer::OS, 'A') ;

						$criteria->addJoin(NotificationGroupMemberPeer::SOCIAL_USER_ID, UserDevicePeer::SOCIAL_USER_ID) ;
						$criteria->add(NotificationGroupMemberPeer::NOTIFICATION_GROUP_ID,$notificationGroupId) ;

						$criteria->addAscendingOrderByColumn(UserDevicePeer::CREATED_AT) ; 
						$pager = new sfPropelPager('UserDevice', $gcmAmount) ;
					} else {
						$criteria = new Criteria() ;
						$criteria->add(GcmRegisterPeer::DEL_FLG, 0) ;
						$criteria->add(GcmRegisterPeer::APP_ID, $appId) ;
						$criteria->addAscendingOrderByColumn(GcmRegisterPeer::CREATED_AT) ; 
						$pager = new sfPropelPager('GcmRegister', $gcmAmount) ;
					}

					$pager->setCriteria($criteria) ;
					$pager->setPage(1) ;
					$pager->init() ;
					$lastPageNo = $pager->getLastPage() ;
					for($pageNo = 1 ; $pageNo <= $lastPageNo ; $pageNo++){
						$logFilePath = sprintf("%s/notification/notification_gcm_%s_%s_%d.log",sfConfig::get('sf_log_dir'),$appId,date('YmdHis'),$pageNo) ; 
						$errorFilePath = sprintf("%s/notification/notification_gcm_error_%s_%s_%d.log",sfConfig::get('sf_log_dir'),$appId,date('YmdHis'),$pageNo) ; 
						$errorLogFilePaths[] = $errorFilePath ;

						$command = sprintf("php %s/symfony sendGcm backend --type=\"real\" --app_id=\"%s\" --amount=\"%d\" --pageno=\"%d\" --group=\"%d\" %s >%s 2>%s",$rootDir,$appId,$gcmAmount,$pageNo,$notificationGroupId,$options,$logFilePath,$errorFilePath) ;
						//print("$command\n") ;
						$return = system($command) ;
					}
				}

				$broadcastNotification->setStatus(2) ; // completed
				$result = 'completed' ;


				// check error log files
				$checkResult = '' ;
				foreach($errorLogFilePaths as $errorLogFilePath){
					if(filesize($errorLogFilePath) > 0){
						$checkResult .= $errorLogFilePath . "\n" ;
					}
				}

				if($checkResult){
					$subject = sprintf("[VEAM_CONSOLE] Notification(%s) warning : %s(%s)",$broadcastNotificationId,$appId,$appName) ;
					$body = sprintf("non zero error files exist\n",$checkResult) ;
					$to = 'tech@veam.co' ;
					ConsoleTools::sendInfoMail($subject,$to,$body) ;
				}


			} else {
				$subject = sprintf("[VEAM_CONSOLE] Notification(%s) warning : %s(%s)",$broadcastNotificationId,$appId,$appName) ;
				$body = sprintf("no message and badge\n",$message,$badge) ;
				$to = 'tech@veam.co' ;
				ConsoleTools::sendInfoMail($subject,$to,$body) ;
				$broadcastNotification->setStatus(3) ; // error
				$result = 'no message and badge' ;
			}



			$broadcastNotification->setResult($result) ;
			$broadcastNotification->save() ;

			$subject = sprintf("[VEAM_CONSOLE] Notification(%s) end : status=%d : %s(%s)",$broadcastNotificationId,$broadcastNotification->getStatus(),$appId,$appName) ;
			$body = sprintf("result : %s\n",$result) ;
			$to = 'tech@veam.co' ;
			ConsoleTools::sendInfoMail($subject,$to,$body) ;

		} else {
			// no broadcast
		}
	}


}
