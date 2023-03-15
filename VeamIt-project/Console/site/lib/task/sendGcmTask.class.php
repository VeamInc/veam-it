<?php

class sendGcmTask extends sfPropelBaseTask
{
  protected function configure()
  {
    $this->namespace        = '';
    $this->name             = 'sendGcm';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [sendGcm|INFO] task does things.
Call it with:

  [php symfony sendGcm|INFO]
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
		preg_match('/console[^\/]*\.veam.co/',$libDir,$matches) ;
		$_SERVER['SERVER_NAME'] = $matches[0] ;

		$i = 1 ;

		$isReal = 0 ;
		if($options['type'] == 'real'){
			$isReal = 1 ;
		}

		$message = $options['message'] ;
		$badge = $options['badge'] ;
		if(!$message){
			print("no message specified\n") ;
			return ;
		}

		$pageNo = $options['pageno'] ;
		$amount = $options['amount'] ;
		$group = $options['group'] ;

		if($appId && $pageNo && $amount){

			$criteria = new Criteria() ;
			if($group){
				$criteria->add(UserDevicePeer::DEL_FLG, 0) ;
				$criteria->add(UserDevicePeer::APP_ID, $appId) ;
				$criteria->add(UserDevicePeer::OS, 'A') ;

				$criteria->addJoin(NotificationGroupMemberPeer::SOCIAL_USER_ID, UserDevicePeer::SOCIAL_USER_ID) ;
				$criteria->add(NotificationGroupMemberPeer::NOTIFICATION_GROUP_ID,$group) ;

				$criteria->addAscendingOrderByColumn(UserDevicePeer::CREATED_AT) ; 
				$pager = new sfPropelPager('UserDevice', $amount) ;
			} else {
				$criteria->add(GcmRegisterPeer::DEL_FLG, 0) ;
				$criteria->add(GcmRegisterPeer::APP_ID, $appId) ;
				$criteria->addAscendingOrderByColumn(GcmRegisterPeer::CREATED_AT) ; 
				$pager = new sfPropelPager('GcmRegister', $amount) ;
			}

			$pager->setCriteria($criteria) ;
			$pager->setPage($pageNo) ;
			$pager->init() ;
			if($pageNo <= $pager->getLastPage()){

				print("++++++++++++++++++ REAL DISTRIBUTION INITIALIZE ++++++++++++++++\n") ;

				//$tokens = GcmRegisterPeer::doSelect($criteria);
				$tokens = $pager->getResults() ;

				$registrationIds = array() ;

				foreach($tokens as $token){
					$tokenString = $token->getToken() ;
					if($tokenString != ""){
						$registrationIds[] = $tokenString ;
					}
				}

				unset($tokens) ;

				//------------------------------
				// Payload data you want to send to Android device (will be accessible via intent extras)
				//------------------------------
				$data = array( 
					'message' => $message,
					);

			    //------------------------------
			    // Replace with real GCM API  key from Google APIs Console  https://code.google.com/apis/console/
			    //------------------------------
			    $apiKey = '__GCM_API_KEY__';

			    //------------------------------
			    // Define URL to GCM endpoint
			    //------------------------------
			    $url = 'https://android.googleapis.com/gcm/send';

			    //------------------------------
			    // Set GCM post variables (Device IDs and push payload)
			    //------------------------------
			    $post = array(
			                    'registration_ids'  => $registrationIds,
								'collapse_key'		=> 'update',
			                    'data'              => $data,
			                    );

			    //------------------------------
			    // Set CURL request headers (Authentication and type)
			    //------------------------------
			    $headers = array( 
			                        'Authorization: key=' . $apiKey,
			                        'Content-Type: application/json'
			                    );

			    //------------------------------
			    // Initialize curl handle
			    //------------------------------
			    $ch = curl_init();

			    //------------------------------
			    // Set URL to GCM endpoint
			    //------------------------------
			    curl_setopt( $ch, CURLOPT_URL, $url );

			    //------------------------------
			    // Set request method to POST
			    //------------------------------
			    curl_setopt( $ch, CURLOPT_POST, true );

			    //------------------------------
			    // Set our custom headers
			    //------------------------------
			    curl_setopt( $ch, CURLOPT_HTTPHEADER, $headers );

			    //------------------------------
			    // Get the response back as 
			    // string instead of printing it
			    //------------------------------
			    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true );

			    //------------------------------
			    // Set post data as JSON
			    //------------------------------
			    curl_setopt( $ch, CURLOPT_POSTFIELDS, json_encode( $post ) );

			    //------------------------------
			    // Actually send the push!
			    //------------------------------
			    $result = curl_exec( $ch );

			    //------------------------------
			    // Error? Display it!
			    //------------------------------
			    if (curl_errno($ch)){
					print(curl_error($ch)) ;
			    }

			    //------------------------------
			    // Close curl handle
			    //------------------------------
			    curl_close( $ch );

			}

			unset($pager) ;
		}
	}
}
