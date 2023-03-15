<?php
//
// This class is used by all apprications.
// Modification will affect to all applications.
//

// sfContext::getInstance()->getLogger()->info(sprintf("target=%d blockedUsersList=%s",$socialUserId,$blockedUsersList)) ;

//include 'HTTP/OAuth/Consumer.php';

//require_once 'Mail.php'; 

define('MEMCACHE_KEY_FORUM_PICTURE_BODY','FORUM_PICTURE_BODY') ; // + forum id
define('MEMCACHE_KEY_FORUM_PICTURE_MAX_PAGE','FORUM_PICTURE_MAX_PAGE') ; // + forum id
define('MEMCACHE_KEY_FORUM_MESSAGE_BODY','FORUM_MESSAGE_BODY') ; // + forum id
define('MEMCACHE_KEY_FORUM_MESSAGE_MAX_PAGE','FORUM_MESSAGE_MAX_PAGE') ; // + forum id
define('MEMCACHE_KEY_FOLLOW_BODY','FOLLOW_BODY') ; // + followKind + social user id
define('MEMCACHE_KEY_FOLLOW_MAX_PAGE','FOLLOW_MAX_PAGE') ; // + followKind + social user id
define('MEMCACHE_KEY_YOUTUBE_VIDEO_BODY','YOUTUBE_VIDEO_BODY') ; // + forum id
define('MEMCACHE_KEY_PROFILE_BODY','PROFILE_BODY') ; // + social user id
define('MEMCACHE_KEY_USER_PICTURE_LIKES','USER_PICTURE_LIKES') ; // + social user id
define('MEMCACHE_KEY_USER_YOUTUBE_LIKES','USER_YOUTUBE_LIKES') ; // + social user id
define('MEMCACHE_KEY_USER_PROGRAM_LIKES','USER_PROGRAM_LIKES') ; // + social user id
define('MEMCACHE_KEY_USER_FOLLOWINGS','USER_FOLLOWINGS') ; // + social user id
define('MEMCACHE_KEY_CONTENT_XML','CONTENT_XML') ; // + app id
define('MEMCACHE_KEY_BLOCKED_USERS','BLOCKED_USERS') ; // + app id
define('GOOGLE_ACCESS_TOKEN','GOOGLE_ACCESS_TOKEN') ;
define('MEMCACHE_KEY_BLOG_POST','BLOG_POST') ; // + blog_post id
define('MEMCACHE_KEY_FORUM_KIND','FORUM_KIND') ; // + forum id
define('MEMCACHE_KEY_SWATCH_XML','SWATCH_XML') ; // + picture id
define('MEMCACHE_KEY_HOT_FORUM_ID','HOT_FORUM_ID') ; // + app id
define('MEMCACHE_KEY_FORUM_IDS','FORUM_IDS') ; // + app id
define('MEMCACHE_KEY_PROGRAMS_BODY','PROGRAMS_BODY') ; // + startDate_endDate
define('MEMCACHE_KEY_PROGRAM_BODY','PROGRAM_BODY') ; // + program id
define('MEMCACHE_KEY_TICKET_BODY','TICKET_BODY') ; // + transaction
define('MEMCACHE_KEY_USER_ADID','USER_ADID') ; // + social user id + adid
define('MEMCACHE_KEY_APP_NAME','APP_NAME') ; // + app id
define('MEMCACHE_KEY_FORUM_NAME','FORUM_NAME') ; // + forum id
define('MEMCACHE_KEY_REPORT_ADDRESSES','REPORT_ADDRESSES') ; // + app id
define('MEMCACHE_KEY_CONSOLE_CONTENT_XML','CONSOLE_CONTENT_XML_V2') ; // + app id
define('API2_KEY_CONTENT_XML','API2_CONTENT_XML') ; // + app id
define('API2_KEY_CONTENT_ID','API2_CONTENT_ID') ; // + app id



function textlineCompare($a, $b)
{
    $cmp = strcmp($a->getCreatedAt(), $b->getCreatedAt());
    return $cmp;
}


class ConsoleTools
{


	public static $memcache = null ;
	public static function getMemcache()
	{
		if(!ConsoleTools::$memcache){
			ConsoleTools::$memcache = new Memcached() ;
			if(!ConsoleTools::$memcache->addServer('__MEMCACHE_SERVER_IP__', 11211)){ // private address of app.veam.co 20161218 CentOS7
				//ConsoleTools::assert(false,"failed to connect to memcached",__FILE__,__LINE__) ;
				ConsoleTools::$memcache = null ;
			}
		}
		return ConsoleTools::$memcache ;
	}

	public static function getMemcacheValue($key)
	{
		$result = "" ;
		$memcache = ConsoleTools::getMemcache() ;
		if($memcache){
			$result = $memcache->get($key) ;
		}
		return $result ;
	}

	public static function setMemcacheValue($key,$value,$expire)
	{
		$result = "" ;
		$memcache = ConsoleTools::getMemcache() ;
		if($memcache){
			$memcache->set($key,$value,time()+$expire) ;
		}
	}

	public static function deleteMemcacheValue($key)
	{
		$result = "" ;
		$memcache = ConsoleTools::getMemcache() ;
		if($memcache){
			$result = $memcache->delete($key) ;
		}
		return $result ;
	}


	public static function clearContentCache($appId){
		$env = ConsoleTools::getEnvString() ;
		$contentXmlKey = $env.MEMCACHE_KEY_CONTENT_XML.$appId ;
		ConsoleTools::deleteMemcacheValue($contentXmlKey) ;

		if($env == 'public'){
			$contentXmlKey = 'preview'.MEMCACHE_KEY_CONTENT_XML.$appId ;
			ConsoleTools::deleteMemcacheValue($contentXmlKey) ;
		}
	}




















	public static function isBlockedUser($appId,$socialUserId)
	{
		$isBlocked = 0 ;
		$blockedUsersKey = ConsoleTools::getEnvString().MEMCACHE_KEY_BLOCKED_USERS.$appId ;
		$blockedUsersList = ConsoleTools::getMemcacheValue($blockedUsersKey) ;

		if(!$blockedUsersList){
			// sfContext::getInstance()->getLogger()->info("blockedUsersList is not in mem") ;
		  	$c = new Criteria();
			$app = AppPeer::retrieveByPk($appId) ;
			if(!$app){
				ConsoleTools::assert(false,"App not found. appId=".$appId,__FILE__,__LINE__) ;
				return 1 ;
			}

			$blockedUsersList = 'list' ;

		  	$c = new Criteria() ;
		  	$c->add(SocialUserPeer::DEL_FLG,0) ;
		  	$c->add(SocialUserPeer::APP_ID,$appId) ;
		  	$c->add(SocialUserPeer::BLOCK_LEVEL,1) ;
		  	$blockedUsers = SocialUserPeer::doSelect($c) ;
			foreach($blockedUsers as $blockedUser){
				$blockedUsersList .= ','.$blockedUser->getId() ;
			}
			ConsoleTools::setMemcacheValue($blockedUsersKey,$blockedUsersList,600) ;
		}

		// sfContext::getInstance()->getLogger()->info(sprintf("target=%d blockedUsersList=%s",$socialUserId,$blockedUsersList)) ;

		$list = explode(',',$blockedUsersList) ;
		if(in_array($socialUserId,$list)){
			sfContext::getInstance()->getLogger()->info(sprintf("Blocked User : %d blockedUsersList=%s",$socialUserId,$blockedUsersList)) ;
			$isBlocked = 1 ;
		}

		return $isBlocked ;
	}

	public static function getBlogPostDate($dbDateString)
	{
		// 2013-10-07 12:00:00
		$year = substr($dbDateString,0,4) ;
		$monthValue = substr($dbDateString,5,2) ;
		$dayValue = substr($dbDateString,8,2) ;
		$months = array(" ","JAN","FEB","MARCH","APRIL","MAY","JUNE","JULY","AUG","SEPT","OCT","NOV","DEC") ;
		$month = $months[intval($monthValue)] ;
		$blogPostDateString = sprintf("%s %d, %s",$month,$dayValue,$year) ;
		return $blogPostDateString ;
	}

	public static function getBlogPost($blogPostId)
	{

		$blogPostKey = ConsoleTools::getEnvString().MEMCACHE_KEY_BLOG_POST.$blogPostId ;
		$blogPostHtml = ConsoleTools::getMemcacheValue($blogPostKey) ;

		if(!$blogPostHtml){
			$blogPost = BlogPostPeer::retrieveByPk($blogPostId) ;
			if(!$blogPost){
				ConsoleTools::assert(false,"BlogPost not found. blogPostId=".$blogPostId,__FILE__,__LINE__) ;
				return "" ;
			}

			$blogPostHtml = $blogPost->getHtml() ;
			$blogPostHtml = str_replace('__BLOGPOST_POSTED_AT__',ConsoleTools::getBlogPostDate($blogPost->getPostedAt()),$blogPostHtml) ;

			ConsoleTools::setMemcacheValue($blogPostKey,$blogPostHtml,86400) ;
		}

		return $blogPostHtml ;

	}



