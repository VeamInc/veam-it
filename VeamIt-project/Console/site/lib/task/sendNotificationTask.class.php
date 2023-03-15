<?php

class sendNotificationTask extends sfPropelBaseTask
{
  protected function configure()
  {
    $this->namespace        = '';
    $this->name             = 'sendNotification';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [sendNotification|INFO] task does things.
Call it with:

  [php symfony sendNotification|INFO]
EOF;
    $this->addArgument('application', sfCommandArgument::REQUIRED, 'The application name');
    // add other arguments here
    $this->addOption('env', null, sfCommandOption::PARAMETER_REQUIRED, 'The environment', 'dev');
    $this->addOption('connection', null, sfCommandOption::PARAMETER_REQUIRED, 'The connection name', 'propel');
    // add other options here
    $this->addOption('type', null, sfCommandOption::PARAMETER_REQUIRED, 'test or real', 'test');
    $this->addOption('app_id', null, sfCommandOption::PARAMETER_REQUIRED, 'app id', '');
    $this->addOption('message', null, sfCommandOption::PARAMETER_REQUIRED, 'message', '');
    $this->addOption('badge', null, sfCommandOption::PARAMETER_REQUIRED, 'badge', '');
    $this->addOption('pageno', null, sfCommandOption::PARAMETER_REQUIRED, 'pageno', '');
    $this->addOption('amount', null, sfCommandOption::PARAMETER_REQUIRED, 'amount', '');
    $this->addOption('group', null, sfCommandOption::PARAMETER_REQUIRED, 'group', '');
  }

  protected function execute($arguments = array(), $options = array())
  {
		// Database initialization
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = Propel::getConnection($options['connection'] ? $options['connection'] : '');
		// add code here

		$appId = $options['app_id'] ;

		$rootDir = sfConfig::get('sf_root_dir') ;
		$libDir = sfConfig::get("sf_lib_dir") ; 
		//preg_match('/console.*\.veam.co/',$libDir,$matches) ;
		preg_match('/console[^\/]*\.veam.co/',$libDir,$matches) ;
		$_SERVER['SERVER_NAME'] = $matches[0] ;

		$i = 1 ;

		$isReal = 0 ;
		if($options['type'] == 'real'){
			$isReal = 1 ;
		}

		$notificationMessage = $options['message'] ;
		$badge = $options['badge'] ;
		if(!$notificationMessage && !$badge){
			print("no message and no badge specified\n") ;
			return ;
		}

		$forceDevCert = 0 ;
		if($appId == '31024533'){ // Musicians Institute
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				if($app->getStatus() != 0){
					$forceDevCert = 1 ;
				}
			}
		}

		$rootCertFilePath = sprintf("%s/task/apn_certs/entrust_root_certification_authority.pem",$libDir) ;
		if(($_SERVER['SERVER_NAME'] == 'console.veam.co') && !$forceDevCert){
			print("env product\n") ;
			$certFilePath = sprintf("%s/task/apn_certs/APN_%s_PROD.pem",$libDir,$appId) ;
			$apnEnv = ApnsPHP_Abstract::ENVIRONMENT_PRODUCTION ;
		} else {
			print("env dev\n") ;
			$certFilePath = sprintf("%s/task/apn_certs/APN_%s_DEV.pem",$libDir,$appId) ;
			$apnEnv = ApnsPHP_Abstract::ENVIRONMENT_SANDBOX ;
		}

		$pageNo = $options['pageno'] ;
		$amount = $options['amount'] ;
		$group = $options['group'] ;

