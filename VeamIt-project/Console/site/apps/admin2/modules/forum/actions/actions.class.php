<?php

define('FORUM_ACTION_KIND_NORMAL',1) ;
define('FORUM_ACTION_KIND_REMOVED',2) ;

/**
 * forum actions.
 *
 * @package    console
 * @subpackage forum
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class forumActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executePosts(sfWebRequest $request)
	{
		$this->preparePictureList($request,FORUM_ACTION_KIND_NORMAL) ;
	}

	public function executeRemovedposts(sfWebRequest $request)
	{
		$this->preparePictureList($request,FORUM_ACTION_KIND_REMOVED) ;
	}

	public function preparePictureList(sfWebRequest $request,$kind)
	{
		$appId = $request->getParameter('a') ;
		$forumId = $request->getParameter('f') ;
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}
		$sortKind = $request->getParameter('so') ;

		$allApps = AdminTools::getReleasedAppsForMcn($this->mcnId) ;

		$forumsForList = array() ;
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

		$forums = AdminTools::getForumsForApps($apps) ;
		$forumIds = AdminTools::getIdsForObjects($forums) ;
		$forumMap = AdminTools::getMapForObjects($forums) ;


	  	$c = new Criteria() ;
		if($kind == FORUM_ACTION_KIND_REMOVED){
		  	$c->add(PicturePeer::DEL_FLAG,2) ;
		} else {
		  	$c->add(PicturePeer::DEL_FLAG,0) ;
		}
		if($forumId){
		  	$c->add(PicturePeer::FORUM_ID,$forumId) ;
		} else {
		  	$c->add(PicturePeer::FORUM_ID,$forumIds,Criteria::IN) ;
		}

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(PicturePeer::ID) ;
		} else {
			$c->addDescendingOrderByColumn(PicturePeer::ID) ;
		}

		$pager = new sfPropelPager('Picture', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;


		$socialUserIds = array() ;
		if($page <= $lastPage){
			$pictures = $pager->getResults() ;

			$pictureIds = AdminTools::getIdsForObjects($pictures) ;

			$commentsForPictureId = array() ;
		  	$c = new Criteria() ;
		  	//$c->add(PictureCommentPeer::DEL_FLAG,0) ;
			$c->add(PictureCommentPeer::PICTURE_ID,$pictureIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(PictureCommentPeer::ID) ;
			$comments = PictureCommentPeer::doSelect($c) ;
			foreach($comments as $comment){
				if(!isset($commentsForPictureId[$comment->getPictureId()])){
					$commentsForPictureId[$comment->getPictureId()] = array() ;
				}
				$commentsForPictureId[$comment->getPictureId()][] = $comment ;

				$socialUserId = $comment->getSocialUserId() ;
				if($socialUserId){
					if(!in_array($socialUserId,$socialUserIds)){
						$socialUserIds[] = $socialUserId ;
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

		$uri = $request->getUri() ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$this->uri = $uri ;
		$this->commentsForPictureId = $commentsForPictureId ;
		$this->pictures = $pictures ;
		$this->appId = $appId ;
		$this->forumId = $forumId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->forums = $forums ;
		$this->forumMap = $forumMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->socialUserMap = $socialUserMap ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
	}

	public function executeDeletepost(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$page = $request->getParameter('p') ;
		$pictureId = $request->getParameter('pid') ;

		// need permission to delete picture
		$picture = PicturePeer::retrieveByPk($pictureId) ;
		if($picture && ($picture->getDelFlag() == 0)){
			$forumId = $picture->getForumId() ;
			$targetMcnId = AdminTools::getMcnIdForForum($forumId) ;
			if($targetMcnId == $this->mcnId){
				$picture->setDelFlag(2) ;
				$picture->save() ;

				$forum = ForumPeer::retrieveByPk($forumId) ;
				if($forum){
					$appId = $forum->getAppId() ;
				}
				$socialUserId = $picture->getSocialUserId() ;

				$socialUser = SocialUserPeer::retrieveByPk($socialUserId) ;
				if($socialUser){
					$numberOfPictures = $socialUser->getNumberOfPictures() ;
					$numberOfPictures-- ;
					if($numberOfPictures < 0){
						$numberOfPictures = 0 ;
					}
					$socialUser->setNumberOfPictures($numberOfPictures) ;
					$socialUser->save() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(ReportSetPeer::DEL_FLG,0) ;
			  	$c->add(ReportSetPeer::KIND,1) ; // picture
			  	$c->add(ReportSetPeer::CONTENT,$pictureId) ;
				$c->addAscendingOrderByColumn(ReportSetPeer::ID) ;
				$reportSet = ReportSetPeer::doSelectOne($c) ;
				if($reportSet){
					$reportSet->setRemoved(1) ;
					$reportSet->save() ;
				}

				$message = sprintf("Picture deleted\nid=%s\nforum_id=%s\nsocial_user_id=%s\nnumber_of_likes=%s\nurl=%s\ndel_flag=%s\ncreated_at=%s\nupdated_at=%s\nadmin_user=%s",
							$picture->getId(),$picture->getForumId(),$picture->getSocialUserId(),$picture->getNumberOfLikes(),$picture->getUrl(),$picture->getDelFlag(),$picture->getCreatedAt(),$picture->getUpdatedAt(),$this->getUser()->getUsername()) ;
				$this->logMessage($message, 'info');

				ConsoleTools::forumChanged($forumId,$appId) ;
				ConsoleTools::someonesPostChanged($socialUserId) ;
			}
		}

		$this->forward('forum','posts') ;
	}


	public function executeDeletecomment(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$page = $request->getParameter('p') ;
		$pictureId = $request->getParameter('pid') ;
		$commentId = $request->getParameter('cid') ;

		// need permission to delete picture
		$picture = PicturePeer::retrieveByPk($pictureId) ;
		if($picture && ($picture->getDelFlag() == 0)){
			$forumId = $picture->getForumId() ;
			$targetMcnId = AdminTools::getMcnIdForForum($forumId) ;
			if($targetMcnId == $this->mcnId){
				$comment = PictureCommentPeer::retrieveByPk($commentId) ;
				if($comment->getPictureId() == $pictureId){
					$comment->setDelFlag(1) ;
					$comment->save() ;

					$forum = ForumPeer::retrieveByPk($forumId) ;
					if($forum){
						$appId = $forum->getAppId() ;
					}

					$message = sprintf("Comment deleted\nid=%s\npictgure_id=%s\nforum_id=%s\nsocial_user_id=%s\nnumber_of_likes=%s\nurl=%s\ndel_flag=%s\ncreated_at=%s\nupdated_at=%s\nadmin_user=%s",
								$comment->getId(),$picture->getId(),$picture->getForumId(),$picture->getSocialUserId(),$picture->getNumberOfLikes(),$picture->getUrl(),$picture->getDelFlag(),$picture->getCreatedAt(),$picture->getUpdatedAt(),$this->getUser()->getUsername()) ;
					$this->logMessage($message, 'info');

					ConsoleTools::forumChanged($forumId,$appId) ;
					ConsoleTools::someonesPostChanged($picture->getSocialUserId()) ;
				}
			}
		}

		$this->forward('forum','posts') ;
	}


	public function executeReports(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}

		$allApps = AdminTools::getReleasedAppsForMcn($this->mcnId) ;

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

		$appIds = AdminTools::getIdsForObjects($apps) ;
		$appMap = AdminTools::getMapForObjects($apps) ;

		$forums = AdminTools::getForumsForApps($apps) ;
		$forumIds = AdminTools::getIdsForObjects($forums) ;
		$forumMap = AdminTools::getMapForObjects($forums) ;

	  	$c = new Criteria() ;
	  	$c->add(ReportSetPeer::DEL_FLG,0) ;
	  	$c->add(ReportSetPeer::KIND,1) ;
	  	$c->add(ReportSetPeer::APP_ID,$appIds,Criteria::IN) ;
		$c->addDescendingOrderByColumn(ReportSetPeer::LAST_REPORTED_AT) ;

		$pager = new sfPropelPager('ReportSet',10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$socialUserIds = array() ;
		$reportsForReportSetId = array() ;
		if($page <= $lastPage){
			$reportSets = $pager->getResults() ;

			$reportSetIds = AdminTools::getIdsForObjects($reportSets) ;

		  	$c = new Criteria() ;
		  	$c->add(ReportPeer::DEL_FLG,0) ;
			$c->add(ReportPeer::REPORT_SET_ID,$reportSetIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(ReportPeer::ID) ;
			$reports = ReportPeer::doSelect($c) ;
			foreach($reports as $report){
				if(!isset($reportsForReportSetId[$report->getReportSetId()])){
					$reportsForReportSetId[$report->getReportSetId()] = array() ;
				}
				$reportsForReportSetId[$report->getReportSetId()][] = $report ;

				$socialUserId = $report->getSocialUserId() ;
				if($socialUserId){
					if(!in_array($socialUserId,$socialUserIds)){
						$socialUserIds[] = $socialUserId ;
					}
				}
			}

			$pictureIds = array() ;
			foreach($reportSets as $reportSet){
				$pictureIds[] = $reportSet->getContent() ;
			}
		  	$c = new Criteria() ;
			$c->add(PicturePeer::ID,$pictureIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(PicturePeer::ID) ;
			$pictures = PicturePeer::doSelect($c) ;
			$pictureMap = AdminTools::getMapForObjects($pictures) ;

			$commentsForPictureId = array() ;
		  	$c = new Criteria() ;
		  	//$c->add(PictureCommentPeer::DEL_FLAG,0) ;
			$c->add(PictureCommentPeer::PICTURE_ID,$pictureIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(PictureCommentPeer::ID) ;
			$comments = PictureCommentPeer::doSelect($c) ;
			foreach($comments as $comment){
				if(!isset($commentsForPictureId[$comment->getPictureId()])){
					$commentsForPictureId[$comment->getPictureId()] = array() ;
				}
				$commentsForPictureId[$comment->getPictureId()][] = $comment ;

				$socialUserId = $comment->getSocialUserId() ;
				if($socialUserId){
					if(!in_array($socialUserId,$socialUserIds)){
						$socialUserIds[] = $socialUserId ;
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

		$this->commentsForPictureId = $commentsForPictureId ;
		$this->reportsForReportSetId = $reportsForReportSetId ;
		$this->reportSets = $reportSets ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->forumMap = $forumMap ;
		$this->pictureMap = $pictureMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->socialUserMap = $socialUserMap ;

	}



	public function executeUser(sfWebRequest $request)
	{

		$socialUserId = $request->getParameter('i') ;
		$socialUser = SocialUserPeer::retrieveByPk($socialUserId) ;
		if($socialUser){

			$forumsForList = array() ;
			$apps = array() ;
			$app = AppPeer::retrieveByPk($socialUser->getAppId()) ;
			if($app->getMcnId() != $this->mcnId){
				$request->setParameter('m','Invalid app') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}
			$apps[] = $app ;
			$appMap = AdminTools::getMapForObjects($apps) ;

			$forums = AdminTools::getForumsForApps($apps) ;
			$forumIds = AdminTools::getIdsForObjects($forums) ;
			$forumMap = AdminTools::getMapForObjects($forums) ;


		  	$c = new Criteria() ;
		  	$c->add(PicturePeer::DEL_FLAG,0) ;
		  	$c->add(PicturePeer::SOCIAL_USER_ID,$socialUserId) ;
			$c->addDescendingOrderByColumn(PicturePeer::ID) ;
			$c->setLimit(100) ;
			$pictures = PicturePeer::doSelect($c) ;

			$socialUserIds = array() ;

			$pictureIds = AdminTools::getIdsForObjects($pictures) ;

			$commentsForPictureId = array() ;
		  	$c = new Criteria() ;
			$c->add(PictureCommentPeer::PICTURE_ID,$pictureIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(PictureCommentPeer::ID) ;
			$comments = PictureCommentPeer::doSelect($c) ;
			foreach($comments as $comment){
				if(!isset($commentsForPictureId[$comment->getPictureId()])){
					$commentsForPictureId[$comment->getPictureId()] = array() ;
				}
				$commentsForPictureId[$comment->getPictureId()][] = $comment ;

				$socialUserId = $comment->getSocialUserId() ;
				if($socialUserId){
					if(!in_array($socialUserId,$socialUserIds)){
						$socialUserIds[] = $socialUserId ;
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

		$uri = $request->getUri() ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$this->uri = $uri ;
		$this->commentsForPictureId = $commentsForPictureId ;
		$this->pictures = $pictures ;
		$this->appId = $appId ;
		$this->forumId = $forumId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->forums = $forums ;
		$this->forumMap = $forumMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->socialUserMap = $socialUserMap ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->targetSocialUser = $socialUser ;

	}



	public function executeBlockuser(sfWebRequest $request)
	{
		$socialUserId = $request->getParameter('i') ;
		$removeContent = $request->getParameter('r') ;

		$socialUser = SocialUserPeer::retrieveByPk($socialUserId) ;
		if($socialUser){
			$appId = $socialUser->getAppId() ;
			$apps = array() ;
			$app = AppPeer::retrieveByPk($appId) ;
			if($app->getMcnId() != $this->mcnId){
				$request->setParameter('m','Invalid app') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			$socialUser->setBlockLevel(1) ;
			$socialUser->save() ;

			if($removeContent){
			  	$c = new Criteria() ;
			  	$c->add(PicturePeer::DEL_FLAG,0) ;
			  	$c->add(PicturePeer::SOCIAL_USER_ID,$socialUserId) ; // picture
				$pictures = PicturePeer::doSelect($c) ;
				foreach($pictures as $picture){
					$picture->setDelFlag(2) ;
					$picture->save() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(PictureCommentPeer::DEL_FLAG,0) ;
			  	$c->add(PictureCommentPeer::SOCIAL_USER_ID,$socialUserId) ;
				$comments = PictureCommentPeer::doSelect($c) ;
				foreach($comments as $comment){
					$comment->setDelFlag(2) ;
					$comment->save() ;
				}

			}

			$apps = array() ;
			$apps[] = $app ;
			$forums = AdminTools::getForumsForApps($apps) ;

			foreach($forums as $forum){
				ConsoleTools::forumChanged($forum->getId(),$appId) ;
			}
			ConsoleTools::someonesPostChanged($socialUserId) ;
			ConsoleTools::blockedUserChanged($socialUser->getAppId()) ;
		}

		$this->forward('forum','user') ;
	}




}