	public static function getContentXml($appId)
	{

		$contentXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_CONTENT_XML.$appId ;
		$contentXml = ConsoleTools::getMemcacheValue($contentXmlKey) ;
		if(!$contentXml){
		  	$c = new Criteria();
			$app = AppPeer::retrieveByPk($appId) ;
			if(!$app){
				ConsoleTools::assert(false,"App not found. appId=".$appId,__FILE__,__LINE__) ;
				return sfView::NONE ;
			}

			$contentXml = sprintf('<?xml version="1.0" encoding="UTF-8"?><list id="%d">',time()) ;

		  	$c = new Criteria() ;
		  	$c->add(WeekdayTextPeer::DEL_FLG,0) ;
		  	$c->add(WeekdayTextPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(WeekdayTextPeer::START_AT) ;
		  	$weekdayTexts = WeekdayTextPeer::doSelect($c) ;
			foreach($weekdayTexts as $weekdayText){
				$contentXml .= sprintf('<wdtext id="%s" s="%d" e="%d" w="%d" a="%d" t="%s" d="%s" l="%s" />',
					$weekdayText->getId(),
					$weekdayText->getStartAt(),
					$weekdayText->getEndAt(),
					$weekdayText->getWeekday(),
					$weekdayText->getAction(),
					$weekdayText->getTitle(),
					$weekdayText->getDescription(),
					$weekdayText->getLinkUrl());
			}

		  	$c = new Criteria() ;
		  	$c->add(BulletinPeer::DEL_FLG,0) ;
		  	$c->add(BulletinPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(BulletinPeer::START_AT) ;
		  	$bulletins = BulletinPeer::doSelect($c) ;
			foreach($bulletins as $bulletin){
				$contentXml .= sprintf('<bulletin id="%s" k="%d" s="%d" e="%d" i="%d" b="%s" t="%s" m="%s" u="%s" />',
					$bulletin->getId(),
					$bulletin->getKind(),
					strtotime($bulletin->getStartAt()." GMT"),
					strtotime($bulletin->getEndAt()." GMT"),
					$bulletin->getIndex(),
					$bulletin->getBackgroundColor(),
					$bulletin->getTextColor(),
					$bulletin->getMessage(),
					$bulletin->getImageUrl()) ;
			}

			if($appId == '31000015'){
				$contentXml .= '<forum id="0" name="Hot Topics" />' ;
			}

		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(ForumPeer::CREATED_AT) ;
		  	$forums = ForumPeer::doSelect($c) ;

			// ConsoleTools::assert(count($forums)>0,"Forum not found. appId=".$appId,__FILE__,__LINE__) ; // no forum for 31000014

			foreach($forums as $forum){
				$contentXml .= sprintf('<forum id="%s" name="%s" kind="%s" />',$forum->getId(),$forum->getName(),$forum->getKind()) ;
			}

		  	$c = new Criteria();
		  	$c->add(RecipeCategoryPeer::DEL_FLG,0) ;
		  	$c->add(RecipeCategoryPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(RecipeCategoryPeer::CREATED_AT) ;
		  	$recipeCategories = RecipeCategoryPeer::doSelect($c) ;

			//ConsoleTools::assert(count($recipeCategories)>0,"recipeCategories not found. appId=".$appId,__FILE__,__LINE__) ;

			foreach($recipeCategories as $recipeCategorie){
				$recipeCategoryId = $recipeCategorie->getId() ;
				$contentXml .= sprintf('<recipe_category id="%s" name="%s" />',$recipeCategoryId,$recipeCategorie->getName()) ;
			  	$recipeCriteria = new Criteria();
			  	$recipeCriteria->add(RecipePeer::DEL_FLAG,0) ;
			  	$recipeCriteria->add(RecipePeer::RECIPE_CATEGORY_ID,$recipeCategoryId) ;
				$recipeCriteria->addDescendingOrderByColumn(RecipePeer::CREATED_AT) ;
			  	$recipes = RecipePeer::doSelect($recipeCriteria) ;
				foreach($recipes as $recipe){
					$contentXml .= sprintf('<recipe id="%s" c="%s" u="%s" t="%s" i="%s" d="%s" n="%s"/>',
							$recipe->getId(),$recipe->getRecipeCategoryId(),$recipe->getImageUrl(),$recipe->getTitle(),$recipe->getIngredients(),$recipe->getDirections(),$recipe->getNutrition()) ;
				}
			}

		  	$c = new Criteria();
		  	$c->add(CategoryPeer::DEL_FLG,0) ;
		  	$c->add(CategoryPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(CategoryPeer::CREATED_AT) ;
		  	$categories = CategoryPeer::doSelect($c) ;

			foreach($categories as $category){
				$categoryId = $category->getId() ;
				$tagName = "category" ;
				if($category->getKind() == 1){
					$tagName = "unlisted_category" ;
				}
				$contentXml .= sprintf('<%s id="%s" name="%s" />',$tagName,$categoryId,$category->getName()) ;
			  	$subCategoryCriteria = new Criteria();
			  	$subCategoryCriteria->add(SubCategoryPeer::DEL_FLG,0) ;
			  	$subCategoryCriteria->add(SubCategoryPeer::CATEGORY_ID,$categoryId) ;
				$subCategoryCriteria->addDescendingOrderByColumn(SubCategoryPeer::CREATED_AT) ;
			  	$subCategories = SubCategoryPeer::doSelect($subCategoryCriteria) ;

				foreach($subCategories as $subCategory){
					$subCategoryId = $subCategory->getId() ;
					$contentXml .= sprintf('<sub_category id="%s" c="%s" name="%s" />',$subCategoryId,$subCategory->getCategoryId(),$subCategory->getName()) ;
				}
			}

		  	$c = new Criteria();
		  	$c->add(YoutubeVideoPeer::DEL_FLG,0) ;
		  	$c->add(YoutubeVideoPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(YoutubeVideoPeer::CREATED_AT) ;
		  	$youtubeVideos = YoutubeVideoPeer::doSelect($c) ;

			foreach($youtubeVideos as $youtubeVideo){
				$contentXml .= sprintf('<youtube id="%s" d="%s" a="%s" t="%s" e="%s" c="%s" s="%s" v="%s" n="%s" k="%d" l="%s" tm="%s" />',
					$youtubeVideo->getId(),$youtubeVideo->getDuration(),$youtubeVideo->getAuthor(),$youtubeVideo->getTitle(),$youtubeVideo->getDescription(),$youtubeVideo->getCategoryId(),$youtubeVideo->getSubCategoryId(),$youtubeVideo->getYoutubeCode(),$youtubeVideo->getIsNew(),$youtubeVideo->getKind(),$youtubeVideo->getLinkUrl(),strtotime($youtubeVideo->getCreatedAt())) ;
			}


			// blog post
		  	$c = new Criteria();
		  	$c->add(BlogCategoryPeer::DEL_FLG,0) ;
		  	$c->add(BlogCategoryPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(BlogCategoryPeer::CREATED_AT) ;
		  	$blogCategories = BlogCategoryPeer::doSelect($c) ;

			foreach($blogCategories as $blogCategory){
				$blogCategoryId = $blogCategory->getId() ;
				$contentXml .= sprintf('<blog_category id="%s" name="%s" />',$blogCategoryId,$blogCategory->getName()) ;
			  	$blogSubCategoryCriteria = new Criteria();
			  	$blogSubCategoryCriteria->add(BlogSubCategoryPeer::DEL_FLG,0) ;
			  	$blogSubCategoryCriteria->add(BlogSubCategoryPeer::CATEGORY_ID,$blogCategoryId) ;
				$blogSubCategoryCriteria->addDescendingOrderByColumn(BlogSubCategoryPeer::CREATED_AT) ;
			  	$blogSubCategories = BlogSubCategoryPeer::doSelect($blogSubCategoryCriteria) ;

				foreach($blogSubCategories as $blogSubCategory){
					$blogSubCategoryId = $blogSubCategory->getId() ;
					$contentXml .= sprintf('<blog_sub_category id="%s" c="%s" name="%s" />',$blogSubCategoryId,$blogSubCategory->getCategoryId(),$blogSubCategory->getName()) ;
				}
			}


		  	$c = new Criteria();
		  	$c->add(BlogPostPeer::DEL_FLG,0) ;
		  	$c->add(BlogPostPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(BlogPostPeer::CREATED_AT) ;
		  	$blogPosts = BlogPostPeer::doSelect($c) ;

			foreach($blogPosts as $blogPost){
				$contentXml .= sprintf('<blog_post id="%s" t="%s" c="%s" s="%s" u="%s" p="%s" tm="%s" />',
					$blogPost->getId(),$blogPost->getTitle(),$blogPost->getBlogCategoryId(),$blogPost->getBlogSubCategoryId(),$blogPost->getThumbnailUrl(),$blogPost->getPostedAt(),strtotime($blogPost->getCreatedAt())) ;
			}



		  	$c = new Criteria() ;
		  	$c->add(StampPeer::DEL_FLG,0) ;
		  	$c->add(StampPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(StampPeer::CREATED_AT) ;
		  	$stamps = StampPeer::doSelect($c) ;

			foreach($stamps as $stamp){
			  	$c = new Criteria() ;
			  	$c->add(StampImagePeer::DEL_FLG,0) ;
			  	$c->add(StampImagePeer::STAMP_ID,$stamp->getId()) ;
				$c->addDescendingOrderByColumn(StampImagePeer::CREATED_AT) ;
			  	$stampImages = StampImagePeer::doSelect($c) ;
				$imagesString = "" ;
				foreach($stampImages as $stampImage){
					if($imagesString){
						$imagesString .= "," ;
					}
					$imagesString .= $stampImage->getId() . ":" .  $stampImage->getBackPalet();
				}
				// <stamp id="1" u="http://__CLOUD_FRONT_HOST__/stamp/1/1.png" ub="http://__CLOUD_FRONT_HOST__/stamp/" t="Smily" d="description" pro="co.veam..." pri="99" i="1,2,3,4,..." />

				$createdTime = strtotime($stamp->getCreatedAt()) ;
				$currentTime = time() ;
				$elapsedTime = $currentTime - $createdTime ;
				if($elapsedTime > 604800){	// 604800 = 3600*24*7 = 1week
					$isNew = "N" ;
				} else {
					$isNew = "Y" ;
				}
				$contentXml .= sprintf('<stamp id="%s" u="%s" pal="%s" ub="http://__CLOUD_FRONT_HOST__/stamp/" t="%s" d="%s" pro="%s" pri="%s" i="%s" n="%s" />',
					$stamp->getId(),$stamp->getImageUrl(),$stamp->getBackPalet(),$stamp->getName(),$stamp->getDescription(),$stamp->getProduct(),$stamp->getPrice(),$imagesString,$isNew) ;
			}



		  	$c = new Criteria() ;
		  	$c->add(ThemePeer::DEL_FLG,0) ;
		  	$c->add(ThemePeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(ThemePeer::CREATED_AT) ;
		  	$themes = ThemePeer::doSelect($c) ;

			foreach($themes as $theme){
				//  <theme id="1" ub="http://__CLOUD_FRONT_HOST__/theme/" t="Theme A" d="Theme A description." pro="co.veam.veam31000016.theme1" pri="99" top_color="D1BBBBBB" top_t_color="FF222222" top_t_font="GillSans" top_t_size="18.0" images="youtube.png,top_bar_back.png" />
				$createdTime = strtotime($theme->getCreatedAt()) ;
				$currentTime = time() ;
				$elapsedTime = $currentTime - $createdTime ;
				if($elapsedTime > 604800){	// 604800 = 3600*24*7 = 1week
					$isNew = "N" ;
				} else {
					$isNew = "Y" ;
				}
				$contentXml .= sprintf('<theme id="%s" ub="%s" thumb="%s" ss="%s" t="%s" d="%s" pro="%s" pri="%s" top_color="%s" top_t_color="%s" top_t_font="%s" top_t_size="%s" base_t_color="%s" link_t_color="%s" bg_color="%s" post_t_color="%s" s_bar_color="%s" s_bar_style="%d" sp_color="%s" t1_color="%s" t2_color="%s" t3_color="%s" images="%s" n="%s" />',
					$theme->getId(),$theme->getBaseUrl(),$theme->getThumbnailName(),$theme->getScreenshots(),$theme->getTitle(),$theme->getDescription(),$theme->getProduct(),$theme->getPrice(),$theme->getTopColor(),$theme->getTopTextColor(),$theme->getTopTextFont(),$theme->getTopTextSize(),$theme->getBaseTextColor(),$theme->getLinkTextColor(),$theme->getBackgroundColor(),$theme->getPostTextColor(),$theme->getStatusBarColor(),$theme->getStatusBarStyle(),$theme->getSeparatorColor(),$theme->getText1Color(),$theme->getText2Color(),$theme->getText3Color(),$theme->getImages(),$isNew) ;
			}



			if($appId == '31000015'){
				// monthly exclusive video
			  	$c = new Criteria() ;
			  	$c->add(ExtraDataPeer::DEL_FLG,0) ;
			  	$c->add(ExtraDataPeer::APP_ID,$appId) ;
			  	$c->add(ExtraDataPeer::NAME,'monthly_exclusive_video') ;
				$c->addDescendingOrderByColumn(ExtraDataPeer::CREATED_AT) ;
			  	$extraDatas = ExtraDataPeer::doSelect($c) ;

				$currentYearMonth = date('Ym') ;

				if(count($extraDatas) > 0){
					foreach($extraDatas as $extraData){

						$date = $extraData->getData() ;
						$elements = explode("_",$date) ;
						$yearMonth = $elements[0] ;
						$videoId = $elements[1] ;
					  	$video = VideoPeer::retrieveByPk($videoId) ;

						if($video){

							// B app 1.0 のために送信する
							if($currentYearMonth == $yearMonth){
								$contentXml .= sprintf('<downloadable_video id="%d" d="%d" t="%s" i="%s" is="%d" v="%s" vs="%d" vk="%s" />',
									$videoId,$video->getDuration(),$video->getTitle(),$video->getThumbnailUrl(),$video->getThumbnailSize(),$video->getDrmPreviewUrl(),$video->getDrmPreviewSize(),$video->getDrmPreviewKey()) ;
							}

							// B app 1.1移行 のために送信する
							$contentXml .= sprintf('<monthly_video id="%d" d="%d" t="%s" i="%s" is="%d" v="%s" vs="%d" vk="%s" ym="%s"/>',
								$videoId,$video->getDuration(),$video->getTitle(),$video->getThumbnailUrl(),$video->getThumbnailSize(),$video->getDrmPreviewUrl(),$video->getDrmPreviewSize(),$video->getDrmPreviewKey(),$yearMonth) ;
						}
					}
				}

				// calendar name
			  	$c = new Criteria() ;
			  	$c->add(ExtraDataPeer::DEL_FLG,0) ;
			  	$c->add(ExtraDataPeer::APP_ID,$appId) ;
			  	$c->add(ExtraDataPeer::NAME,'calendar_name') ;
				$c->addDescendingOrderByColumn(ExtraDataPeer::CREATED_AT) ;
			  	$extraDatas = ExtraDataPeer::doSelect($c) ;

				if(count($extraDatas) > 0){
					foreach($extraDatas as $extraData){

						$date = $extraData->getData() ;
						$elements = explode("_",$date) ;
						$calendarIndex = $elements[0] ;
						$calendarMonth = $elements[1] ;
						$calendarName = $elements[2] ;

						$contentXml .= sprintf('<calendar_name_%d_%s value="%s" />',$calendarIndex,$calendarMonth,$calendarName) ;
					}
				}

				// それ以外
			  	$c = new Criteria() ;
			  	$c->add(ExtraDataPeer::DEL_FLG,0) ;
			  	$c->add(ExtraDataPeer::APP_ID,$appId) ;
			  	$c->addAnd(ExtraDataPeer::NAME,'monthly_exclusive_video',Criteria::NOT_EQUAL) ;
			  	$c->addAnd(ExtraDataPeer::NAME,'calendar_name',Criteria::NOT_EQUAL) ;
			  	$extraDatas = ExtraDataPeer::doSelect($c) ;

				if(count($extraDatas) > 0){
					foreach($extraDatas as $extraData){
						$contentXml .= sprintf('<%s value="%s" />',$extraData->getName(),$extraData->getData()) ;
					}
				}
			} else if($appId == '31000014'){ // for 
			  	$c = new Criteria();
			  	$c->add(ExtraDataPeer::DEL_FLG,0);
			  	$c->add(ExtraDataPeer::APP_ID,$appId);
			  	$extraDatas = ExtraDataPeer::doSelect($c) ;

				foreach($extraDatas as $extraData){
					$videoId = $extraData->getVideoId() ;
					$name = $extraData->getName() ;
					$data = $extraData->getData() ;
					$data = ConsoleTools::xmlEscape($data) ;
					$contentXml .= sprintf('<v%s_%s value="%s" />',$videoId,$name,$data) ;
				}
			} else { // 31000015 では加工が必要だったが31000015以外ではそのままextraDataを送出
			  	$c = new Criteria() ;
			  	$c->add(ExtraDataPeer::DEL_FLG,0) ;
			  	$c->add(ExtraDataPeer::APP_ID,$appId) ;
			  	$extraDatas = ExtraDataPeer::doSelect($c) ;

				if(count($extraDatas) > 0){
					foreach($extraDatas as $extraData){
						$contentXml .= sprintf('<%s value="%s" />',$extraData->getName(),$extraData->getData()) ;
					}
				}
			}

			if($appId != '31000015'){
				// video
			  	$c = new Criteria();
			  	$c->add(VideoCategoryPeer::DEL_FLG,0) ;
			  	$c->add(VideoCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(VideoCategoryPeer::CREATED_AT) ;
			  	$categories = VideoCategoryPeer::doSelect($c) ;

				foreach($categories as $category){
					$categoryId = $category->getId() ;
					$contentXml .= sprintf('<video_category id="%s" name="%s" />',$categoryId,$category->getName()) ;
				  	$subCategoryCriteria = new Criteria();
				  	$subCategoryCriteria->add(VideoSubCategoryPeer::DEL_FLG,0) ;
				  	$subCategoryCriteria->add(VideoSubCategoryPeer::VIDEO_CATEGORY_ID,$categoryId) ;
					$subCategoryCriteria->addDescendingOrderByColumn(VideoSubCategoryPeer::CREATED_AT) ;
				  	$subCategories = VideoSubCategoryPeer::doSelect($subCategoryCriteria) ;

					foreach($subCategories as $subCategory){
						$subCategoryId = $subCategory->getId() ;
						$contentXml .= sprintf('<video_sub_category id="%s" c="%s" name="%s" />',$subCategoryId,$subCategory->getVideoCategoryId(),$subCategory->getName()) ;
					}
				}


			  	$c = new Criteria();
			  	$c->add(VideoPeer::DEL_FLG,0) ;
			  	$c->add(VideoPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(VideoPeer::CREATED_AT) ;
			  	$videos = VideoPeer::doSelect($c) ;

				foreach($videos as $video){
					$contentXml .= sprintf('<video id="%d" d="%d" t="%s" c="%s" s="%s" i="%s" is="%d" v="%s" vs="%d" vk="%s" l="%s" />',
						$video->getId(),$video->getDuration(),$video->getTitle(),$video->getVideoCategoryId(),$video->getVideoSubCategoryId(),$video->getThumbnailUrl(),$video->getThumbnailSize(),$video->getDrmPreviewUrl(),$video->getDrmPreviewSize(),$video->getDrmPreviewKey(),$video->getShareText()) ;
				}
			}




			// free textline
		  	$c = new Criteria();
		  	$c->add(TextlineCategoryPeer::DEL_FLG,0) ;
		  	$c->add(TextlineCategoryPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(TextlineCategoryPeer::CREATED_AT) ;
		  	$categories = TextlineCategoryPeer::doSelect($c) ;

			foreach($categories as $category){
				$categoryId = $category->getId() ;
				$contentXml .= sprintf('<textline_category id="%s" name="%s" />',$categoryId,$category->getName()) ;
			}

		  	$c = new Criteria();
		  	$c->add(TextlinePeer::DEL_FLG,0) ;
		  	$c->add(TextlinePeer::APP_ID,$appId) ;
		  	$c->add(TextlinePeer::KIND,0) ; // free textline
			$c->addAscendingOrderByColumn(TextlinePeer::CREATED_AT) ;
		  	$textlines = TextlinePeer::doSelect($c) ;

			foreach($textlines as $textline){
				$contentXml .= sprintf('<textline id="%d" ca="0" ti="%s" te="%s" cr="%d" />',
					$textline->getId(),$textline->getTitle(),$textline->getText(),strtotime($textline->getCreatedAt())) ;
			}


			$contentXml .= '<check value="OK" /></list>' ;

			ConsoleTools::setMemcacheValue($contentXmlKey,$contentXml,86400) ;
		}

		return $contentXml ;

	}

	public static function xmlEscape($string){
		$escapedString = $string ;
		$escapedString = str_replace('&',"&amp;",$escapedString) ;
		$escapedString = str_replace('"',"&quot;",$escapedString) ;
		$escapedString = str_replace('<',"&lt;",$escapedString) ;
		$escapedString = str_replace('>',"&gt;",$escapedString) ;
		$escapedString = str_replace("\n","&#xA;",$escapedString) ;
		return $escapedString ;
	}


	public static function getForumKind($forumId){
		if($forumId == 'MYPOST'){
			return 0 ;
		}

		if($forumId == 'LATEST'){
			return 0 ;
		}

		if($forumId == 'FOLLOWINGS'){
			return 0 ;
		}

		if(substr($forumId,0,9) == "USERPOST:") {
			return 0 ;
		}


		if(substr($forumId,0,2) == "f:") {
			return 0 ;
		}

		if($forumId == 0){
			return 2 ; // 
		}


		$forumKindKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_KIND.$forumId ;
		$forumKind = ConsoleTools::getMemcacheValue($forumKindKey) ;
		if(!$forumKind){
			$forum = ForumPeer::retrieveByPk($forumId) ;
			$forumKind = $forum->getKind() ;
			ConsoleTools::setMemcacheValue($forumKindKey,$forumKind,86400) ;
		}
		return $forumKind ;
	}

	public static function getHotForumId($appId){
		// define('MEMCACHE_KEY_HOT_FORUM_ID','HOT_FORUM_ID') ; // + app id
		$hotForumKey = ConsoleTools::getEnvString().MEMCACHE_KEY_HOT_FORUM_ID.$appId ;
		$hotForumId = ConsoleTools::getMemcacheValue($hotForumKey) ;
		if(!$hotForumId){

		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
		  	$c->add(ForumPeer::KIND,2) ;
		  	$forums = ForumPeer::doSelect($c);
			if(count($forums) > 0){
				$forum = $forums[0] ;
				$hotForumId = $forum->getId() ;
				ConsoleTools::setMemcacheValue($hotForumKey,$hotForumId,86400) ;
			}
		}
		return $hotForumId ;
	}

	public static function getForumIds($appId){
		// define('MEMCACHE_KEY_FORUM_IDS','FORUM_IDS') ; // + app id
		$forumIdsKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_IDS.$appId ;
		$forumIdsString = ConsoleTools::getMemcacheValue($forumIdsKey) ;
		if(!$forumIdsString){
			//sfContext::getInstance()->getLogger()->info(sprintf("getForumIds no cache")) ;
		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
		  	$forums = ForumPeer::doSelect($c);
			$forumIdsString = "" ;
			if(count($forums) > 0){
				foreach($forums as $forum){
					if($forumIdsString){
						$forumIdsString .= "," ;
					}
					$forumIdsString .= $forum->getId() ;
				}
				ConsoleTools::setMemcacheValue($forumIdsKey,$forumIdsString,86400) ;
			}
		}
		//sfContext::getInstance()->getLogger()->info(sprintf("getForumIdsString=%s",$forumIdsString)) ;
		return explode(",",$forumIdsString) ;
	}

	public static function getSwatchXml($pictureId){
		$swatchXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_SWATCH_XML.$pictureId ;
		$swatchXml = ConsoleTools::getMemcacheValue($swatchXmlKey) ;
		if(!$swatchXml){
		  	$c = new Criteria();
		  	$c->add(SwatchPeer::DEL_FLAG,0) ;
		  	$c->add(SwatchPeer::PICTURE_ID,$pictureId) ;
		  	$swatches = SwatchPeer::doSelect($c) ;
			if(count($swatches) > 0){
				$swatch = $swatches[0] ;
				$swatchXml = sprintf('<swatch id="%s" pid="%s" url="%s" i1="%s" i2="%s" i3="%s" i4="%s" i5="%s" pn="%s" cn="%s" bn="%s" r="%s" sto="%s" sty="%s" e="%s" />',
								$swatch->getId(),
								$swatch->getPictureId(),
								$swatch->getBaseUrl(),
								$swatch->getImage1(),
								$swatch->getImage2(),
								$swatch->getImage3(),
								$swatch->getImage4(),
								$swatch->getImage5(),
								ConsoleTools::escapeUserName($swatch->getProductName()),
								ConsoleTools::escapeUserName($swatch->getCategory()),
								ConsoleTools::escapeUserName($swatch->getBrand()),
								$swatch->getRating(),
								ConsoleTools::escapeUserName($swatch->getSkinTone()),
								ConsoleTools::escapeUserName($swatch->getSkinType()),
								ConsoleTools::escapeUserName($swatch->getEyeColor())) ;
				ConsoleTools::setMemcacheValue($swatchXmlKey,$swatchXml,86400) ;
			} else {
				ConsoleTools::assert(false,"Swatch not found. pictureId=".$pictureId,__FILE__,__LINE__) ;
			}
		}
		return $swatchXml ;
	}


	public static function getPagedPictureXml($forumId,$socialUserId,$pageNo,$appId = '31000015')
	{

		if($forumId == 'MYPOST'){
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId."_".$socialUserId ;
		} else if($forumId == 'FOLLOWINGS'){
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId."_".$pageNo."_".$socialUserId ;
		} else if($forumId == 'LATEST'){
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId."_".$appId ;
		} else if(substr($forumId,0,9) == "USERPOST:") {
			$elements = explode(':',$forumId) ;
			$targetSocialUserId = $elements[1] ;
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY."MYPOST_".$targetSocialUserId ;
		} else {
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId."_".$pageNo ;
		}
		$maxPageKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_MAX_PAGE.$forumId ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;

		if(!$bodyXml){
			// 無ければDBから値を取って来て設定する

			$isLastPage = 0 ;
		  	$c = new Criteria();
		  	$c->add(PicturePeer::DEL_FLAG,0) ;
			$lastPageNo = 0 ;

			$forumKind = ConsoleTools::getForumKind($forumId) ;

			if($forumKind != 2){
				if($forumId == 'MYPOST'){
				  	$c->add(PicturePeer::SOCIAL_USER_ID,$socialUserId) ;
					$c->addDescendingOrderByColumn(PicturePeer::CREATED_AT) ;
				  	$pictures = PicturePeer::doSelect($c) ;
					$isLastPage = 1 ;
					$lastPageNo = 1 ;
				} else if(substr($forumId,0,9) == "USERPOST:") {
				  	$c->add(PicturePeer::SOCIAL_USER_ID,$targetSocialUserId) ;
					$c->addDescendingOrderByColumn(PicturePeer::CREATED_AT) ;
				  	$pictures = PicturePeer::doSelect($c) ;
					$isLastPage = 1 ;
					$lastPageNo = 1 ;
				} else if($forumId == 'LATEST'){
					$forumIds = ConsoleTools::getForumIds($appId) ;
					$c = new Criteria();
					$c->add(PicturePeer::DEL_FLAG,0) ;
					$c->add(PicturePeer::FORUM_ID,$forumIds,Criteria::IN) ;
					$c->addDescendingOrderByColumn(PicturePeer::CREATED_AT) ;
					$c->setLimit(10) ;
				  	$pictures = PicturePeer::doSelect($c) ;
					$isLastPage = 1 ;
					$lastPageNo = 1 ;
				} else if($forumId == 'FOLLOWINGS') {
					$followingIds = ConsoleTools::getFollowingIds($socialUserId) ;

					$c->add(PicturePeer::SOCIAL_USER_ID,$followingIds,Criteria::IN) ;
					$c->addDescendingOrderByColumn(PicturePeer::CREATED_AT) ;
 					$pager = new sfPropelPager('Picture', 100) ;
					$pager->setCriteria($c) ;
					$pager->setPage($pageNo) ;
					$pager->init() ;
					$lastPageNo = $pager->getLastPage() ;
					if($pageNo <= $lastPageNo){
						$pictures = $pager->getResults() ;
					}

					if($pageNo == $lastPageNo){
						$isLastPage = 1 ;
					}
				} else if(substr($forumId,0,2) == "f:") {
					$ids = explode('_',substr($forumId,2)) ;

					$c->add(PicturePeer::ID,$ids,Criteria::IN) ;
					$c->addDescendingOrderByColumn(PicturePeer::CREATED_AT) ;
 					$pager = new sfPropelPager('Picture', 100) ;
					$pager->setCriteria($c) ;
					$pager->setPage($pageNo) ;
					$pager->init() ;
					$lastPageNo = $pager->getLastPage() ;
					if($pageNo <= $lastPageNo){
						$pictures = $pager->getResults() ;
					}

					if($pageNo == $lastPageNo){
						$isLastPage = 1 ;
					}
				} else {
				  	$c->add(PicturePeer::FORUM_ID,$forumId) ;
					$c->addDescendingOrderByColumn(PicturePeer::CREATED_AT) ;
 					$pager = new sfPropelPager('Picture', 100) ;
					$pager->setCriteria($c) ;
					$pager->setPage($pageNo) ;
					$pager->init() ;
					$lastPageNo = $pager->getLastPage() ;
					if($pageNo <= $lastPageNo){
						$pictures = $pager->getResults() ;
					}

					if($pageNo == $lastPageNo){
						$isLastPage = 1 ;
					}
				}
			} else {

				// 過去24時間でLikeが多い順に10個
				$aDayAgo = date("Y-m-d H:i:s",time()-86400) ;
				sfContext::getInstance()->getLogger()->info(sprintf("aDayAgo=%s",$aDayAgo)) ;
				$c = new Criteria();
				$c->add(PictureLikePeer::DEL_FLAG,0) ;
				$c->add(PictureLikePeer::APP_ID,$appId) ;
				$c->add(PictureLikePeer::CREATED_AT,$aDayAgo,Criteria::GREATER_EQUAL) ;
				$pictureLikes = PictureLikePeer::doSelect($c) ;
				$likeCounts = array() ;
				$listedPictures = array() ;
				foreach($pictureLikes as $pictureLike){
					$likeCounts[$pictureLike->getPictureId()]++ ;
				}
				arsort($likeCounts) ;
				$pictures = array() ;
				$pictureCount = 0 ; 
				foreach($likeCounts as $pictureId => $count){
					sfContext::getInstance()->getLogger()->info(sprintf("hot topic : %d : %d",$pictureId,$count)) ;
					$picture = PicturePeer::retrieveByPk($pictureId) ;
					if($picture){
						if($picture->getDelFlag() == 0){
							$pictures[] = $picture ;
							$listedPictures[$picture->getId()] = 1 ;
							$pictureCount++ ;
							if($pictureCount >= 10){
								break ;
							}
						}
					}
				}

				if($pictureCount < 10){
					/*
					$c = new Criteria();
					$c->add(ForumPeer::DEL_FLAG,0) ;
					$c->add(ForumPeer::APP_ID,$appId) ;
				  	$forums = ForumPeer::doSelect($c) ;
					$forumIds = array() ;
					foreach($forums as $forum){
						$forumIds[] = $forum->getId() ;
					}
					*/
					$forumIds = ConsoleTools::getForumIds($appId) ;

					$c = new Criteria();
					$c->add(PicturePeer::DEL_FLAG,0) ;
					$c->add(PicturePeer::FORUM_ID,$forumIds,Criteria::IN) ;
					$c->addDescendingOrderByColumn(PicturePeer::NUMBER_OF_LIKES) ;
					$c->setLimit(10) ;
				  	$candidatePictures = PicturePeer::doSelect($c) ;
					foreach($candidatePictures as $candidatePicture){
						if($listedPictures[$candidatePicture->getId()] != 1){
							$pictures[] = $candidatePicture ;
							$listedPictures[$candidatePicture->getId()] = 1 ;
							$pictureCount++ ;
							if($pictureCount >= 10){
								break ;
							}
						}
					}
				}

				/*
				$c->addDescendingOrderByColumn(PicturePeer::NUMBER_OF_LIKES) ;
				$c->setLimit(10) ;
			  	$pictures = PicturePeer::doSelect($c) ;
				*/
				$isLastPage = 1 ;
				$lastPageNo = 1 ;
			}

			$socialUserNames = array() ;
			$profileImages = array() ;
			$pictureNums = array() ;
			$forumKinds = array() ;

			$bodyXml = sprintf('<page no="%d" is_last_page="%d" />',$pageNo,$isLastPage) ;
			foreach($pictures as $picture){
				$pictureOwnerUserId = $picture->getSocialUserId() ;
		        $socialUserName = '' ;
				$profileImage = '' ;
				if($socialUserNames[$pictureOwnerUserId]){
					$socialUserName = $socialUserNames[$pictureOwnerUserId] ;
					$profileImage = $profileImages[$pictureOwnerUserId] ;
					$numberOfPictures = $pictureNums[$pictureOwnerUserId] ;
				} else {
					$socialUser = SocialUserPeer::retrieveByPk($pictureOwnerUserId) ;
					if($socialUser){
						$socialUserName = ConsoleTools::escapeUserName($socialUser->getName()) ;
						$socialUserNames[$pictureOwnerUserId] = $socialUserName ;
						$profileImage = $socialUser->getProfileImage() ;
						$profileImages[$pictureOwnerUserId] = $profileImage ;
						$numberOfPictures = $socialUser->getNumberOfPictures() ;
						$pictureNums[$pictureOwnerUserId] = $numberOfPictures ;
					}
				}

				$numberOfLikes = $picture->getNumberOfLikes() ;
				if($numberOfLikes < 0){
					$numberOfLikes = 0 ; 
				}

				$bodyXml .= sprintf('<picture id="%s" url="%s" user_id="%s" user_name="%s" user_icon_url="%s" user_pic_num="%s" is_like="%s" likes="%s" created_at="%s" />',
			        $picture->getId(),
			        $picture->getUrl(),
			        $pictureOwnerUserId,
			        $socialUserName,
					$profileImage,
					$numberOfPictures,
			        '0',
			        $numberOfLikes,
					strtotime($picture->getCreatedAt())
					) ;

				if($forumKinds[$picture->getForumId()]){
					$forumKind = $forumKinds[$picture->getForumId()] ;
				} else {
					$forumKind = ConsoleTools::getForumKind($picture->getForumId()) ;
					$forumKinds[$picture->getForumId()] = $forumKind ;
				}

				if($forumKind == 3){ // swatch
					$bodyXml .= ConsoleTools::getSwatchXml($picture->getId()) ;
				}


			  	$c = new Criteria();
			  	$c->add(PictureCommentPeer::DEL_FLAG,0) ;
			  	$c->add(PictureCommentPeer::PICTURE_ID,$picture->getId()) ;
				$c->addAscendingOrderByColumn(PictureCommentPeer::CREATED_AT) ;
			  	$comments = PictureCommentPeer::doSelect($c) ;
				foreach($comments as $comment){
					$commentOwnerUserId = $comment->getSocialUserId() ;
					if($socialUserNames[$commentOwnerUserId]){
						$socialUserName = $socialUserNames[$commentOwnerUserId] ;
						$profileImage = $profileImages[$commentOwnerUserId] ;
					} else {
						$socialUser = SocialUserPeer::retrieveByPk($commentOwnerUserId) ;
						if($socialUser){
							$socialUserName = ConsoleTools::escapeUserName($socialUser->getName()) ;
							$socialUserNames[$commentOwnerUserId] = $socialUserName ;
							$profileImage = $socialUser->getProfileImage() ;
							$profileImages[$commentOwnerUserId] = $profileImage ;
							$numberOfPictures = $socialUser->getNumberOfPictures() ;
							$pictureNums[$pictureOwnerUserId] = $numberOfPictures ;
						}
					}

					$socialUserName = ConsoleTools::escapeUserName($socialUserName) ;
					$bodyXml .= sprintf('<comment id="%s" picture_id="%s" user_id="%s" user_name="%s" text="%s" />',
				        $comment->getId(),
				        $comment->getPictureId(),
				        $commentOwnerUserId,
				        $socialUserName,
				        $comment->getComment()
						) ;
				}
			}

			if(substr($forumId,0,2) != "f:") { // f: の場合はキャッシュしない
				$duration = 600 ;
				if($forumId == 'FOLLOWINGS'){ // FOLLOWINGS の場合はキャッシュでは実現が複雑になる、かといって毎回DBアクセスだと負担になる。ので60秒間はキャッシュ固定の値を返す。
					$duration = 300 ;
				}
				ConsoleTools::setMemcacheValue($bodyXmlKey,$bodyXml,$duration) ;
				ConsoleTools::setMemcacheValue($maxPageKey,$lastPageNo,$duration) ;
			}
		}

		$likeXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_PICTURE_LIKES.$socialUserId ;
		$likeXml = ConsoleTools::getMemcacheValue($likeXmlKey) ;
		if(!$likeXml){
		  	$c = new Criteria();
		  	$c->add(PictureLikePeer::DEL_FLAG,0) ;
		  	$c->add(PictureLikePeer::SOCIAL_USER_ID,$socialUserId) ;
		  	$pictureLikes = PictureLikePeer::doSelect($c) ;
			if(count($pictureLikes) > 0){
				$likeString = "" ;
				foreach($pictureLikes as $pictureLike){
					if($likeString){
						$likeString .= ',' ;
					}
					$likeString .= $pictureLike->getPictureId() ;
				}
				$likeXml .= sprintf('<picture_like value="%s" />',$likeString) ;
			}
			ConsoleTools::setMemcacheValue($likeXmlKey,$likeXml,600) ;
		}

		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= $likeXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		return $xmlString ;
	}

	public static function escapeUserName($userName){
		$escapedUserName = str_replace('&','&amp;',$userName) ;
		$escapedUserName = str_replace('<','&lt;',$escapedUserName) ;
		$escapedUserName = str_replace('>','&gt;',$escapedUserName) ;
		$escapedUserName = str_replace('"','&quot;',$escapedUserName) ;
		return $escapedUserName ;
	}

	public static function getPictureXml($forumId,$socialUserId)
	{
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;
		if(!$bodyXml){
			// 無ければDBから値を取って来て設定する
			$bodyXml = "" ;

		  	$c = new Criteria();
		  	$c->add(PicturePeer::DEL_FLAG,0) ;
			if($forumId){
			  	$c->add(PicturePeer::FORUM_ID,$forumId) ;
				$c->addDescendingOrderByColumn(PicturePeer::CREATED_AT) ;
			} else {
				$c->addDescendingOrderByColumn(PicturePeer::NUMBER_OF_LIKES) ;
				$c->setLimit(10) ;
			}
		  	$pictures = PicturePeer::doSelect($c) ;

			$socialUserNames = array() ;
			$profileImages = array() ;

			foreach($pictures as $picture){
				$pictureOwnerUserId = $picture->getSocialUserId() ;
				if($socialUserNames[$pictureOwnerUserId]){
					$socialUserName = $socialUserNames[$pictureOwnerUserId] ;
					$profileImage = $profileImages[$pictureOwnerUserId] ;
				} else {
					$socialUser = SocialUserPeer::retrieveByPk($pictureOwnerUserId) ;
					if($socialUser){
						$socialUserName = $socialUser->getName() ;
						$socialUserNames[$pictureOwnerUserId] = $socialUserName ;
						$profileImage = $socialUser->getProfileImage() ;
						$profileImages[$pictureOwnerUserId] = $profileImage ;
					}
				}

				$numberOfLikes = $picture->getNumberOfLikes() ;
				if($numberOfLikes < 0){
					$numberOfLikes = 0 ; 
				}

				$bodyXml .= sprintf('<picture id="%s" url="%s" user_id="%s" user_name="%s" user_icon_url="%s" is_like="%s" likes="%s" created_at="%s" />',
			        $picture->getId(),
			        $picture->getUrl(),
			        $pictureOwnerUserId,
			        $socialUserName,
					$profileImage,
			        '0',
			        $numberOfLikes,
					strtotime($picture->getCreatedAt())
					) ;

			  	$c = new Criteria();
			  	$c->add(PictureCommentPeer::DEL_FLAG,0) ;
			  	$c->add(PictureCommentPeer::PICTURE_ID,$picture->getId()) ;
				$c->addAscendingOrderByColumn(PictureCommentPeer::CREATED_AT) ;
			  	$comments = PictureCommentPeer::doSelect($c) ;
				foreach($comments as $comment){
					$commentOwnerUserId = $comment->getSocialUserId() ;
					if($socialUserNames[$commentOwnerUserId]){
						$socialUserName = $socialUserNames[$commentOwnerUserId] ;
						$profileImage = $profileImages[$commentOwnerUserId] ;
					} else {
						$socialUser = SocialUserPeer::retrieveByPk($commentOwnerUserId) ;
						if($socialUser){
							$socialUserName = $socialUser->getName() ;
							$socialUserNames[$commentOwnerUserId] = $socialUserName ;
							$profileImage = $socialUser->getProfileImage() ;
							$profileImages[$commentOwnerUserId] = $profileImage ;
						}
					}

					$bodyXml .= sprintf('<comment id="%s" picture_id="%s" user_id="%s" user_name="%s" text="%s" />',
				        $comment->getId(),
				        $comment->getPictureId(),
				        $commentOwnerUserId,
				        $socialUserName,
				        $comment->getComment()
						) ;
				}
			}

			ConsoleTools::setMemcacheValue($bodyXmlKey,$bodyXml,600) ;
		}

		$likeXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_PICTURE_LIKES.$socialUserId ;
		$likeXml = ConsoleTools::getMemcacheValue($likeXmlKey) ;
		if(!$likeXml){
		  	$c = new Criteria();
		  	$c->add(PictureLikePeer::DEL_FLAG,0) ;
		  	$c->add(PictureLikePeer::SOCIAL_USER_ID,$socialUserId) ;
		  	$pictureLikes = PictureLikePeer::doSelect($c) ;
			if(count($pictureLikes) > 0){
				$likeString = "" ;
				foreach($pictureLikes as $pictureLike){
					if($likeString){
						$likeString .= ',' ;
					}
					$likeString .= $pictureLike->getPictureId() ;
				}
				$likeXml .= sprintf('<picture_like value="%s" />',$likeString) ;
			}
			ConsoleTools::setMemcacheValue($likeXmlKey,$likeXml,600) ;
		}

		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= $likeXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		return $xmlString ;
	}
















	// $startDate format ''2013-12-17 02:57:33' 
	public static function getProgramsXml($appId,$startDate,$endDate,$transaction)
	{

		$bodyXml = "" ;
		/*
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_PROGRAMS_BODY."_" ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;
		*/

		if(!$bodyXml){
			// 無ければDBから値を取って来て設定する

		  	$c = new Criteria();
		  	$c->add(ProgramPeer::DEL_FLG,0) ;
		  	$c->add(ProgramPeer::APP_ID,$appId) ;
		  	$c->add(ProgramPeer::KIND,0,Criteria::NOT_EQUAL) ;
			$c->addAnd(ProgramPeer::CREATED_AT,$startDate,Criteria::GREATER_EQUAL);          // 2011-05-24 09:24:31
			$c->addAnd(ProgramPeer::CREATED_AT,$endDate,Criteria::LESS_THAN);          // 2011-05-24 09:24:31
			$c->addDescendingOrderByColumn(ProgramPeer::CREATED_AT) ;
		  	$programs = ProgramPeer::doSelect($c) ;

			foreach($programs as $program){
				$bodyXml .= sprintf('<program id="%s" k="%s" a="%s" du="%s" t="%s" de="%s" surl="%s" lurl="%s" durl="%s" dsize="%d" c="%s" />',
					$program->getId(),
					$program->getKind(),
					$program->getAuthor(),
					$program->getDuration(),
					$program->getTitle(),
					$program->getDescription(),
					$program->getSmallImageUrl(),
					$program->getLargeImageUrl(),
					$program->getDataUrl(),
					$program->getDataSize(),
					strtotime($program->getCreatedAt())) ;
			}

			// デフォルトで含めるprogram
		  	$c = new Criteria();
		  	$c->add(ProgramPeer::DEL_FLG,0) ;
		  	$c->add(ProgramPeer::APP_ID,$appId) ;
		  	$c->add(ProgramPeer::KIND,0,Criteria::LESS_EQUAL) ;
			$c->addDescendingOrderByColumn(ProgramPeer::CREATED_AT) ;
		  	$programs = ProgramPeer::doSelect($c) ;

			foreach($programs as $program){
				$bodyXml .= sprintf('<program id="%s" k="%d" a="%s" du="%s" t="%s" de="%s" surl="%s" lurl="%s" durl="%s" dsize="%d" c="%s" />',
					$program->getId(),
					$program->getKind()*-1+1,
					$program->getAuthor(),
					$program->getDuration(),
					$program->getTitle(),
					$program->getDescription(),
					$program->getSmallImageUrl(),
					$program->getLargeImageUrl(),
					$program->getDataUrl(),
					$program->getDataSize(),
					strtotime($startDate)) ;
			}

			// ConsoleTools::setMemcacheValue($bodyXmlKey,$bodyXml,600) ;
		}

		if($transaction){
			//////////// ticket ////////////
			$ticketXml = "" ; // from memcache 		$ticketXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_TICKET_BODY.$transaction ;
			if(!$ticketXml){

				// その人が持っているチケットも含める
			  	$c = new Criteria();
			  	$c->add(TicketPeer::DEL_FLG,0) ;
			  	$c->add(TicketPeer::APP_ID,$appId) ;
			  	$c->add(TicketPeer::TRANSACTION,$transaction) ;
				$c->addDescendingOrderByColumn(TicketPeer::QUALIFIED_AT) ;
			  	$tickets = TicketPeer::doSelect($c) ;
				if(count($tickets) > 0){
					$criteriaTime = strtotime($tickets[0]->getQualifiedAt()) ; // 一番最後に発行したもの
				} else {
					$criteriaTime = strtotime($startDate) ;
				}


/*
////// for test ////
if(count($tickets) == 0){
	
	// テスト用に一つ追加
	$ticket = new Ticket() ;
	$ticket->setAppId($appId) ;
	$ticket->setTransaction($transaction) ;
	$ticket->setKind(1) ;
	$ticket->setTitle("Meet&Greet") ;
	$ticket->setDescription("") ;
	$ticket->setImageUrl("") ;
	$ticket->setUsedImageUrl("") ;
	$ticket->setCode("") ;
	$ticket->setQualifiedAt(date('Y-m-d H:i:s')) ;
	$ticket->save() ;

	// その人が持っているチケットも含める
  	$c = new Criteria();
  	$c->add(TicketPeer::DEL_FLG,0) ;
  	$c->add(TicketPeer::APP_ID,$appId) ;
  	$c->add(TicketPeer::TRANSACTION,$transaction) ;
	$c->addDescendingOrderByColumn(TicketPeer::QUALIFIED_AT) ;
  	$tickets = TicketPeer::doSelect($c) ;
	if(count($tickets) > 0){
		$criteriaTime = strtotime($tickets[0]->getQualifiedAt()) ; // 一番最後に発行したもの
	} else {
		$criteriaTime = strtotime($startDate) ;
	}

}
////////////////////
*/


				$currentTime = time() ;
				$diff = $currentTime - $criteriaTime ;
				$span = 15552000 ; // 180days in second
				$addFlag = 0 ;
				while($diff > $span){ 
					$criteriaTime += $span ;
					$ticket = new Ticket() ;
					$ticket->setAppId($appId) ;
					$ticket->setTransaction($transaction) ;
					$ticket->setKind(1) ;
					$ticket->setTitle("Meet&Greet") ;
					$ticket->setDescription("") ;
					$ticket->setImageUrl("") ;
					$ticket->setUsedImageUrl("") ;
					$ticket->setCode("") ;
					$ticket->setQualifiedAt(date('Y-m-d H:i:s',$criteriaTime)) ;
					$ticket->save() ;
					$diff = $currentTime - $criteriaTime ;
					$addFlag = 1 ;
				}
				if($addFlag){
				  	$c = new Criteria();
				  	$c->add(TicketPeer::DEL_FLG,0) ;
				  	$c->add(TicketPeer::APP_ID,$appId) ;
				  	$c->add(TicketPeer::TRANSACTION,$transaction) ;
					$c->addDescendingOrderByColumn(TicketPeer::QUALIFIED_AT) ;
				  	$tickets = TicketPeer::doSelect($c) ;
				}

				foreach($tickets as $ticket){
					$ticketXml .= sprintf('<program id="t%s" k="3" a="" du="0" t="%s" de="%s" surl="" lurl="" durl="" dsize="0" c="%s" />',
						$ticket->getId(),
						$ticket->getKind(),
						$ticket->getUsed(),
						strtotime($ticket->getQualifiedAt())) ;
				}
				// ConsoleTools::setMemcacheValue($ticketXmlKey,$ticketXml,86400) ;
			}

			///////////////////////////
			$bodyXml .= $ticketXml ;
		}


		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		sfContext::getInstance()->getLogger()->info(sprintf("start=%s end=%s result=%s",$startDate,$endDate,$xmlString)) ;

		return $xmlString ;
	}


	public static function getProgramXml($programId,$socialUserId,$appId)
	{

		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_PROGRAM_BODY.$programId ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;

		if(!$bodyXml){
			// 無ければDBから値を取って来て設定する
			$socialUserNames = array() ;

		  	$c = new Criteria();
		  	$c->add(ProgramLikePeer::DEL_FLAG,0) ;
		  	$c->add(ProgramLikePeer::PROGRAM_ID,$programId) ;
		  	$numberOfLikes = ProgramLikePeer::doCount($c) ;

			$bodyXml .= sprintf('<program id="%s" like="%d" />',$programId,$numberOfLikes) ;

		  	$c = new Criteria();
		  	$c->add(ProgramCommentPeer::DEL_FLAG,0) ;
		  	$c->add(ProgramCommentPeer::PROGRAM_ID,$programId) ;
			$c->addAscendingOrderByColumn(ProgramCommentPeer::CREATED_AT) ;
		  	$comments = ProgramCommentPeer::doSelect($c) ;
			foreach($comments as $comment){
				$commentOwnerUserId = $comment->getSocialUserId() ;
				if($socialUserNames[$commentOwnerUserId]){
					$socialUserName = $socialUserNames[$commentOwnerUserId] ;
				} else {
					$socialUser = SocialUserPeer::retrieveByPk($commentOwnerUserId) ;
					if($socialUser){
						$socialUserName = ConsoleTools::escapeUserName($socialUser->getName()) ;
						$socialUserNames[$commentOwnerUserId] = $socialUserName ;
					}
				}

				$socialUserName = ConsoleTools::escapeUserName($socialUserName) ;
				$bodyXml .= sprintf('<comment id="%s" user_id="%s" user_name="%s" text="%s" />',
			        $comment->getId(),
			        $commentOwnerUserId,
			        $socialUserName,
			        $comment->getComment()
					) ;
			}
		}

		ConsoleTools::setMemcacheValue($bodyXmlKey,$bodyXml,86400) ;

		$likeXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_PROGRAM_LIKES.$socialUserId ;
		$likeXml = ConsoleTools::getMemcacheValue($likeXmlKey) ;
		if(!$likeXml){
		  	$c = new Criteria();
		  	$c->add(ProgramLikePeer::DEL_FLAG,0) ;
		  	$c->add(ProgramLikePeer::SOCIAL_USER_ID,$socialUserId) ;
		  	$programLikes = ProgramLikePeer::doSelect($c) ;
			if(count($programLikes) > 0){
				$likeString = "" ;
				foreach($programLikes as $programLike){
					if($likeString){
						$likeString .= ',' ;
					}
					$likeString .= $programLike->getProgramId() ;
				}
				$likeXml .= sprintf('<program_like value="%s" />',$likeString) ;
			}
			ConsoleTools::setMemcacheValue($likeXmlKey,$likeXml,86400) ;
		}

		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= $likeXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		return $xmlString ;
	}



	public static function clearConsoleContentCache($env,$appId)
	{
		$contentXmlKey = $env.MEMCACHE_KEY_CONSOLE_CONTENT_XML.$appId ;
		ConsoleTools::deleteMemcacheValue($contentXmlKey) ;

		$contentXmlKey = $env.MEMCACHE_KEY_CONTENT_XML.$appId ;
		ConsoleTools::deleteMemcacheValue($contentXmlKey) ;

		$key = $env.API2_KEY_CONTENT_ID.$appId ;
		ConsoleTools::deleteMemcacheValue($key) ;

		$key = $env.API2_KEY_CONTENT_XML.$appId ;
		ConsoleTools::deleteMemcacheValue($key) ;
	}

	public static function consoleContentsChanged($appId)
	{

		$env = ConsoleTools::getEnvString() ;
		ConsoleTools::clearConsoleContentCache($env,$appId) ;

		if($env == 'public'){
			ConsoleTools::clearConsoleContentCache('preview',$appId) ;
		}
	}



	public static function programChanged($programId)
	{
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_PROGRAM_BODY.$programId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
	}

	public static function programLikeChanged($socialUserId)
	{
		$likeXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_PROGRAM_LIKES.$socialUserId ;
		ConsoleTools::deleteMemcacheValue($likeXmlKey) ;
	}

	public static function ticketChanged($transaction)
	{
		$ticketXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_TICKET_BODY.$transaction ;
		ConsoleTools::deleteMemcacheValue($ticketXmlKey) ;
	}














	// $startDate format ''2013-12-17 02:57:33' 
	public static function getTextlinesXml($appId,$startDate,$endDate,$transaction)
	{

		$bodyXml = "" ;
		/*
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_PROGRAMS_BODY."_" ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;
		*/

		if(!$bodyXml){
			// 無ければDBから値を取って来て設定する

			// デフォルトで含めるtextline
		  	$c = new Criteria();
		  	$c->add(TextlinePeer::DEL_FLG,0) ;
		  	$c->add(TextlinePeer::APP_ID,$appId) ;
		  	$c->add(TextlinePeer::TEXTLINE_CATEGORY_ID,0,Criteria::LESS_THAN) ;
			$c->addAscendingOrderByColumn(TextlinePeer::CREATED_AT) ;
		  	$defaultTextlines = TextlinePeer::doSelect($c) ;

			foreach($defaultTextlines as $textline){
				$textline->setCreatedAt($startDate) ;
				$textline->setTextlineCategoryId(abs($textline->getTextlineCategoryId())) ;
				/*
				$bodyXml .= sprintf('<textline id="%d" ca="%s" ti="%s" te="%s" cr="%d" />',
					$textline->getId(),abs($textline->getTextlineCategoryId()),$textline->getTitle(),$textline->getText(),strtotime($startDate)) ;
				*/
			}

		  	$c = new Criteria();
		  	$c->add(TextlinePeer::DEL_FLG,0) ;
		  	$c->add(TextlinePeer::APP_ID,$appId) ;
		  	$c->add(TextlinePeer::TEXTLINE_CATEGORY_ID,0,Criteria::GREATER_THAN) ;

			// フリーのモノまたは期間内のモノ
			$c1 = $c->getNewCriterion(TextlinePeer::KIND,0) ;
			$c2 = $c->getNewCriterion(TextlinePeer::CREATED_AT,$startDate,Criteria::GREATER_EQUAL);          // 2011-05-24 09:24:31
			$c3 = $c->getNewCriterion(TextlinePeer::CREATED_AT,$endDate,Criteria::LESS_THAN);          // 2011-05-24 09:24:31
			$c2->addAnd($c3) ;
			$c1->addOr($c2) ;
			$c->add($c1) ;

			$c->addAscendingOrderByColumn(TextlinePeer::CREATED_AT) ;
		  	$textlines = TextlinePeer::doSelect($c) ;

			$textlines = array_merge($defaultTextlines,$textlines) ;
			usort( $textlines , "textlineCompare" );

			foreach($textlines as $textline){
				$time = strtotime($textline->getCreatedAt()) ;
				$bodyXml .= sprintf('<textline id="%d" ca="%s" ti="%s" te="%s" cr="%d" />',
					$textline->getId(),$textline->getTextlineCategoryId(),$textline->getTitle(),$textline->getText(),$time) ;
			}
		}


		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		sfContext::getInstance()->getLogger()->info(sprintf("start=%s end=%s result=%s",$startDate,$endDate,$xmlString)) ;

		return $xmlString ;
	}


















	public static function isValidRequest($string,$signature)
	{
		$valid = false ;
		$sha1 = strtolower(sha1($string)) ;
		$lowerSignature = strtolower($signature) ;
		if($sha1 == $lowerSignature){
			$valid = true ;
		} else {
			// iOS版不具合への救済
			$multiByteLen = mb_strlen($string,'utf-8') ;
			if($multiByteLen > 0){
				$shortString = substr($string,0,$multiByteLen) ;
				$sha1 = strtolower(sha1($shortString)) ;
				if($sha1 == $lowerSignature){
					$valid = true ;
				}
			}
		}
		return $valid ;
	}

	public static function getYoutubeVideoXml($youtubeVideoId,$socialUserId,$appId)
	{

		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_YOUTUBE_VIDEO_BODY.$youtubeVideoId ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;

		if(!$bodyXml){
			// 無ければDBから値を取って来て設定する
			$socialUserNames = array() ;

		  	$c = new Criteria();
		  	$c->add(YoutubeLikePeer::DEL_FLAG,0) ;
		  	$c->add(YoutubeLikePeer::YOUTUBE_VIDEO_ID,$youtubeVideoId) ;
		  	$numberOfLikes = YoutubeLikePeer::doCount($c) ;

			$bodyXml .= sprintf('<youtube id="%s" like="%d" />',$youtubeVideoId,$numberOfLikes) ;

		  	$c = new Criteria();
		  	$c->add(YoutubeCommentPeer::DEL_FLAG,0) ;
		  	$c->add(YoutubeCommentPeer::YOUTUBE_VIDEO_ID,$youtubeVideoId) ;
			$c->addAscendingOrderByColumn(YoutubeCommentPeer::CREATED_AT) ;
		  	$comments = YoutubeCommentPeer::doSelect($c) ;
			foreach($comments as $comment){
				$commentOwnerUserId = $comment->getSocialUserId() ;
				if($socialUserNames[$commentOwnerUserId]){
					$socialUserName = $socialUserNames[$commentOwnerUserId] ;
				} else {
					$socialUser = SocialUserPeer::retrieveByPk($commentOwnerUserId) ;
					if($socialUser){
						$socialUserName = ConsoleTools::escapeUserName($socialUser->getName()) ;
						$socialUserNames[$commentOwnerUserId] = $socialUserName ;
					}
				}

				$socialUserName = ConsoleTools::escapeUserName($socialUserName) ;
				$bodyXml .= sprintf('<comment id="%s" user_id="%s" user_name="%s" text="%s" />',
			        $comment->getId(),
			        $commentOwnerUserId,
			        $socialUserName,
			        $comment->getComment()
					) ;
			}
		}

		ConsoleTools::setMemcacheValue($bodyXmlKey,$bodyXml,86400) ;

		$likeXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_YOUTUBE_LIKES.$socialUserId ;
		$likeXml = ConsoleTools::getMemcacheValue($likeXmlKey) ;
		if(!$likeXml){
		  	$c = new Criteria();
		  	$c->add(YoutubeLikePeer::DEL_FLAG,0) ;
		  	$c->add(YoutubeLikePeer::SOCIAL_USER_ID,$socialUserId) ;
		  	$youtubeLikes = YoutubeLikePeer::doSelect($c) ;
			if(count($youtubeLikes) > 0){
				$likeString = "" ;
				foreach($youtubeLikes as $youtubeLike){
					if($likeString){
						$likeString .= ',' ;
					}
					$likeString .= $youtubeLike->getYoutubeVideoId() ;
				}
				$likeXml .= sprintf('<youtube_like value="%s" />',$likeString) ;
			}
			ConsoleTools::setMemcacheValue($likeXmlKey,$likeXml,86400) ;
		}

		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= $likeXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		return $xmlString ;
	}

	public static function youtubeVideoChanged($youtubeVideoId)
	{
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_YOUTUBE_VIDEO_BODY.$youtubeVideoId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
	}














	public static function getPagedFollowXml($followKind,$socialUserId,$pageNo,$appId)
	{

		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FOLLOW_BODY.$followKind."_".$pageNo."_".$socialUserId ;
		$maxPageKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FOLLOW_MAX_PAGE.$followKind."_".$socialUserId ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;

		if(!$bodyXml){
			// 無ければDBから値を取って来て設定する

			$isLastPage = 0 ;
			$lastPageNo = 0 ;

		  	$c = new Criteria();
		  	$c->add(SocialFollowPeer::DEL_FLG,0) ;
			if($followKind == 1){
			  	$c->add(SocialFollowPeer::FROM_USER,$socialUserId) ;
			} else {
			  	$c->add(SocialFollowPeer::TO_USER,$socialUserId) ;
			}
			$c->addDescendingOrderByColumn(SocialFollowPeer::CREATED_AT) ;

			$pager = new sfPropelPager('SocialFollow', 100) ;
			$pager->setCriteria($c) ;
			$pager->setPage($pageNo) ;
			$pager->init() ;
			$lastPageNo = $pager->getLastPage() ;
			if($pageNo <= $lastPageNo){
				$socialFollows = $pager->getResults() ;
			}

			if($pageNo == $lastPageNo){
				$isLastPage = 1 ;
			}


			$bodyXml = sprintf('<page no="%d" is_last_page="%d" />',$pageNo,$isLastPage) ;


			$followUserIds = array() ;
			foreach($socialFollows as $socialFollow){
				if($followKind == 1){
					$followUserIds[] = $socialFollow->getToUser() ;
				} else {
					$followUserIds[] = $socialFollow->getFromUser() ;
				}
			}


		  	$c = new Criteria();
		  	$c->add(SocialUserPeer::DEL_FLG,0) ;
			$c->add(SocialUserPeer::ID,$followUserIds,Criteria::IN) ;
			//$c->addOrderByField(SocialUserPeer::ID,$followUserIds) ;
			$socialUsers = SocialUserPeer::doSelect($c) ;

			$socialUserMap = array() ;
			foreach($socialUsers as $socialUser){
				$socialUserMap[$socialUser->getId()] = $socialUser ;
			}

			foreach($followUserIds as $followUserId){
				$socialUser = $socialUserMap[$followUserId] ;
				if($socialUser){
					$bodyXml .= sprintf('<user id="%s" u="%s" n="%s" />',
				        $socialUser->getId(),
				        ConsoleTools::xmlEscape($socialUser->getProfileImage()),
				        ConsoleTools::xmlEscape($socialUser->getName())
						) ;
				}
			}

			ConsoleTools::setMemcacheValue($bodyXmlKey,$bodyXml,86400) ;
			ConsoleTools::setMemcacheValue($maxPageKey,$lastPageNo,86400) ;
		}


		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		return $xmlString ;
	}















	public static function getProfileXml($targetUserId,$myUserId,$appId)
	{

		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_PROFILE_BODY.$targetUserId ;
		$bodyXml = ConsoleTools::getMemcacheValue($bodyXmlKey) ;

		if(!$bodyXml){
			$socialUser = SocialUserPeer::retrieveByPk($targetUserId) ;
			if($socialUser){
			  	$c = new Criteria();
			  	$c->add(SocialFollowPeer::TO_USER,$targetUserId) ;
			  	$c->add(SocialFollowPeer::DEL_FLG,0) ;
			  	$numberOfFollowers = SocialFollowPeer::doCount($c) ;

			  	$c = new Criteria();
			  	$c->add(SocialFollowPeer::FROM_USER,$targetUserId) ;
			  	$c->add(SocialFollowPeer::DEL_FLG,0) ;
			  	$numberOfFollowings = SocialFollowPeer::doCount($c) ;

			  	$c = new Criteria();
			  	$c->add(PicturePeer::SOCIAL_USER_ID,$targetUserId) ;
			  	$c->add(PicturePeer::DEL_FLAG,0) ;
			  	$numberOfPosts = PicturePeer::doCount($c) ;

				$profileImage = $socialUser->getProfileImage() ;
				if(preg_match('/(http:\/\/graph\.facebook\.com\/.+\/picture\?)type=square/',$profileImage,$matches)){
					$profileImage = $matches[1] . 'width=160&height=160' ;
				}

				$bodyXml = sprintf('<profile id="%s" n="%s" d="%s" u="%s" p="%d" fers="%d" fing="%d" />',
					$targetUserId,ConsoleTools::xmlEscape($socialUser->getName()),ConsoleTools::xmlEscape($socialUser->getDescription()),ConsoleTools::xmlEscape($profileImage),$numberOfPosts,$numberOfFollowers,$numberOfFollowings) ;

			}
			ConsoleTools::setMemcacheValue($bodyXmlKey,$bodyXml,86400) ;
		}

		// 自分がフォローしているユーザ一覧  // -1,123,456,789
		$followingIds = ConsoleTools::getFollowingIds($myUserId) ;
		if(in_array($targetUserId,$followingIds)){
			$followingXml = '<following value="1" />' ;
		} else {
			$followingXml = '<following value="0" />' ;
		}


		$xmlString = sprintf('<?xml version="1.0" encoding="UTF-8"?><list>') ;
		$xmlString .= $bodyXml ;
		$xmlString .= $followingXml ;
		$xmlString .= '<check value="OK" /></list>' ;

		return $xmlString ;
	}

	public static function getFollowingIds($socialUserId)
	{
		// 自分がフォローしているユーザ一覧  // "-1,123,456,789"
		$followingsKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_FOLLOWINGS.$socialUserId ;
		$followings = ConsoleTools::getMemcacheValue($followingsKey) ;
		if(!$followings){
		  	$c = new Criteria();
		  	$c->add(SocialFollowPeer::DEL_FLG,0) ;
		  	$c->add(SocialFollowPeer::FROM_USER,$socialUserId) ;
		  	$socialFollows = SocialFollowPeer::doSelect($c) ;
			$followings = "-1" ;
			if(count($socialFollows) > 0){
				foreach($socialFollows as $socialFollow){
					$followings .= ",".$socialFollow->getToUser() ;
				}
			}
			ConsoleTools::setMemcacheValue($followingsKey,$followings,86400) ;
		}

		$followingIds = explode(',',$followings) ;
		return $followingIds ;
	}

	// ・description を変更したとき
	// ・この人がPOSTしたとき
	// ・この人がFollowしたとき、解除したとき
	// ・この人がFollowされたとき、解除されたとき
	// に呼ぶ
	public static function profileChanged($socialUserId)
	{
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_PROFILE_BODY.$socialUserId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
	}

	// ・この人がFollowしたとき、解除したとき
	public static function followingChanged($targetSocialUserId,$mySocialUserId)
	{
		$followingsKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_FOLLOWINGS.$mySocialUserId ;
		ConsoleTools::deleteMemcacheValue($followingsKey) ;

		$maxPageKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FOLLOW_MAX_PAGE."1_".$mySocialUserId ; // FOLLOWING
		$maxPageNo = ConsoleTools::getMemcacheValue($maxPageKey) ;
		if($maxPageNo < 1){
			$maxPageNo = 1 ;
		}
		for($pageNo = 1 ; $pageNo <= $maxPageNo ; $pageNo++){
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FOLLOW_BODY."1_".$pageNo."_".$mySocialUserId ;
			ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
		}

		$maxPageKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FOLLOW_MAX_PAGE."2_".$targetSocialUserId ; // FOLLOWERS
		$maxPageNo = ConsoleTools::getMemcacheValue($maxPageKey) ;
		if($maxPageNo < 1){
			$maxPageNo = 1 ;
		}
		for($pageNo = 1 ; $pageNo <= $maxPageNo ; $pageNo++){
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FOLLOW_BODY."2_".$pageNo."_".$targetSocialUserId ;
			ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
		}

		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY."FOLLOWINGS_1_".$mySocialUserId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;

	}









	public static function registerUserAdId($appId,$socialUserId,$adId)
	{
		if($socialUserId && $adId){
			$userAdIdKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_ADID.$socialUserId."_".$adId ;
			$registered = ConsoleTools::getMemcacheValue($userAdIdKey) ;
			if(!$registered){
			  	$c = new Criteria() ;
			  	$c->add(UserAdidPeer::DEL_FLG,0) ;
			  	$c->add(UserAdidPeer::SOCIAL_USER_ID,$socialUserId) ;
			  	$c->add(UserAdidPeer::ADID,$adId) ;
				$userAdid = UserAdidPeer::doSelectOne($c) ;
				if(!$userAdid){
					$userAdid = new UserAdid() ;
					$userAdid->setAppId($appId) ;
					$userAdid->setSocialUserId($socialUserId) ;
					$userAdid->setAdid($adId) ;
					$userAdid->save() ;
				}
				ConsoleTools::setMemcacheValue($userAdIdKey,'1',8640000) ; // 100 days
			}
		}
	}















	public static function pictureLikeChanged($socialUserId)
	{
		$likeXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_PICTURE_LIKES.$socialUserId ;
		ConsoleTools::deleteMemcacheValue($likeXmlKey) ;
	}

	public static function youtubeLikeChanged($socialUserId)
	{
		$likeXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_USER_YOUTUBE_LIKES.$socialUserId ;
		ConsoleTools::deleteMemcacheValue($likeXmlKey) ;
	}

	public static function forumChanged($forumId,$appId='31000015')
	{
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;

		$maxPageKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_MAX_PAGE.$forumId ;
		$maxPageNo = ConsoleTools::getMemcacheValue($maxPageKey) ;
		if($maxPageNo < 1){
			$maxPageNo = 1 ;
		}
		for($pageNo = 1 ; $pageNo <= $maxPageNo ; $pageNo++){
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId."_".$pageNo ;
			ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
		}


		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_MESSAGE_BODY.$forumId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;

		$maxPageKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_MESSAGE_MAX_PAGE.$forumId ;
		$maxPageNo = ConsoleTools::getMemcacheValue($maxPageKey) ;
		if($maxPageNo < 1){
			$maxPageNo = 1 ;
		}
		for($pageNo = 1 ; $pageNo <= $maxPageNo ; $pageNo++){
			$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_MESSAGE_BODY.$forumId."_".$pageNo ;
			ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
		}




		if($appId == '31000015'){
			$hotForumId = '0' ;
		} else {
			$hotForumId = ConsoleTools::getHotForumId($appId) ;
		}
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$hotForumId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;

		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$hotForumId.'_1' ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;

		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY."LATEST_".$appId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
	}

	public static function someonesPostChanged($socialUserId)
	{
		$forumId = 'MYPOST' ;
		$bodyXmlKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_PICTURE_BODY.$forumId."_".$socialUserId ;
		ConsoleTools::deleteMemcacheValue($bodyXmlKey) ;
	}

	public static function blockedUserChanged($appId)
	{
		$blockedUsersKey = ConsoleTools::getEnvString().MEMCACHE_KEY_BLOCKED_USERS.$appId ;
		ConsoleTools::deleteMemcacheValue($blockedUsersKey) ;
	}


	public static function getUploadedDirFrom($appId)
	{
		$appDir = "" ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$appDir = $app->getUploadedDir() ;
		}
		return $appDir ;
	}

	public static function getUploadedDirFromListAppId($appId)
	{
		$appDir = "" ;
		$app = ListAppPeer::retrieveByPk($appId) ;
		if($app){
			$appDir = $app->getUploadedDir() ;
		}
		return $appDir ;
	}

	public static function getGeneratedDirFromListAppId($appId)
	{
		$appDir = "" ;
		$app = ListAppPeer::retrieveByPk($appId) ;
		if($app){
			$appDir = $app->getGeneratedDir() ;
		}
		return $appDir ;
	}

	public static function getGeneratedDirFrom($appId)
	{
		$appDir = "" ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$appDir = $app->getGeneratedDir() ;
		}
		return $appDir ;
	}

	public static function getEnvString()
	{

		$hostName = $_SERVER['SERVER_NAME'] ;

		if(preg_match('/work\./',$hostName)){
			return 'work' ;
		} else if(preg_match('/preview\./',$hostName)){
			return 'preview' ;
		} 
		
		return 'public' ;
	}

	public static function getMarketUrl($appId)
	{
		$marketUrl = sprintf("http://market.android.com/details?id=co.veam.AndroidMAGIC_%08d",$appId) ;
		return ConsoleTools::createShortUrl($marketUrl) ;
	}

	// bitly の shortenerを使ってURLを短くする
	public static function createBitlyUrl($longUrl){
		$escapedLongUrl = htmlspecialchars(strip_tags(trim($longUrl)));
        $encodedLongUrl = urlencode($escapedLongUrl);
        $login = 'veam';
        $api_key = '__BITLY_API_KEY__';
        $format = 'json';
        $data = file_get_contents('http://api.bitly.com/v3/shorten?login='.$login.'&apiKey='.$api_key.'&longUrl='.$encodedLongUrl.'&format='.$format);
		$result = json_decode($data); // 返り値はJSONなのでデコード
		return $result->data->url ;
    }

	// google の shortenerを使ってURLを短くする
	public static function createShortUrl($longUrl)
	{

		// ログインしてから短くしないと、アカウントにひもづかない
		$api_url = "https://www.googleapis.com/urlshortener/v1/url";
		$api_key = "__GOOGLE_API_KEY__";

		$params = array(
		      'accountType' => 'HOSTED_OR_GOOGLE',
		      'Email'       => 'android@veam.co',
		      'Passwd'      => '__PASSWORD__',
		      'service'     => 'urlshortener',
		      'source'      => 'android.veam.co' // Application's name, e.g. companyName-applicationName-versionID
		) ;

		$curl = curl_init();
		$curl_params = array(
		    CURLOPT_URL => 'https://www.google.com/accounts/ClientLogin',
		    CURLOPT_POST => true,
		    CURLOPT_POSTFIELDS => $params,
		    CURLOPT_RETURNTRANSFER => true
		);
		curl_setopt_array( $curl, $curl_params );
		$result = curl_exec( $curl ) ; 


		preg_match('/Auth=(.+)/', $result, $matches);
		$auth = $matches[1];

		$curl = curl_init();
		$curl_params = array(
		    CURLOPT_URL => $api_url . "?" . http_build_query( array( "key" => $api_key) ),
		    CURLOPT_HTTPHEADER => array("Content-Type: application/json",'Authorization: GoogleLogin auth=' . $auth),
		    CURLOPT_POST => true,
		    CURLOPT_POSTFIELDS => ConsoleTools::json_encode( array( "longUrl" => $longUrl)),
		    CURLOPT_RETURNTRANSFER => true
		);
		curl_setopt_array( $curl, $curl_params );
		$result = ConsoleTools::json_decode( curl_exec( $curl ) ); // 返り値はJSONなのでデコード

		return $result->id ;
	}

	// android subscription の有効期間を取得する
	public static function getSubscriptionInfo($appId,$productId,$purchaseToken)
	{
		$accessToken = ConsoleTools::getMemcacheValue(GOOGLE_ACCESS_TOKEN) ;
		if(!$accessToken){
			sfContext::getInstance()->getLogger()->info("no cached google access token") ;
			$params = array(
				'grant_type' => 'refresh_token',
				'client_id'=>'__GOOGLE_CLIENT_ID__',
				'client_secret'=>'__GOOGLE_CLIENT_SECRET__',
				'refresh_token'=>'__REFRESH_TOKEN__'
			) ;

			$curl = curl_init();
			$curl_params = array(
			    CURLOPT_URL => 'https://accounts.google.com/o/oauth2/token',
			    CURLOPT_POST => true,
			    CURLOPT_POSTFIELDS => $params,
			    CURLOPT_RETURNTRANSFER => true
			);

			curl_setopt_array( $curl, $curl_params );
			$result = curl_exec( $curl ) ;

			// sfContext::getInstance()->getLogger()->info(sprintf("OAuth result : %s",$result)) ;

			$json = json_decode($result) ;
			$accessToken = $json->access_token ;
			$json->expires_in ;
			
			if($accessToken){
				ConsoleTools::setMemcacheValue(GOOGLE_ACCESS_TOKEN,$accessToken,$json->expires_in) ;
			}
		}

		$subscriptionInfo = "" ;
		if($accessToken){
			// https://www.googleapis.com/androidpublisher/v1.1/applications/co.veam.veam31000015/subscriptions/co.veam.veam31000015.calendar.1m/purchases/
			$api_url = sprintf("https://www.googleapis.com/androidpublisher/v1.1/applications/co.veam.veam%s/subscriptions/%s/purchases/%s?access_token=%s",$appId,$productId,$purchaseToken,$accessToken) ;
			$result = file_get_contents($api_url) ;
			// sfContext::getInstance()->getLogger()->info(sprintf("Subscription result : %s",$result)) ;
			if($result){
				$subscriptionInfo = json_decode($result) ; // 返り値はJSONなのでデコード
				/*
				{
				  "kind": "androidpublisher#subscriptionPurchase",
				  "initiationTimestampMsec": long,
				  "validUntilTimestampMsec": long,
				  "autoRenewing": boolean
				}
				*/
			}
		}

		return $subscriptionInfo ;
	}


	// google の shortenerを使ったURLの情報を取得する
	public static function listShortUrl()
	{

		// ログインしてから短くしないと、アカウントにひもづかない
		//$api_url = "https://www.googleapis.com/urlshortener/v1/url";
//		$api_url = "https://www.googleapis.com/urlshortener/v1/url/history?key=__GOOGLE_API_KEY__&start-token=" . {startToken?} . "&projection=" . {projection?} ;
		$api_key = "__GOOGLE_API_KEY__";

		$params = array(
		      'accountType' => 'HOSTED_OR_GOOGLE',
		      'Email'       => 'android@veam.co',
		      'Passwd'      => '__PASSWORD__',
		      'service'     => 'urlshortener',
		      'source'      => 'android.exemagic.com' // Application's name, e.g. companyName-applicationName-versionID
		) ;

		$curl = curl_init();
		$curl_params = array(
		    CURLOPT_URL => 'https://www.google.com/accounts/ClientLogin',
		    CURLOPT_POST => true,
		    CURLOPT_POSTFIELDS => $params,
		    CURLOPT_RETURNTRANSFER => true
		);
		curl_setopt_array( $curl, $curl_params );
		$result = curl_exec( $curl ) ; 

		preg_match('/Auth=(.+)/', $result, $matches);
		$auth = $matches[1];

		$stillRemain = true ;
		$items = array() ;
		$startToken = "" ;
		while($stillRemain){




			if($startToken == ""){
				$api_url = "https://www.googleapis.com/urlshortener/v1/url/history?key=__GOOGLE_API_KEY__&projection=FULL" ;
			} else {
				$api_url = "https://www.googleapis.com/urlshortener/v1/url/history?key=__GOOGLE_API_KEY__&projection=FULL&start-token=" . urlencode($startToken) ;
			}

			$curl = curl_init();
			$curl_params = array(
			    CURLOPT_URL => $api_url ,
			    CURLOPT_HTTPHEADER => array("Content-Type: application/json",'Authorization: GoogleLogin auth=' . $auth),
			    CURLOPT_RETURNTRANSFER => true
			);
			curl_setopt_array( $curl, $curl_params );
			$result = ConsoleTools::json_decode( curl_exec( $curl ) ); // 返り値はJSONなのでデコード

			if(isset($result->nextPageToken)){
				$startToken = $result->nextPageToken ;
			} else {
				$stillRemain = false ;
			}

			$items = array_merge($items, $result->items);
		}

		return $items ;
	}

    private static function json_decode($content, $assoc=false)
	{
		require_once 'JSON.php';
		if ( $assoc ){
			$json = new Services_JSON(SERVICES_JSON_LOOSE_TYPE);
		} else {
			$json = new Services_JSON;
		}
		return $json->decode($content);
	}
    private static function json_encode($content)
	{
		require_once 'JSON.php';
		$json = new Services_JSON;
		return $json->encode($content);
	}


	// メールを送信する
	public static function sendInfoMail($Subject,$To,$Body)
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

	// アサーション
	// こうあるべきだという条件を第一引数に指定
	// 例:ConsoleTools::assert((count($Users) == 1),$TermID,__FILE__,__LINE__) ; // 検索にひっかかったユーザは１人のはず
	// 条件が満たされなかった場合は、第二引数のメッセージをメールで送信
	public static function assert($Condition,$Message,$FileName,$Line)
	{
		if(!$Condition){
			$SendTo = 'tech@veam.co' ;
			ConsoleTools::sendInfoMail("[VEAM_CONSOLE_INFO]ASSERTION FAILED",$SendTo,$Message."\r\rFILE=".$FileName."\rLINE=".$Line) ;
		}
	}

	public static function getElementNameBy($kind,$targetId)
	{
		$name = "" ;
		switch($kind){		
		case 0: // カスタム 
			$custom = CustomPeer::retrieveByPk($targetId) ;
			$name = $custom->getAction() . ":" . $custom->getParam() ;
			break ;
		case 1: // WEBリンク 
			$link = LinkPeer::retrieveByPk($targetId) ;
			$name = $link->getTextEn() . ":" . $link->getSummaryEn() . "[" . $link->getUrl() . "]" ;
			break ;
		case 2: // 映像再生 
			$play = PlayPeer::retrieveByPk($targetId) ;
			$name = $play->getTextEn() . ":" . $play->getSummaryEn() ;
			break ;
		case 3: // 共有 
			$share = SharePeer::retrieveByPk($targetId) ;
			$name = $share->getTextEn() . ":" . $share->getSummaryEn() ;
			break ;
/*
		case 4: // テキスト 
			$custom = CustomPeer::retrieveByPk($targetId) ;
			break ;
*/
		case 5: // 小テキスト 
			$smallText = SmallTextPeer::retrieveByPk($targetId) ;
			$name = $smallText->getTextEn() ;
			break ;
		case 6: // アプリケーションリンク 
			$appLink = AppLinkPeer::retrieveByPk($targetId) ;
			$name = $appLink->getAppName1() . ":" . $appLink->getAppName2() . ":" . $appLink->getAppName3() ;
			break ;
		case 7: // 壁紙
			$keyvisual = KeyvisualPeer::retrieveByPk($targetId) ;
			$name = "wallpaper" ;
			break ;
		case 9: // HTML
			$html = HtmlPeer::retrieveByPk($targetId) ;
			$name = $html->getTextEn() . ":" . $html->getSummaryEn() ;
			break ;
		default:
			ConsoleTools::assert(false,"unexpected kind " . $kind,__FILE__,__LINE__) ;
			break ;
		}
		return $name ;
	}

	public static function getCountThisMonth($clientId)
	{
	  	$c = new Criteria();
	  	$c->add(GenerationLogPeer::DEL_FLG,0);
	  	$c->add(GenerationLogPeer::CLIENT_ID,$clientId);
		$startDate = date("Y-m-01 00:00:00") ;
		$endDate = date("Y-m-01 00:00:00", strtotime(date("Y-m-01") . "+1 month"));
		$c->addAnd(GenerationLogPeer::CREATED_AT,$startDate,Criteria::GREATER_EQUAL);          // 2011-05-24 09:24:31
		$c->addAnd(GenerationLogPeer::CREATED_AT,$endDate,Criteria::LESS_THAN);          // 2011-05-24 09:24:31
	  	$generationLogs = GenerationLogPeer::doSelect($c);
		return count($generationLogs) ;
	}

	public static function getLimitOf($clientId)
	{
		$client = ClientPeer::retrieveByPk($clientId) ;
		$planNumId = $client->getPlanNumId() ;
		$limitNum = $client->getLimitNum() ;
		$planNum = PlanNumPeer::retrieveByPk($planNumId) ;
		$num = $planNum->getNum() ;
		$limit = $num * $limitNum ;

		ConsoleTools::assert($limit > 0,"アプリ生成上限数が不正です。clientId=" . $clientId,__FILE__,__LINE__) ;

		return $limit ;
	}

	public static function getBinDirectory()
	{
		//  /home/android/site/android-work.exemagic.com/sf_project 
		return sfConfig::get('sf_root_dir') . "/../../../bin/" . ConsoleTools::getEnvString() ;
	}

	public static function getSiteDirectory()
	{
		//  /home/android/site/android-work.exemagic.com/sf_project 
		return sfConfig::get('sf_root_dir') . "/.." ;
	}


	/* kind
	0:カスタム" ;
	1:WEBリンク" ;
	2:映像再生" ;
	3:共有" ;
	4:テキスト" ;
	5:小テキスト" ;
	6:アプリケーションリンク" ;
	7:壁紙" ;
	*/
	public static function registerCustomElement($element,$password,$productId,$stillId,$action,$actionParam)
	{
		$custom = new Custom() ;
		$custom->fromArray(array('Password'=>$password,'ProductId'=>$productId,'Still'=>$stillId,'Action'=>$action,'Param'=>$actionParam,'DelFlg'	=>0));
		$custom->save() ;
		$element->fromArray(array('Kind'=>0,'TargetId'=>$custom->getId(),'DelFlg'=>0));
		$element->save() ;
	}

	public static function registerWebLinkElement($element,$password,$productId,$text,$summary,$url)
	{
		$link = new Link() ;
		$link->fromArray(array('Password'=>$password,'ProductId'=>$productId,'TextEn'=>'Web Site','TextEn'=>$text,'SummaryEn'=>'Go Web Site','SummaryEn'=>$summary,'Url'=>$url,'DelFlg'=>0));
		$link->save() ;
		$element->fromArray(array('Kind'=>1,'TargetId'=>$link->getId(),'DelFlg'=>0));
		$element->save() ;
	}

	public static function registerPlayElement($element,$password,$productId,$text,$summary)
	{
		$play = new Play() ;
		$play->fromArray(array('Password'=>$password,'ProductId'=>$productId,'TextEn'=>'Play','TextEn'=>$text,'SummaryEn'=>'Play The Movie','SummaryEn'=>$summary,'DelFlg'=>0));
		$play->save() ;
		$element->fromArray(array('Kind'=>2,'TargetId'=>$play->getId(),'DelFlg'=>0));
		$element->save() ;
	}

	public static function registerShareElement($element,$text,$summary,$content)
	{
		$share = new Share() ;
		$share->fromArray(array('TextEn'=>'Share','TextEn'=>$text,'SummaryEn'=>'Share with Twitter,Mail,etc.','SummaryEn'=>$summary,'Content'=>$content,'DelFlg'=>0));
		$share->save() ;
		$element->fromArray(array('Kind'=>3,'TargetId'=>$share->getId(),'DelFlg'=>0));
		$element->save() ;
	}

	public static function registerSmallTextElement($element,$text)
	{
		$smallText = new SmallText() ;
		$smallText->fromArray(array('TextEn'=>$text,'TextEn'=>$text,'DelFlg'=>0));
		$smallText->save() ;
		$element->fromArray(array('Kind'=>5,'TargetId'=>$smallText->getId(),'DelFlg'=>0));
		$element->save() ;
	}

	public static function registerAppLinkElement($element,$password,$productId,$stillId,$icon1StillId,$appName1,$appUrl1,$icon2StillId,$appName2,$appUrl2,$icon3StillId,$appName3,$appUrl3)
	{
		$appLink = new AppLink() ;
		$appLink->fromArray(array('Password'=>$password,'ProductId'=>$productId,'Still'=>$stillId,
			'AppStill1'=>$icon1StillId,'AppName1'=>$appName1,'AppUrl1'=>$appUrl1,
			'AppStill2'=>$icon2StillId,'AppName2'=>$appName2,'AppUrl2'=>$appUrl2,
			'AppStill3'=>$icon3StillId,'AppName3'=>$appName3,'AppUrl3'=>$appUrl3,
			'DelFlg'=>0));
		$appLink->save() ;
		$element->fromArray(array('Kind'=>6,'TargetId'=>$appLink->getId(),'DelFlg'=>0));
		$element->save() ;
	}

	public static function registerKeyvisualElement($element,$password,$productId,$stillId,$x1,$y1,$x2,$y2)
	{
		$keyvisual = new Keyvisual() ;
		$keyvisual->fromArray(array('Password'=>$password,'ProductId'=>$productId,'Still'=>$stillId,'X1'=>$x1,'Y1'=>$y1,'X2'=>$x2,'Y2'=>$y2,'DelFlg'=>0));
		$keyvisual->save() ;
		$element->fromArray(array('Kind'=>7,'TargetId'=>$keyvisual->getId(),'DelFlg'=>0));
		$element->save() ;
	}

	public static function registerHtmlElement($element,$password,$productId,$stillId,$text,$summary)
	{
		$html = new Html() ;
		$html->fromArray(array('Password'=>$password,'ProductId'=>$productId,'TextEn'=>'HTML','TextEn'=>$text,'SummaryEn'=>'Show HTML','SummaryEn'=>$summary,'Dir'=>$stillId,'DelFlg'=>0));
		$html->save() ;
		$element->fromArray(array('Kind'=>9,'TargetId'=>$html->getId(),'DelFlg'=>0));
		$element->save() ;
	}


	public static function sendMail($from,$to,$subject,$message)
	{
		//SMTP接続オプション
		$smtp_options = array(
			'host'		=> '__SMTP_SERVER_IP__',
			'port'		=> '25',
			'auth'		=> FALSE,
		);

		$mail = Mail::factory("smtp", $smtp_options);

		$mail_subject_b64 = "=?iso-2022-jp?B?" . base64_encode(mb_convert_encoding($subject,"JIS","UTF-8")) . "?=";

		$headers = array(
		  "To" => $to, // 
		  "From" => $from, //
		  "Subject" => $mail_subject_b64
		);

		// $mail = Mail::factory("sendmail");
	    $ret = $mail->send($to, $headers, $message);



	}




	public static function getAppName($appId)
	{
		$appNameKey = ConsoleTools::getEnvString().MEMCACHE_KEY_APP_NAME.$appId ;
		$appName = ConsoleTools::getMemcacheValue($appNameKey) ;

		if(!$appName){
		  	$c = new Criteria();
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$appName = $app->getName() ;
			}
			ConsoleTools::setMemcacheValue($appNameKey,$appName,2592000) ; // 30 days
		}

		return $appName ;
	}

	public static function getForumName($forumId)
	{
		$forumNameKey = ConsoleTools::getEnvString().MEMCACHE_KEY_FORUM_NAME.$forumId ;
		$forumName = ConsoleTools::getMemcacheValue($forumNameKey) ;

		if(!$forumName){
		  	$c = new Criteria();
			$forum = ForumPeer::retrieveByPk($forumId) ;
			if($forum){
				$forumName = $forum->getName() ;
				$forumName = str_replace('&amp;','&',$forumName) ;
			}
			ConsoleTools::setMemcacheValue($forumNameKey,$forumName,2592000) ; // 30 days
		}

		return $forumName ;
	}

	public static function getReportAddresses($appId)
	{
		$reportAddressesKey = ConsoleTools::getEnvString().MEMCACHE_KEY_REPORT_ADDRESSES.$appId ;
		$addressString = ConsoleTools::getMemcacheValue($reportAddressesKey) ;

		if(!$addressString){
		  	$c = new Criteria() ;
		  	$c->add(ReportAddressPeer::DEL_FLG,0) ;
		  	$c->add(ReportAddressPeer::APP_ID,$appId) ;
		  	$reportAddresses = ReportAddressPeer::doSelect($c) ;
			foreach($reportAddresses as $reportAddress){
				if($addressString){
					$addressString .= ',' ;
				}
				$addressString .= $reportAddress->getEmail() ;
			}
			if(!$addressString){
				$addressString = 'veam_report@veam.co' ;
			}
			ConsoleTools::setMemcacheValue($reportAddressesKey,$addressString,2592000) ; // 30 days
		}

		return $addressString ;
	}
























	public static function uploadPNGFileToS3($appId,$newWidth,$newHeight)
	{
		sfContext::getInstance()->getLogger()->info("uploadPNGFileToS3") ;
		$imageUrl = "" ;
		$fileName = sprintf("c_%s_%s_%04d.png",$appId,date('YmdHis'),rand()%10000) ;
		$filePath = "/tmp/" . $fileName ;

		//sfContext::getInstance()->getLogger()->info(sprintf('filePath=%s',$filePath));

		if(is_uploaded_file($_FILES["upfile"]["tmp_name"])){
			//if(move_uploaded_file($_FILES["upfile"]["tmp_name"], $filePath)){
			if(ConsoleTools::moveUploadedFileToPng($filePath,$newWidth,$newHeight)){
				chmod($filePath, 0666) ;
				$outputs = array() ;
				$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$filePath,$appId) ;
				//$this->logMessage(sprintf('commandLine=%s',$commandLine), 'info');

				exec($commandLine,$outputs) ;
				if($outputs[0] == '1'){
					$imageUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$fileName) ;
					sfContext::getInstance()->getLogger()->info(sprintf('imageUrl=%s',$imageUrl));
				} else {
					sfContext::getInstance()->getLogger()->info(sprintf('result=%s',implode(" - ",$outputs)));
				}

				unlink($filePath) ;

			} else {
				//echo "ファイルをアップロードできません。";
				sfContext::getInstance()->getLogger()->info(sprintf('failed to upload'));
			}
		} else {
			//echo "ファイルが選択されていません。";
			sfContext::getInstance()->getLogger()->info(sprintf('not uploaded'));
		}

		sfContext::getInstance()->getLogger()->info("uploadPNGFileToS3 end ".$imageUrl) ;
		return $imageUrl ;

	}


	public static function moveUploadedFileToPng($filePath,$newWidth,$newHeight)
	{
		$result = false ;
		$tmpFilePath = sprintf("/tmp/tmp%d_%d.png",time(),rand()) ;
		if(move_uploaded_file($_FILES["upfile"]["tmp_name"], $tmpFilePath)){
			$image = imagecreatefrompng($tmpFilePath) ;
			if(!$image){
				$image = imagecreatefromjpeg($tmpFilePath) ;
				if(!$image){
					$image = imagecreatefromgif($tmpFilePath) ;
					if(!$image){
						$image = imagecreatefromwbmp($tmpFilePath) ;
					}
				}
			}

			if($image){
				list($width, $height) = getimagesize($tmpFilePath) ;
				$resizedImage = imagecreatetruecolor($newWidth, $newHeight);

				/*
				imagecopyresized($resizedImage, $image, 0, 0, 0, 0, $newWidth, $newHeight, $width, $height);
				bool imagecopyresized ( resource $dst_image , resource $src_image , int $dst_x , int $dst_y , int $src_x , int $src_y , int $dst_w , int $dst_h , int $src_w , int $src_h )
				*/
				if(($newWidth / $newHeight) > ($width / $height)){
					$targetWidth = $width ;
					$targetHeight = $width * $newHeight / $newWidth ;
					$src_x = 0 ;
					$src_y = ($height - $targetHeight) / 2 ;
				} else {
					$targetWidth = $height * $newWidth / $newHeight ;
					$targetHeight = $height ;
					$src_x = ($width - $targetWidth) / 2 ;
					$src_y = 0 ;
				}

				imagecopyresized($resizedImage, $image, 0, 0, $src_x, $src_y, $newWidth, $newHeight, $targetWidth, $targetHeight);

				imagepng($resizedImage,$filePath);

				$result = true ;
			}
		}
		return $result ;
	}


	public static function uploadBackgroundPNGFileToS3($appId)
	{
		sfContext::getInstance()->getLogger()->info("uploadBackgroundPNGFileToS3") ;

		$fileName = sprintf("c_%s_%s_%04d.png",$appId,date('YmdHis'),rand()%10000) ;
		$filePath = "/tmp/" . $fileName ;

		/*
		$splashFileName = sprintf("c_%s_%s_%04d_s.png",$appId,date('YmdHis'),rand()%10000) ;
		$splashFilePath = "/tmp/" . $splashFileName ;
		*/

		$blurFileName = sprintf("c_%s_%s_%04d_b.png",$appId,date('YmdHis'),rand()%10000) ;
		$blurFilePath = "/tmp/" . $blurFileName ;

		//sfContext::getInstance()->getLogger()->info(sprintf('filePath=%s',$filePath));

		$imageUrls = array() ;

		if(is_uploaded_file($_FILES["upfile"]["tmp_name"])){
			//if(move_uploaded_file($_FILES["upfile"]["tmp_name"], $filePath)){
			if(ConsoleTools::moveUploadedFileToPng($filePath,640,1136)){
				//ConsoleTools::blurImage($filePath,$splashFilePath) ;
				ConsoleTools::whitenImage($filePath,$blurFilePath) ;
				chmod($filePath, 0666) ;
				//chmod($splashFilePath, 0666) ;
				chmod($blurFilePath, 0666) ;

				$outputs = array() ;
				$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$filePath,$appId) ;
				//$this->logMessage(sprintf('commandLine=%s',$commandLine), 'info');

				exec($commandLine,$outputs) ;
				if($outputs[0] == '1'){
					$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$fileName) ;
					sfContext::getInstance()->getLogger()->info(sprintf('imageUrl=%s',$imageUrls[0]));

					$outputs = array() ;
					$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$blurFilePath,$appId) ;
					exec($commandLine,$outputs) ;

					if($outputs[0] == '1'){
						$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$blurFileName) ;
						sfContext::getInstance()->getLogger()->info(sprintf('imageUrl=%s',$imageUrls[1]));
					}


					/*
					$outputs = array() ;
					$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$splashFilePath,$appId) ;
					exec($commandLine,$outputs) ;

					if($outputs[0] == '1'){
						$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$splashFileName) ;
						sfContext::getInstance()->getLogger()->info(sprintf('imageUrl=%s',$imageUrls[1]));
					}
					*/


				} else {
					sfContext::getInstance()->getLogger()->info(sprintf('result=%s',implode(" - ",$outputs)));
				}

				unlink($filePath) ;
				//unlink($splashFilePath) ;
				unlink($blurFilePath) ;

			} else {
				//echo "ファイルをアップロードできません。";
				sfContext::getInstance()->getLogger()->info(sprintf('failed to upload'));
			}
		} else {
			//echo "ファイルが選択されていません。";
			sfContext::getInstance()->getLogger()->info(sprintf('not uploaded'));
		}

		sfContext::getInstance()->getLogger()->info("uploadBackgroundPNGFileToS3 end ") ;
		return $imageUrls ;

	}

	public static function uploadIconPNGFileToS3($appId)
	{
		sfContext::getInstance()->getLogger()->info("uploadIconPNGFileToS3") ;

		$fileName = sprintf("c_%s_%s_%04d.png",$appId,date('YmdHis'),rand()%10000) ;
		$filePath = "/tmp/" . $fileName ;

		$smallFileName = sprintf("c_%s_%s_%04d_s.png",$appId,date('YmdHis'),rand()%10000) ;
		$smallFilePath = "/tmp/" . $smallFileName ;

		//sfContext::getInstance()->getLogger()->info(sprintf('filePath=%s',$filePath));

		$imageUrls = array() ;

		if(is_uploaded_file($_FILES["upfile"]["tmp_name"])){
			//if(move_uploaded_file($_FILES["upfile"]["tmp_name"], $filePath)){
			if(ConsoleTools::moveUploadedFileToPng($filePath,1024,1024)){
				ConsoleTools::removeImageAlpha($filePath) ;
				ConsoleTools::resizeImage($filePath,$smallFilePath,64,64) ;
				chmod($filePath, 0666) ;
				chmod($smallFilePath, 0666) ;

				$outputs = array() ;
				$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$filePath,$appId) ;
				//$this->logMessage(sprintf('commandLine=%s',$commandLine), 'info');

				exec($commandLine,$outputs) ;
				if($outputs[0] == '1'){
					$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$fileName) ;
					sfContext::getInstance()->getLogger()->info(sprintf('imageUrl=%s',$imageUrls[0]));

					$outputs = array() ;
					$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$smallFilePath,$appId) ;
					exec($commandLine,$outputs) ;

					if($outputs[0] == '1'){
						$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$smallFileName) ;
						sfContext::getInstance()->getLogger()->info(sprintf('imageUrl=%s',$imageUrls[1]));
					}
				} else {
					sfContext::getInstance()->getLogger()->info(sprintf('result=%s',implode(" - ",$outputs)));
				}

				unlink($filePath) ;
				unlink($smallFilePath) ;

			} else {
				//echo "ファイルをアップロードできません。";
				sfContext::getInstance()->getLogger()->info(sprintf('failed to upload'));
			}
		} else {
			//echo "ファイルが選択されていません。";
			sfContext::getInstance()->getLogger()->info(sprintf('not uploaded'));
		}

