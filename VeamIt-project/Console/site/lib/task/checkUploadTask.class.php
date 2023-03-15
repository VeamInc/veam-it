<?php

class checkUploadTask extends sfBaseTask
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
    $this->name             = 'checkUpload';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [checkUpload|INFO] task does things.
Call it with:

  [php symfony checkUpload|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$currentTime = time() ;

		// get subscription template to be checked
		$c = new Criteria() ;
		$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		$c->add(TemplateSubscriptionPeer::UPLOAD_SPAN,0,Criteria::NOT_EQUAL) ;
		$templateSubscriptions = TemplateSubscriptionPeer::doSelect($c) ;
		$appIds = array() ;
		foreach($templateSubscriptions as $templateSubscription){
			$appIds[] = $templateSubscription->getAppId() ;
		}

		$c = new Criteria() ;
		$c->add(AppPeer::DEL_FLG,0) ;
		$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$apps = AppPeer::doSelect($c) ;
		$appMap = AdminTools::getMapForObjects($apps) ;

		foreach($templateSubscriptions as $templateSubscription){
			$appId = $templateSubscription->getAppId() ;
			$app = $appMap[$appId] ;
			if($app){
				$status = $app->getStatus() ;
				if($status == 0){ // released
					print(sprintf("%s:%s  released:%s\n",$appId,$status,$app->getReleasedAt())) ;
					$c = new Criteria() ;
					$c->add(MixedPeer::DEL_FLG,0) ;
					$c->add(MixedPeer::APP_ID,$appId) ;
					$c->addDescendingOrderByColumn(MixedPeer::CREATED_AT) ;
					$mixed = MixedPeer::doSelectOne($c) ;
					$dueDateTime = $app->getCreatedAt() ;
					$shouldUpload = false ;
					$level = 0 ; 
					if($mixed){
						$lastUploadTime = strtotime($mixed->getCreatedAt()) ;
						$appReleaseTime = strtotime($app->getReleasedAt()) ;
						if($lastUploadTime < $appReleaseTime){
							$lastUploadTime = $appReleaseTime ;
						}
						$lastUploadDateTime = date('Y-m-d H:i:s',$lastUploadTime) ;
						print(sprintf("last=%s\n",$lastUploadDateTime)) ;

						$blankTime = $currentTime - $lastUploadTime ;
						$uploadSpanTime = $templateSubscription->getUploadSpan() * 86400 ; // 86400 = 60 * 60 * 24
						if($uploadSpanTime < $blankTime){
							$shouldUpload = true ;
							$dueDateTime = date('Y-m-d H:i:s',$lastUploadTime+$uploadSpanTime) ;

							if($uploadSpanTime * 2 < $blankTime){
								$level = 1 ;
							}
							
						}
					} else {
						$shouldUpload = true ;
					}


					$c = new Criteria() ;
					$c->add(DelayPeer::DEL_FLAG,0) ;
					$c->add(DelayPeer::APP_ID,$appId) ;
					$c->add(DelayPeer::KIND,1) ; // content upload
					$c->addDescendingOrderByColumn(DelayPeer::CREATED_AT) ;
					$delay = DelayPeer::doSelectOne($c) ;

					if($shouldUpload){
						print(sprintf("should upload\n")) ;
						// create delay record
						if(!$delay){
							$delay = new Delay() ;
							$delay->setAppId($appId) ;
							$delay->setKind(1) ;
						}
						$delay->setLevel($level) ;
						$delay->setDueAt($dueDateTime) ;
						$delay->save() ;

						// send notification message
						AdminTools::sendMessageToAppCreator($appId,"Have you updated the subscription content?",0,'AUTO') ;

						/*
						$mailSubject = sprintf("Reminder : %s",$app->getName()) ;
						$mailBody = sprintf("\n%s\n\nJust to remind you, that it is about time for the voice message update.\n\n",$app->getName()) ;

						$creatorNotification = new CreatorNotification() ;
						$creatorNotification->setAppId($appId) ;
						$creatorNotification->setKind(1) ;
						$creatorNotification->setBadge(0) ; // TODO
						$creatorNotification->setMessage("") ; // TODO
						$creatorNotification->setMailSubject($mailSubject) ;
						$creatorNotification->setMailBody($mailBody) ;
						$creatorNotification->save() ;

						$c = new Criteria() ;
						$c->add(CreatorNotificationAddressPeer::DEL_FLAG,0) ;
						$c->add(CreatorNotificationAddressPeer::APP_ID,$appId) ;
						$creatorNotificationAddresses = CreatorNotificationAddressPeer::doSelect($c) ;
						foreach($creatorNotificationAddresses as $creatorNotificationAddress){
							if($creatorNotificationAddress->getKind() & 0x00000001){
								$email = $creatorNotificationAddress->getEmail() ;
								print(sprintf("send to %s\n",$email)) ;
								AdminTools::sendNotificationMail($mailSubject,$email,$mailBody) ;
							}
						}
						*/
					} else {
						if($delay){
							$delay->delete() ;
						}
					}
				}
			}
		}
	}
}
