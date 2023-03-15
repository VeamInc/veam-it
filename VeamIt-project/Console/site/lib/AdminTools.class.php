<?php
//
// This class is used by all apprications.
// Modification will affect to all applications.
//

// sfContext::getInstance()->getLogger()->info(sprintf("target=%d blockedUsersList=%s",$socialUserId,$blockedUsersList)) ;

//include 'HTTP/OAuth/Consumer.php';

//require_once 'Mail.php'; 

define('ADMIN_SAMPLE_KEY','ADMIN_SAMPLE_VALUE') ; //

//////////////////////////////////////////////////
////// DASHBOARD
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_APP',						'DASHBOARD_APP') ;
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_SUBSCRIPTION',			'DASHBOARD_SUBSCRIPTION') ;
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_PAYPERCONTENT',			'DASHBOARD_PAYPERCONTENT') ;
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_YOUTUBE',					'DASHBOARD_YOUTUBE') ;
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_FORUM',					'DASHBOARD_FORUM') ;
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_LINK',					'DASHBOARD_LINK') ;
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_OTHER',					'DASHBOARD_OTHER') ;
define('ACCORDION_TOGGLE_TARGET_DASHBOARD_MI',						'DASHBOARD_MI') ; // Musicians Institute

//// DASHBOARD/APP
define('ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTALL',				'DASHBOARD_APP_LISTALL') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTRELEASED',			'DASHBOARD_APP_LISTRELEASED') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTUNRELEASED',		'DASHBOARD_APP_LISTUNRELEASED') ;

//// DASHBOARD/SUBSCRIPTION
define('ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTCONTENT',	'DASHBOARD_SUBSCRIPTION_LISTCONTENT') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTDELAYED',	'DASHBOARD_SUBSCRIPTION_LISTDELAYED') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTLONGDELAYED',	'DASHBOARD_SUBSCRIPTION_LISTLONGDELAYED') ;

//// DASHBOARD/PAYPERCONTENT
define('ACCORDION_INNER_TARGET_DASHBOARD_PAYPERCONTENT_LISTVIDEO',	'DASHBOARD_PAYPERCONTENT_LISTVIDEO') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_PAYPERCONTENT_LISTAUDIO',	'DASHBOARD_PAYPERCONTENT_LISTAUDIO') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_PAYPERCONTENT_LISTPDF',	'DASHBOARD_PAYPERCONTENT_LISTPDF') ;

//// DASHBOARD/YOUTUBE
define('ACCORDION_INNER_TARGET_DASHBOARD_YOUTUBE_LISTVIDEO',		'DASHBOARD_YOUTUBE_LISTVIDEO') ;

//// DASHBOARD/FORUM
define('ACCORDION_INNER_TARGET_DASHBOARD_FORUM_POST',				'DASHBOARD_FORUM_POST') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REMOVEDPOST',		'DASHBOARD_FORUM_REMOVEDPOST') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REPORT',				'DASHBOARD_FORUM_REPORT') ;

//// DASHBOARD/LINK
define('ACCORDION_INNER_TARGET_DASHBOARD_LINK_LISTLINK',			'DASHBOARD_LINK_LISTLINK') ;

//// DASHBOARD/OTHER
define('ACCORDION_INNER_TARGET_DASHBOARD_OTHER_LISTUSERGUIDE',		'DASHBOARD_OTHER_LISTUSERGUIDE') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_OTHER_LISTTERMS',			'DASHBOARD_OTHER_LISTTERMS') ;

//// DASHBOARD/MI
define('ACCORDION_INNER_TARGET_DASHBOARD_MI_FORUMUSER',				'DASHBOARD_MI_FORUMUSER') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_MI_NOTIFICATION',			'DASHBOARD_MI_NOTIFICATION') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_MI_NOTIFICATIONGROUP',		'DASHBOARD_MI_NOTIFICATIONGROUP') ;
define('ACCORDION_INNER_TARGET_DASHBOARD_MI_FORUMPOST',				'DASHBOARD_MI_FORUMPOST') ;



define('ACCORDION_INNER_TARGET_CREATOR_APP_DESIGN',					'CREATOR_APP_DESIGN') ;
define('ACCORDION_INNER_TARGET_CREATOR_APP_STORE',					'CREATOR_APP_STORE') ;
define('ACCORDION_INNER_TARGET_CREATOR_APP_PAYMENTTYPE',			'CREATOR_APP_PAYMENTTYPE') ;
define('ACCORDION_INNER_TARGET_CREATOR_APP_TERMS',					'CREATOR_APP_TERMS') ;
define('ACCORDION_INNER_TARGET_CREATOR_APP_SUBMIT',					'CREATOR_APP_SUBMIT') ;
define('ACCORDION_INNER_TARGET_CREATOR_APP_PUBLISH',				'CREATOR_APP_PUBLISH') ;
define('ACCORDION_INNER_TARGET_CREATOR_SUBSCRIPTION_CONTENT',		'CREATOR_SUBSCRIPTION_CONTENT') ;
define('ACCORDION_INNER_TARGET_CREATOR_SUBSCRIPTION_CATEGORY',		'CREATOR_SUBSCRIPTION_CATEGORY') ;
define('ACCORDION_INNER_TARGET_CREATOR_YOUTUBE_PLAYLIST_ACTIVATION','CREATOR_YOUTUBE_PLAYLIST_ACTIVATION') ;
define('ACCORDION_INNER_TARGET_CREATOR_YOUTUBE_PLAYLIST_ORDER',		'CREATOR_YOUTUBE_PLAYLIST_ORDER') ;
define('ACCORDION_INNER_TARGET_CREATOR_FORUM_CATEGORY_LIST',		'CREATOR_FORUM_CATEGORY_LIST') ;
define('ACCORDION_INNER_TARGET_CREATOR_FORUM_CATEGORY_ORDER',		'CREATOR_FORUM_CATEGORY_ORDER') ;
define('ACCORDION_INNER_TARGET_CREATOR_LINK_LIST',					'CREATOR_LINK_LIST') ;
define('ACCORDION_INNER_TARGET_CREATOR_LINK_ORDER',					'CREATOR_LINK_ORDER') ;




//////////////////////////////////////////////////
////// APP STATUS
define('ACCORDION_TOGGLE_TARGET_STATUS_STATUS',						'STATUS_STATUS') ;



//////////////////////////////////////////////////
////// YOUTUBER SUPPORT
define('ACCORDION_TOGGLE_TARGET_CREATOR_REVENUE',					'CREATOR_REVENUE') ;
define('ACCORDION_TOGGLE_TARGET_CREATOR_ANALYTICS',					'CREATOR_ANALYTICS') ;
define('ACCORDION_TOGGLE_TARGET_CREATOR_ACCOUNT',					'CREATOR_ACCOUNT') ;

//// CREATOR/REVENUE
define('ACCORDION_INNER_TARGET_CREATOR_REVENUE_LISTREVENUE',		'CREATOR_REVENUE_LISTREVENUE') ;
define('ACCORDION_INNER_TARGET_CREATOR_REVENUE_UPLOAD',				'CREATOR_REVENUE_UPLOAD') ;

//// CREATOR/ANALYTICS
define('ACCORDION_INNER_TARGET_CREATOR_ANALYTICS_LISTALL',			'CREATOR_ANALYTICS_LISTALL') ;

//// CREATOR/ACCOUNT
define('ACCORDION_INNER_TARGET_CREATOR_ACCOUNT_LISTALL',			'CREATOR_ACCOUNT_LISTALL') ;



//////////////////////////////////////////////////
////// MESSAGE BOARD
define('ACCORDION_TOGGLE_TARGET_MESSAGE_COMPOSE',					'MESSAGE_COMPOSE') ;
define('ACCORDION_TOGGLE_TARGET_MESSAGE_INBOX',						'MESSAGE_INBOX') ;
define('ACCORDION_TOGGLE_TARGET_MESSAGE_OUTBOX',					'MESSAGE_OUTBOX') ;

//// MESSAGE/COMPOSE
define('ACCORDION_INNER_TARGET_MESSAGE_COMPOSE_APPUSER',			'MESSAGE_COMPOSE_APPUSER') ;
define('ACCORDION_INNER_TARGET_MESSAGE_COMPOSE_CREATOR',			'MESSAGE_COMPOSE_CREATOR') ;

//// MESSAGE/INBOX
define('ACCORDION_INNER_TARGET_MESSAGE_INBOX_LISTFROMAPPUSER',		'MESSAGE_INBOX_LISTFROMAPPUSER') ;
define('ACCORDION_INNER_TARGET_MESSAGE_INBOX_LISTFROMCREATOR',		'MESSAGE_INBOX_LISTFROMCREATOR') ;

//// MESSAGE/OUTBOX
define('ACCORDION_INNER_TARGET_MESSAGE_OUTBOX_LISTTOAPPUSER',		'MESSAGE_OUTBOX_LISTTOAPPUSER') ;
define('ACCORDION_INNER_TARGET_MESSAGE_OUTBOX_LISTTOCREATOR',		'MESSAGE_OUTBOX_LISTTOCREATOR') ;



//////////////////////////////////////////////////
////// PAYMENT
define('ACCORDION_TOGGLE_TARGET_PAYMENT_ACCOUNT',					'PAYMENT_ACCOUNT') ;
define('ACCORDION_TOGGLE_TARGET_PAYMENT_TRANSACTION',				'PAYMENT_TRANSACTION') ;

//// PAYMENT/ACCOUNT
define('ACCORDION_INNER_TARGET_PAYMENT_ACCOUNT_LISTALL',			'PAYMENT_ACCOUNT_LISTALL') ;

//// PAYMENT/TRANSACTION
define('ACCORDION_INNER_TARGET_PAYMENT_TRANSACTION_LIST'	,		'PAYMENT_TRANSACTION_LIST') ;



define('ADMIN_TO_CREATOR_MESSAGE_10500'		,"Now preparing your app submit to Appstore") ;
define('ADMIN_TO_CREATOR_MESSAGE_20100'		,"Your app data is ready for submission. Finalizing app data for submission") ;
define('ADMIN_TO_CREATOR_MESSAGE_20100_2'	,"Please review and modify") ;
define('ADMIN_TO_CREATOR_MESSAGE_40300'		,"App submitted to Appstore!") ;
define('ADMIN_TO_CREATOR_MESSAGE_50100'		,"App released") ;






define('ADMIN_DATE_FORMAT_1',1) ; // 1.Jan 2015



class AdminTools
{