		sfContext::getInstance()->getLogger()->info("uploadIconPNGFileToS3 end ") ;
		return $imageUrls ;

	}


	public static function blurImage($imagePath1,$imagePath2)
	{
		$image = imagecreatefrompng($imagePath1) ;
		list($width1, $height1) = getimagesize($imagePath1) ;

		for($count = 0 ; $count < 19 ; $count++){
			imagefilter($image, IMG_FILTER_GAUSSIAN_BLUR) ;
		}

		imagepng($image,$imagePath2);
	}

	public static function whitenImage($imagePath1,$imagePath2)
	{
		$image = imagecreatefrompng($imagePath1) ;
		list($width1, $height1) = getimagesize($imagePath1) ;

		// blur
		for($count = 0 ; $count < 19 ; $count++){
			imagefilter($image, IMG_FILTER_GAUSSIAN_BLUR) ;
		}

		// whiten
		$white = imagecolorallocatealpha($image, 0xFF, 0xFF, 0xFF, 19) ; // White 85%
		imagefilledrectangle($image, 0, 0, $width1,$height1, $white) ;

		imagepng($image,$imagePath2);
	}

	public static function resizeImage($imagePath1,$imagePath2,$width,$height)
	{
		$image = imagecreatefrompng($imagePath1) ;
		list($width1, $height1) = getimagesize($imagePath1) ;

		$resizedImage = imagecreatetruecolor($width, $height);
		imagecopyresized($resizedImage, $image, 0, 0, 0, 0, $width, $height, $width1, $height1);

		imagepng($resizedImage,$imagePath2);
	}

	public static function removeImageAlpha($imagePath1)
	{
		$image = imagecreatefrompng($imagePath1) ;
		imagesavealpha($image,false) ;
		imagepng($image,$imagePath1);
	}



	public static function uploadCroppedPNGFileToS3($appId,$orgFilePath,$size)
	{
		sfContext::getInstance()->getLogger()->info(sprintf("uploadCroppedPNGFileToS3 %d",$size)) ;
		$imageUrl = "" ;

		$fileName = sprintf("c_%s_%s_%04d_%d.png",$appId,date('YmdHis'),rand()%10000,$size) ;
		$filePath = "/tmp/" . $fileName ;

		ConsoleTools::cropImageFileToCircle($orgFilePath,$filePath,$size) ;
		chmod($filePath, 0666) ;
		$outputs = array() ;
		$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$filePath,$appId) ;
		//$this->logMessage(sprintf('commandLine=%s',$commandLine), 'info');
		exec($commandLine,$outputs) ;
		if($outputs[0] == '1'){
			$imageUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$fileName) ;
			sfContext::getInstance()->getLogger()->info(sprintf('imageUrl=%s',$imageUrl));
		} else {
			sfContext::getInstance()->getLogger()->info(sprintf('result=%s',implode(" - ",$outputs)));
		}

		unlink($filePath) ;

		sfContext::getInstance()->getLogger()->info("uploadCroppedPNGFileToS3 end ".$imageUrl) ;
		return $imageUrl ;

	}

	public static function cropImageFileToCircle($fromFilePath,$toFilePath,$cropSize)
	{

		$dataDir = sfConfig::get("sf_data_dir") ; 

		$canvas  = new stdClass() ;
		$image   = new stdClass() ;
		$resizedImage   = new stdClass() ;
		$mask    = new stdClass() ;

		$imageFileName = $fromFilePath ;

		$imageType = exif_imagetype($imageFileName) ;
		if($imageType == IMAGETYPE_JPEG){
			$image->image = imagecreatefromjpeg($imageFileName) ;
		} else if($imageType == IMAGETYPE_PNG){
			$image->image = imagecreatefrompng($imageFileName) ;
		} else if($imageType == IMAGETYPE_GIF){
			$image->image = imagecreatefromgif($imageFileName) ;
		}
		$image->width     = imagesx($image->image);
		$image->height    = imagesy($image->image);

		$mask->image  = imagecreatefrompng(sprintf('%s/mask%d.png',$dataDir,$cropSize)) ;
		$mask->width  = imagesx($mask->image) ;
		$mask->height = imagesy($mask->image) ;

		if($image->width < $image->height){
			$resizedWidth = $mask->width ;
			$resizedHeight = $image->height * $resizedWidth / $image->width  ;
		} else {
			$resizedHeight = $mask->width ;
			$resizedWidth = $image->width * $resizedHeight / $image->height ;
		}

		$resizedImage->image = imagecreatetruecolor($resizedWidth, $resizedHeight) ;
		$resizedImage->width     = $resizedWidth ;
		$resizedImage->height    = $resizedHeight ;

		imagecopyresampled($resizedImage->image,  // 背景画像
		                   $image->image,   // コピー元画像
		                   0,        // 背景画像の x 座標
		                   0,        // 背景画像の y 座標
		                   0,        // コピー元の x 座標
		                   0,        // コピー元の y 座標
		                   $resizedWidth,   // 背景画像の幅
		                   $resizedHeight,  // 背景画像の高さ
		                   $image->width, // コピー元画像ファイルの幅
		                   $image->height  // コピー元画像ファイルの高さ
		                  ) ;

		$canvas->width    = $mask->width ;
		$canvas->height   = $mask->height ;
		$canvas->image = imagecreatetruecolor($canvas->width, $canvas->height) ;

		imagealphablending($canvas->image, false) ;
		imagesavealpha($canvas->image, true) ;
		$transparent = imagecolorallocatealpha( $canvas->image, 0, 0, 0, 127 ) ;
		imagefill( $canvas->image, 0, 0, $transparent ) ;

		$top = round(($resizedImage->width - $mask->width) / 2) ;
		$left = round(($resizedImage->height - $mask->height) / 2) ;
 
		for($y=0;$y<$canvas->height;$y++){
		    for($x=0;$x<$canvas->width;$x++){
		        $rgb     = imagecolorat($mask->image, $x, $y);
		        $index   = imagecolorsforindex($mask->image, $rgb);
		         
		        $alpha   = $index['alpha'];
		        //$alpha     = ($index['red'] + $index['green'] + $index['blue']) / 765 * 127 ;
		 
		        $current = imagecolorat($resizedImage->image, $x + $top, $y + $left);
		        $index   = imagecolorsforindex($resizedImage->image, $current);
		        $color   = imagecolorallocatealpha($canvas->image, $index['red'], $index['green'], $index['blue'], $alpha);
		        imagesetpixel($canvas->image, $x, $y, $color);
		    }
		}

		imagepng($canvas->image,$toFilePath) ;
 
		imagedestroy($canvas->image);
		imagedestroy($image->image);
		imagedestroy($resizedImage->image);
		imagedestroy($mask->image);
	}



	public static function setAlternativeImage($appId,$fileName,$url)
	{
		sfContext::getInstance()->getLogger()->info(sprintf("setAlternativeImage %s %s %s",$appId,$fileName,$url)) ;

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

	public static function saveConsoleLog($request,$value){
		$log = sprintf("\nAll Params :\n") ;
		$parameters = $request->getParameterHolder()->getAll() ;
		foreach($parameters as $paramName => $paramValue){
			$log .= sprintf("%s=%s\n",$paramName,$paramValue) ;
		}

		$requestInfoNames = array(
			'HTTP_USER_AGENT',
			'REMOTE_ADDR',
			'QUERY_STRING',
			'REQUEST_URI',
			'PATH_INFO',
			'REQUEST_TIME'
		) ;
		$log .= sprintf("\nrequest info :\n") ;
		foreach($requestInfoNames as $requestInfoName){
			$log .= sprintf("%s=%s\n",$requestInfoName,$_SERVER[$requestInfoName]) ;
		}

		$consoleLog = new ConsoleLog() ;
		$consoleLog->setAppId($request->getParameter('a')) ;
		$consoleLog->setLog($log) ;
		$consoleLog->setValue(var_export($value,true)) ;
		$consoleLog->save() ;
	}



	public static function getSettingCompletionRatio($appId)
	{
		$app = AppPeer::retrieveByPk($appId) ;
		$isSubmittable = true ;
		$ratio = 0 ;
		if($app){
			if(!$app->getTermsAcceptedAt()){
				$isSubmittable = false ;
			} else {
				$ratio += 10 ;
			}

			if(!$app->getDescription()){
				$isSubmittable = false ;
			} else {
				$ratio += 5 ;
			}

			if(!$app->getKeyWord()){
				$isSubmittable = false ;
			} else {
				$ratio += 5 ;
			}

			if(!$app->getCategory()){
				$isSubmittable = false ;
			} else {
				$ratio += 5 ;
			}

		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
		  	$c->add(ForumPeer::KIND,1) ;
			$forums = ForumPeer::doCount($c) ;
			if($forums == 0){
				$isSubmittable = false ;
			} else {
				$ratio += 10 ;
			}

			//// link
		  	$c = new Criteria() ;
		  	$c->add(WebPeer::DEL_FLAG,0) ;
		  	$c->add(WebPeer::APP_ID,$appId) ;
			$webs = WebPeer::doCount($c) ;
			if($webs == 0){
				$isSubmittable = false ;
			} else {
				$ratio += 10 ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
		  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
		  	$appRatingAnswers = AppRatingAnswerPeer::doSelect($c) ;
			$appRatingAnswerMap = array() ;
			foreach($appRatingAnswers as $appRatingAnswer){
				$appRatingAnswerMap[$appRatingAnswer->getAppRatingQuestionId()] = $appRatingAnswer ;
			}

			$allQuestionsAnswered = true ;
		  	$c = new Criteria() ;
		  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
		  	$c->addAscendingOrderByColumn(AppRatingQuestionPeer::DISPLAY_ORDER) ;
		  	$appRatingQuestions = AppRatingQuestionPeer::doSelect($c) ;
			foreach($appRatingQuestions as $appRatingQuestion){
				if(!$appRatingAnswerMap[$appRatingQuestion->getId()]){
					$isSubmittable = false ;
					$allQuestionsAnswered = false ;
				}
			}

			if($allQuestionsAnswered){
				$ratio += 5 ;
			}



		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;

			if($templateSubscription){
				if($templateSubscription->getKind() == 4){ // Subscription
				  	$c = new Criteria() ;
				  	$c->add(MixedPeer::DEL_FLG,0) ;
				  	$c->add(MixedPeer::APP_ID,$appId) ;
				  	$c->add(MixedPeer::CONTENT_ID,0,Criteria::NOT_EQUAL) ;
				  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
					$mixeds = MixedPeer::doCount($c) ;
					if($mixeds == 0){
						$isSubmittable = false ;
					} else {
						$ratio += 50 ;
					}
				} else if($templateSubscription->getKind() == 5){ // Pay Per Content
				  	$c = new Criteria() ;
				  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
				  	$c->add(SellVideoPeer::APP_ID,$appId) ;
					$sellVideos = SellVideoPeer::doCount($c) ;

				  	$c = new Criteria() ;
				  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
				  	$c->add(SellAudioPeer::APP_ID,$appId) ;
					$sellAudios = SellAudioPeer::doCount($c) ;

				  	$c = new Criteria() ;
				  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
				  	$c->add(SellPdfPeer::APP_ID,$appId) ;
					$sellPdfs = SellPdfPeer::doCount($c) ;

					if(($sellVideos == 0) && ($sellAudios == 0) && ($sellPdfs == 0)){
						$isSubmittable = false ;
					} else {
						$ratio += 50 ;
					}

				} else if($templateSubscription->getKind() == 6){ // Pay Per Section
				  	$c = new Criteria() ;
				  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
				  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
				  	$c->add(SellSectionItemPeer::CONTENT_ID,0,Criteria::NOT_EQUAL) ;
					$sellSectionItems = SellSectionItemPeer::doCount($c) ;
					if($sellSectionItems == 0){
						$isSubmittable = false ;
					} else {
						$ratio += 50 ;
					}
				}
			} else {
				$ratio = 0 ;
			}


			if($isSubmittable){
				$ratio = 100 ;
			} else {
		        if($ratio >= 100){
		            $ratio = 95 ;
		        }
			}
	    }
	    return $ratio ;
	}



	public static function executeConsoleCommand($appId,$command,$params)
	{
		$seedString = sprintf("%d%d%d",time(),rand(),rand()) ;
		$secret = sha1($seedString) ;
		$remoteCommand = new RemoteCommand() ;
		$remoteCommand->setAppId($appId) ;
		$remoteCommand->setName($command) ;
		$remoteCommand->setSecret($secret) ;
		$remoteCommand->setStatus(0) ;
		$remoteCommand->setParams($params) ;
		$remoteCommand->save() ;

		// http://console-work.veam.co/api.php/command/execute/?a=31000019&i=1&s=a7be3a97e7084e044558b1b38868555b52bd979b
		$env = ConsoleTools::getEnvString() ;
		if($env == 'public'){
			$consoleServer = 'console-preview.veam.co' ;
		} else if($env == 'preview'){
			$consoleServer = 'console-preview.veam.co' ;
		} else {
			$consoleServer = 'console-work.veam.co' ;
		}


		/*
			$url = sprintf("http://%s/api.php/command/execute/?a=%s&i=%s&s=%s",$consoleServer,$appId,$remoteCommand->getId(),$secret) ;
			$result = file_get_contents($url) ;
			sfContext::getInstance()->getLogger()->info("Command : " . $url) ;
		*/

		if($remoteCommand){
			$remoteCommandId = $remoteCommand->getId() ;
			$commandName = $remoteCommand->getName() ;
			//print("EXECUTE ".$commandName) ;
			if($commandName == 'UPDATE_CONCEPT_COLOR'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateConceptcolor --command_id=%d > /dev/null &",$consoleServer,$remoteCommandId) ;
			} else if($commandName == 'UPDATE_SCREEN_SHOT'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateScreenshot --command_id=%d > /dev/null &",$consoleServer,$remoteCommandId) ;
			} else if($commandName == 'UPDATE_YOUTUBE_LIST'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateYoutubelist --command_id=%d > /dev/null &",$consoleServer,$remoteCommandId) ;
			} else if($commandName == 'COMPLETE_APP_PROCESS'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony completeAppprocess --command_id=%d > /dev/null &",$consoleServer,$remoteCommandId) ;
			} else if($commandName == 'DEPLOY_APP'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony deployApp --command_id=%d > /dev/null &",$consoleServer,$remoteCommandId) ;
			} else if($commandName == 'DEPLOY_APP_CONTENTS'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony deployAppcontents --command_id=%d > /dev/null &",$consoleServer,$remoteCommandId) ;
			} else {
				ConsoleTools::assert(false,sprintf("unknown command commandname=%s id=%s appid=%s secret=%s",$commandName,$remoteCommandId,$appId,$secret),__FILE__,__LINE__) ;
			}

			if($commandLine){
				//print("$commandLine\n") ;
				sfContext::getInstance()->getLogger()->info("Command : " . $commandLine) ;
				exec($commandLine) ;
			}
		} else {
			ConsoleTools::assert(false,sprintf("remote command not found id=%s appid=%s secret=%s",$remoteCommandId,$appId,$secret),__FILE__,__LINE__) ;
		}


	}




}

