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
	public function executeShowsummary(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app && ($app->getMcnId() == $this->mcnId)){

			$this->app = $app ;

			//// subscription
		  	$c = new Criteria() ;
		  	$c->add(MixedPeer::DEL_FLG,0) ;
		  	$c->add(MixedPeer::APP_ID,$appId) ;
		  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
			$c->addDescendingOrderByColumn(MixedPeer::UPDATED_AT) ;
			$c->setLimit(3) ;
			$mixeds = MixedPeer::doSelect($c) ;
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
			}

			if(count($videoIds) > 0){
			  	$c = new Criteria() ;
			  	$c->add(VideoPeer::DEL_FLG,0) ;
			  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
				$videos = VideoPeer::doSelect($c) ;
				if($videos){
					$videoMap = AdminTools::getMapForObjects($videos) ;
				}
			}

			$this->mixeds = $mixeds ;
			$this->audioMap = $audioMap ;
			$this->videoMap = $videoMap ;

			//// youtube
		  	$c = new Criteria() ;
		  	$c->add(CategoryPeer::DEL_FLG,0) ;
		  	$c->add(CategoryPeer::DISABLED,0) ;
		  	$c->add(CategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
			$youtubeCategories = CategoryPeer::doSelect($c) ;

			$this->youtubeCategories = $youtubeCategories ;


			//// forum
		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
		  	$c->add(ForumPeer::KIND,1) ;
			$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
			$forums = ForumPeer::doSelect($c) ;
			$forumMap = AdminTools::getMapForObjects($forums) ;

			$this->forums = $forums ;
			$this->forumMap = $forumMap ;



			//// report from users
		  	$c = new Criteria() ;
		  	$c->add(ReportSetPeer::DEL_FLG,0) ;
		  	$c->add(ReportSetPeer::KIND,1) ;
		  	$c->add(ReportSetPeer::APP_ID,$appId) ;
			$c->addDescendingOrderByColumn(ReportSetPeer::LAST_REPORTED_AT) ;
			$c->setLimit(2) ;
			$reportSets = ReportSetPeer::doSelect($c) ;

			$socialUserIds = array() ;
			$reportsForReportSetId = array() ;
			if(count($reportSets) > 0){
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

			  	$c = new Criteria() ;
			  	$c->add(SocialUserPeer::DEL_FLG,0) ;
				$c->add(SocialUserPeer::ID,$socialUserIds,Criteria::IN) ;
				$c->addAscendingOrderByColumn(SocialUserPeer::ID) ;
				$socialUsers = SocialUserPeer::doSelect($c) ;
				$socialUserMap = AdminTools::getMapForObjects($socialUsers) ;


				$pictureIds = array() ;
				foreach($reportSets as $reportSet){
					$pictureIds[] = $reportSet->getContent() ;
				}
			  	$c = new Criteria() ;
				$c->add(PicturePeer::ID,$pictureIds,Criteria::IN) ;
				$c->addAscendingOrderByColumn(PicturePeer::ID) ;
				$pictures = PicturePeer::doSelect($c) ;
				$pictureMap = AdminTools::getMapForObjects($pictures) ;
			}


			$this->reportSets = $reportSets ;
			$this->reportsForReportSetId = $reportsForReportSetId ;
			$this->pictureMap = $pictureMap ;
			$this->socialUserMap = $socialUserMap ;


			//// link
		  	$c = new Criteria() ;
		  	$c->add(WebPeer::DEL_FLAG,0) ;
		  	$c->add(WebPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
			$webs = WebPeer::doSelect($c) ;

			$this->webs = $webs ;


			//// app store information
		  	$c = new Criteria() ;
		  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
			$c->addAscendingOrderByColumn(AppRatingQuestionPeer::DISPLAY_ORDER) ;
			$appRatingQuestions = AppRatingQuestionPeer::doSelect($c) ;

		  	$c = new Criteria() ;
		  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
		  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
			$appRatingAnswers = AppRatingAnswerPeer::doSelect($c) ;
			$appRatingAnswerMapForQuestion = array() ;
			foreach($appRatingAnswers as $appRatingAnswer){
				$appRatingAnswerMapForQuestion[$appRatingAnswer->getAppRatingQuestionId()] = $appRatingAnswer ;
			}

			$this->appRatingQuestions = $appRatingQuestions ;
			$this->appRatingAnswerMapForQuestion = $appRatingAnswerMapForQuestion ;



		} else {
			return sfView::NONE ;
		}
	}
}
