<?php

/**
 * account actions.
 *
 * @package    console
 * @subpackage account
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class accountActions extends myActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeSignup(sfWebRequest $request)
	{
		$this->errorMessages = $request->getParameter('em') ;

		//$this->companyName = $request->getParameter('cn') ;
		$this->lastName = $request->getParameter('ln') ;
		$this->firstName = $request->getParameter('fn') ;
		$this->email = $request->getParameter('m') ;
		$this->confirmEmail = $request->getParameter('cm') ;
		$this->password = $request->getParameter('p') ;
		$this->confirmPassword = $request->getParameter('cp') ;
		//$this->tel = $request->getParameter('t') ;
		//$this->sns = $request->getParameter('sns') ;
		$this->youtubeUserName = $request->getParameter('y') ;
		$this->mcnId = $request->getParameter('mcn') ;

	}

	public function executeConfirmsignup(sfWebRequest $request)
	{

		$errorMessages = array() ;
		//$companyName = $request->getParameter('cn') ;
		$lastName = $request->getParameter('ln') ;
		$firstName = $request->getParameter('fn') ;
		$email = $request->getParameter('m') ;
		$confirmEmail = $request->getParameter('cm') ;
		$password = $request->getParameter('p') ;
		$confirmPassword = $request->getParameter('cp') ;
		//$tel = $request->getParameter('t') ;
		//$sns = $request->getParameter('sns') ;
		$youtubeUserName = $request->getParameter('y') ;

		$this->mcnId = $request->getParameter('mcn') ;

		if(!$lastName){
			$errorMessages[] = 'Please enter your last name.' ;
		}
		if(!$firstName){
			$errorMessages[] = 'Please enter your first name.' ;
		}
		if(!$email){
			$errorMessages[] = 'Please enter your mail address.' ;
		}
		if($email != $confirmEmail){
			$errorMessages[] = 'The Confirmation Email must match your Email Address.' ;
		}
		if(!$password){
			$errorMessages[] = 'Please enter the password.' ;
		} else {
			if(strlen($password) < 8){
				$errorMessages[] = 'Your password must be at least 8 characters long.' ;
			}
		}

		if($password != $confirmPassword){
			$errorMessages[] = 'The Confirmation Password must match Password.' ;
		}
		/*
		if(!$tel){
			$errorMessages[] = 'Please enter your phone number.' ;
		}
		if(!$sns){
			$errorMessages[] = 'Please type in your social media info.' ;
		}
		*/


		if(!$errorMessages){
		  	$c = new Criteria();
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::USERNAME,$email) ;
			$appCreator = AppCreatorPeer::doSelectOne($c) ;
			if($appCreator){
				$errorMessages[] = 'The email address you have entered is already registered.' ;
			} else {
				if($youtubeUserName){
					$channels = AdminTools::getYoutubeChannels($youtubeUserName) ;

					if(count($channels) > 0){
						// OK
					} else {
						$errorMessages[] = "Wrong YouTube Channel ID." ;
					}
				} else {
					// no youtube
					// OK
				}
			}
		}


		//$this->companyName = $companyName ;
		$this->lastName = $lastName ;
		$this->firstName = $firstName ;
		$this->email = $email ;
		$this->confirmEmail = $confirmEmail ;
		$this->password = $password ;
		$this->confirmPassword = $confirmPassword ;
		//$this->tel = $tel ;
		//$this->sns = $sns ;
		$this->youtubeUserName = $youtubeUserName ;
		$this->errorMessages = $errorMessages ;

		$request->setParameter('em',$errorMessages) ;
		if(count($errorMessages) > 0){
			$this->forward('account','signup') ;
		}

	}






	public function executeRegistersignup(sfWebRequest $request)
	{

		$errorMessages = array() ;
		//$companyName = $request->getParameter('cn') ;
		$lastName = $request->getParameter('ln') ;
		$firstName = $request->getParameter('fn') ;
		$email = $request->getParameter('m') ;
		$confirmEmail = $request->getParameter('cm') ;
		$password = $request->getParameter('p') ;
		$confirmPassword = $request->getParameter('cp') ;
		//$tel = $request->getParameter('t') ;
		//$sns = $request->getParameter('sns') ;
		$youtubeUserName = $request->getParameter('y') ;

		$this->mcnId = $request->getParameter('mcn') ;
		if(!$this->mcnId){
			$this->mcnId = 5 ; // VeamLP
		}

		if(!$lastName){
			$errorMessages[] = 'Please enter your last name.' ;
		}
		if(!$firstName){
			$errorMessages[] = 'Please enter your first name.' ;
		}
		if(!$email){
			$errorMessages[] = 'Please enter your mail address.' ;
		}
		if(!$password){
			$errorMessages[] = 'Please enter the password.' ;
		}
		/*
		if(!$tel){
			$errorMessages[] = 'Please enter your phone number.' ;
		}
		if(!$sns){
			$errorMessages[] = 'Please type in your social media info.' ;
		}
		*/


		$user = $this->getUser() ;
		$language = substr($user->getCulture(),0,2) ;

		if(!$errorMessages){
		  	$c = new Criteria();
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::USERNAME,$email) ;
			$appCreator = AppCreatorPeer::doSelectOne($c) ;
			if($appCreator){
				$errorMessages[] = 'The email address you have entered is already registered.' ;
			} else {
				$validationToken = strtolower(sha1(sprintf("REGISTERSIGNUP_VALIDATION%d%04d",time(),rand(0,9999)))) ;
				$approvalToken = strtolower(sha1(sprintf("REGISTERSIGNUP_APPROVAL%d%04d",time(),rand(0,9999)))) ;
				if($youtubeUserName){
					$channels = AdminTools::getYoutubeChannels($youtubeUserName) ;

					if(count($channels) > 0){

						$item = $channels[0] ;
						$channelName = $item->{'snippet'}->{'title'} ;
						#print("title = ".$channelName) ;

						$app = new App() ;
						$app->setName($channelName) ;
						$app->setStoreAppName($channelName) ;
						$app->setDescription('') ;
						$app->setStatus(4) ; // 4:Initialized
						$app->setMcnId($this->mcnId) ; // VeamLP
						$app->setCurrentProcess(10100) ; 
						$app->save() ;

						$appId = $app->getId() ;



						$c = new Criteria() ;
					  	$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
					  	$c->add(YoutubeUserPeer::APP_ID,$appId) ;
						$youtubeUser = YoutubeUserPeer::doSelectOne($c) ;
						if(!$youtubeUser){
							$youtubeUser = new YoutubeUser() ;
							$youtubeUser->setAppId($appId) ;
							$youtubeUser->setAutoList(1) ;
						}
						$youtubeUser->setName($youtubeUserName) ;
						$youtubeUser->save() ;

						//print("item count = ".count($channels)) ;
						$appCreator = new AppCreator() ;
						$appCreator->setAppId($appId) ;
						$appCreator->setUserName($email) ;
						$appCreator->setFirstName($firstName) ;
						$appCreator->setLastName($lastName) ;
						$appCreator->setPassword(strtolower(sha1($password))) ;
						//$appCreator->setCompanyName($companyName) ;
						//$appCreator->setTelephone($tel) ;
						//$appCreator->setSns($sns) ;
						$appCreator->setValidationToken($validationToken) ;
						$appCreator->setApprovalToken($approvalToken) ;
						$appCreator->setValid(0) ;
						$appCreator->setApprove(0) ;
						$appCreator->save() ;

						$creatorNotificationAddress = new CreatorNotificationAddress() ;
						$creatorNotificationAddress->setAppId($appId) ;
						$creatorNotificationAddress->setEmail($email) ;
						$creatorNotificationAddress->setKind(65535) ;
						$creatorNotificationAddress->save() ;

						AdminTools::setAppDefaultValues($appId,$language) ;

						AdminTools::deployApp($appId) ;

						// create youtube list
						$seedString = sprintf("%d%d%d",time(),rand(),rand()) ;
						$secret = sha1($seedString) ;
						$remoteCommand = new RemoteCommand() ;
						$remoteCommand->setAppId($appId) ;
						$remoteCommand->setName('UPDATE_YOUTUBE_LIST') ;
						$remoteCommand->setSecret($secret) ;
						$remoteCommand->setStatus(0) ;
						$remoteCommand->setParams('') ;
						$remoteCommand->save() ;

						$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateYoutubelist --command_id=%d > /dev/null &",AdminTools::getServerNameForDb(),$remoteCommand->getId()) ;
						//print("$commandLine\n") ;
						exec($commandLine) ;

					} else {
						$errorMessages[] = "Wrong YouTube user name." ;
					}
				} else {
					// no youtube
					$app = new App() ;
					$app->setName($firstName) ;
					$app->setStoreAppName($firstName) ;
					$app->setDescription('') ;
					$app->setStatus(4) ; // 4:Initialized
					$app->setMcnId($this->mcnId) ; // VeamLP
					$app->setCurrentProcess(10100) ; 
					$app->save() ;

					$appId = $app->getId() ;

					$appCreator = new AppCreator() ;
					$appCreator->setAppId($appId) ;
					$appCreator->setUserName($email) ;
					$appCreator->setFirstName($firstName) ;
					$appCreator->setLastName($lastName) ;
					$appCreator->setPassword(strtolower(sha1($password))) ;
					//$appCreator->setCompanyName($companyName) ;
					//$appCreator->setTelephone($tel) ;
					//$appCreator->setSns($sns) ;
					$appCreator->setValidationToken($validationToken) ;
					$appCreator->setApprovalToken($approvalToken) ;
					$appCreator->setValid(0) ;
					$appCreator->setApprove(0) ;
					$appCreator->save() ;

					$creatorNotificationAddress = new CreatorNotificationAddress() ;
					$creatorNotificationAddress->setAppId($appId) ;
					$creatorNotificationAddress->setEmail($email) ;
					$creatorNotificationAddress->setKind(65535) ;
					$creatorNotificationAddress->save() ;

					AdminTools::setAppDefaultValues($appId,$language) ;
					AdminTools::setAppData($appId,'template_ids','8_2_3') ; // no youtube

					AdminTools::deployApp($appId) ;
				}

				$validationUrl = sprintf("http://%s/creator.php/account/validate/t/%s",$_SERVER['SERVER_NAME'],$validationToken) ;

				$sendTo = 'tech@veam.co' ;
				$message = sprintf("%s\r\n%s\r\n%s\r\n%s\r\n",$lastName,$firstName,$email,$validationUrl) ;
				ConsoleTools::sendInfoMail("[VEAM_CONSOLE_INFO]CREATOR REGISTERED",$sendTo,$message) ;

				// TODO send mail to creator

				if($language == 'ja'){
					$subject = 'Veam メールアドレス確認' ;
$message = <<< EOMJ
－－－－－－－－－－－－－－－－－－－－－－
このメールはVeamに仮登録いただいた方へ
システムが自動的にメール送信しています。
－－－－－－－－－－－－－－－－－－－－－－

■Veam本登録作業について■

この度はVeamにご登録いただき、誠にありがとうございます。

お客様は現在、仮登録が完了した状態です。
登録を完了させるには、以下の認証URLをクリックして下さい。

$validationUrl

※本メールアドレス宛に返信頂いても、お返事することができません。
　あらかじめご了承下さい。
EOMJ;
				} else {
					$subject = 'Creating your app with Veam - Please confirm your email address' ;
$message = <<< EOME

Hi there,

Thanks so much for registering for an app with Veam.

Please click the link below to confirm your email address:

$validationUrl

Once you complete the email confirmation, we'll send you another email with details about how to start creating your app with the Veam It! Publisher.

If you have any questions, feel free to reach out directly at team@veamapp.com

Warm regards,
The Veam It! Publisher Team

This is an automated message from Veam - do not reply

EOME;
				}

				$sendTo = $email ;
				ConsoleTools::sendInfoMail($subject,$sendTo,$message) ;

			}


		}


		//$this->companyName = $companyName ;
		$this->lastName = $lastName ;
		$this->firstName = $firstName ;
		$this->email = $email ;
		$this->confirmEmail = $confirmEmail ;
		$this->password = $password ;
		$this->confirmPassword = $confirmPassword ;
		//$this->tel = $tel ;
		//$this->sns = $sns ;
		$this->youtubeUserName = $youtubeUserName ;
		$this->errorMessages = $errorMessages ;

		$request->setParameter('em',$errorMessages) ;
		if(count($errorMessages) > 0){
			$this->forward('account','signup') ;
		}

	}


















	public function getMessage($code,$language)
	{
		$errorMessages = array(
			'ALREADY_en' => 'The email address you have entered is already registered.',
			'ALREADY_ja' => '入力したメールアドレスはすでに登録されています。',
			'WRONG_CHANNEL_ID_en' => 'The Youtube Channel ID is incorrect. Please enter the part corresponding to YOUTUBE_CHANNEL_ID of https://www.youtube.com/channel/YOUTUBE_CHANNEL_ID',
			'WRONG_CHANNEL_ID_ja' => 'YouTubeチャンネルIDが正しくありません。https://www.youtube.com/channel/YOUTUBE_CHANNEL_ID のYOUTUBE_CHANNEL_IDの部分に該当するIDを入力してください。',
			'NOT_FOUND_en' => 'The email address you have entered is not registered.',
			'NOT_FOUND_ja' => '入力されたメールアドレスは登録されていません。',
			'SUCCESS_en' => 'Thanks for registering for the Veam service.\nAn email has been sent to the address you registered with.\nClick the link and complete registration.',
			'SUCCESS_ja' => 'ご登録いただきましてありがとうございます。\n入力されたメールアドレスにメールを送信しました。\nメールの文言にあるURLをクリックしてメールアドレスの登録を完了させてください。',
			'RESET_SUCCESS_en' => 'The new password was sent to.',
			'RESET_SUCCESS_ja' => '新しいパスワードを送信しました。',
		) ;

		return $errorMessages[$code . "_" . $language] ;
	}




	public function executeRegisterbyapp(sfWebRequest $request)
	{

		$errorMessages = array() ;
		$lastName = $request->getParameter('ln') ;
		$firstName = $request->getParameter('fn') ;
		$email = $request->getParameter('m') ;
		$password = $request->getParameter('p') ;
		$youtubeUserName = $request->getParameter('y') ;
		$locale = $request->getParameter('loc') ;

		$this->mcnId = $request->getParameter('mcn') ;
		if(!$this->mcnId){
			if(substr($locale,0,2) == 'ja'){
				$this->mcnId = 4 ; // Veam
				$language = 'ja' ;
			} else {
				$this->mcnId = 5 ; // VeamLP
				$language = 'en' ;
			}
		}


		/*
		echo "ERROR_MESSAGE\n" ;
		echo $lastName . "-" .$firstName . "-" .$email . "-" .$password . "-" .$youtubeUserName . "-" .$this->mcnId . "\n" ;
		AdminTools::assert(false,"DEBUG\n".var_export($_SERVER,true),__FILE__,__LINE__) ;return sfView::NONE ;
		*/

		if(!$errorMessages){
		  	$c = new Criteria();
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::USERNAME,$email) ;
			$appCreator = AppCreatorPeer::doSelectOne($c) ;
			if($appCreator){
				$errorMessages[] = $this->getMessage('ALREADY',$language) ;
			} else {
				$validationToken = strtolower(sha1(sprintf("REGISTERSIGNUP_VALIDATION%d%04d",time(),rand(0,9999)))) ;
				$approvalToken = strtolower(sha1(sprintf("REGISTERSIGNUP_APPROVAL%d%04d",time(),rand(0,9999)))) ;
				if($youtubeUserName){
					$channels = AdminTools::getYoutubeChannels($youtubeUserName) ;

					if(count($channels) > 0){

						$item = $channels[0] ;
						$channelName = $item->{'snippet'}->{'title'} ;

						$app = new App() ;
						$app->setName($channelName) ;
						$app->setStoreAppName($channelName) ;
						$app->setDescription('') ;
						$app->setStatus(4) ; // 4:Initialized
						$app->setMcnId($this->mcnId) ; // VeamLP
						$app->setCurrentProcess(10100) ; 
						$app->save() ;

						$appId = $app->getId() ;



						$c = new Criteria() ;
					  	$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
					  	$c->add(YoutubeUserPeer::APP_ID,$appId) ;
						$youtubeUser = YoutubeUserPeer::doSelectOne($c) ;
						if(!$youtubeUser){
							$youtubeUser = new YoutubeUser() ;
							$youtubeUser->setAppId($appId) ;
							$youtubeUser->setAutoList(1) ;
						}
						$youtubeUser->setName($youtubeUserName) ;
						$youtubeUser->save() ;

						//print("item count = ".count($channels)) ;
						$appCreator = new AppCreator() ;
						$appCreator->setAppId($appId) ;
						$appCreator->setUserName($email) ;
						$appCreator->setFirstName($firstName) ;
						$appCreator->setLastName($lastName) ;
						$appCreator->setPassword(strtolower(sha1($password))) ;
						$appCreator->setValidationToken($validationToken) ;
						$appCreator->setApprovalToken($approvalToken) ;
						$appCreator->setValid(0) ;
						$appCreator->setApprove(0) ;
						$appCreator->save() ;

						$creatorNotificationAddress = new CreatorNotificationAddress() ;
						$creatorNotificationAddress->setAppId($appId) ;
						$creatorNotificationAddress->setEmail($email) ;
						$creatorNotificationAddress->setKind(65535) ;
						$creatorNotificationAddress->save() ;

						AdminTools::setAppDefaultValues($appId,$language) ;

						AdminTools::deployApp($appId) ;

						// create youtube list
						$seedString = sprintf("%d%d%d",time(),rand(),rand()) ;
						$secret = sha1($seedString) ;
						$remoteCommand = new RemoteCommand() ;
						$remoteCommand->setAppId($appId) ;
						$remoteCommand->setName('UPDATE_YOUTUBE_LIST') ;
						$remoteCommand->setSecret($secret) ;
						$remoteCommand->setStatus(0) ;
						$remoteCommand->setParams('') ;
						$remoteCommand->save() ;

						$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateYoutubelist --command_id=%d > /dev/null &",AdminTools::getServerNameForDb(),$remoteCommand->getId()) ;
						//print("$commandLine\n") ;
						exec($commandLine) ;

					} else {
						$errorMessages[] = $this->getMessage('WRONG_CHANNEL_ID',$language) ;
					}
				} else {
					// no youtube
					$app = new App() ;
					$app->setName($firstName) ;
					$app->setStoreAppName($firstName) ;
					$app->setDescription('') ;
					$app->setStatus(4) ; // 4:Initialized
					$app->setMcnId($this->mcnId) ; // VeamLP
					$app->setCurrentProcess(10100) ; 
					$app->save() ;

					$appId = $app->getId() ;

					$appCreator = new AppCreator() ;
					$appCreator->setAppId($appId) ;
					$appCreator->setUserName($email) ;
					$appCreator->setFirstName($firstName) ;
					$appCreator->setLastName($lastName) ;
					$appCreator->setPassword(strtolower(sha1($password))) ;
					$appCreator->setValidationToken($validationToken) ;
					$appCreator->setApprovalToken($approvalToken) ;
					$appCreator->setValid(0) ;
					$appCreator->setApprove(0) ;
					$appCreator->save() ;

					$creatorNotificationAddress = new CreatorNotificationAddress() ;
					$creatorNotificationAddress->setAppId($appId) ;
					$creatorNotificationAddress->setEmail($email) ;
					$creatorNotificationAddress->setKind(65535) ;
					$creatorNotificationAddress->save() ;

					AdminTools::setAppDefaultValues($appId,$language) ;
					AdminTools::setAppData($appId,'template_ids','8_2_3') ; // no youtube

					AdminTools::deployApp($appId) ;
				}




				if(count($errorMessages) == 0){

					$validationUrl = sprintf("http://%s/creator.php/account/validate/t/%s",$_SERVER['SERVER_NAME'],$validationToken) ;

					$sendTo = 'tech@veam.co' ;
					$message = sprintf("%s\r\n%s\r\n%s\r\n%s\r\n",$lastName,$firstName,$email,$validationUrl) ;
					ConsoleTools::sendInfoMail("[VEAM_CONSOLE_INFO]CREATOR REGISTERED BY APP",$sendTo,$message) ;

					// TODO send mail to creator

					if($language == 'ja'){
						$subject = 'Veam メールアドレス確認' ;
$message = <<< EOMJ
－－－－－－－－－－－－－－－－－－－－－－
このメールはVeamに仮登録いただいた方へ
システムが自動的にメール送信しています。
－－－－－－－－－－－－－－－－－－－－－－

■Veam本登録作業について■

この度はVeamにご登録いただき、誠にありがとうございます。

お客様は現在、仮登録が完了した状態です。
登録を完了させるには、以下の認証URLをクリックして下さい。

$validationUrl

※本メールアドレス宛に返信頂いても、お返事することができません。
　あらかじめご了承下さい。
EOMJ;
					} else {
						$subject = 'Creating your app with Veam - Please confirm your email address' ;
$message = <<< EOME

Hi there,

Thanks so much for registering for an app with Veam.

Please click the link below to confirm your email address:

$validationUrl

Once you complete the email confirmation, we'll send you another email with details about how to start creating your app with the Veam It! Publisher.

If you have any questions, feel free to reach out directly at team@veamapp.com

Warm regards,
The Veam It! Publisher Team

This is an automated message from Veam - do not reply

EOME;
					}

					$sendTo = $email ;
					ConsoleTools::sendInfoMail($subject,$sendTo,$message) ;
				}
			}
		}

		if(count($errorMessages) > 0){
			print("ERROR_MESSAGE\n") ;
			print($errorMessages[0]."\n") ;
		} else {
			print("OK\n") ;
			print($this->getMessage('SUCCESS',$language)."\n") ;
		}

		return sfView::NONE ;

	}

	public function executeResetpasswordbyapp(sfWebRequest $request)
	{
		$email = $request->getParameter('email') ;
		$locale = $request->getParameter('loc') ;
		if(substr($locale,0,2) == 'ja'){
			$language = 'ja' ;
		} else {
			$language = 'en' ;
		}

		$errorMessages = array() ;
	  	$c = new Criteria();
	  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
	  	$c->add(AppCreatorPeer::USERNAME,$email) ;
		$appCreator = AppCreatorPeer::doSelectOne($c) ;
		if(!$appCreator){
			$errorMessages[] = $this->getMessage('NOT_FOUND',$language) ;
		} else {
			$alpha = 'acdefghkmnprstuvwxyz' ;
			$alphaLen = strlen($alpha) ;
			$password = substr($alpha,rand(0,$alphaLen-1),1) ;
			$password .= substr($alpha,rand(0,$alphaLen-1),1) ;
			$password .= sprintf('%06d',rand(100000,999999)) ;

			$appCreator->setPassword(strtolower(sha1($password))) ;
			$appCreator->save() ;

			if($language == 'ja'){
				$subject = "Veam パスワード再設定" ;
$message = <<< EOMJ
－－－－－－－－－－－－－－－－－－－－－－
このメールはVeamに登録いただいた方へ
システムが自動的にメール送信しています。
－－－－－－－－－－－－－－－－－－－－－－

■Veamへのログインパスワードについて■

パスワードを再設定いたしました。

新しいパスワードは $password です。

※本メールアドレス宛に返信頂いても、お返事することができません。
　あらかじめご了承下さい。
EOMJ;
		} else {

				$subject = "Veam automated message - New Password" ;
$message = <<< EOME

This is an automated message from Veam

Password reset was completed.
Your new password is $password

*Responses to this email will not go to customer support

EOME;

		}

			ConsoleTools::sendInfoMail($subject,$email,$message) ;

		}

		if(count($errorMessages) > 0){
			print("ERROR_MESSAGE\n") ;
			print($errorMessages[0]."\n") ;
		} else {
			print("OK\n") ;
			print($this->getMessage('RESET_SUCCESS',$language)."\n") ;
		}

		return sfView::NONE ;

	}

















	public function executeResetpassword(sfWebRequest $request)
	{
		$this->errorMessages = $request->getParameter('em') ;

	}

	public function executeSendpassword(sfWebRequest $request)
	{
		$email = $request->getParameter('email') ;

		$errorMessages = array() ;
	  	$c = new Criteria();
	  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
	  	$c->add(AppCreatorPeer::USERNAME,$email) ;
		$appCreator = AppCreatorPeer::doSelectOne($c) ;
		if(!$appCreator){
			$errorMessages[] = 'The email address you have entered is not registered.' ;
		} else {

			$user = $this->getUser() ;
			$language = substr($user->getCulture(),0,2) ;

			$alpha = 'acdefghkmnprstuvwxyz' ;
			$alphaLen = strlen($alpha) ;
			$password = substr($alpha,rand(0,$alphaLen-1),1) ;
			$password .= substr($alpha,rand(0,$alphaLen-1),1) ;
			$password .= sprintf('%06d',rand(100000,999999)) ;

			$appCreator->setPassword(strtolower(sha1($password))) ;
			$appCreator->save() ;

			if($language == 'ja'){
				$subject = "Veam パスワード再設定" ;
$message = <<< EOMJ
－－－－－－－－－－－－－－－－－－－－－－
このメールはVeamに登録いただいた方へ
システムが自動的にメール送信しています。
－－－－－－－－－－－－－－－－－－－－－－

■Veamへのログインパスワードについて■

パスワードを再設定いたしました。

新しいパスワードは $password です。

※本メールアドレス宛に返信頂いても、お返事することができません。
　あらかじめご了承下さい。
EOMJ;
		} else {

				$subject = "Veam automated message - New Password" ;
$message = <<< EOME

This is an automated message from Veam

Password reset was completed.
Your new password is $password

*Responses to this email will not go to customer support

EOME;

		}

			ConsoleTools::sendInfoMail($subject,$email,$message) ;

		}

		if(count($errorMessages) > 0){
			$request->setParameter('em',$errorMessages) ;
			$this->forward('account','resetpassword') ;
		}

	}


	public function executeTerms(sfWebRequest $request)
	{
	}

	public function executeGuideline(sfWebRequest $request)
	{
	}

	public function executePrivacy(sfWebRequest $request)
	{
	}























	public function executeInquiry(sfWebRequest $request)
	{
		$this->errorMessages = $request->getParameter('em') ;

		$errorMessages = array() ;
		$companyName = $request->getParameter('cn') ;
		$lastName = $request->getParameter('ln') ;
		$firstName = $request->getParameter('fn') ;
		$email = $request->getParameter('m') ;
		$tel = $request->getParameter('t') ;
		$snsUserName = $request->getParameter('sns') ;
		$query = $request->getParameter('q') ;
		$os = $request->getParameter('os') ;
		if($os == 'a'){
			$kind = $request->getParameter('k') ;
		} else {
			$kind = $request->getParameter('kind') ;
		}
		$app = $request->getParameter('app') ;

		$this->companyName = $companyName ;
		$this->lastName = $lastName ;
		$this->firstName = $firstName ;
		$this->email = $email ;
		$this->tel = $tel ;
		$this->snsUserName = $snsUserName ;
		$this->query = $query ;
		$this->kind = $kind ;
		$this->os = $os ;
		$this->app = $app ;

	}

	public function executeConfirminquiry(sfWebRequest $request)
	{

		$errorMessages = array() ;

		$errorMessages = array() ;
		$companyName = $request->getParameter('cn') ;
		$lastName = $request->getParameter('ln') ;
		$firstName = $request->getParameter('fn') ;
		$email = $request->getParameter('m') ;
		//$tel = $request->getParameter('t') ;
		$snsUserName = $request->getParameter('sns') ;
		$query = $request->getParameter('q') ;
		$kind = $request->getParameter('kind') ;
		$os = $request->getParameter('os') ;
		$app = $request->getParameter('app') ;

		if(!$lastName){
			$errorMessages[] = 'Please enter your last name.' ;
		}
		if(!$firstName){
			$errorMessages[] = 'Please enter your first name.' ;
		}
		if(!$email){
			$errorMessages[] = 'Please enter your mail address.' ;
		}
		/*
		if(!$tel){
			$errorMessages[] = 'Please enter your phone number.' ;
		}
		*/
		if(!$query){
			$errorMessages[] = 'Please type in your inquiry.' ;
		}

		$this->companyName = $companyName ;
		$this->lastName = $lastName ;
		$this->firstName = $firstName ;
		$this->email = $email ;
		//$this->tel = $tel ;
		$this->snsUserName = $snsUserName ;
		$this->query = $query ;
		$this->kind = $kind ;
		$this->os = $os ;
		$this->app = $app ;
		$this->errorMessages = $errorMessages ;

		$request->setParameter('em',$errorMessages) ;
		if(count($errorMessages) > 0){
			$this->forward('account','inquiry') ;
		}

	}






	public function executeRegisterinquiry(sfWebRequest $request)
	{

		$errorMessages = array() ;
		$companyName = $request->getParameter('cn') ;
		$lastName = $request->getParameter('ln') ;
		$firstName = $request->getParameter('fn') ;
		$email = $request->getParameter('m') ;
		//$tel = $request->getParameter('t') ;
		$snsUserName = $request->getParameter('sns') ;
		$query = $request->getParameter('q') ;
		$kind = $request->getParameter('kind') ;
		$os = $request->getParameter('os') ;
		$appId = $request->getParameter('app') ;

		if(!$lastName){
			$errorMessages[] = 'Please enter your last name.' ;
		}
		if(!$firstName){
			$errorMessages[] = 'Please enter your first name.' ;
		}
		if(!$email){
			$errorMessages[] = 'Please enter your mail address.' ;
		}
		/*
		if(!$tel){
			$errorMessages[] = 'Please enter your phone number.' ;
		}
		*/
		if(!$query){
			$errorMessages[] = 'Please type in your inquiry.' ;
		}


		if(!$errorMessages){

			ConsoleTools::saveConsoleLog($request,NULL) ;
			$user = $this->getUser() ;
			$language = substr($user->getCulture(),0,2) ;

			if($language == 'ja'){
				$subject = '[VEAM]CREATOR INQUIRY' ;
				if(ConsoleTools::getEnvString() == 'work'){
					$sendTo = 'tech@veam.co' ;
				} else {
					$sendTo = 'contact@veam.com' ;
				}
				$message = sprintf("Company Name : %s\r\n\r\nLast Name : %s\r\n\r\nFirst Name : %s\r\n\r\nEmail Address : %s\r\n\r\nSocial Media Info : %s\r\n\r\nInquiry : \r\n%s\r\n\r\n",$companyName,$lastName,$firstName,$email,$snsUserName,$query) ;
				ConsoleTools::sendInfoMail($subject,$sendTo,$message) ;
			} else {
				if($kind == 'veamit'){
					$subject = '[Veam It! Inquiry]' ;
					if($appId){
						$app = AppPeer::retrieveByPk($appId) ;
						if($app){
							$appName = $app->getName() ;
							$subject .= $appName ;
						}
					}
				} else if($kind == 'app'){
					if($appId){
						$app = AppPeer::retrieveByPk($appId) ;
						if($app){
							$appName = $app->getName() ;
							$subject = sprintf('[%s Inquiry]',$appName) ;
						}
					} else {
						$subject = '[App Inquiry]' ;
					}
				} else {
					$subject = '[Web Inquiry]' ;
				}
				if(ConsoleTools::getEnvString() == 'work'){
					$sendTo = 'tech@veam.co' ;
				} else {
					$sendTo = 'support@veam.zendesk.com' ;
				}

				$message = sprintf("Company Name : %s\r\n\r\nLast Name : %s\r\n\r\nFirst Name : %s\r\n\r\nEmail Address : %s\r\n\r\nSocial Media Info : %s\r\n\r\nInquiry : \r\n%s\r\n\r\n",$companyName,$lastName,$firstName,$email,$snsUserName,$query) ;
				if($appName){
					$message = sprintf("App Name : %s\r\n\r\n%s",$appName,$message) ;
				}
				$this->sendMailReplyToUser($subject,$sendTo,$email,$message) ;
//				ConsoleTools::sendInfoMail($subject,$sendTo,$message) ;
			}
		}


		$this->companyName = $companyName ;
		$this->lastName = $lastName ;
		$this->firstName = $firstName ;
		$this->email = $email ;
		$this->confirmEmail = $confirmEmail ;
		$this->password = $password ;
		$this->confirmPassword = $confirmPassword ;
		//$this->tel = $tel ;
		$this->youtubeUserName = $youtubeUserName ;
		$this->kind = $kind ;
		$this->os = $os ;
		$this->app = $app ;
		$this->errorMessages = $errorMessages ;

		$request->setParameter('em',$errorMessages) ;
		if(count($errorMessages) > 0){
			$this->forward('account','inquiry') ;
		}

	}


	// メールを送信する
	public static function sendMailReplyToUser($Subject,$To,$replyTo,$Body)
	{
		$Subject = mb_convert_encoding($Subject, "SJIS", "UTF-8");
		$Body = mb_convert_encoding($Body, "SJIS", "UTF-8");

		mb_language('japanese');
		$Subject = mb_convert_encoding($Subject,"ISO-2022-JP","SJIS");
		$Subject = mb_convert_kana($Subject, 'KV', "SJIS");
		$Body = mb_convert_encoding($Body,"ISO-2022-JP","SJIS");
		$Body = mb_convert_kana($Body, 'KV', "SJIS");
		$From = sprintf("From: support@veam.co\nReply-To: %s",$replyTo) ;
		mb_send_mail($To, $Subject, $Body, $From);
	}


	public function executeValidate(sfWebRequest $request)
	{
		$token = $request->getParameter('t') ;

		$this->result = '' ;

		if($token){
		  	$c = new Criteria();
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::VALID,0) ;
		  	$c->add(AppCreatorPeer::VALIDATION_TOKEN,$token) ;
			$appCreator = AppCreatorPeer::doSelectOne($c) ;
			if($appCreator){
				$appCreator->setValid(1) ;
				$appCreator->setApprove(1) ;
				$appCreator->save() ;

				$app = AppPeer::retrieveByPk($appCreator->getAppId()) ;
				if($app){
					$mcnId = $app->getMcnId() ;
				}

				ConsoleTools::saveConsoleLog($request,NULL) ;
				if($mcnId == 4){ // Veam
					$subject = '[VEAM]CREATOR REGISTERED : Veam' ;
					if(ConsoleTools::getEnvString() == 'work'){
						$sendTo = 'tech@veam.co' ;
					} else {
						$sendTo = 'contact@veam.co' ;
					}
				} else {
					$subject = '[VEAM]CREATOR REGISTERED : VeamLP' ;
					if(ConsoleTools::getEnvString() == 'work'){
						$sendTo = 'tech@veam.co' ;
					} else {
						$sendTo = 'contact@veam.co' ;
					}
				}
				$approvalUrl = sprintf("http://%s/creator.php/account/approve/t/%s",$_SERVER['SERVER_NAME'],$appCreator->getApprovalToken()) ;
				$message = sprintf("クリエータの登録がありました。\r\n\r\n姓 : %s\r\n\r\n名 : %s\r\n\r\nメールアドレス : %s\r\n\r\n電話番号 : %s\r\n\r\n",
					$appCreator->getLastName(),
					$appCreator->getFirstName(),
					$appCreator->getUsername(),
					$appCreator->getTelephone()
					) ;

				ConsoleTools::sendInfoMail($subject,$sendTo,$message) ;

				$loginUrl = sprintf("http://%s/creator.php/",$_SERVER['SERVER_NAME']) ;

				if($language == 'ja'){
					$subject = 'Veam メールアドレス確認' ;
$message = <<< EOMJ
－－－－－－－－－－－－－－－－－－－－－－
このメールはVeamに登録いただいた方へ
システムが自動的にメール送信しています。
－－－－－－－－－－－－－－－－－－－－－－

■Veam本登録作業について■

この度はVeamにご登録いただき、誠にありがとうございます。

Veamへの本登録が完了しました。

以下のURLをクリックしてログインしてください。

$loginUrl

※本メールアドレス宛に返信頂いても、お返事することができません。
　あらかじめご了承下さい。
EOMJ;
				} else {
					$subject = "Congratulations! You're ready to create your app with the Veam It! Publisher" ;
$message = <<< EOME

Hi again,

Thanks for confirming your email address, now it's time to get started!

To get started, please download the Veam It! Publisher App from the App Store for iOS:
https://itunes.apple.com/us/app/veam-it!-publisher-app/id953709465?l

And Google Play
https://play.google.com/store/apps/details?id=co.veam.veam31000287

Login with the email address and password from sign up and begin filling out the template.

This Veam It! Publisher tutorial should help you get started:
https://www.youtube.com/watch?v=RcMVxHdF8To

You can also check out the Veam Help Center at https://veam.zendesk.com/hc/

If you have any trouble at all, email team@veamapp.com for quick, helpful support.

-The Veam It! Publisher Team

This is an automated message from Veam - do not reply

EOME;
				}

				$sendTo = $appCreator->getUsername() ;
				ConsoleTools::sendInfoMail($subject,$sendTo,$message) ;

			}
		}
	}


	public function executeApprove(sfWebRequest $request)
	{
		$token = $request->getParameter('t') ;

		$this->result = '' ;

		if($token){
		  	$c = new Criteria();
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::APPROVE,0) ;
		  	$c->add(AppCreatorPeer::APPROVAL_TOKEN,$token) ;
			$appCreator = AppCreatorPeer::doSelectOne($c) ;
			if($appCreator){

				$appCreator->setApprove(1) ;
				$appCreator->save() ;

				$loginUrl = sprintf("http://%s/creator.php/",$_SERVER['SERVER_NAME']) ;

$message = <<< EOM
－－－－－－－－－－－－－－－－－－－－－－
このメールはVeamに登録いただいた方へ
システムが自動的にメール送信しています。
－－－－－－－－－－－－－－－－－－－－－－

■Veam本登録作業について■

この度はVeamにご登録いただき、誠にありがとうございます。

Veamへの本登録が完了しました。

以下のURLをクリックしてログインしてください。

$loginUrl

※本メールアドレス宛に返信頂いても、お返事することができません。
　あらかじめご了承下さい。
EOM;

				$sendTo = $appCreator->getUsername() ;
				ConsoleTools::sendInfoMail("Veam",$sendTo,$message) ;
			}
		}
	}




}
