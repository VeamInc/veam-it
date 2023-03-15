<?php

define('SUBSCRIPTION_ACTION_KIND_NORMAL',1) ;

define('SUBSCRIPTION_ACTION_KIND_DELAYED_NORMAL',2) ;
define('SUBSCRIPTION_ACTION_KIND_DELAYED_LONG',3) ;

/**
 * subscription actions.
 *
 * @package    console
 * @subpackage subscription
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class subscriptionActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListcontents(sfWebRequest $request)
	{
		$this->prepareContentList($request,SUBSCRIPTION_ACTION_KIND_NORMAL) ;
	}

	public function prepareContentList(sfWebRequest $request,$kind)
	{
		$appId = $request->getParameter('a') ;
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}
		$sortKind = $request->getParameter('so') ;

		$allApps = AdminTools::getAppsForMcn($this->mcnId) ;

		if($appId){
			$apps = array() ;
			$app = AppPeer::retrieveByPk($appId) ;
			if($app->getMcnId() != $this->mcnId){
				$request->setParameter('m','Invalid app') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}
			$apps[] = $app ;
		} else {
			$apps = $allApps ;
		}

		$appMap = AdminTools::getMapForObjects($apps) ;
		$appIds = AdminTools::getIdsForObjects($apps) ;

	  	$c = new Criteria() ;
	  	$c->add(MixedPeer::DEL_FLG,0) ;
	  	$c->add(MixedPeer::APP_ID,$appIds,Criteria::IN) ;
	  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(MixedPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(MixedPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('Mixed', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$audioIds = array() ;
		$videoIds = array() ;
		$socialUserIds = array() ;
		if($page <= $lastPage){
			$mixeds = $pager->getResults() ;
			foreach($mixeds as $mixed){
				$kind = $mixed->getKind() ;
				if(($kind == 7) || ($kind == 8)){
					$videoIds[] = $mixed->getContentId() ;
				} else if(($kind == 9) || ($kind == 10)){
					$audioIds[] = $mixed->getContentId() ;
				}
			}

			if(count($audioIds) > 0){
			  	$c = new Criteria() ;
			  	$c->add(AudioPeer::DEL_FLG,0) ;
			  	$c->add(AudioPeer::ID,$audioIds,Criteria::IN) ;
				$audios = AudioPeer::doSelect($c) ;
				if($audios){
					$audioMap = AdminTools::getMapForObjects($audios) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(AudioLikePeer::DEL_FLAG,0) ;
			  	$c->add(AudioLikePeer::AUDIO_ID,$audioIds,Criteria::IN) ;
				$audioLikes = AudioLikePeer::doSelect($c) ;
				$numberOfAudioLikes = array() ;
				foreach($audioLikes as $audioLike){
					$numberOfAudioLikes[$audioLike->getAudioId()]++ ;
				}

			  	$c = new Criteria() ;
			  	$c->add(AudioCommentPeer::DEL_FLAG,0) ;
			  	$c->add(AudioCommentPeer::AUDIO_ID,$audioIds,Criteria::IN) ;
			  	$c->addAscendingOrderByColumn(AudioCommentPeer::CREATED_AT) ;
				$audioComments = AudioCommentPeer::doSelect($c) ;
				$audioCommentsMap = array() ;
				foreach($audioComments as $audioComment){
					if(!isset($audioCommentsMap[$audioComment->getAudioId()])){
						$audioCommentsMap[$audioComment->getAudioId()] = array() ;
					}
					$audioCommentsMap[$audioComment->getAudioId()][] = $audioComment ;

					$socialUserId = $audioComment->getSocialUserId() ;
					if($socialUserId){
						if(!in_array($socialUserId,$socialUserIds)){
							$socialUserIds[] = $socialUserId ;
						}
					}
				}

			}

			if(count($videoIds) > 0){
			  	$c = new Criteria() ;
			  	$c->add(VideoPeer::DEL_FLG,0) ;
			  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
				$videos = VideoPeer::doSelect($c) ;
				if($videos){
					$videoMap = AdminTools::getMapForObjects($videos) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(VideoLikePeer::DEL_FLAG,0) ;
			  	$c->add(VideoLikePeer::VIDEO_ID,$videoIds,Criteria::IN) ;
				$videoLikes = VideoLikePeer::doSelect($c) ;
				$numberOfVideoLikes = array() ;
				foreach($videoLikes as $videoLike){
					$numberOfVideoLikes[$videoLike->getVideoId()]++ ;
				}

			  	$c = new Criteria() ;
			  	$c->add(VideoCommentPeer::DEL_FLAG,0) ;
			  	$c->add(VideoCommentPeer::VIDEO_ID,$videoIds,Criteria::IN) ;
			  	$c->addAscendingOrderByColumn(VideoCommentPeer::CREATED_AT) ;
				$videoComments = VideoCommentPeer::doSelect($c) ;
				$videoCommentsMap = array() ;
				foreach($videoComments as $videoComment){
					if(!isset($videoCommentsMap[$videoComment->getVideoId()])){
						$videoCommentsMap[$videoComment->getVideoId()] = array() ;
					}
					$videoCommentsMap[$videoComment->getVideoId()][] = $videoComment ;

					$socialUserId = $videoComment->getSocialUserId() ;
					if($socialUserId){
						if(!in_array($socialUserId,$socialUserIds)){
							$socialUserIds[] = $socialUserId ;
						}
					}
				}
			}

		  	$c = new Criteria() ;
		  	$c->add(SocialUserPeer::DEL_FLG,0) ;
			$c->add(SocialUserPeer::ID,$socialUserIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(SocialUserPeer::ID) ;
			$socialUsers = SocialUserPeer::doSelect($c) ;
			$socialUserMap = AdminTools::getMapForObjects($socialUsers) ;

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

		$this->mixeds = $mixeds ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->audioMap = $audioMap ;
		$this->videoMap = $videoMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->numberOfAudioLikes = $numberOfAudioLikes ;
		$this->audioCommentsMap = $audioCommentsMap ;
		$this->numberOfVideoLikes = $numberOfVideoLikes ;
		$this->videoCommentsMap = $videoCommentsMap ;
		$this->socialUserMap = $socialUserMap ;


	}




	public function executeListdelayed(sfWebRequest $request)
	{
		$this->prepareDelayedList($request,SUBSCRIPTION_ACTION_KIND_DELAYED_NORMAL) ;
	}

	public function executeListlongdelayed(sfWebRequest $request)
	{
		$this->prepareDelayedList($request,SUBSCRIPTION_ACTION_KIND_DELAYED_LONG) ;
	}


	public function prepareDelayedList($request,$kind)
	{
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}

		$allApps = AdminTools::getAppsForMcn($this->mcnId) ;

		$apps = $allApps ;

		$appMap = AdminTools::getMapForObjects($apps) ;
		$appIds = AdminTools::getIdsForObjects($apps) ;

	  	$c = new Criteria() ;
	  	$c->add(DelayPeer::DEL_FLAG,0) ;
	  	$c->add(DelayPeer::APP_ID,$appIds,Criteria::IN) ;
		if($kind == SUBSCRIPTION_ACTION_KIND_DELAYED_LONG){
		  	$c->add(DelayPeer::LEVEL,1) ;
		}
		$c->addDescendingOrderByColumn(DelayPeer::CREATED_AT) ;

		$pager = new sfPropelPager('Delay', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$delays = $pager->getResults() ;
		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}

		$this->delays = $delays ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->appMap = $appMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
	}



}
