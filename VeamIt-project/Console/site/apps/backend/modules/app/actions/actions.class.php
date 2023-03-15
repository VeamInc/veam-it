<?php

/**
 * 	app actions.
 *
 * @package    console
 * @subpackage app
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class appActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeList(sfWebRequest $request)
	{
	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0);
		$c->addDescendingOrderByColumn(AppPeer::ID) ;
		$this->apps = AppPeer::doSelect($c) ;
	}

	public function executeShow(sfWebRequest $request)
	{
		$appId = $request->getParameter('id') ;
		if($appId){
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLAG,0);
		  	$c->add(AppPeer::ID,$appId);
			$this->apps = AppPeer::doSelect($c) ;
		}
	}


	public function executeConfirminitialize(sfWebRequest $request)
	{
		$appId = $request->getParameter('id') ;
		if($appId){
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0);
		  	$c->add(AppPeer::ID,$appId);
			$c->addDescendingOrderByColumn(AppPeer::ID) ;
			$this->apps = AppPeer::doSelect($c) ;
		}
	}

	public function executeInitialize(sfWebRequest $request)
	{
		$appId = $request->getParameter('id') ;

		if($appId >= 31000030){
		  	$c = new Criteria();
		  	$c->add(AppPeer::DEL_FLG,0) ;
		  	$c->add(AppPeer::ID,$appId) ;
		  	$apps = AppPeer::doSelect($c) ;
			if(count($apps) > 0){
				$app = $apps[0] ;
				$this->message = 'Initialized' ;
				$app->setName('App Name') ;
				$app->setStoreAppName('Store App Name') ;
				$app->setDescription('This is a description') ;
				$app->setStatus(4) ; // 4:Initialized
				$app->save() ;

				$this->removeAppValues($appId) ;
				$this->setDefaultValues($appId) ;
				ConsoleTools::consoleContentsChanged($appId) ;

			} else {
				$this->message = 'Failed' ;
			}
		} else {
			$this->message = 'Not supported for id less than 31000030' ;
		}
	}

	public function executeNew(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
	}


	public function executeCreate(sfWebRequest $request)
	{
		$appCreatorName = $request->getParameter('app_creator_name') ;
		$appCreatorPassword = $request->getParameter('app_creator_password') ;
		if($appCreatorName && $appCreatorPassword){
		  	$c = new Criteria();
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::USERNAME,$appCreatorName) ;
			$appCreator = AppCreatorPeer::doSelectOne($c) ;
			if($appCreator){
				$request->setParameter('error_message',sprintf('user %s already exists',$appCreatorName)) ;
				$this->forward('app','new') ;
			} else {
				$app = new App() ;
				$app->setName('App Name') ;
				$app->setStoreAppName('Store App Name') ;
				$app->setDescription('This is a description') ;
				$app->setStatus(4) ; // 4:Initialized
				$app->save() ;

				$appId = $app->getId() ;
				
				$appCreator = new AppCreator() ;
				$appCreator->setAppId($appId) ;
				$appCreator->setUserName($appCreatorName) ;
				$appCreator->setPassword(strtolower(sha1($appCreatorPassword))) ;
				$appCreator->save() ;

				$this->setDefaultValues($appId) ;

				$this->forward('app','list') ;
			}
		} else {
			$request->setParameter('error_message','please input user name and password') ;
			$this->forward('app','new') ;
		}
	}

	public function removeAppValues($appId)
	{
		// app_color
		$this->removeAppColor($appId) ;

		// app_data
		$this->removeAppData($appId) ;

		// forum
		$this->removeForum($appId) ;

		// template_forum
		$this->removeTemplateForum($appId) ;

		// template_subscription
		$this->removeTemplateSubscription($appId) ;

		// template_web
		$this->removeTemplateWeb($appId) ;

		// template_youtube
		$this->removeTemplateYoutube($appId) ;

		// video_category
		$this->removeVideoCategory($appId) ;

		// video
		$this->removeVideo($appId) ;

		// audio
		$this->removeAudio($appId) ;

		// mixed
		$this->removeMixed($appId) ;

		// web` (`title`, `url`, `display_order`
		$this->removeWeb($appId) ;

	}


	public function setDefaultValues($appId)
	{
		// app_color
		$this->setAppColor($appId,'top_bar_color_argb'				,'FF8B8B8B') ;
		$this->setAppColor($appId,'tab_text_color_argb'				,'FF000000') ;
		$this->setAppColor($appId,'base_text_color_argb'			,'FF000000') ;
		$this->setAppColor($appId,'base_background_color_argb'		,'33FFFFFF') ;
		$this->setAppColor($appId,'new_videos_text_color_argb'		,'FF60FFFF') ;
		$this->setAppColor($appId,'table_selection_color_argb'		,'3060FFFF') ;

		// app_data
		$this->setAppData($appId,'template_ids'						,'8_1_2_3') ;
		$this->setAppData($appId,'subscription_0_description'		,'This is a description.&#xA;&#xA;') ;
		$this->setAppData($appId,'subscription_0_button_text'		,'Tap to subscribe - US$0.99 per/month') ;
		$this->setAppData($appId,'email_to'							,'support@veam.co') ;

		// forum
		$this->setForum($appId,'Hot Topics'							,2,-1) ;
		$this->setForum($appId,'Meet &amp; Greet'					,1,1) ;

		// template_forum
		$this->setTemplateForum($appId,'Forum') ;

		// template_subscription
		$this->setTemplateSubscription($appId,'Premium','$0.99','','1') ;

		// template_web
		$this->setTemplateWeb($appId,'Links');

		// template_youtube
		$this->setTemplateYoutube($appId,'YouTube') ;

		// video_category
		$videoCategoryId = $this->setVideoCategory($appId,'Monthly Premium Video',1) ;

		// video
		$this->setVideo($appId,$videoCategoryId, 5, 'Video 1', 1, 1, '1') ;
		$this->setVideo($appId,$videoCategoryId, 5, 'Video 2', 2, 1, '2') ;
		$this->setVideo($appId,$videoCategoryId, 5, 'Video 3', 3, 1, '3') ;

		// mixed
		$this->setMixed($appId,0, 0, 'Content 1', 1, 1, '1') ;
		$this->setMixed($appId,0, 0, 'Content 2', 2, 1, '2') ;
		$this->setMixed($appId,0, 0, 'Content 3', 3, 1, '3') ;

		// web` (`title`, `url`, `display_order`
		$this->setWeb($appId,'Facebook', 'https://www.facebook.com/VeamApp', 1) ;
		$this->setWeb($appId,'Twitter', 'https://twitter.com/VeamApp', 2) ;

	}

	public function setWeb($appId,$title,$url,$displayOrder)
	{
		$web = new Web() ;
		$web->setAppId($appId) ;
		$web->setTitle($title) ;
		$web->setUrl($url) ;
		$web->setDisplayOrder($displayOrder) ;
		$web->save() ;
	}

	public function setVideo($appId,$videoCategoryId,$kind,$title,$displayOrder,$status,$statusText)
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


	public function setMixed($appId,$mixedCategoryId,$kind,$title,$displayOrder,$status,$statusText)
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


	public function setVideoCategory($appId,$name,$displayOrder)
	{
		$videoCategory = new VideoCategory() ;
		$videoCategory->setAppId($appId) ;
		$videoCategory->setName($name) ;
		$videoCategory->setDisplayOrder($displayOrder) ;
		$videoCategory->save() ;

		return $videoCategory->getId() ;
	}

	public function setTemplateYoutube($appId,$name)
	{
		$templateYoutube = new TemplateYoutube() ;
		$templateYoutube->setAppId($appId) ;
		$templateYoutube->setTitle($name) ;
		$templateYoutube->setEmbedFlag(0) ;
		$templateYoutube->save() ;
	}

	public function setTemplateWeb($appId,$name)
	{
		$templateWeb = new TemplateWeb() ;
		$templateWeb->setAppId($appId) ;
		$templateWeb->setTitle($name) ;
		$templateWeb->save() ;
	}

	public function setTemplateSubscription($appId,$name,$price,$layout,$kind)
	{
		$templateSubscription = new TemplateSubscription() ;
		$templateSubscription->setAppId($appId) ;
		$templateSubscription->setTitle($name) ;
		$templateSubscription->setPrice($price) ;
		$templateSubscription->setLayout($layout) ;
		$templateSubscription->setKind($kind) ;
		$templateSubscription->save() ;
	}

	public function setTemplateForum($appId,$name)
	{
		$templateForum = new TemplateForum() ;
		$templateForum->setAppId($appId) ;
		$templateForum->setTitle($name) ;
		$templateForum->save() ;
	}

	public function setForum($appId,$name,$kind,$displayOrder)
	{
		$forum = new Forum() ;
		$forum->setAppId($appId) ;
		$forum->setName($name) ;
		$forum->setKind($kind) ;
		$forum->setDisplayOrder($displayOrder) ;
		$forum->save() ;
	}

	public function setAppColor($appId,$name,$value)
	{
		$appColor = new AppColor() ;
		$appColor->setAppId($appId) ;
		$appColor->setName($name) ;
		$appColor->setColor($value) ;
		$appColor->save() ;
	}

	public function setAppData($appId,$name,$value)
	{
		$appData = new AppData() ;
		$appData->setAppId($appId) ;
		$appData->setName($name) ;
		$appData->setData($value) ;
		$appData->save() ;
	}
















	public function removeAppData($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(AppDataPeer::APP_ID,$appId) ;
		$records = AppDataPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}



	public function removeAppColor($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(AppColorPeer::APP_ID,$appId) ;
		$records = AppColorPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeForum($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(ForumPeer::APP_ID,$appId) ;
		$records = ForumPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeTemplateForum($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(TemplateForumPeer::APP_ID,$appId) ;
		$records = TemplateForumPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeTemplateSubscription($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		$records = TemplateSubscriptionPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeTemplateWeb($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(TemplateWebPeer::APP_ID,$appId) ;
		$records = TemplateWebPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeTemplateYoutube($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(TemplateYoutubePeer::APP_ID,$appId) ;
		$records = TemplateYoutubePeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeVideoCategory($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(VideoCategoryPeer::APP_ID,$appId) ;
		$records = VideoCategoryPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeVideo($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(VideoPeer::APP_ID,$appId) ;
		$records = VideoPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeAudio($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(AudioPeer::APP_ID,$appId) ;
		$records = AudioPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeMixed($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(MixedPeer::APP_ID,$appId) ;
		$records = MixedPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}

	public function removeWeb($appId)
	{
	  	$c = new Criteria() ;
	  	$c->add(WebPeer::APP_ID,$appId) ;
		$records = WebPeer::doSelect($c) ;
		foreach($records as $record){
			$record->delete() ;
		}
	}


}

