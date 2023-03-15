<?php

define('APP_ACTION_KIND_ALL'			,1) ;
define('APP_ACTION_KIND_RELEASED'		,2) ;
define('APP_ACTION_KIND_UNRELEASED'		,3) ;
define('APP_ACTION_KIND_STATUS'			,4) ;

/**
 * app actions.
 *
 * @package    console
 * @subpackage app
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class appActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */

	public function executeListall(sfWebRequest $request)
	{
		$this->prepareAppList($request,APP_ACTION_KIND_ALL) ;
	}

	public function executeListreleased(sfWebRequest $request)
	{
		$this->prepareAppList($request,APP_ACTION_KIND_RELEASED) ;
	}

	public function executeListunreleased(sfWebRequest $request)
	{
		$this->prepareAppList($request,APP_ACTION_KIND_UNRELEASED) ;
	}


	public function executeListforstatus(sfWebRequest $request)
	{
		$this->prepareAppList($request,APP_ACTION_KIND_STATUS) ;
	}

	public function prepareAppList(sfWebRequest $request,$kind)
	{
		$page = $request->getParameter('p') ;
		$processCategoryId = $request->getParameter('pc') ;
		$sortKind = $request->getParameter('so') ;
		$appName = $request->getParameter('na') ;
		$appId = $request->getParameter('a') ;
		$processCategory = "" ;
		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;

		if($appName){
		  	$c->add(AppPeer::NAME,'%'.$appName.'%',Criteria::LIKE) ;
		}

		if($appId){
		  	$c->add(AppPeer::ID,$appId) ;
		}

		if($kind == APP_ACTION_KIND_RELEASED){
		  	$c->add(AppPeer::STATUS,0) ;
		} else if($kind == APP_ACTION_KIND_UNRELEASED) {
		  	$c->add(AppPeer::STATUS,0,Criteria::NOT_EQUAL) ;
		} else if($kind == APP_ACTION_KIND_STATUS) {
			$appProcesses = AdminTools::getAppProcessesForAppProcessCategory($processCategoryId) ;
			$appProcessIds = AdminTools::getIdsForObjects($appProcesses) ;
			$processCategory = AppProcessCategoryPeer::retrieveByPk($processCategoryId) ;
			if($processCategoryId != 5){ // settings
			  	$c->add(AppPeer::CURRENT_PROCESS,$appProcessIds,Criteria::IN) ;
			  	$c->add(AppPeer::STATUS,0,Criteria::NOT_EQUAL) ;
			} else if($processCategoryId == 2){ // MCN Review
				$criterion = $c->getNewCriterion(AppPeer::CURRENT_PROCESS,$appProcessIds,Criteria::IN) ;
				$criterion->addOr($c->getNewCriterion(AppPeer::STATUS,2));
				$c->add($criterion);
			} else {
				$criterion = $c->getNewCriterion(AppPeer::CURRENT_PROCESS,$appProcessIds,Criteria::IN) ;
				$criterion->addOr($c->getNewCriterion(AppPeer::STATUS,0));
				$c->add($criterion);
			}
		}

		if($kind == APP_ACTION_KIND_RELEASED){
			$sortCulmn = AppPeer::RELEASED_AT ;
		} else {
			$sortCulmn = AppPeer::CREATED_AT ;
		}
		if($sortKind == 1){
			$c->addAscendingOrderByColumn($sortCulmn) ;
		} else {
			$c->addDescendingOrderByColumn($sortCulmn) ;
		}

		$pager = new sfPropelPager('App', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$apps = $pager->getResults() ;
		}

		$appMap = AdminTools::getMapForObjects($apps) ;

		$appIds = AdminTools::getIdsForObjects($apps) ;

	  	$c = new Criteria() ;
	  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
	  	$c->add(AppCreatorPeer::APP_ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(AppCreatorPeer::ID) ;
		$appCreators = AppCreatorPeer::doSelect($c) ;
		$appCreatorsMapForAppId = array() ;
		foreach($appCreators as $appCreator){
			$appId = $appCreator->getAppId() ;
			if(!isset($appCreatorsMapForAppId[$appId])){
				$appCreatorsMapForAppId[$appId] = array() ;
			}
			$appCreatorsMapForAppId[$appId][] = $appCreator ;
		}


	  	$c = new Criteria() ;
	  	$c->add(YoutubeAdditionalChannelPeer::DEL_FLG,0) ;
	  	$c->add(YoutubeAdditionalChannelPeer::APP_ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(YoutubeAdditionalChannelPeer::ID) ;
		$youtubeAdditionalChannels = YoutubeAdditionalChannelPeer::doSelect($c) ;
		$youtubeAdditionalChannelMapForAppId = array() ;
		foreach($youtubeAdditionalChannels as $youtubeAdditionalChannel){
			$appId = $youtubeAdditionalChannel->getAppId() ;
			if(!isset($youtubeAdditionalChannelMapForAppId[$appId])){
				$youtubeAdditionalChannelMapForAppId[$appId] = array() ;
			}
			$youtubeAdditionalChannelMapForAppId[$appId][] = $youtubeAdditionalChannel ;
		}


	  	$c = new Criteria() ;
	  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
	  	$c->add(TemplateSubscriptionPeer::APP_ID,$appIds,Criteria::IN) ;
		$templateSubscriptions = TemplateSubscriptionPeer::doSelect($c) ;
		$templateSubscriptionMapForAppId = array() ;
		foreach($templateSubscriptions as $templateSubscription){
			$appId = $templateSubscription->getAppId() ;
			$templateSubscriptionMapForAppId[$appId] = $templateSubscription ;
		}



		$lastUpdatedAt = array() ;
		foreach($apps as $app){
			if($app->getStatus() == 0){
				$appId = $app->getId() ;
				$templateSubscription = $templateSubscriptionMapForAppId[$appId] ;
				if($templateSubscription){
					$paymentType = $templateSubscription->getKind() ;
					if($paymentType == 4){ // SUBSCRIPTION
					  	$c = new Criteria() ;
					  	$c->add(MixedPeer::DEL_FLG,0) ;
					  	$c->add(MixedPeer::APP_ID,$appId) ;
					  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
						$c->addDescendingOrderByColumn(MixedPeer::UPDATED_AT) ;
						$mixed = MixedPeer::doSelectOne($c) ;
						if($mixed){
							$lastUpdatedAt[$appId] = $mixed->getUpdatedAt() ;
						}
					} else if($paymentType == 5){ // PPC

					  	$c = new Criteria() ;
					  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
					  	$c->add(SellVideoPeer::APP_ID,$appId) ;
						$c->addDescendingOrderByColumn(SellVideoPeer::UPDATED_AT) ;
						$sellVideo = SellVideoPeer::doSelectOne($c) ;
						if($sellVideo){
							$lastUpdatedAt[$appId] = $sellVideo->getUpdatedAt() ;
						}

					  	$c = new Criteria() ;
					  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
					  	$c->add(SellAudioPeer::APP_ID,$appId) ;
						$c->addDescendingOrderByColumn(SellAudioPeer::UPDATED_AT) ;
						$sellAudio = SellAudioPeer::doSelectOne($c) ;
						if($sellAudio){
							if(!$lastUpdatedAt[$appId] || (strcmp($sellAudio->getUpdatedAt(),$lastUpdatedAt[$appId]) > 0)){
								$lastUpdatedAt[$appId] = $sellAudio->getUpdatedAt() ;
							}
						}

					  	$c = new Criteria() ;
					  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
					  	$c->add(SellPdfPeer::APP_ID,$appId) ;
						$c->addDescendingOrderByColumn(SellPdfPeer::UPDATED_AT) ;
						$sellPdf = SellPdfPeer::doSelectOne($c) ;
						if($sellPdf){
							if(!$lastUpdatedAt[$appId] || (strcmp($sellPdf->getUpdatedAt(),$lastUpdatedAt[$appId]) > 0)){
								$lastUpdatedAt[$appId] = $sellPdf->getUpdatedAt() ;
							}
						}
					} else if($paymentType == 6){ // PPS
					  	$c = new Criteria() ;
					  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
					  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
						$c->addDescendingOrderByColumn(SellSectionItemPeer::UPDATED_AT) ;
						$sellSectionItem = SellSectionItemPeer::doSelectOne($c) ;
						if($sellSectionItem){
							$lastUpdatedAt[$appId] = $sellSectionItem->getUpdatedAt() ;
						}
					}
				}
			}
		}



		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$this->apps = $apps ;
		$this->appName = $appName ;
		$this->page = $page ;
		$this->appCreatorsMapForAppId = $appCreatorsMapForAppId ;
		$this->youtubeAdditionalChannelMapForAppId = $youtubeAdditionalChannelMapForAppId ;
		$this->processCategoryId = $processCategoryId ;
		$this->processCategory = $processCategory ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->templateSubscriptionMapForAppId = $templateSubscriptionMapForAppId ;
		$this->lastUpdatedAt = $lastUpdatedAt ;
	}


	public function executeDetailforstatus(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app && ($app->getMcnId() == $this->mcnId)){
		  	$c = new Criteria() ;
		  	$c->add(AppProcessLogPeer::DEL_FLAG,0) ;
		  	$c->add(AppProcessLogPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(AppProcessLogPeer::ID) ;
			$appProcessLogs = AppProcessLogPeer::doSelect($c) ;
			$appProcessLogMapForProcess = array() ;
			foreach($appProcessLogs as $appProcessLog){
				$appProcessLogMapForProcess[$appProcessLog->getAppProcessId()] = $appProcessLog ;
			}

			$currentProcess = AppProcessPeer::retrieveByPk($app->getCurrentProcess()) ;
			if(!$currentProcess){
				$currentProcess = AppProcessPeer::retrieveByPk(10100) ; // start process
			}

			$this->app = $app ;
			$this->appProcessLogMapForProcess = $appProcessLogMapForProcess ;
			$this->currentProcess = $currentProcess ;
		}
	}

	public function executeCompleteprocess(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$appProcessId = $request->getParameter('p') ;
		$result = $request->getParameter('r') ;

		$app = AppPeer::retrieveByPk($appId) ;
		if($app && ($app->getMcnId() == $this->mcnId)){
			AdminTools::completeProcess($appId,$appProcessId,$result,$this->getUser()->getUsername()) ;
		}
		$this->forward('app','detailforstatus') ;
	}

	public function executeEnterapskey(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->type = $request->getParameter('t') ;
		$this->errorMessage = $request->getParameter('e') ;
	}

	public function executeUploadapskey(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$type = $request->getParameter('t') ;

		$fileFix = ($type == 'p')?"PRO":"DEV" ;

		$orgFileName = $_FILES['apsfile']['name'] ;
		$expectedFileName = sprintf('APS_%s_%s.p12',$fileFix,$appId) ;
		if($orgFileName != $expectedFileName){
			$request->setParameter('e',sprintf('The file name should be %s',$expectedFileName)) ;
			$this->forward('app','enterapskey') ;
			return ;
		}


		$p12Dir = sfConfig::get("sf_lib_dir")."/task/apn_p12" ;
		$p12FilePath = sprintf("%s/%s",$p12Dir,$expectedFileName) ;
		if(is_uploaded_file($_FILES["apsfile"]["tmp_name"])){
			if(move_uploaded_file($_FILES["apsfile"]["tmp_name"], $p12FilePath)){
				chmod($p12FilePath, 0666) ;

				$certDir = sfConfig::get("sf_lib_dir")."/task/apn_certs" ;

				$certFilePath = sprintf("%s/apns_%s_cert_%s.pem",$p12Dir,$fileFix,$appId) ;
				$keyFilePath = sprintf("%s/apns_%s_key_%s.pem",$p12Dir,$fileFix,$appId) ;
				$planeKeyFilePath = sprintf("%s/apns_%s_nopass_key_%s.pem",$p12Dir,$fileFix,$appId) ;
				$pemFilePath = sprintf("%s/APN_%s_%s.pem",$certDir,$appId,($type == 'p')?"PROD":"DEV") ;
				$pemFileName = sprintf("APN_%s_%s.pem",$appId,($type == 'p')?"PROD":"DEV") ;

				// convert p12 to pem
				$commandLine = sprintf('openssl pkcs12 -clcerts -nokeys -out %s -in %s -password pass:',$certFilePath,$p12FilePath) ;
				exec($commandLine) ;
				$commandLine = sprintf('openssl pkcs12 -nocerts -out %s -in %s -password pass: -passout pass:hogehoge',$keyFilePath,$p12FilePath) ;
				exec($commandLine) ;
				$commandLine = sprintf('openssl rsa -in %s -out %s -passin pass:hogehoge',$keyFilePath,$planeKeyFilePath) ;
				exec($commandLine) ;
				$commandLine = sprintf('cat %s %s > %s',$certFilePath,$planeKeyFilePath,$pemFilePath) ;
				exec($commandLine) ;

				if(file_exists($pemFilePath)){

					// upload to app.veam.co
					$env = ConsoleTools::getEnvString() ;
					if($env == 'work'){
						$appDomain = 'app-work.veam.co' ;
					} else if($env == 'preview'){
						$appDomain = 'app-preview.veam.co' ;
					} else {
						$appDomain = 'app.veam.co' ;
					}

					$url = sprintf('http://%s/dataapi/uploadapskey',$appDomain) ;

					$apsKey = file_get_contents($pemFilePath) ;

					$data = array(
						"p" => "__P12_ENC_KEY__",
						"f" => $pemFileName,
						"k" => $apsKey
					) ;

					$data = http_build_query($data, "", "&") ;

					$header = array(
						"Content-Type: application/x-www-form-urlencoded",
						"Content-Length: ".strlen($data)
					) ;

					$context = array(
						"http" => array(
							"method"  => "POST",
							"header"  => implode("\r\n", $header),
							"content" => $data
						)
					);

					$result = file_get_contents($url, false, stream_context_create($context)) ;
					if($result != 'OK'){
						AdminTools::assert(false,"upload pem to app.veam.co failed file=$pemFileName",__FILE__,__LINE__) ;
					}






					$checkFileFix = ($type == 'p')?"DEV":"PROD" ;
					$checkPemFilePath = sprintf("%s/APN_%s_%s.pem",$certDir,$appId,$checkFileFix) ;
					if(file_exists($checkPemFilePath)){
						// uploaded both
						AdminTools::completeProcess($appId,'30300',1,$this->getUser()->getUsername()) ;
					}
					$this->uploadedFileName = $orgFileName ;
				} else {
					AdminTools::assert(false,"create pem failed appId=$appId",__FILE__,__LINE__) ;
					$request->setParameter('e',sprintf('Upload failed')) ;
					$this->forward('app','enterapskey') ;
				}
			} else {
				AdminTools::assert(false,"create pem failed appId=$appId",__FILE__,__LINE__) ;
				$request->setParameter('e',sprintf('Upload failed')) ;
				$this->forward('app','enterapskey') ;
			}
		} else {
			AdminTools::assert(false,"create pem failed appId=$appId",__FILE__,__LINE__) ;
			$request->setParameter('e',sprintf('Upload failed')) ;
			$this->forward('app','enterapskey') ;
		}
	}









	public function executeEnterapk(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->errorMessage = $request->getParameter('e') ;
	}

	public function executeUploadapk(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;

		if($appId){
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$orgFileName = $_FILES['apkfile']['name'] ;
				$expectedFileName = sprintf('veam%s-release.apk',$appId) ;
				if($orgFileName != $expectedFileName){
					$request->setParameter('e',sprintf('The file name should be %s',$expectedFileName)) ;
					$this->forward('app','enterapk') ;
					return ;
				}

				$apkPath = sprintf("/apk/%s/%s/%05d",$appId,date("YmdHis"),rand(0,99999)) ;
				$apkDir = sprintf("%s%s",sfConfig::get("sf_web_dir"),$apkPath) ;
				mkdir($apkDir,0777,true) ;
				$apkFilePath = sprintf("%s/%s",$apkDir,$expectedFileName) ;
				if(is_uploaded_file($_FILES["apkfile"]["tmp_name"])){
					if(move_uploaded_file($_FILES["apkfile"]["tmp_name"], $apkFilePath)){
						chmod($apkFilePath, 0666) ;
						$apkUrl = sprintf("http://%s%s/%s",$_SERVER['SERVER_NAME'],$apkPath,$expectedFileName) ;
						$app->setApkUrl($apkUrl) ;
						$app->save() ;
						AdminTools::completeProcess($appId,'30925',1,$this->getUser()->getUsername()) ;
						$this->uploadedFileName = $expectedFileName ;
					} else {
						AdminTools::assert(false,"upload apk failed appId=$appId",__FILE__,__LINE__) ;
						$request->setParameter('e',sprintf('Upload failed')) ;
						$this->forward('app','enterapk') ;
					}
				} else {
					AdminTools::assert(false,"upload apk failed appId=$appId",__FILE__,__LINE__) ;
					$request->setParameter('e',sprintf('Upload failed')) ;
					$this->forward('app','enterapk') ;
				}
			} else {
				AdminTools::assert(false,"app not found appId=$appId",__FILE__,__LINE__) ;
				$request->setParameter('e',sprintf('Invalid appId')) ;
				$this->forward('app','enterapk') ;
			}
		}
	}










	public function executeEnterfacebookappid(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->facebookAppId = $request->getParameter('f') ;
		$this->errorMessage = $request->getParameter('e') ;
	}


	public function executeRegisterfacebookappid(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$facebookAppId = $request->getParameter('f') ;

		if($appId){
			if($facebookAppId){
				$app = AppPeer::retrieveByPk($appId) ;
				if($app && ($app->getMcnId() == $this->mcnId)){
					$app->setFacebookApp($facebookAppId) ;
					$app->save() ;
					AdminTools::completeProcess($appId,30800,1,$this->getUser()->getUsername()) ;
				}
			} else {
				$request->setParameter('e',sprintf('Enter Facebook App ID')) ;
				$this->forward('app','enterfacebookappid') ;
			}
		}
	}










	public function executeEnteriabpublic(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->iabPublic = $request->getParameter('p') ;
		$this->errorMessage = $request->getParameter('e') ;
	}


	public function executeRegisteriabpublic(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$iabPublic = $request->getParameter('p') ;

		if($appId){
			if($iabPublic){
				$app = AppPeer::retrieveByPk($appId) ;
				if($app && ($app->getMcnId() == $this->mcnId)){
					$app->setIabPublic($iabPublic) ;
					$app->save() ;
					AdminTools::completeProcess($appId,30750,1,$this->getUser()->getUsername()) ;
				}
			} else {
				$request->setParameter('e',sprintf('Enter Facebook App ID')) ;
				$this->forward('app','enterfacebookappid') ;
			}
		}
	}













	public function executeEnterkiipapp(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->kiipAppKey = $request->getParameter('kk') ;
		$this->kiipAppSecret = $request->getParameter('ks') ;
		$this->errorMessage = $request->getParameter('e') ;
	}


	public function executeRegisterkiipapp(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$kiipAppKey = $request->getParameter('kk') ;
		$kiipAppSecret = $request->getParameter('ks') ;

		if($appId){
			$errorMessage = "" ;
			if(!$kiipAppKey){
				$errorMessage .= 'Enter Kiip App Key<br />' ;
			}
			if(!$kiipAppSecret){
				$errorMessage .= 'Enter Kiip App Secret<br />' ;
			}

			if(!$errorMessage){
				$app = AppPeer::retrieveByPk($appId) ;
				if($app && ($app->getMcnId() == $this->mcnId)){
					$app->setKiipAppKey($kiipAppKey) ;
					$app->setKiipAppSecret($kiipAppSecret) ;
					$app->save() ;
					//AdminTools::completeProcess($appId,30900,1,$this->getUser()->getUsername()) ;  // do this when android done
				}
			} else {
				$request->setParameter('e',$errorMessage) ;
				$this->forward('app','enterkiipapp') ;
			}
		}
	}






	public function executeEnterkiipappforandroid(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->kiipAppKey = $request->getParameter('kk') ;
		$this->kiipAppSecret = $request->getParameter('ks') ;
		$this->errorMessage = $request->getParameter('e') ;
	}


	public function executeRegisterkiipappforandroid(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$kiipAppKey = $request->getParameter('kk') ;
		$kiipAppSecret = $request->getParameter('ks') ;

		if($appId){
			$errorMessage = "" ;
			if(!$kiipAppKey){
				$errorMessage .= 'Enter Kiip App Key<br />' ;
			}
			if(!$kiipAppSecret){
				$errorMessage .= 'Enter Kiip App Secret<br />' ;
			}

			if(!$errorMessage){
				$app = AppPeer::retrieveByPk($appId) ;
				if($app && ($app->getMcnId() == $this->mcnId)){
					$app->setKiipAndroidAppKey($kiipAppKey) ;
					$app->setKiipAndroidAppSecret($kiipAppSecret) ;
					$app->save() ;
					AdminTools::completeProcess($appId,30900,1,$this->getUser()->getUsername()) ;
				}
			} else {
				$request->setParameter('e',$errorMessage) ;
				$this->forward('app','enterkiipappforandroid') ;
			}
		}
	}









	public function executeRegisteradmob(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;


		if($appId){
			$idNames = array(
				//"ios_exclusive",
				//"ios_playlist_category",
				//"ios_playlist",
				//"ios_forum_category",
				//"ios_forum",
				"ios_forum_native",
				//"ios_links_category",
				//"ios_post_picture",
				//"ios_post_picture_comment",
				//"android_exclusive",
				//"android_playlist_category",
				//"android_playlist",
				//"android_forum_category",
				//"android_forum",
				"android_forum_native",
				//"android_links_category",
				//"android_post_picture",
				//"android_post_picture_comment",
			) ;

			$adIds = array() ;
			foreach($idNames as $idName){
				$adIds[$idName] = trim($request->getParameter($idName)) ;
				if(!$adIds[$idName]){
					$errorMessage .= sprintf('Enter %s<br />',$idName) ;
				}
			}

			if(!$errorMessage){
				$app = AppPeer::retrieveByPk($appId) ;
				if($app && ($app->getMcnId() == $this->mcnId)){
					foreach($idNames as $idName){
						$name = '' ;
						if(substr($idName,0,4) == 'ios_'){
							$kind = 1 ; // iOS
							$name = substr($idName,4) ;
						} else if(substr($idName,0,8) == 'android_'){
							$kind = 2 ; // Android
							$name = substr($idName,8) ;
						}
						if($name){
							$c = new Criteria() ;
							$c->add(AdmobPeer::APP_ID,$appId) ;
							$c->add(AdmobPeer::NAME,$name) ;
							$c->add(AdmobPeer::KIND,$kind) ;
							$admob = AdmobPeer::doSelectOne($c) ;
							if(!$admob){
								$admob = new Admob() ;
								$admob->setAppId($appId) ;
								$admob->setKind($kind) ;
								$admob->setName($name) ;
							}
							$admob->setUnitId($adIds[$idName]) ;
							$admob->save() ;
						}
					}
					AdminTools::completeProcess($appId,30900,1,$this->getUser()->getUsername()) ;
				}
			} else {
				$this->errorMessage = $errorMessage ;
			}
		} else {
			$this->errorMessage = 'Invalid App ID' ;
		}
	}








	public function executeEntertwitterapp(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->twitterConsumerKey = $request->getParameter('tk') ;
		$this->twitterConsumerSecret = $request->getParameter('ts') ;
		$this->errorMessage = $request->getParameter('e') ;
	}


	public function executeRegistertwitterapp(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$twitterConsumerKey = $request->getParameter('tk') ;
		$twitterConsumerSecret = $request->getParameter('ts') ;

		if($appId){
			$errorMessage = "" ;
			if(!$twitterConsumerKey){
				$errorMessage .= 'Enter Twitter Consumer Key<br />' ;
			}
			if(!$twitterConsumerSecret){
				$errorMessage .= 'Enter Twitter Consumer Secret<br />' ;
			}

			if(!$errorMessage){
				$app = AppPeer::retrieveByPk($appId) ;
				if($app && ($app->getMcnId() == $this->mcnId)){
					$app->setTwitterConsumerKey($twitterConsumerKey) ;
					$app->setTwitterConsumerSecret($twitterConsumerSecret) ;
					$app->save() ;
					AdminTools::completeProcess($appId,30850,1,$this->getUser()->getUsername()) ;
				}
			} else {
				$request->setParameter('e',$errorMessage) ;
				$this->forward('app','entertwitterapp') ;
			}
		}
	}





	public function executeUpdateplaylist(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;

		if(($appId > 31000030) || ($appId == 31000024)){
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

			$commandLine = sprintf("php /data/console/%s/site/symfony updateYoutubelist --command_id=%d > /dev/null",AdminTools::getServerNameForDb(),$remoteCommand->getId()) ;
			//print("$commandLine\n") ;
			exec($commandLine) ;

			echo 'OK' ;
		} else {
			echo 'Not supported for this app' ;
		}
		return sfView::NONE ;
	}

	public function executeUpdatescreenshot(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;

		if(($appId > 31000030) || ($appId == 31000024)){

			
			// create concept color
			$seedString = sprintf("%d%d%d",time(),rand(),rand()) ;
			$secret = sha1($seedString) ;
			$remoteCommand = new RemoteCommand() ;
			$remoteCommand->setAppId($appId) ;
			$remoteCommand->setName('UPDATE_CONCEPT_COLOR') ;
			$remoteCommand->setSecret($secret) ;
			$remoteCommand->setStatus(0) ;
			$remoteCommand->setParams('') ;
			$remoteCommand->save() ;

			$commandLine = sprintf("php /data/console/%s/site/symfony updateConceptcolor --command_id=%d > /dev/null",AdminTools::getServerNameForDb(),$remoteCommand->getId()) ;
			//print("$commandLine\n") ;
			exec($commandLine) ;


			// create screen shot
			$seedString = sprintf("%d%d%d",time(),rand(),rand()) ;
			$secret = sha1($seedString) ;
			$remoteCommand = new RemoteCommand() ;
			$remoteCommand->setAppId($appId) ;
			$remoteCommand->setName('UPDATE_SCREEN_SHOT') ;
			$remoteCommand->setSecret($secret) ;
			$remoteCommand->setStatus(0) ;
			$remoteCommand->setParams('') ;
			$remoteCommand->save() ;

			/*
			// remove files to be refreshed
			$imageDir = sprintf("/data/console/%s/bin/image/%d",AdminTools::getServerNameForDb(),$appId) ;
			unlink(sprintf("%s/ss2_3i_text.png",$imageDir)) ;
			unlink(sprintf("%s/ss2_text.png",$imageDir)) ;
			*/

			$commandLine = sprintf("php /data/console/%s/site/symfony updateScreenshot --command_id=%d > /dev/null",AdminTools::getServerNameForDb(),$remoteCommand->getId()) ;
			//print("$commandLine\n") ;
			exec($commandLine) ;

			echo 'OK' ;
		} else {
			echo 'Not supported for this app' ;
		}
		return sfView::NONE ;
	}

	public function executePublishcontent(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;

		if(($appId > 31000030) || ($appId == 31000024)){
			// create youtube list
			$seedString = sprintf("%d%d%d",time(),rand(),rand()) ;
			$secret = sha1($seedString) ;
			$remoteCommand = new RemoteCommand() ;
			$remoteCommand->setAppId($appId) ;
			$remoteCommand->setName('DEPLOY_APP') ;
			$remoteCommand->setSecret($secret) ;
			$remoteCommand->setStatus(0) ;
			$remoteCommand->setParams('') ;
			$remoteCommand->save() ;

			$commandLine = sprintf("php /data/console/%s/site/symfony deployAppcontents --command_id=%d > /dev/null",AdminTools::getServerNameForDb(),$remoteCommand->getId()) ;
			//print("$commandLine\n") ;
			exec($commandLine) ;

			echo 'OK' ;
		} else {
			echo 'Not supported for this app' ;
		}
		return sfView::NONE ;
	}



	public function executeInputnewadditionalchannel(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
		$this->youtubeChannelId = $request->getParameter('c') ;
		$this->appId = $request->getParameter('a') ;
	}

	public function executeAddnewadditionalchannel(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
		$appId = $request->getParameter('a') ;
		$youtubeChannelId = $request->getParameter('c') ;

		if($youtubeChannelId){
			$c = new Criteria() ;
			$c->add(YoutubeAdditionalChannelPeer::YOUTUBE_CHANNEL_ID,$youtubeChannelId) ;
			$youtubeAdditionalChannel = YoutubeAdditionalChannelPeer::doSelectOne($c) ;
			if($youtubeAdditionalChannel){
				$request->setParameter('error_message','Already added.') ;
				$this->forward('app','inputnewadditionalchannel') ;
			} else {
				$youtubeAdditionalChannel = new YoutubeAdditionalChannel() ;
				$youtubeAdditionalChannel->setAppId($appId) ;
				$youtubeAdditionalChannel->setYoutubeChannelId($youtubeChannelId) ;
				$youtubeAdditionalChannel->save() ;
				$request->setParameter('a',$appId) ;
				$this->forward('app','listall') ;
			}
		} else {
			$request->setParameter('error_message','Please enter Youtbue Channel ID') ;
			$this->forward('app','inputnewadditionalchannel') ;
		}
	}



}