	public static $accordionToggleClassMap = array(
		'app/listall' 					=> ACCORDION_TOGGLE_TARGET_DASHBOARD_APP,
		'app/listreleased' 				=> ACCORDION_TOGGLE_TARGET_DASHBOARD_APP,
		'app/listunreleased' 			=> ACCORDION_TOGGLE_TARGET_DASHBOARD_APP,
		'subscription/listcontents' 	=> ACCORDION_TOGGLE_TARGET_DASHBOARD_SUBSCRIPTION,
		'subscription/listdelayed' 		=> ACCORDION_TOGGLE_TARGET_DASHBOARD_SUBSCRIPTION,
		'subscription/listlongdelayed' 	=> ACCORDION_TOGGLE_TARGET_DASHBOARD_SUBSCRIPTION,
		'paypercontent/listcontents' 	=> ACCORDION_TOGGLE_TARGET_DASHBOARD_PAYPERCONTENT,
		'youtube/listvideos'		 	=> ACCORDION_TOGGLE_TARGET_DASHBOARD_YOUTUBE,
		'forum/posts' 					=> ACCORDION_TOGGLE_TARGET_DASHBOARD_FORUM,
		'forum/removedposts' 			=> ACCORDION_TOGGLE_TARGET_DASHBOARD_FORUM,
		'forum/reports'		 			=> ACCORDION_TOGGLE_TARGET_DASHBOARD_FORUM,
		'link/listlinks'				=> ACCORDION_TOGGLE_TARGET_DASHBOARD_LINK,
		'userguide/listuserguide'		=> ACCORDION_TOGGLE_TARGET_DASHBOARD_OTHER,
		'terms/listterms'				=> ACCORDION_TOGGLE_TARGET_DASHBOARD_OTHER,
		'creator/listall'				=> ACCORDION_TOGGLE_TARGET_CREATOR_ACCOUNT,
		'revenue/listrevenue'			=> ACCORDION_TOGGLE_TARGET_CREATOR_REVENUE,
		'revenue/input'					=> ACCORDION_TOGGLE_TARGET_CREATOR_REVENUE,
		'analytics/listall'				=> ACCORDION_TOGGLE_TARGET_CREATOR_ANALYTICS,
		'inquiry/composetoappuser'		=> ACCORDION_TOGGLE_TARGET_MESSAGE_COMPOSE,
		'message/composetocreator'		=> ACCORDION_TOGGLE_TARGET_MESSAGE_COMPOSE,
		'inquiry/listfromappuser'		=> ACCORDION_TOGGLE_TARGET_MESSAGE_INBOX,
		'inquiry/listfromcreator'		=> ACCORDION_TOGGLE_TARGET_MESSAGE_INBOX,
		'inquiry/listtoappuser'			=> ACCORDION_TOGGLE_TARGET_MESSAGE_OUTBOX,
		'inquiry/listtocreator'			=> ACCORDION_TOGGLE_TARGET_MESSAGE_OUTBOX,
		'mi/forumuser' 					=> ACCORDION_TOGGLE_TARGET_DASHBOARD_MI,
		'mi/forumposts'					=> ACCORDION_TOGGLE_TARGET_DASHBOARD_MI,
		'mi/notification'				=> ACCORDION_TOGGLE_TARGET_DASHBOARD_MI,
		'mi/notificationgroup'			=> ACCORDION_TOGGLE_TARGET_DASHBOARD_MI,

		'app/design'					=> ACCORDION_TOGGLE_TARGET_CREATOR_APP,
		'app/store'						=> ACCORDION_TOGGLE_TARGET_CREATOR_APP,
		'app/paymenttype'				=> ACCORDION_TOGGLE_TARGET_CREATOR_APP,
		'app/terms'						=> ACCORDION_TOGGLE_TARGET_CREATOR_APP,
		'app/submit'					=> ACCORDION_TOGGLE_TARGET_CREATOR_APP,
		'app/publish'					=> ACCORDION_TOGGLE_TARGET_CREATOR_APP,
		'subscription/content'			=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'subscription/category'			=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'subscription/contentforsubscription'	=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'subscription/categoryforsubscription'	=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'subscription/contentforppc'	=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'subscription/categoryforppc'	=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'subscription/contentforpps'	=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'subscription/categoryforpps'	=> ACCORDION_TOGGLE_TARGET_CREATOR_SUBSCRIPTION,
		'youtube/playlistactivation'	=> ACCORDION_TOGGLE_TARGET_CREATOR_YOUTUBE,
		'youtube/playlistorder'			=> ACCORDION_TOGGLE_TARGET_CREATOR_YOUTUBE,
		'forum/categorylist'			=> ACCORDION_TOGGLE_TARGET_CREATOR_FORUM,
		'forum/categoryorder'			=> ACCORDION_TOGGLE_TARGET_CREATOR_FORUM,
		'link/linklist'					=> ACCORDION_TOGGLE_TARGET_CREATOR_LINK,
		'link/linkorder'				=> ACCORDION_TOGGLE_TARGET_CREATOR_LINK,

	) ;

	public static $accordionInnerClassMap = array(
		'app/listall' 					=> ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTALL,
		'app/listreleased' 				=> ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTRELEASED,
		'app/listunreleased' 			=> ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTUNRELEASED,
		'subscription/listcontents' 	=> ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTCONTENT,
		'subscription/listdelayed' 		=> ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTDELAYED,
		'subscription/listlongdelayed' 	=> ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTLONGDELAYED,
		'paypercontent/listcontents' 	=> ACCORDION_INNER_TARGET_DASHBOARD_PAYPERCONTENT_LISTCONTENT,
		'youtube/listvideos' 			=> ACCORDION_INNER_TARGET_DASHBOARD_YOUTUBE_LISTVIDEO,
		'forum/posts' 					=> ACCORDION_INNER_TARGET_DASHBOARD_FORUM_POST,
		'forum/removedposts' 			=> ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REMOVEDPOST,
		'forum/reports' 				=> ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REPORT,
		'link/listlinks' 				=> ACCORDION_INNER_TARGET_DASHBOARD_LINK_LISTLINK,
		'userguide/listuserguide' 		=> ACCORDION_INNER_TARGET_DASHBOARD_OTHER_LISTUSERGUIDE,
		'terms/listterms' 				=> ACCORDION_INNER_TARGET_DASHBOARD_OTHER_LISTTERMS,
		'creator/listall' 				=> ACCORDION_INNER_TARGET_CREATOR_ACCOUNT_LISTALL,
		'revenue/listrevenue' 			=> ACCORDION_INNER_TARGET_CREATOR_REVENUE_LISTREVENUE,
		'revenue/input' 				=> ACCORDION_INNER_TARGET_CREATOR_REVENUE_UPLOAD,
		'analytics/listall' 			=> ACCORDION_INNER_TARGET_CREATOR_ANALYTICS_LISTALL,
		'inquiry/composetoappuser' 		=> ACCORDION_INNER_TARGET_MESSAGE_COMPOSE_APPUSER,
		'message/composetocreator' 		=> ACCORDION_INNER_TARGET_MESSAGE_COMPOSE_CREATOR,
		'inquiry/listfromappuser' 		=> ACCORDION_INNER_TARGET_MESSAGE_INBOX_LISTFROMAPPUSER,
		'message/listfromcreator' 		=> ACCORDION_INNER_TARGET_MESSAGE_INBOX_LISTFROMCREATOR,
		'inquiry/listtoappuser' 		=> ACCORDION_INNER_TARGET_MESSAGE_OUTBOX_LISTTOAPPUSER,
		'message/listtocreator' 		=> ACCORDION_INNER_TARGET_MESSAGE_OUTBOX_LISTTOCREATOR,
		'mi/forumuser' 					=> ACCORDION_INNER_TARGET_DASHBOARD_MI_FORUMUSER,
		'mi/forumposts' 				=> ACCORDION_INNER_TARGET_DASHBOARD_MI_FORUMPOST,
		'mi/notification' 				=> ACCORDION_INNER_TARGET_DASHBOARD_MI_NOTIFICATION,
		'mi/notificationgroup' 			=> ACCORDION_INNER_TARGET_DASHBOARD_MI_NOTIFICATIONGROUP,

		'app/design'					=> ACCORDION_INNER_TARGET_CREATOR_APP_DESIGN,
		'app/store'						=> ACCORDION_INNER_TARGET_CREATOR_APP_STORE,
		'app/paymenttype'				=> ACCORDION_INNER_TARGET_CREATOR_APP_PAYMENTTYPE,
		'app/terms'						=> ACCORDION_INNER_TARGET_CREATOR_APP_TERMS,
		'app/submit'					=> ACCORDION_INNER_TARGET_CREATOR_APP_SUBMIT,
		'app/publish'					=> ACCORDION_INNER_TARGET_CREATOR_APP_PUBLISH,
		'subscription/content'			=> ACCORDION_INNER_TARGET_CREATOR_SUBSCRIPTION_CONTENT,
		'subscription/category'			=> ACCORDION_INNER_TARGET_CREATOR_SUBSCRIPTION_CATEGORY,
		'youtube/playlistactivation'	=> ACCORDION_INNER_TARGET_CREATOR_YOUTUBE_PLAYLIST_ACTIVATION,
		'youtube/playlistorder'			=> ACCORDION_INNER_TARGET_CREATOR_YOUTUBE_PLAYLIST_ORDER,
		'forum/categorylist'			=> ACCORDION_INNER_TARGET_CREATOR_FORUM_CATEGORY_LIST,
		'forum/categoryorder'			=> ACCORDION_INNER_TARGET_CREATOR_FORUM_CATEGORY_ORDER,
		'link/linklist'					=> ACCORDION_INNER_TARGET_CREATOR_LINK_LIST,
		'link/linkorder'				=> ACCORDION_INNER_TARGET_CREATOR_LINK_ORDER,

	) ;

	public static $appStatusNameMap = array(
		0 					=> 'Released',
		1 					=> 'Setting',
		2 					=> 'In Review(MCN)',
		3 					=> 'In Review(Apple)',
		4 					=> 'Initialized',
		5 					=> 'Building',
	) ;



	public static function getIdsForObjects($objects)
	{
		$ids = array() ;
		foreach($objects as $object){
			$ids[] = $object->getId() ;
		}
		return $ids ;
	}

	public static function getMapForObjects($objects)
	{
		$map = array() ;
		foreach($objects as $object){
			$map[$object->getId()] = $object ;
		}
		return $map ;
	}

	public static function unescapeName($name)
	{
		$unescapedName = str_replace('&quot;','"',$name) ;
		$unescapedName = str_replace('&gt;','>',$unescapedName) ;
		$unescapedName = str_replace('&lt;','<',$unescapedName) ;
		$unescapedName = str_replace('&amp;','&',$unescapedName) ;
		return $unescapedName ;
	}

	public static function getAppProcesses()
	{
	  	$c = new Criteria() ;
	  	$c->add(AppProcessPeer::DEL_FLAG,0) ;
		$c->addAscendingOrderByColumn(AppProcessPeer::ID) ;
		$appProcesses = AppProcessPeer::doSelect($c) ;
		return $appProcesses ;
	}