		if($pageNo && $amount){

			$criteria = new Criteria() ;
			if($group){
				$criteria->add(UserDevicePeer::DEL_FLG, 0) ;
				$criteria->add(UserDevicePeer::APP_ID, $appId) ;
				$criteria->add(UserDevicePeer::OS, 'I') ;

				$criteria->addJoin(NotificationGroupMemberPeer::SOCIAL_USER_ID, UserDevicePeer::SOCIAL_USER_ID) ;
				$criteria->add(NotificationGroupMemberPeer::NOTIFICATION_GROUP_ID,$group) ;

				$criteria->addAscendingOrderByColumn(UserDevicePeer::CREATED_AT) ; 
				$pager = new sfPropelPager('UserDevice', $amount) ;
			} else {
				$criteria->add(DeviceTokenPeer::DEL_FLG, 0) ;
				$criteria->add(DeviceTokenPeer::APP_ID, $appId) ;
				$criteria->addAscendingOrderByColumn(DeviceTokenPeer::CREATED_AT) ; 
				$pager = new sfPropelPager('DeviceToken', $amount) ;
			}

			$pager->setCriteria($criteria) ;
			$pager->setPage($pageNo) ;
			$pager->init() ;
			if($pageNo <= $pager->getLastPage()){

				if($isReal){
					print("++++++++++++++++++ REAL DISTRIBUTION INITIALIZE ++++++++++++++++\n") ;
					//*///////////////////////////////////////////////////////////////
					// Instanciate a new ApnsPHP_Push object
					$push = new ApnsPHP_Push(
						$apnEnv,
						$certFilePath
					);

					// Set the Root Certificate Autority to verify the Apple remote peer
					$push->setRootCertificationAuthority($rootCertFilePath);

					// Increase write interval to 100ms (default value is 10ms).
					// This is an example value, the 10ms default value is OK in most cases.
					// To speed up the sending operations, use Zero as parameter but
					// some messages may be lost.
					$push->setWriteInterval(100 * 1000);

					// Connect to the Apple Push Notification Service
					$push->connect() ;
					//*///////////////////////////////////////////////////////////////
				} else {
					print("++++++++++++++++++ TEST DISTRIBUTION INITIALIZE ++++++++++++++++\n") ;
				}


				//$tokens = DeviceTokenPeer::doSelect($criteria);
				$tokens = $pager->getResults() ;

				foreach($tokens as $token){
					$tokenString = $token->getToken() ;
					if($tokenString != ""){
						$customId = sprintf("M%08d", $i) ;

						if($isReal){
							print(sprintf("REAL %s %s %s\n",$tokenString,$customId,$notificationMessage)) ;
							//*///////////////////////////////////////////////////////////////
							// Instantiate a new Message with a single recipient
							$message = new ApnsPHP_Message($tokenString) ;

							// Set a custom identifier. To get back this identifier use the getCustomIdentifier() method
							// over a ApnsPHP_Message object retrieved with the getErrors() message.
							$message->setCustomIdentifier($customId) ;

							// Set badge icon
							if($badge){
								$message->setBadge(intval($badge)) ;
							}

							if($notificationMessage){
								$message->setText($notificationMessage) ;
							}

							// Add the message to the message queue
							$push->add($message) ;
							//*///////////////////////////////////////////////////////////////
						} else {
							print(sprintf("TEST %s %s %s\n",$tokenString,$customId,$notificationMessage)) ;
						}

						$i++ ;
					}
				}

				unset($tokens) ;

				if($isReal){
					print("++++++++++++++++++ REAL DISTRIBUTION SEND ++++++++++++++++\n") ;
					//*///////////////////////////////////////////////////////////////
					// Send all messages in the message queue
					$push->send() ;

					// Disconnect from the Apple Push Notification Service
					$push->disconnect() ;

					// Examine the error message container
					$aErrorQueue = $push->getErrors() ;
					if (!empty($aErrorQueue)) {
						var_dump($aErrorQueue) ;
					}
					//*///////////////////////////////////////////////////////////////
				} else {
					print("++++++++++++++++++ TEST DISTRIBUTION SEND ++++++++++++++++\n") ;
				}

				unset($aErrorQueue) ;
				unset($push) ;

			}

			unset($pager) ;
		}
	}
}
