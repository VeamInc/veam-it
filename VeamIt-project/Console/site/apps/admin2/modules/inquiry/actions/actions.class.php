<?php

define('INQUIRY_ACTION_KIND_FROM_APP_USER'		,1) ;
define('INQUIRY_ACTION_KIND_FROM_CREATOR'		,2) ;
define('INQUIRY_ACTION_KIND_REPLY'				,3) ;
define('INQUIRY_ACTION_KIND_SHOWDETAIL'			,4) ;
define('INQUIRY_ACTION_KIND_TO_APP_USER'		,5) ;
define('INQUIRY_ACTION_KIND_TO_CREATOR'			,6) ;


/**
 * inquiry actions.
 *
 * @package    console
 * @subpackage inquiry
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class inquiryActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListfromcreator(sfWebRequest $request)
	{
		$this->prepareInquirySet($request,INQUIRY_ACTION_KIND_FROM_CREATOR) ;
	}

	public function executeListfromappuser(sfWebRequest $request)
	{
		$this->prepareInquirySet($request,INQUIRY_ACTION_KIND_FROM_APP_USER) ;
	}


	public function executeListtocreator(sfWebRequest $request)
	{
		$this->prepareInquirySet($request,INQUIRY_ACTION_KIND_TO_CREATOR) ;
	}

	public function executeListtoappuser(sfWebRequest $request)
	{
		$this->prepareInquirySet($request,INQUIRY_ACTION_KIND_TO_APP_USER) ;
	}


	public function prepareInquirySet(sfWebRequest $request,$kind)
	{
		$appId = $request->getParameter('a') ;
		$page = $request->getParameter('p') ;
		$status = $request->getParameter('s') ;
		$inquirySetId = $request->getParameter('i') ;
		if(!$page){
			$page = 1 ;
		}

		if($kind == INQUIRY_ACTION_KIND_FROM_APP_USER){
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
		  	$c->add(AppPeer::STATUS,1,Criteria::NOT_EQUAL) ;
		  	$c->addAnd(AppPeer::STATUS,4,Criteria::NOT_EQUAL) ;
		  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
			$c->addAscendingOrderByColumn(AppPeer::ID) ;
			$allApps = AppPeer::doSelect($c) ;
		} else {
			$allApps = AdminTools::getReleasedAppsForMcn($this->mcnId) ;
		}

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

	  	$c = new Criteria() ;
	  	$c->add(InquirySetPeer::DEL_FLAG,0) ;
		if(($kind == INQUIRY_ACTION_KIND_REPLY) || ($kind == INQUIRY_ACTION_KIND_SHOWDETAIL)){
		  	$c->add(InquirySetPeer::ID,$inquirySetId) ;
		} else {
			if($kind == INQUIRY_ACTION_KIND_FROM_APP_USER){
			  	//$c->add(InquirySetPeer::KIND,1) ;
			    $c->addJoin(InquiryPeer::INQUIRY_SET_ID, InquirySetPeer::ID) ;
			  	$c->add(InquiryPeer::KIND,1) ; // from app user
			} else if($kind == INQUIRY_ACTION_KIND_FROM_CREATOR){
			  	//$c->add(InquirySetPeer::KIND,2) ;
			    $c->addJoin(InquiryPeer::INQUIRY_SET_ID, InquirySetPeer::ID) ;
			  	$c->add(InquiryPeer::KIND,2) ; // from creator
			} else if($kind == INQUIRY_ACTION_KIND_TO_APP_USER){
			    $c->addJoin(InquiryPeer::INQUIRY_SET_ID, InquirySetPeer::ID) ;
			  	$c->add(InquiryPeer::KIND,3) ; // to app user
			} else if($kind == INQUIRY_ACTION_KIND_TO_CREATOR){
			    $c->addJoin(InquiryPeer::INQUIRY_SET_ID, InquirySetPeer::ID) ;
			  	$c->add(InquiryPeer::KIND,4) ; // to creator
			}

			if($status){
			  	$c->add(InquirySetPeer::STATUS,$status) ;
			}

		  	$c->add(InquirySetPeer::APP_ID,$appIds,Criteria::IN) ;
			$c->addDescendingOrderByColumn(InquirySetPeer::UPDATED_AT) ;
		}

		$c->setDistinct() ;

		$pager = new sfPropelPager('InquirySet',10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$inquiriesForInquirySetId = array() ;
		if($page <= $lastPage){
			$inquirySets = $pager->getResults() ;

			$inquirySetIds = AdminTools::getIdsForObjects($inquirySets) ;

		  	$c = new Criteria() ;
		  	$c->add(InquiryPeer::DEL_FLAG,0) ;
			$c->add(InquiryPeer::INQUIRY_SET_ID,$inquirySetIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(InquiryPeer::ID) ;
			$inquiries = InquiryPeer::doSelect($c) ;
			foreach($inquiries as $inquiry){
				if(!isset($inquiriesForInquirySetId[$inquiry->getInquirySetId()])){
					$inquiriesForInquirySetId[$inquiry->getInquirySetId()] = array() ;
				}
				$inquiriesForInquirySetId[$inquiry->getInquirySetId()][] = $inquiry ;
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

		$this->inquiriesForInquirySetId = $inquiriesForInquirySetId ;
		$this->inquirySets = $inquirySets ;
		$this->appId = $appId ;
		$this->status = $status ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
	}


	public function executeReplytoappuser(sfWebRequest $request)
	{
		$inquirySetId = $request->getParameter('i') ;
		$inquirySetToken = $request->getParameter('t') ;

		$inquirySet = InquirySetPeer::retrieveByPk($inquirySetId) ;
		if($inquirySet && ($inquirySet->getToken() == $inquirySetToken)){
			$this->prepareInquirySet($request,INQUIRY_ACTION_KIND_REPLY) ;
			$this->inquirySetId = $inquirySetId ;
			$this->inquirySetToken = $inquirySetToken ;
		} else {
			return sfView::NONE ;
		}
	}

	public function executeSetstatus(sfWebRequest $request)
	{
		$inquirySetId = $request->getParameter('i') ;
		$inquirySetToken = $request->getParameter('t') ;
		$status = $request->getParameter('s') ;

		$inquirySet = InquirySetPeer::retrieveByPk($inquirySetId) ;
		if($inquirySet && ($inquirySet->getToken() == $inquirySetToken)){
			$inquirySet->setStatus($status) ;
			$inquirySet->save() ;
			$this->forward('inquiry','showdetail') ;
		} else {
			return sfView::NONE ;
		}
	}

	public function executeShowdetail(sfWebRequest $request)
	{
		$inquirySetId = $request->getParameter('i') ;
		$inquirySetToken = $request->getParameter('t') ;

		$inquirySet = InquirySetPeer::retrieveByPk($inquirySetId) ;
		if($inquirySet && ($inquirySet->getToken() == $inquirySetToken)){
			$this->prepareInquirySet($request,INQUIRY_ACTION_KIND_SHOWDETAIL) ;
			$this->inquirySetId = $inquirySetId ;
			$this->inquirySetToken = $inquirySetToken ;
		} else {
			return sfView::NONE ;
		}
	}

	public function executeSendreply(sfWebRequest $request)
	{
		$inquirySetId = $request->getParameter('i') ;
		$inquirySetToken = $request->getParameter('t') ;

		$inquirySet = InquirySetPeer::retrieveByPk($inquirySetId) ;
		if($inquirySet && ($inquirySet->getToken() == $inquirySetToken)){
			$reply = $request->getParameter('r') ;

			// send mail
			$kind = $inquirySet->getKind() ;
			$inquiryKind = 0 ;
			if(($kind == 1) || ($kind == 3)){ // from app user
				AdminTools::sendMailToAppUser($this->mcnId,$inquirySet,$reply) ;
				$inquiryKind = 3 ; // from MCN to app user
			} else if(($kind == 2) || ($kind == 4)){
				AdminTools::sendMailToCreator($this->mcnId,$inquirySet,$reply) ;
				$inquiryKind = 4 ; // from MCN to creator
			} else {
				AdminTools::assert(false,"invalid inquirySet kind=$kind",__FILE__,__LINE__) ;
			}

			$inquirySet->setStatus(2) ; // responded
			$inquirySet->save() ;

			$inquiry = new Inquiry() ;
			$inquiry->setAppId($inquirySet->getAppId()) ;
			$inquiry->setInquirySetId($inquirySet->getId()) ;
			$inquiry->setKind($inquiryKind) ;
			$inquiry->setUserName($this->getUser()->getUsername()) ;
			$inquiry->setMessage($reply) ;
			$inquiry->setIpAddress($_SERVER['REMOTE_ADDR']) ;
			$inquiry->save() ;

			$this->forward('inquiry','showdetail') ;

		} else {
			return sfView::NONE ;
		}
	}


	public function executeComposetocreator(sfWebRequest $request)
	{
		$apps = AdminTools::getReleasedAppsForMcn($this->mcnId) ;
		$appIds = AdminTools::getIdsForObjects($apps) ;
		$appMap = AdminTools::getMapForObjects($apps) ;
	  	$c = new Criteria() ;
	  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		$c->add(AppCreatorPeer::APP_ID,$appIds,Criteria::IN) ;
		$c->addDescendingOrderByColumn(AppCreatorPeer::APP_ID) ;
		$appCreators = AppCreatorPeer::doSelect($c) ;

		$this->appMap = $appMap ;
		$this->appCreators = $appCreators ;

	}

	public function executeComposetoappuser(sfWebRequest $request)
	{
		$apps = AdminTools::getReleasedAppsForMcn($this->mcnId) ;
		$appIds = AdminTools::getIdsForObjects($apps) ;
		$appMap = AdminTools::getMapForObjects($apps) ;

		$this->apps = $apps ;
	}

	public function executeSendmessage(sfWebRequest $request)
	{
		$appCreatorId = $request->getParameter('c') ;
		$email = $request->getParameter('e') ;
		$appId = $request->getParameter('a') ;
		$subject = $request->getParameter('s') ;
		$message = $request->getParameter('m') ;


		if($appCreatorId){
			$appCreator = AppCreatorPeer::retrieveByPk($appCreatorId) ;
			if($appCreator){
				$app = AppPeer::retrieveByPk($appCreator->getAppId()) ;
			}
		} else if($email && $appId){
			$app = AppPeer::retrieveByPk($appId) ;
		}

		if($app && ($app->getMcnId() == $this->mcnId)){
			$appId = $app->getId() ;

			$inquiryKind = 0 ; 
			if($email){ // to app user
				$inquirySet = new InquirySet() ;
				$inquirySet->setAppId($appId) ;
				$inquirySet->setToken(strtolower(sha1(sprintf("VEAM%d%04d",time(),rand(0,9999))))) ;
				$inquirySet->setKind(3) ; // from MCN to app user
				$inquirySet->setEmail($email) ;
				$inquirySet->setSubject($subject) ;
				$inquirySet->setStatus(2) ; // responded
				$inquirySet->save() ;

				AdminTools::sendMailToAppUser($this->mcnId,$inquirySet,$message) ;

				$inquiry = new Inquiry() ;
				$inquiry->setAppId($appId) ;
				$inquiry->setInquirySetId($inquirySet->getId()) ;
				$inquiry->setKind(3) ; // from MCN to app user
				$inquiry->setMessage($message) ;
				$inquiry->setUserName($this->getUser()->getUsername()) ;
				$inquiry->setIpAddress($_SERVER['REMOTE_ADDR']) ;
				$inquiry->save() ;

			} else if($appCreator){
				$inquirySet = new InquirySet() ;
				$inquirySet->setAppId($appId) ;
				$inquirySet->setToken(strtolower(sha1(sprintf("VEAM%d%04d",time(),rand(0,9999))))) ;
				$inquirySet->setKind(4) ; // from MCN to creator
				$inquirySet->setEmail($appCreator->getUsername()) ;
				$inquirySet->setSubject($subject) ;
				$inquirySet->setStatus(2) ; // responded
				$inquirySet->save() ;

				AdminTools::sendMailToCreator($this->mcnId,$inquirySet,$message) ;

				$inquiry = new Inquiry() ;
				$inquiry->setAppId($appId) ;
				$inquiry->setInquirySetId($inquirySet->getId()) ;
				$inquiry->setKind(4) ; // from MCN to creator
				$inquiry->setMessage($message) ;
				$inquiry->setUserName($this->getUser()->getUsername()) ;
				$inquiry->setIpAddress($_SERVER['REMOTE_ADDR']) ;
				$inquiry->save() ;
			} else {
				AdminTools::assert(false,"invalid inquirySet kind=$kind",__FILE__,__LINE__) ;
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}

		$request->setParameter('i',$inquirySet->getId()) ;
		$request->setParameter('t',$inquirySet->getToken()) ;
		$this->forward('inquiry','showdetail') ;

	}


}