	public static function getAppsForMcn($mcnId)
	{
	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::MCN_ID,$mcnId) ;
		$c->addAscendingOrderByColumn(AppPeer::ID) ;
		$apps = AppPeer::doSelect($c) ;
		return $apps ;
	}

	public static function getReleasedAppsForMcn($mcnId)
	{
	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::MCN_ID,$mcnId) ;
	  	$c->add(AppPeer::STATUS,0) ;
		$c->addAscendingOrderByColumn(AppPeer::ID) ;
		$apps = AppPeer::doSelect($c) ;
		return $apps ;
	}

	public static function getForumsForApps($apps)
	{
		$appIds = AdminTools::getIdsForObjects($apps) ;

		if(count($appIds) > 0){
		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::KIND,2,Criteria::NOT_EQUAL) ;
		  	$c->add(ForumPeer::APP_ID,$appIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(ForumPeer::ID) ;
			$forums = ForumPeer::doSelect($c) ;
		}
		return $forums ;
	}

	public static function getCategoriesForApps($apps)
	{
		$appIds = AdminTools::getIdsForObjects($apps) ;

		if(count($appIds) > 0){
		  	$c = new Criteria() ;
		  	$c->add(CategoryPeer::DEL_FLG,0) ;
		  	$c->add(CategoryPeer::DISABLED,0) ;
		  	$c->add(CategoryPeer::APP_ID,$appIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
			$categories = CategoryPeer::doSelect($c) ;
		}
		return $categories ;
	}

	public static function getAppProcessesForAppProcessCategory($appProcessCategoryId)
	{
	  	$c = new Criteria() ;
	  	$c->add(AppProcessPeer::DEL_FLAG,0) ;
	  	$c->add(AppProcessPeer::APP_PROCESS_CATEGORY_ID,$appProcessCategoryId) ;
		$c->addAscendingOrderByColumn(AppProcessPeer::ID) ;
		$appProcesses = AppProcessPeer::doSelect($c) ;

		return $appProcesses ;
	}

	public static function getAppProcessLogsForApp($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(AppProcessLogPeer::DEL_FLAG,0) ;
	  	$c->add(AppProcessLogPeer::APP_ID,$appId) ;
		$c->addAscendingOrderByColumn(AppProcessLogPeer::ID) ;
		$appProcessLogs = AppProcessLogPeer::doSelect($c) ;

		return $appProcessLogs ;
	}


	public static function getDoneAllAppProcessDependency($dependency,$appProcessLogMapForProcess)
	{
		$doneAllDependency = true ;
		if($dependency){
			$dependencies = explode(",",$dependency) ;
			foreach($dependencies as $dependedProcessId){
				if(!$appProcessLogMapForProcess[$dependedProcessId]){
					$doneAllDependency = false ;
				}
			}
		}
		return $doneAllDependency ;
	}



	public static function isAccordionToggleTarget($targetName,$moduleName,$actionName)
	{
		$isTarget = false ;

		if(AdminTools::$accordionToggleClassMap[sprintf("%s/%s",$moduleName,$actionName)] == $targetName){
			$isTarget = true ;
		}
		return $isTarget ;
	}

	public static function getAccordionToggleClass($targetName,$moduleName,$actionName)
	{
		$className = "accordion-toggle" ;
		if(AdminTools::isAccordionToggleTarget($targetName,$moduleName,$actionName)){
			$className = "accordion-toggle active" ;
		}
		return $className ;
	}

	public static function getAccordionToggleIconClass($targetName,$moduleName,$actionName)
	{
		$className = "icon-plus" ;
		if(AdminTools::isAccordionToggleTarget($targetName,$moduleName,$actionName)){
			$className = "icon-minus" ;
		}
		return $className ;
	}

	public static function getAccordionToggleCollapseClass($targetName,$moduleName,$actionName)
	{
		$className = "accordion-body collapse" ;
		if(AdminTools::isAccordionToggleTarget($targetName,$moduleName,$actionName)){
			$className = "accordion-body collapse in" ;
		}
		return $className ;
	}


	public static function isAccordionInnerTarget($targetName,$moduleName,$actionName)
	{
		$isTarget = false ;
		if(AdminTools::$accordionInnerClassMap[sprintf("%s/%s",$moduleName,$actionName)] == $targetName){
			$isTarget = true ;
		}
		return $isTarget ;
	}

	public static function getAccordionInnerListClass($targetName,$moduleName,$actionName)
	{
		$className = "" ;
		if(AdminTools::isAccordionInnerTarget($targetName,$moduleName,$actionName)){
			$className = "selected-list" ;
		}
		return $className ;
	}


	public static function getMcnIdForForum($forumId)
	{
		$mcnId = 0 ;
		$forum = ForumPeer::retrieveByPk($forumId) ;
		if($forum){
			$appId = $forum->getAppId() ;
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$mcnId = $app->getMcnId() ;
			}
		}
		return $mcnId ;
	}

	public static function getAppIdForForum($forumId)
	{
		$mcnId = 0 ;
		$forum = ForumPeer::retrieveByPk($forumId) ;
		if($forum){
			$appId = $forum->getAppId() ;
		}
		return $appId ;
	}

	public static function getAppStatusName($status)
	{
		return AdminTools::$appStatusNameMap[$status] ;
	}


	public static function getAgoString($dateString)
	{
		$currentTime = time() ;
		$targetTime = strtotime($dateString) ;
		$diff = $currentTime - $targetTime ;
		if($diff < 0){
			$diff = 0 ; 
		}

		if($diff < 2){
			$agoString = sprintf("%d second ago",$diff) ;
		} else if($diff < 60){
			$agoString = sprintf("%d seconds ago",$diff) ;
		} else if($diff < 120){
			$agoString = sprintf("%d minute ago",$diff/60) ;
		} else if($diff < 3600){
			$agoString = sprintf("%d minutes ago",$diff/60) ;
		} else if($diff < 7200){
			$agoString = sprintf("%d hour ago",$diff/3600) ;
		} else if($diff < 86400){
			$agoString = sprintf("%d hours ago",$diff/3600) ;
		} else if($diff < 172800){
			$agoString = sprintf("%d day ago",$diff/86400) ;
		} else {
			$agoString = sprintf("%d days ago",$diff/86400) ;
		}
		return $agoString ;
	}


	// アサーション
	// こうあるべきだという条件を第一引数に指定
	// 例:ConsoleTools::assert((count($Users) == 1),$TermID,__FILE__,__LINE__) ; // 検索にひっかかったユーザは１人のはず
	// 条件が満たされなかった場合は、第二引数のメッセージをメールで送信
	public static function assert($Condition,$Message,$FileName,$Line)
	{
		if(!$Condition){
			$SendTo = 'tech@veam.co' ;
			ConsoleTools::sendInfoMail("[ADMIN_INFO]ASSERTION FAILED",$SendTo,$Message."\r\rFILE=".$FileName."\rLINE=".$Line) ;
		}
	}

	// メールを送信する
	public static function sendNotificationMail($Subject,$To,$Body)
	{
		$Subject = mb_convert_encoding($Subject, "SJIS", "UTF-8");
		$Body = mb_convert_encoding($Body, "SJIS", "UTF-8");

		mb_language('japanese');
		$Subject = mb_convert_encoding($Subject,"ISO-2022-JP","SJIS");
		$Subject = mb_convert_kana($Subject, 'KV', "SJIS");
		$Body = mb_convert_encoding($Body,"ISO-2022-JP","SJIS");
		$Body = mb_convert_kana($Body, 'KV', "SJIS");
		$From = "From: no-reply@veam.co" ;
		mb_send_mail($To, $Subject, $Body, $From);
	}


	public static function getDateString($dateString,$format)
	{
		$retValue = $dateString ;
		if($format == ADMIN_DATE_FORMAT_1){
			$retValue = date('j.M Y',strtotime($dateString)) ;
		}
		return $retValue ;
	}




	public static function setAppDefaultValues($appId,$language,$dbManager=null)
	{
		// app_color
		AdminTools::setAppColor($appId,'top_bar_color_argb'				,'FF8B8B8B') ;
		AdminTools::setAppColor($appId,'tab_text_color_argb'			,'FF000000') ;
		AdminTools::setAppColor($appId,'base_text_color_argb'			,'FF000000') ;
		AdminTools::setAppColor($appId,'base_background_color_argb'		,'33FFFFFF') ;
		AdminTools::setAppColor($appId,'new_videos_text_color_argb'		,'FF60FFFF') ;
		AdminTools::setAppColor($appId,'table_selection_color_argb'		,'3060FFFF') ;

		// app_data
		AdminTools::setAppData($appId,'template_ids'					,'8_1_2_3') ;

		if($language == 'ja'){
			AdminTools::setAppData($appId,'subscription_0_description'		,"プレミアムコンテンツコーナーでは、動画をはじめとするコンテンツを配信します。&#xA;&#xA;") ;
			AdminTools::setAppData($appId,'subscription_0_button_text'		,'定期購読を行う - 120円/月') ;
		} else {
			AdminTools::setAppData($appId,'subscription_0_description'		,"Join [Your Name]'s premium subscriber area and you will have access to variety of premium content that [Your Name] only shares with private members.&#xA;&#xA;I can't wait to see you there!&#xA;&#xA;	") ;
			AdminTools::setAppData($appId,'subscription_0_button_text'		,'Tap to subscribe - US$0.99 per/month') ;
		}

		AdminTools::setAppData($appId,'email_to'						,'support@veam.co') ;
		AdminTools::setAppData($appId,'skip_initial'					,'1') ;

		AdminTools::setAlternativeImage($appId,'video_left.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/video_left.png') ;
		AdminTools::setAlternativeImage($appId,'share_twitter_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_twitter_on.png') ;
		AdminTools::setAlternativeImage($appId,'program_comment.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/program_comment.png') ;
		AdminTools::setAlternativeImage($appId,'goodjob.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/goodjob.png') ;
		AdminTools::setAlternativeImage($appId,'forum_like_button_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/forum_like_button_on.png') ;
		AdminTools::setAlternativeImage($appId,'grid_audio.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_audio.png') ;
		AdminTools::setAlternativeImage($appId,'q_vote_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_vote_icon.png') ;
		AdminTools::setAlternativeImage($appId,'flame.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/flame.png') ;
		AdminTools::setAlternativeImage($appId,'share_facebook_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_facebook_on.png') ;
		AdminTools::setAlternativeImage($appId,'program_like.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/program_like.png') ;
		AdminTools::setAlternativeImage($appId,'pro_post_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_post_icon.png') ;
		AdminTools::setAlternativeImage($appId,'list_following.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/list_following.png') ;
		AdminTools::setAlternativeImage($appId,'list_clip.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/list_clip.png') ;
		AdminTools::setAlternativeImage($appId,'audio_thumbnail.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/audio_thumbnail.png') ;
		AdminTools::setAlternativeImage($appId,'share_facebook_off.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_facebook_off.png') ;
		AdminTools::setAlternativeImage($appId,'select_back.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/select_back.png') ;
		AdminTools::setAlternativeImage($appId,'pro_settings.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_settings.png') ;
		AdminTools::setAlternativeImage($appId,'share_twitter_off.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_twitter_off.png') ;
		AdminTools::setAlternativeImage($appId,'thankyou.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/thankyou.png') ;
		AdminTools::setAlternativeImage($appId,'forum_comment.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/forum_comment.png') ;
		AdminTools::setAlternativeImage($appId,'q_answer_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_answer_icon.png') ;
		AdminTools::setAlternativeImage($appId,'vote_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/vote_on.png') ;
		AdminTools::setAlternativeImage($appId,'video_thumbnail.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/video_thumbnail.png') ;
		AdminTools::setAlternativeImage($appId,'answer_audio_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/answer_audio_on.png') ;
		AdminTools::setAlternativeImage($appId,'grid_back2.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_back2.png') ;
		AdminTools::setAlternativeImage($appId,'expand_comment.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/expand_comment.png') ;
		AdminTools::setAlternativeImage($appId,'report.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/report.png') ;
		AdminTools::setAlternativeImage($appId,'list_my_post.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/list_my_post.png') ;
		AdminTools::setAlternativeImage($appId,'grid_back1.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_back1.png') ;
		AdminTools::setAlternativeImage($appId,'pro_follow.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_follow.png') ;
		AdminTools::setAlternativeImage($appId,'check_box_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/check_box_on.png') ;
		AdminTools::setAlternativeImage($appId,'like.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/like.png') ;
		AdminTools::setAlternativeImage($appId,'q_ranking_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_ranking_icon.png') ;
		AdminTools::setAlternativeImage($appId,'calendar_dot2.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/calendar_dot2.png') ;
		AdminTools::setAlternativeImage($appId,'tab_selected_back.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/tab_selected_back.png') ;
		AdminTools::setAlternativeImage($appId,'pro_person_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_person_icon.png') ;
		AdminTools::setAlternativeImage($appId,'grid_video.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_video.png') ;
		AdminTools::setAlternativeImage($appId,'add_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/add_on.png') ;
		AdminTools::setAlternativeImage($appId,'answer_video_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/answer_video_on.png') ;
		AdminTools::setAlternativeImage($appId,'camera_button.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/camera_button.png') ;
		AdminTools::setAlternativeImage($appId,'q_video_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_video_icon.png') ;
		AdminTools::setAlternativeImage($appId,'t1_top_left.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/t1_top_left.png') ;
		AdminTools::setAlternativeImage($appId,'grid_year.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_year.png') ;
		AdminTools::setAlternativeImage($appId,'tab_selected_back@2x.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/tab_selected_back@2x.png') ;
		AdminTools::setAlternativeImage($appId,'grid_back.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_back.png') ;
		AdminTools::setAlternativeImage($appId,'default_grid_0.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/default_grid_0.png') ;

		// 固定のカラーでパーツを設定
	    $name = 'concept_color_argb' ;
		$appColor = AdminTools::getAppColor($appId,$name) ;
		$appColor->setColor('FF3DBCFF') ;
		$appColor->save() ;

	    $name = 'new_videos_text_color_argb' ;
		$appColor = AdminTools::getAppColor($appId,$name) ;
		$appColor->setColor('FF3DBCFF') ;
		$appColor->save() ;

	    $name = 'table_selection_color_argb' ;
		$appColor = AdminTools::getAppColor($appId,$name) ;
		$appColor->setColor('303DBCFF') ;
		$appColor->save() ;

		$libDir = sfConfig::get("sf_lib_dir") ; 
		if($dbManager){
			$manager = $dbManager ;
		} else {
			$manager = sfContext::getInstance()->getDatabaseManager() ;
		}
		if($manager){
			$db = $manager->getDatabase('propel') ;
			$dbUser = $db->getParameter("username") ;
			if($dbUser == 'veam_preview'){
				$libDir = '/data/console/console-preview.veam.co/site/lib' ;
			}
		}

		$commandDir = sprintf("%s/../../bin/image",$libDir) ;

		$outputs = array() ;
 		$commandLine = sprintf("cp -r %s/31000000 %s/%s",$commandDir,$commandDir,$appId) ;
		//print($commandLine."\n") ;
		exec($commandLine,$outputs) ;


		// forum
		AdminTools::setForum($appId,'Hot Topics'						,2,-1) ;
		if($language == 'ja'){
			AdminTools::setForum($appId,'自己紹介'						,1,1) ;
		} else {
			AdminTools::setForum($appId,'Meet &amp; Greet'					,1,1) ;
		}

		// template_forum
		AdminTools::setTemplateForum($appId,'Forum') ;

		// template_subscription
		//AdminTools::setTemplateSubscription($appId,'Exclusive','$0.99','2','4') ; // subscription
		AdminTools::setTemplateSubscription($appId,'Premium','$0.99','','5') ; // pay per content

		if($language == 'ja'){
			$videoCategoryId = AdminTools::setVideoCategory($appId,'プレミアムコンテンツ',1) ;
		} else {
			$videoCategoryId = AdminTools::setVideoCategory($appId,'Premium Content List',1) ;
		}

		$sellItemCategoryId = AdminTools::setSellItemCategory($appId,$videoCategoryId,1/*video*/,1) ;

		// template_web
		AdminTools::setTemplateWeb($appId,'Links');

		// template_youtube
		AdminTools::setTemplateYoutube($appId,'YouTube') ;

		// video_category
		$videoCategoryId = AdminTools::setVideoCategory($appId,'Monthly Premium Video',1) ;

		// video
		AdminTools::setVideo($appId,$videoCategoryId, 5, 'Video 1', 1, 1, '1') ;
		AdminTools::setVideo($appId,$videoCategoryId, 5, 'Video 2', 2, 1, '2') ;
		AdminTools::setVideo($appId,$videoCategoryId, 5, 'Video 3', 3, 1, '3') ;

		// mixed
		AdminTools::setMixed($appId,0, 0, 'Welcome', 1, 1, '1') ;
		AdminTools::setMixed($appId,0, 0, 'Bonus', 2, 1, '2') ;

		// web` (`title`, `url`, `display_order`
		AdminTools::setWeb($appId,'Facebook', 'https://www.facebook.com/VeamApp', 1) ;
		AdminTools::setWeb($appId,'Twitter', 'https://twitter.com/VeamApp', 2) ;

		if($language == 'ja'){
		    $description = <<<EODJ

[アプリ名]の構成

＊フォーラムコーナー＊無料
写真投稿ができます。
皆様からの投稿やお問い合わせをお待ちしております。

＊YouTubeコーナー＊無料
動画コンテンツを無料でお楽しみ頂けます。

＊Linksコーナー＊無料
[アプリ名]関連サイトに全てリンクされます。

＊Premiumコンテンツコーナー＊有料
本アプリに特別に撮り下ろした動画をお楽しみ頂けます。

■自動継続購読(Auto Renewable Subscription)について
・本アプリケーションは、アプリ内課金の自動継続購読機能(Auto Renewable Subscription)を利用しています。
・定期購読料の支払いは、iTunesアカウントにて行われます。
・定期購読料は、予告なく変更される場合がございます。
・定期購読の有効期間は、定期購読申請を行った日から1ヵ月です。
・定期購読は、1ヶ月ごとに自動継続されます。
・定期購読の有効期間が終了する24時間以上前に自動更新設定をオフにされていない限り、自動的に継続されます。
・定期購読の有効期間が終了する24時間以内に自動継続は更新され課金されます。
・自動継続の更新設定は、[設定]→[Store]→[アカウント情報]内の[App購読の管理]にて、オフに設定変更できます。
・定期購読の有効期間中は、現在の課金をキャンセルすることは出来ません。
・個人情報保護方針および利用規約については、下記リンクをご確認下さい。
http://veam.co/top/guideline_ja

EODJ;
		} else {
		    $description = <<<EODE
Finally, you can access all of [Your Name]'s videos in an instant... FOR FREE on your mobile phone! Separated by category, this app makes it easy to find your favorite YouTube videos, and premium tips.

In addition, join in on the addicting Forum to see what [Your Name] and fellow followers are doing and discover their favorite products. Best of all, you can ask [Your Name] questions directly.

Plus, only in the app will you be able to unlock Premium member videos that [Your Name] only shares with his private members. This is the app for you!

What's in the App;

YouTube Videos
- All of [Your Name] YouTube Playlist videos is organized so it's easy to find them,

Community Forum
Be part of [Your Name]'s community.  The app includes a FREE fun and interactive forum. Share your photos, get motivated, ask questions and interact with [Your Name] and other hot members just like you.

- Join in on the fun and upload your own pictures and follow fellow members including [Your Name]!
- The Instagram like feature in the forum allows you to post pictures along with your posts.
- Topics include: Hot Topics, Meet & Greet and others

Subscriber Premium Area:
Premium video/voice messages $0.99 per month (*)
- Each month [Your Name] will post an premium video or voice messages and you will have access to private tips that [Your Name] only shares with his private members


NOTE(*):
Subscribing to 'Premium' will be an auto-renewable monthly subscription.
US$0.99 payment will be charged monthly to iTunes Account at confirmation of purchase. Subscription automatically renews monthly unless auto-renew is turned off at least 24-hours before the end of the current period. Your account will be charged US$0.99 for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. No cancellation of the current subscription is allowed during active subscription period.

Privacy policy and terms of use;
http://veam.co/top/guideline

EODE;
		}


		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$app->setDescription($description) ;
			$app->save() ;
		}
	}

	public static function setWeb($appId,$title,$url,$displayOrder)
	{
		$web = new Web() ;
		$web->setAppId($appId) ;
		$web->setTitle($title) ;
		$web->setUrl($url) ;
		$web->setDisplayOrder($displayOrder) ;
		$web->save() ;
	}

	public static function setVideo($appId,$videoCategoryId,$kind,$title,$displayOrder,$status,$statusText)
	{
		$video = new Video() ;
		$video->setAppId($appId) ;
		$video->setVideoCategoryId($videoCategoryId) ;
		$video->setKind($kind) ;
		$video->setTitle($title) ;
		$video->setDisplayOrder($displayOrder) ;
		$video->setStatus($status) ;
		$video->setStatusText($statusText) ;
		$video->save() ;
	}


	public static function setMixed($appId,$mixedCategoryId,$kind,$title,$displayOrder,$status,$statusText)
	{
		$mixed = new Mixed() ;
		$mixed->setAppId($appId) ;
		$mixed->setMixedCategoryId($mixedCategoryId) ;
		$mixed->setKind($kind) ;
		$mixed->setName($title) ;
		$mixed->setDisplayOrder($displayOrder) ;
		$mixed->setDisplayType(1) ;
		$mixed->setStatus($status) ;
		$mixed->setStatusText($statusText) ;
		$mixed->save() ;
	}


	public static function setVideoCategory($appId,$name,$displayOrder)
	{
		$videoCategory = new VideoCategory() ;
		$videoCategory->setAppId($appId) ;
		$videoCategory->setName($name) ;
		$videoCategory->setDisplayOrder($displayOrder) ;
		$videoCategory->save() ;

		return $videoCategory->getId() ;
	}

	public static function setSellItemCategory($appId,$targetCategoryId,$kind,$displayOrder)
	{
		$sellItemCategory = new SellItemCategory() ;
		$sellItemCategory->setAppId($appId) ;
		$sellItemCategory->setTargetCategoryId($targetCategoryId) ;
		$sellItemCategory->setKind(1) ; // 1:video    2:pdf    3:audio
		$sellItemCategory->setDisplayOrder($displayOrder) ;
		$sellItemCategory->save() ;

		return $sellItemCategory->getId() ;
	}

	public static function setTemplateYoutube($appId,$name)
	{
		$templateYoutube = new TemplateYoutube() ;
		$templateYoutube->setAppId($appId) ;
		$templateYoutube->setTitle($name) ;
		$templateYoutube->setEmbedFlag(0) ;
		$templateYoutube->save() ;
	}

	public static function setTemplateWeb($appId,$name)
	{
		$templateWeb = new TemplateWeb() ;
		$templateWeb->setAppId($appId) ;
		$templateWeb->setTitle($name) ;
		$templateWeb->save() ;
	}

	public static function setTemplateSubscription($appId,$name,$price,$layout,$kind)
	{
		$templateSubscription = new TemplateSubscription() ;
		$templateSubscription->setAppId($appId) ;
		$templateSubscription->setTitle($name) ;
		$templateSubscription->setPrice($price) ;
		$templateSubscription->setLayout($layout) ;
		$templateSubscription->setKind($kind) ;
		$templateSubscription->save() ;
	}

	public static function setTemplateForum($appId,$name)
	{
		$templateForum = new TemplateForum() ;
		$templateForum->setAppId($appId) ;
		$templateForum->setTitle($name) ;
		$templateForum->save() ;
	}

	public static function setForum($appId,$name,$kind,$displayOrder)
	{
		$forum = new Forum() ;
		$forum->setAppId($appId) ;
		$forum->setName($name) ;
		$forum->setKind($kind) ;
		$forum->setDisplayOrder($displayOrder) ;
		$forum->save() ;
	}

	public static function getAppColor($appId,$name)
	{
		$c = new Criteria() ;
	  	$c->add(AppColorPeer::DEL_FLG,0) ;
	  	$c->add(AppColorPeer::APP_ID,$appId) ;
	  	$c->add(AppColorPeer::NAME,$name) ;
		$appColor = AppColorPeer::doSelectOne($c) ;

		if(!$appColor){
			$appColor = new AppColor() ;
			$appColor->setAppId($appId) ;
			$appColor->setName($name) ;
		}

		return $appColor ;
	}


	public static function setAppColor($appId,$name,$value)
	{
		$appColor = new AppColor() ;
		$appColor->setAppId($appId) ;
		$appColor->setName($name) ;
		$appColor->setColor($value) ;
		$appColor->save() ;
	}


	public static function setAlternativeImage($appId,$fileName,$url)
	{
		//sfContext::getInstance()->getLogger()->info(sprintf("setAlternativeImage %s %s %s",$appId,$fileName,$url)) ;

	  	$c = new Criteria() ;
	  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
	  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
	  	$c->add(AlternativeImagePeer::FILE_NAME,$fileName) ;
		$alternativeImage = AlternativeImagePeer::doSelectOne($c) ;
		if(!$alternativeImage){
			$alternativeImage = new AlternativeImage() ;
			$alternativeImage->setAppId($appId) ;
			$alternativeImage->setFileName($fileName) ;
		}
		$alternativeImage->setUrl($url) ;
		$alternativeImage->save() ;
	}


	public static function setAppData($appId,$name,$value)
	{
		$c = new Criteria() ;
	  	$c->add(AppDataPeer::DEL_FLG,0) ;
	  	$c->add(AppDataPeer::APP_ID,$appId) ;
	  	$c->add(AppDataPeer::NAME,$name) ;
		$appData = AppDataPeer::doSelectOne($c) ;
		
		if(!$appData){
			$appData = new AppData() ;
			$appData->setAppId($appId) ;
			$appData->setName($name) ;
		}
		$appData->setData($value) ;
		$appData->save() ;
	}



	public static function sendMailToAppUser($mcnId,$inquirySet,$message)
	{
		$env = ConsoleTools::getEnvString() ;
		// http://help-work.veam.co/contact/app.php/inquiry?m=1
		if($env == 'work'){
			$helpDomain = 'help-work.veam.co' ;
		} else if($env == 'preview'){
			$helpDomain = 'help-preview.veam.co' ;
		} else {
			$helpDomain = 'help.veam.co' ;
		}

		$formUrl = sprintf("http://%s/contact/app.php/inquiry?m=%d&i=%d&t=%s",$helpDomain,$mcnId,$inquirySet->getId(),$inquirySet->getToken()) ;
		$body = sprintf("%s\n\nIf you would like to reply to this message,\nPlease visit the following URL\n%s\n\n",$message,$formUrl) ;

		AdminTools::sendNotificationMail($inquirySet->getSubject(),$inquirySet->getEmail(),$body) ;
	}

	public static function sendMailToCreator($mcnId,$inquirySet,$message)
	{
		$env = ConsoleTools::getEnvString() ;
		// http://help-work.veam.co/contact/dashboard.php/inquiry?m=1
		if($env == 'work'){
			$helpDomain = 'help-work.veam.co' ;
		} else if($env == 'preview'){
			$helpDomain = 'help-preview.veam.co' ;
		} else {
			$helpDomain = 'help.veam.co' ;
		}

		$formUrl = sprintf("http://%s/contact/dashboard.php/inquiry?m=%d&i=%d&t=%s",$helpDomain,$mcnId,$inquirySet->getId(),$inquirySet->getToken()) ;
		$body = sprintf("%s\n\nIf you would like to reply to this message,\nPlease visit the following URL\n%s\n\n",$message,$formUrl) ;

		AdminTools::sendNotificationMail($inquirySet->getSubject(),$inquirySet->getEmail(),$body) ;
	}

	public static function getInquirySetStatuses()
	{
		return array(
			'1' => 'Not Responded',
			'2' => 'Responded',
			'3' => 'Solved',
		) ;
	}



	public static function getYoutubeChannels($youtubeUserName)
	{
		sfContext::getInstance()->getLogger()->info(sprintf("getYoutubeChannels(%s)",$youtubeUserName)) ;

		$items = "" ;
		$url = sprintf('https://www.googleapis.com/youtube/v3/channels?key=__YOUTUBE_API_KEY__&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&forUsername=%s',$youtubeUserName) ;
		$result = file_get_contents($url) ;

		$reload = false ;
		if(!$result){
			$reload = true ;
		} else {
			$channelList = json_decode($result) ;
			if($channelList){
				#print(var_export($channelList,true)) ;
				$items = $channelList->{'items'} ;
				if(count($items) == 0){
					$reload = true ;
				}
			} else {
				$reload = true ;
			}
		}

		if($reload){
			$url = sprintf('https://www.googleapis.com/youtube/v3/channels?key=__YOUTUBE_API_KEY__&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&id=%s',$youtubeUserName) ;
			$result = file_get_contents($url) ;
		}

		sfContext::getInstance()->getLogger()->info(sprintf("result = %s",$result)) ;

		if($result){
			$channelList = json_decode($result) ;
			if($channelList){
				#print(var_export($channelList,true)) ;
				$items = $channelList->{'items'} ;
			} else {
				//print("ERROR_MESSAGE\n") ;
				//print("Server error. code=2\n") ;
			}
		} else {
			//print("ERROR_MESSAGE\n") ;
			//print("Server error. code=1\n") ;
		}
		
		return $items ;
	}



	public static function completeProcess($appId,$appProcessId,$result,$userName,$dbManager=null)
	{
		//sfContext::getInstance()->getLogger()->info(sprintf("completeProcess %s",$appProcessId)) ;

		$app = AppPeer::retrieveByPk($appId) ;
		$appProcesses = AdminTools::getAppProcesses() ;
		$appProcessMap = AdminTools::getMapForObjects($appProcesses) ;

		$appProcess = $appProcessMap[$appProcessId] ;
		if($appProcess){
			if(($appProcessId == 20100) && ($result == 2)){ // Rejected by MCN
				$c = new Criteria() ;
			  	$c->add(AppProcessLogPeer::DEL_FLAG,0) ;
			  	$c->add(AppProcessLogPeer::APP_ID,$appId) ;
			  	$c->add(AppProcessLogPeer::APP_PROCESS_ID,10500) ; // Submit for MCN Review
				$appProcessLogs = AppProcessLogPeer::doSelect($c) ;
				foreach($appProcessLogs as $appProcessLog){
					$appProcessLog->delete() ;
				}
				$app->setStatus(1) ; // settings
				$app->setCurrentProcess(10500) ; // 
				$app->save() ;
				ConsoleTools::consoleContentsChanged($appId) ;
			} else {

				if(($appProcessId == 20100) && ($result == 1)){ // Approved by MCN
					$app->setStatus(5) ; // building
					$app->save() ;
				} else if($appProcessId == 50100){	// released
					$app->setPictureNotification(1) ; // 
					$app->setStatus(0) ; // released
					$app->setReleasedAt(date('Y-m-d H:i:s',time())) ; // released
					$app->save() ;

					$c = new Criteria() ;
				  	$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
				  	$c->add(YoutubeUserPeer::APP_ID,$appId) ;
					$youtubeUser = YoutubeUserPeer::doSelectOne($c) ;
					if($youtubeUser){
						$youtubeUser->setNewVideoCheck(1) ;
						$youtubeUser->save() ;
					}

					ConsoleTools::deleteMemcacheValue('publicCONSOLE_CONTENT_XML_V2'.$appId) ;
					ConsoleTools::deleteMemcacheValue('previewCONSOLE_CONTENT_XML_V2'.$appId) ;
				}

				$appProcessLog = new AppProcessLog() ;
				$appProcessLog->setAppId($appId) ;
				$appProcessLog->setAppProcessId($appProcessId) ;
				$appProcessLog->setResult($result) ;
				$appProcessLog->setUserName($userName) ;
				$appProcessLog->save() ;
			}

			$appProcessLogs = AdminTools::getAppProcessLogsForApp($appId) ;
			$appProcessLogMapForProcess = array() ;
			foreach($appProcessLogs as $appProcessLog){
				$appProcessLogMapForProcess[$appProcessLog->getAppProcessId()] = $appProcessLog ;
			}

			$nextAppProcessId = 0 ;
			if($result == 1){
				$nextAppProcessId = $appProcess->getNextProcess1() ;
			}
			if($result == 2){
				$nextAppProcessId = $appProcess->getNextProcess2() ;
			}
			if($result == 3){
				$nextAppProcessId = $appProcess->getNextProcess3() ;
			}

			if($nextAppProcessId){
				while($appProcessLogMapForProcess[$nextAppProcessId]){
					$appProcessLog = $appProcessLogMapForProcess[$nextAppProcessId] ;
					$result = $appProcessLog->getResult() ;
					$appProcess = $appProcessMap[$nextAppProcessId] ;
					$nextAppProcessId = 0 ;
					if($result == 1){
						$nextAppProcessId = $appProcess->getNextProcess1() ;
					}
					if($result == 2){
						$nextAppProcessId = $appProcess->getNextProcess2() ;
					}
					if($result == 3){
						$nextAppProcessId = $appProcess->getNextProcess3() ;
					}
				}
				if($nextAppProcessId){
					$appProcess = $appProcessMap[$nextAppProcessId] ;
					$dependency = $appProcess->getDependsOn() ;
					if(AdminTools::getDoneAllAppProcessDependency($dependency,$appProcessLogMapForProcess)){
						$app->setCurrentProcess($nextAppProcessId) ;
						$app->save() ;
					}
				}
			}

			AdminTools::deployApp($appId,$dbManager) ;
			ConsoleTools::consoleContentsChanged($appId) ;

			if($appProcessId == 10500){ // Submit for MCN
				$c = new Criteria() ;
			  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
			  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
				$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
				if($templateSubscription){
					$templateSubscription->setUploadSpan(7) ; // weekly
					$templateSubscription->save() ;
				}
				AdminTools::deployAppContents($appId,$dbManager) ;
				AdminTools::sendSubmitNotificationMail($appId) ;
				AdminTools::sendMessageToAppCreators($appId,ADMIN_TO_CREATOR_MESSAGE_10500,$appProcessId,'AUTO') ;


			} else if(($appProcessId == 20100) && ($result == 1)){ // Approved by MCN
				AdminTools::sendMessageToAppCreators($appId,ADMIN_TO_CREATOR_MESSAGE_20100,$appProcessId,'AUTO') ;
			} else if(($appProcessId == 20100) && ($result == 2)){ // Rejected by MCN
				AdminTools::sendMessageToAppCreators($appId,ADMIN_TO_CREATOR_MESSAGE_20100_2,$appProcessId,'AUTO') ;
			} else if($appProcessId == 40300){
				AdminTools::sendMessageToAppCreators($appId,ADMIN_TO_CREATOR_MESSAGE_40300,$appProcessId,'AUTO') ;
			} else if($appProcessId == 50100){
				AdminTools::sendMessageToAppCreators($appId,ADMIN_TO_CREATOR_MESSAGE_50100,$appProcessId,'AUTO') ;
			}
		} else {
			AdminTools::assert(false,"AppProcess not found appProcessId=$appProcessId appId=$appId result=$result",__FILE__,__LINE__) ;
		}
	}

	public static function link_to_admin_preview($name,$moduleAction,$params=null)
	{
		$queryString = "" ;
		$options = "" ;
		if($params){
			if($params['query_string']){
				$queryString = "?" . $params['query_string'] ;
			}

			foreach($params as $key=>$value){
				if($key != 'query_string'){
					$options = sprintf('%s="%s" ',$key,$value) ;
				}
			}
		}

		return sprintf('<a href="/admin.php/%s%s" %s>%s</a>',$moduleAction,$queryString,$options,$name) ;
	}

	public static function link_to_admin_public($name,$moduleAction,$params=null)
	{
		$queryString = "" ;
		$options = "" ;
		if($params){
			if($params['query_string']){
				$queryString = "?" . $params['query_string'] ;
			}

			foreach($params as $key=>$value){
				if($key != 'query_string'){
					$options = sprintf('%s="%s" ',$key,$value) ;
				}
			}
		}

		return sprintf('<a href="/admin2.php/%s%s" %s>%s</a>',$moduleAction,$queryString,$options,$name) ;
	}

	public static function link_to($name,$moduleAction,$params=null)
	{
		$link = "" ;
		$publicActions = array(
			//'app/completeprocess'=>1,
			//'app/detailforstatus'=>1,
			//'app/enterapskey'=>1,
			//'app/enterfacebookappid'=>1,
			//'app/enterkiipapp'=>1,
			//'app/listall'=>1,
			//'app/listforstatus'=>1,
			//'app/listreleased'=>1,
			//'app/listunreleased'=>1,
			'app/showsummary'=>1,
			//'creator/inputnew'=>1,
			//'creator/listall'=>1,
			'forum/deletepost'=>1,
			'forum/deletecomment'=>1,
			'forum/posts'=>1,
			'forum/removedposts'=>1,
			'forum/reports'=>1,
			'forum/user'=>1,
			'forum/blockuser'=>1,
			'inquiry/listfromappuser'=>1,
			'inquiry/composetoappuser'=>1,
			'inquiry/replytoappuser'=>1,
			//'inquiry/setstatus'=>1,
			'link/listlinks'=>1,
			'subscription/listcontents'=>1,
			'subscription/listdelayed'=>1,
			'subscription/listlongdelayed'=>1,
			'youtube/listvideos'=>1,
		) ;

		if($publicActions[$moduleAction]){
			$link = AdminTools::link_to_admin_public($name,$moduleAction,$params) ;
		} else {
			$link = AdminTools::link_to_admin_preview($name,$moduleAction,$params) ;
		}

		return $link ;
	}

























	public static function link_to_creator_preview($name,$moduleAction,$params=null)
	{
		$queryString = "" ;
		$options = "" ;
		if($params){
			if($params['query_string']){
				$queryString = "?" . $params['query_string'] ;
			}

			foreach($params as $key=>$value){
				if($key != 'query_string'){
					$options = sprintf('%s="%s" ',$key,$value) ;
				}
			}
		}

		return sprintf('<a href="/creator.php/%s%s" %s>%s</a>',$moduleAction,$queryString,$options,$name) ;
	}

	public static function link_to_creator_public($name,$moduleAction,$params=null)
	{
		$queryString = "" ;
		$options = "" ;
		if($params){
			if($params['query_string']){
				$queryString = "?" . $params['query_string'] ;
			}

			foreach($params as $key=>$value){
				if($key != 'query_string'){
					$options = sprintf('%s="%s" ',$key,$value) ;
				}
			}
		}

		return sprintf('<a href="/creator2.php/%s%s" %s>%s</a>',$moduleAction,$queryString,$options,$name) ;
	}

	public static function link_to_creator($name,$moduleAction,$params=null)
	{
		$link = "" ;
		$publicActions = array(
			//'app/completeprocess'=>1,
			//'app/detailforstatus'=>1,
			//'app/enterapskey'=>1,
			//'app/enterfacebookappid'=>1,
			//'app/enterkiipapp'=>1,
			//'app/listall'=>1,
			//'app/listforstatus'=>1,
			//'app/listreleased'=>1,
			//'app/listunreleased'=>1,
			'app/showsummary'=>1,
			//'creator/inputnew'=>1,
			//'creator/listall'=>1,
			'forum/deletepost'=>1,
			'forum/deletecomment'=>1,
			'forum/posts'=>1,
			'forum/removedposts'=>1,
			'forum/reports'=>1,
			'forum/user'=>1,
			'forum/blockuser'=>1,
			'inquiry/listfromappuser'=>1,
			'inquiry/composetoappuser'=>1,
			'inquiry/replytoappuser'=>1,
			//'inquiry/setstatus'=>1,
			'link/listlinks'=>1,
			'subscription/listcontents'=>1,
			'subscription/listdelayed'=>1,
			'subscription/listlongdelayed'=>1,
			'youtube/listvideos'=>1,
			'mi/forumuser'=>1,
			'mi/forumposts'=>1,
			'mi/deleteforumpost'=>1,
			'mi/notification'=>1,
			'mi/notificationgroup'=>1,
		) ;

		if($publicActions[$moduleAction]){
			$link = AdminTools::link_to_creator_public($name,$moduleAction,$params) ;
		} else {
			$link = AdminTools::link_to_creator_preview($name,$moduleAction,$params) ;
		}

		return $link ;
	}


















	public static function deployApp($appId,$dbManager=null)
	{
		if($dbManager){
			$manager = $dbManager ;
		} else {
			$manager = sfContext::getInstance()->getDatabaseManager() ;
		}
		$db = $manager->getDatabase('propel') ;
		$dbUser = $db->getParameter("username") ;

		if($dbUser == 'veam_preview'){
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$commandDir = sprintf("%s/../../bin/deploy",sfConfig::get("sf_lib_dir")) ;
				$outputs = array() ;
				$commandLine = sprintf('perl %s/deploy_app.pl %s public',$commandDir,$appId) ;
				//print("$commandLine\n") ;
				exec($commandLine,$outputs) ;
				if($outputs[0] == '1'){
					// success 
					AdminTools::appChanged($appId) ;
				} else {
					AdminTools::assert(false,"failed to deploy app appId=$appId output=".$outputs[0],__FILE__,__LINE__) ;
				}
			} else {
				AdminTools::assert(false,"app to be deployed not found appId=$appId",__FILE__,__LINE__) ;
			}
		}
	}

	public static function deployAppContents($appId,$dbManager=null)
	{
		if($dbManager){
			$manager = $dbManager ;
		} else {
			$manager = sfContext::getInstance()->getDatabaseManager() ;
		}
		$db = $manager->getDatabase('propel') ;
		$dbUser = $db->getParameter("username") ;

		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$commandDir = sprintf("%s/../../bin/deploy",sfConfig::get("sf_lib_dir")) ;
			$outputs = array() ;
			$commandLine = sprintf('perl %s/deploy_app_contents.pl %s public',$commandDir,$appId) ;
			//print("$commandLine\n") ;
			if($dbUser == 'veam_preview'){
				exec($commandLine,$outputs) ;
			} else {
				//sfContext::getInstance()->getLogger()->info(sprintf("omit command (%s)",$commandLine)) ;
				$outputs[0] = '1' ;
			}
			if($outputs[0] == '1'){
				// success 
				$app->setModify(0) ;
				$app->save() ;
				//AdminTools::appChanged($appId) ;
				ConsoleTools::deleteMemcacheValue('publicAPI2_CONTENT_XML'.$appId) ;
				ConsoleTools::deleteMemcacheValue('publicAPI2_CONTENT_ID'.$appId) ;
				ConsoleTools::deleteMemcacheValue('publicCONSOLE_CONTENT_XML_V2'.$appId) ;

				$commandLine = sprintf("php /data/console/console.veam.co/site/symfony createBroadcast --app_id=%d > /dev/null",$appId) ;
				exec($commandLine) ;

			} else {
				AdminTools::assert(false,"failed to deploy app appId=$appId output=".$outputs[0],__FILE__,__LINE__) ;
			}
		} else {
			AdminTools::assert(false,"app to be deployed not found appId=$appId",__FILE__,__LINE__) ;
		}
	}

	public static function deployAppYoutubeContents($appId,$dbManager=null)
	{
		if($dbManager){
			$manager = $dbManager ;
		} else {
			$manager = sfContext::getInstance()->getDatabaseManager() ;
		}
		$db = $manager->getDatabase('propel') ;
		$dbUser = $db->getParameter("username") ;

		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$commandDir = sprintf("%s/../../bin/deploy",sfConfig::get("sf_lib_dir")) ;
			$outputs = array() ;
			$commandLine = sprintf('perl %s/deploy_app_youtube_contents.pl %s public',$commandDir,$appId) ;
			//print("$commandLine\n") ;
			if($dbUser == 'veam_preview'){
				exec($commandLine,$outputs) ;
				ConsoleTools::deleteMemcacheValue('publicAPI2_CONTENT_XML'.$appId) ;
				ConsoleTools::deleteMemcacheValue('publicAPI2_CONTENT_ID'.$appId) ;
				ConsoleTools::deleteMemcacheValue('publicCONSOLE_CONTENT_XML_V2'.$appId) ;
			} else {
				//sfContext::getInstance()->getLogger()->info(sprintf("omit command (%s)",$commandLine)) ;
				$outputs[0] = '1' ;
			}
			if($outputs[0] == '1'){
				// success 
				AdminTools::appChanged($appId) ;
			} else {
				AdminTools::assert(false,"failed to deploy youtube appId=$appId output=".$outputs[0],__FILE__,__LINE__) ;
			}
		} else {
			AdminTools::assert(false,"app to be deployed not found appId=$appId",__FILE__,__LINE__) ;
		}
	}

	public static function appChanged($appId)
	{
		//define('API2_KEY_CONTENT_XML','API2_CONTENT_XML') ; // + app id
		//define('API2_KEY_CONTENT_ID','API2_CONTENT_ID') ; // + app id
		//ConsoleTools::deleteMemcacheValue(API2_KEY_CONTENT_XML.$appId) ;
		//ConsoleTools::deleteMemcacheValue(API2_KEY_CONTENT_ID.$appId) ;
		ConsoleTools::deleteMemcacheValue(ConsoleTools::getEnvString().'API2_CONTENT_XML'.$appId) ;
		ConsoleTools::deleteMemcacheValue(ConsoleTools::getEnvString().'API2_CONTENT_ID'.$appId) ;
		ConsoleTools::deleteMemcacheValue(ConsoleTools::getEnvString().'CONSOLE_CONTENT_XML_V2'.$appId) ;
	}

	public static function getCurrentDbUserName()
	{
		$manager = sfContext::getInstance()->getDatabaseManager() ;
		$db = $manager->getDatabase('propel') ;
		$dbUserName = $db->getParameter("username") ;
		return $dbUserName ;
	}

	public static function getServerNameForDb()
	{
		$dbUserName = AdminTools::getCurrentDbUserName() ;
		$serverName = '' ;
		if($dbUserName == 'veam_work'){
			$serverName = 'console-work.veam.co' ;
		} else if($dbUserName == 'veam_preview'){
			$serverName = 'console-preview.veam.co' ;
		} else if($dbUserName == 'veam_public'){
			$serverName = 'console.veam.co' ;
		}
		return $serverName ;
	}


	public static function sendSubmitNotificationMail($appId){
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			/*
			1 	Veam 	
			2 	Bent 
			3 	Bizcast 	
			4 	Veam 	
			5 	VeamLP 	
			6 	VeamAuto 	
			7 	Invalidated 	
			*/
			$mcnId = $app->getMcnId() ;
			if(($mcnId == 1) || ($mcnId == 5) || ($mcnId == 6)){
				$to = "submit_notification@veam.co" ;
			} else if($mcnId == 4){
				$to = "submit_notification@veam.com" ;
			} else {
				$to = "tech@veam.co" ;
			}

			$mcn = McnPeer::retrieveByPk($mcnId) ;
			if($mcn){
				$mcnName = $mcn->getName() ;
			} else {
				$mcnName = "Unknown" ;
				AdminTools::assert(false,"Mcn not found mcnId=$mcnId",__FILE__,__LINE__) ;
			}

			$appName = $app->getName() ;

			$message = sprintf("The following app has been submitted.\n\nApp : %s \nMcn : %s \n\n",$appName,$mcnName) ;
			ConsoleTools::sendInfoMail("[VEAMIT] App Submitted",$to,$message) ;
		} else {
			AdminTools::assert(false,"App not found appId=$appId",__FILE__,__LINE__) ;
		}
	}

	public static function sendMessageToAppCreators($appId,$message,$kind,$mcnUserName)
	{
		$c = new Criteria() ;
	  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
	  	$c->add(AppCreatorPeer::APP_ID,$appId) ;
		$appCreators = AppCreatorPeer::doSelect($c) ;

		foreach($appCreators as $appCreator){
			AdminTools::sendMessageToAppCreator($appCreator,$message,$kind,$mcnUserName) ;
		}
	}

	public static function sendMessageToAppCreator($appCreator,$message,$kind,$mcnUserName)
	{
		if($appCreator){

			AdminTools::createMessageToAppCreator($appCreator->getId(),$kind,$message,$mcnUserName) ;

			$body = "" ;
			$body .= sprintf("Hi %s.\n",$appCreator->getFirstName()) ;
			$body .= sprintf("\n") ;
			$body .= sprintf("You have a new message in app.\n") ;
			$body .= sprintf("Do not reply to this e-mail. Please reply from the app.\n") ;
			$body .= sprintf("- - - - - - -\n") ;
			$body .= sprintf("%s\n",$message) ;
			$body .= sprintf("- - - - - - -\n") ;
			$body .= sprintf("Thanks,\n") ;
			$body .= sprintf("Veam Support Team\n") ;
			$body .= sprintf("*This email address is delivered only\n") ;
			$body .= sprintf("\n") ;

			AdminTools::sendNotificationMail('Message from Veam Support',$appCreator->getUsername(),$body) ;

			$c = new Criteria() ;
		  	$c->add(ConsoleDeviceTokenPeer::DEL_FLG,0) ;
		  	$c->add(ConsoleDeviceTokenPeer::APP_CREATOR_ID,$appCreator->getId()) ;
			$consoleDeviceTokens = ConsoleDeviceTokenPeer::doSelect($c) ;
			foreach($consoleDeviceTokens as $consoleDeviceToken){
				AdminTools::sendiOSNotification($consoleDeviceToken,'Check the message from Veam Support',1) ;
			}
		}
	}


	public static function createMessageToAppCreator($appCreatorId,$kind,$message,$mcnUserName)
	{
		$appCreator = AppCreatorPeer::retrieveByPk($appCreatorId) ;
		if($appCreator){
			$appId = $appCreator->getAppId() ;
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$appCreatorMessage = new AppCreatorMessage() ;
				$appCreatorMessage->setAppId($appId) ;
				$appCreatorMessage->setAppCreatorId($appCreator->getId()) ;
				$appCreatorMessage->setMcnId($app->getMcnId()) ;
				$appCreatorMessage->setMcnUserName($mcnUserName) ;
				$appCreatorMessage->setDirection(2) ; // MCN to Creator
				$appCreatorMessage->setKind($kind) ;
				$appCreatorMessage->setMessage($message) ;
				$appCreatorMessage->save() ;

				$c = new Criteria() ;
				$c->add(AppCreatorMessageLatestPeer::DEL_FLG,0) ;
				$c->add(AppCreatorMessageLatestPeer::APP_CREATOR_ID,$appCreator->getId()) ;
				$c->add(AppCreatorMessageLatestPeer::DIRECTION,2) ;
				$appCreatorMessageLatest = AppCreatorMessageLatestPeer::doSelectOne($c) ;
				if(!$appCreatorMessageLatest){
					$appCreatorMessageLatest = new AppCreatorMessageLatest() ;
					$appCreatorMessageLatest->setAppId($appId) ;
					$appCreatorMessageLatest->setAppCreatorId($appCreator->getId()) ;
					$appCreatorMessageLatest->setMcnId($app->getMcnId()) ;
					$appCreatorMessageLatest->setMcnUserName($mcnUserName) ;
					$appCreatorMessageLatest->setDirection(2) ; // MCN to Creator
					$appCreatorMessageLatest->setKind($kind) ;
				}
				$appCreatorMessageLatest->setMessage($message) ;
				$appCreatorMessageLatest->save() ;
			} else {
				ConsoleTools::assert(false,"app not found appId=$appId",__FILE__,__LINE__) ;
			}
		} else {
			ConsoleTools::assert(false,"appCreator not found appCreatorId=$appCreatorId",__FILE__,__LINE__) ;
		}
	}




	public static function sendiOSNotification($consoleDeviceToken,$notificationMessage,$badge)
	{
		if($consoleDeviceToken){

			$libDir = sfConfig::get("sf_lib_dir") ;

			$targetEnv = $consoleDeviceToken->getEnvironment() ;
			if($targetEnv == 'D'){
				$envs = array('D') ;
			} else if($targetEnv == 'P'){
				$envs = array('P') ;
			} else {
				$envs = array('D','P') ;
			}

			foreach($envs as $env){
				if($env == 'P'){
					$push = new ApnsPHP_Push(ApnsPHP_Abstract::ENVIRONMENT_PRODUCTION,sprintf('%s/task/apn_certs/APN_VeamConsole_PROD.pem',$libDir)) ;
				} else {
					$push = new ApnsPHP_Push(ApnsPHP_Abstract::ENVIRONMENT_SANDBOX	 ,sprintf('%s/task/apn_certs/APN_VeamConsole_DEV.pem' ,$libDir)) ;
				}

				$push->setLogger(new ApnsPHP_Log_None) ; // no output
				$push->setRootCertificationAuthority($libDir.'/task/apn_certs/entrust_root_certification_authority.pem') ;
				$push->setWriteInterval(50 * 1000) ;
				$push->connect() ;

				$tokenString = $consoleDeviceToken->getToken() ;
				if($tokenString != ""){
					//sfContext::getInstance()->getLogger()->info(sprintf("sendiOSNotification %s %s %s %d\n",$tokenString,$customId,$notificationMessage,$badge)) ;

					$message = new ApnsPHP_Message($tokenString) ;
					$message->setCustomIdentifier("M0");

					if($badge){
						$message->setBadge(intval($badge)) ;
					}

					if($notificationMessage){
						$message->setText($notificationMessage) ;
					}

					$push->add($message);
				}

				$push->send() ;
				$push->disconnect() ;

				$aErrorQueue = $push->getErrors() ;
				if(!empty($aErrorQueue)){
					//sfContext::getInstance()->getLogger()->info(sprintf("APN send error %s",$var_export($aErrorQueue,true))) ;
					//$aErrorQueue[1]["ERRORS"][0]["statusCode"] ;
				} else {
					if($targetEnv != $env){
						$consoleDeviceToken->setEnvironment($env) ;
						$consoleDeviceToken->save() ;
					}
					break ;
				}
			}
		}
	}



	public static function getRemoteFileSize($url) 
	{
	    $regex = '/^Content-Length: *+\K\d++$/im' ;
	    if(!$fp = @fopen($url, 'rb')){
	        return false ;
	    }
	    if(isset($http_response_header) && preg_match($regex, implode("\n", $http_response_header), $matches)){
	        return (int)$matches[0] ;
	    }
	    return strlen(stream_get_contents($fp)) ;
	}



	public static function createAndroidResource($appId)
	{

		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			if($app->getIconImage()){
				$c = new Criteria() ;
				$c->add(YoutubeUserPeer::APP_ID,$appId) ;
				$c->add(YoutubeUserPeer::AUTO_LIST,1) ;
				$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
				$youtubeUser = YoutubeUserPeer::doSelectOne($c) ;
				if($youtubeUser){

					$libDir = sfConfig::get("sf_lib_dir") ;
					$webDir = sfConfig::get("sf_web_dir") ;

					$baseDir = sprintf("%s/uploads/%s",$webDir,$app->getId()) ;
					$iconFileName = "icon512.png" ;
					$orgIconFileName = "icon1024.png" ;
					$infoFileName = "icon1024.txt" ;
					$promoFileName = "promo.png" ;
					$promo1FileName = "promo1.png" ;
					$promo2FileName = "promo2.png" ;
					$promo3FileName = "promo3.png" ;
					$promo4FileName = "promo4.png" ;
					$iconFilePath = sprintf("%s/%s",$baseDir,$iconFileName) ;
					$orgIconFilePath = sprintf("%s/%s",$baseDir,$orgIconFileName) ;
					$infoFilePath = sprintf("%s/%s",$baseDir,$infoFileName) ;
					$promoFilePath = sprintf("%s/%s",$baseDir,$promoFileName) ;
					$promo1FilePath = sprintf("%s/%s",$baseDir,$promo1FileName) ;
					$promo2FilePath = sprintf("%s/%s",$baseDir,$promo2FileName) ;
					$promo3FilePath = sprintf("%s/%s",$baseDir,$promo3FileName) ;
					$promo4FilePath = sprintf("%s/%s",$baseDir,$promo4FileName) ;

					$iconImageUrl = $app->getIconImage() ;

					if(!file_exists($baseDir)){
						//print("not exists\n") ;
						mkdir($baseDir,0777,true) ;
						chmod($baseDir,0777) ;
					}

					if(!file_exists($promo1FilePath)){
						$promoImageUrl = AdminTools::getPromoImageUrl($youtubeUser) ;
						if($promoImageUrl){
							//print("promo=$promoImageUrl\n") ;
							$promo = file_get_contents($promoImageUrl) ;
						    $fp = fopen($promoFilePath, 'w') ;
						    fwrite($fp, $promo) ;
						    fclose($fp) ;

							AdminTools::makePromoImage1($promoFilePath,$promo1FilePath) ;
							AdminTools::makePromoImage2($promoFilePath,$promo2FilePath) ;
							AdminTools::makePromoImage3($promoFilePath,$promo3FilePath) ;
							AdminTools::makePromoImage4($promoFilePath,$promo4FilePath) ;
						}
					}

					$shouldCreateIcon = false ;
					if(!file_exists($iconFilePath)){
						$shouldCreateIcon = true ;
					} else {
						if(!file_exists($infoFilePath)){
							$shouldCreateIcon = true ;
						} else {
							$size = file_get_contents($infoFilePath) ;
							$remoteSize = AdminTools::getRemoteFileSize($iconImageUrl) ;
							if($size != $remoteSize){
								$shouldCreateIcon = true ;
							}
						}
					}

					if($shouldCreateIcon){
						$icon1024 = file_get_contents($iconImageUrl) ;
					    $fp = fopen($orgIconFilePath, 'w') ;
					    fwrite($fp, $icon1024) ;
					    fclose($fp) ;

						$orgSize = filesize($orgIconFilePath) ;
					    $fp = fopen($infoFilePath, 'w') ;
					    fwrite($fp, $orgSize) ;
					    fclose($fp) ;

						AdminTools::resizeImage($orgIconFilePath,$iconFilePath,512,512) ;
					}
				}
			}
		}
	}


	public static function makePromoImage1($imagePath1,$imagePath2)
	{
		$width = 1024 ;
		$height = 500 ;

		$image = imagecreatefrompng($imagePath1) ;
		if(!$image){
			$image = imagecreatefromjpeg($imagePath1) ;
		}
		list($width1, $height1) = getimagesize($imagePath1) ;

		$newWidth = $width ;
		$newHeight = $height1 * $width / $width1 ;

		$resizedImage = imagecreatetruecolor($width, $height) ;
		imagecopyresized($resizedImage, $image, 0, ($height - $newHeight) / 2, 0, 0, $newWidth, $newHeight, $width1, $height1);

		imagepng($resizedImage,$imagePath2);
	}

	public static function makePromoImage2($imagePath1,$imagePath2)
	{
		$width = 1024 ;
		$height = 500 ;

		$image = imagecreatefrompng($imagePath1) ;
		if(!$image){
			$image = imagecreatefromjpeg($imagePath1) ;
		}
		list($width1, $height1) = getimagesize($imagePath1) ;

		$newHeight = $height ;
		$newWidth = $width1 * $height / $height1 ;

		$resizedImage = imagecreatetruecolor($width, $height) ;
		imagecopyresized($resizedImage, $image, ($width - $newWidth) / 2 ,0, 0, 0, $newWidth, $newHeight, $width1, $height1);

		imagepng($resizedImage,$imagePath2);
	}

	public static function makePromoImage3($imagePath1,$imagePath2)
	{
		$width = 1024 ;
		$height = 500 ;

		$image = imagecreatefrompng($imagePath1) ;
		if(!$image){
			$image = imagecreatefromjpeg($imagePath1) ;
		}
		list($width1, $height1) = getimagesize($imagePath1) ;

		$newHeight = $height ;
		$newWidth = $width1 * $height / $height1 ;

		$resizedImage = imagecreatetruecolor($width, $height) ;
		imagefilledrectangle($resizedImage , 0 , 0 , $width , $height, imagecolorallocate($resizedImage, 255, 255, 255)) ;
		imagecopyresized($resizedImage, $image, ($width - $newWidth) / 2 ,0, 0, 0, $newWidth, $newHeight, $width1, $height1);

		imagepng($resizedImage,$imagePath2);
	}

	public static function makePromoImage4($imagePath1,$imagePath2)
	{
		$width = 1024 ;
		$height = 500 ;

		$image = imagecreatefrompng($imagePath1) ;
		if(!$image){
			$image = imagecreatefromjpeg($imagePath1) ;
		}
		list($width1, $height1) = getimagesize($imagePath1) ;

		$newHeight = $height ;
		$newWidth = $width1 * $height / $height1 ;

		$resizedImage = imagecreatetruecolor($width, $height) ;
		$extraWidth = ($width - $newWidth) / 2 ;
		imagecopyresized($resizedImage, $image, ($width - $newWidth) / 2 ,0, 0, 0, $newWidth, $newHeight, $width1, $height1);
		imagecopyresized($resizedImage, $image, 0 ,0, 0, 0, $extraWidth, $newHeight, 1, $height1);
		imagecopyresized($resizedImage, $image, $extraWidth+$newWidth ,0, $width1-1, 0, $extraWidth, $newHeight, 1, $height1);

		imagepng($resizedImage,$imagePath2);
	}



	public static function resizeImage($imagePath1,$imagePath2,$width,$height)
	{
		$image = imagecreatefrompng($imagePath1) ;
		if(!$image){
			$image = imagecreatefromjpeg($imagePath1) ;
		}
		list($width1, $height1) = getimagesize($imagePath1) ;

		$resizedImage = imagecreatetruecolor($width, $height);
		imagecopyresized($resizedImage, $image, 0, 0, 0, 0, $width, $height, $width1, $height1);

		imagepng($resizedImage,$imagePath2);
	}




	public function getPromoImageUrl($youtubeUser)
	{
		$apiKey = '__YOUTUBE_API_KEY__' ;
		$appId = $youtubeUser->getAppId() ;

		$userName = $youtubeUser->getName() ;
		//print("$userName\n") ;
		// username から ChannelID を取得
		$url = sprintf("https://www.googleapis.com/youtube/v3/channels?key=%s&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&forUsername=%s",$apiKey,$userName) ;
		$json = file_get_contents($url,true) ;

		$reload = false ;
		if(!$json){
			$reload = true ;
		} else {
			$channelList = json_decode($json) ;
			if($channelList){
				#print(var_export($channelList,true)) ;
				$items = $channelList->{'items'} ;
				if(count($items) == 0){
					$reload = true ;
				} else {
					$reload = true ;
					$userName = $items[0]->{'id'} ;
				}
			} else {
				$reload = true ;
			}
		}

		if($reload){
			//print("reload with id\n") ;
			$url = sprintf('https://www.googleapis.com/youtube/v3/channels?key=__YOUTUBE_API_KEY__&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&id=%s',$userName) ;
			$json = file_get_contents($url) ;
		}

		if(!$json){
			return "http://console.veam.co/uploads/android_promo_not_found.png" ;
		}

		$channelListResponse = json_decode($json) ;
		$channels = $channelListResponse->{'items'} ;
		foreach($channels as $channel){
			$tagNames = array(
				"bannerTvImageUrl",
				"bannerTvHighImageUrl",
				"bannerTvMediumImageUrl",
				"bannerTvLowImageUrl",
				"bannerTabletExtraHdImageUrl",
				"bannerTabletHdImageUrl",
				"bannerTabletImageUrl",
				"bannerTabletLowImageUrl",
				"bannerMobileImageUrl",
				"bannerMobileExtraHdImageUrl",
				"bannerMobileHdImageUrl",
				"bannerMobileMediumHdImageUrl",
				"bannerMobileLowImageUrl",
				"bannerImageUrl",
			) ;

			foreach($tagNames as $tagName){
				if($channel->{'brandingSettings'}->{'image'}->{$tagName}){
					return $channel->{'brandingSettings'}->{'image'}->{$tagName} ;
				}
			}
		}
		return "http://console.veam.co/uploads/android_promo_not_found.png" ;
	}




	public static function saveConsoleLoginLog($appId,$userName,$ip,$userAgent,$accessedAt)
	{
		$accessTime = strtotime($accessedAt) ;
		$before = $accessTime - 36000 ; // 10 hours
		$after = $accessTime + 36000 ; // 10 hours

	  	$c = new Criteria();
	  	$c->add(ConsoleLoginLogPeer::DEL_FLAG,0) ;
	  	$c->add(ConsoleLoginLogPeer::USER_NAME,$userName) ;
	  	$c->addAnd(ConsoleLoginLogPeer::ACCESSED_AT,date('Y-m-d H:i:s',$before),Criteria::GREATER_EQUAL) ;
	  	$c->addAnd(ConsoleLoginLogPeer::ACCESSED_AT,date('Y-m-d H:i:s',$after),Criteria::LESS_EQUAL) ;
	  	$numberOfLogs = ConsoleLoginLogPeer::doCount($c) ;
		if($numberOfLogs == 0){
			$consoleLoginLog = new ConsoleLoginLog() ;
			$consoleLoginLog->setAppId($appId) ;
			$consoleLoginLog->setUserName($userName) ;
			$consoleLoginLog->setIp($ip) ;
			$consoleLoginLog->setUserAgent($userAgent) ;
			$consoleLoginLog->setAccessedAt($accessedAt) ;
			$consoleLoginLog->save() ;
		}
	}




}

class ApnsPHP_Log_None implements ApnsPHP_Log_Interface
{
	public function log($sMessage){}
}

