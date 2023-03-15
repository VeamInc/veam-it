<?php

define('MESSAGE_ACTION_KIND_FROM_APP_USER'		,1) ;
define('MESSAGE_ACTION_KIND_FROM_CREATOR'		,2) ;
define('MESSAGE_ACTION_KIND_REPLY'				,3) ;
define('MESSAGE_ACTION_KIND_SHOWDETAIL'			,4) ;
define('MESSAGE_ACTION_KIND_TO_APP_USER'		,5) ;
define('MESSAGE_ACTION_KIND_TO_CREATOR'			,6) ;


/**
 * message actions.
 *
 * @package    console
 * @subpackage message
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class messageActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListfromcreator(sfWebRequest $request)
	{
		$this->prepareMessageSet($request,MESSAGE_ACTION_KIND_FROM_CREATOR) ;
	}

	public function executeListtocreator(sfWebRequest $request)
	{
		$this->prepareMessageSet($request,MESSAGE_ACTION_KIND_TO_CREATOR) ;
	}

	public function prepareMessageSet(sfWebRequest $request,$kind)
	{
		$appId = $request->getParameter('a') ;
		$page = $request->getParameter('p') ;
		$appCreatorId = $request->getParameter('c') ;
		if(!$page){
			$page = 1 ;
		}

		//$allApps = AdminTools::getAppsForMcn($this->mcnId) ;

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

		//$appIds = AdminTools::getIdsForObjects($apps) ;
		//$appMap = AdminTools::getMapForObjects($apps) ;

	  	$c = new Criteria() ;
	  	$c->add(AppCreatorMessageLatestPeer::DEL_FLG,0) ;
		if($kind == MESSAGE_ACTION_KIND_FROM_CREATOR){
		    $c->add(AppCreatorMessageLatestPeer::DIRECTION, 1) ;
		} else if($kind == MESSAGE_ACTION_KIND_TO_CREATOR){
		    $c->add(AppCreatorMessageLatestPeer::DIRECTION, 2) ;
		}

		if($appId){
		    $c->add(AppCreatorMessageLatestPeer::APP_ID, $appId) ;
		} else {
		  	//$c->add(AppCreatorMessageLatestPeer::APP_ID,$appIds,Criteria::IN) ;
		  	$c->addJoin(AppCreatorMessageLatestPeer::APP_ID,AppPeer::ID) ;
		  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
		}

		$c->addDescendingOrderByColumn(AppCreatorMessageLatestPeer::UPDATED_AT) ;

		$pager = new sfPropelPager('AppCreatorMessageLatest',10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$appCreatorMessageLatests = $pager->getResults() ;
			$appCreatorIds = array() ;
			foreach($appCreatorMessageLatests as $appCreatorMessageLatest){
				$appCreatorIds[] = $appCreatorMessageLatest->getAppCreatorId() ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::ID,$appCreatorIds,Criteria::IN) ;
			$appCreators = AppCreatorPeer::doSelect($c) ;
			$appCreatorMap = AdminTools::getMapForObjects($appCreators) ;

		  	$c = new Criteria() ;
		  	$c->add(AppCreatorMessagePeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorMessagePeer::APP_CREATOR_ID,$appCreatorIds,Criteria::IN) ;
			$c->addDescendingOrderByColumn(AppCreatorMessagePeer::UPDATED_AT) ;
			$appCreatorMessages = AppCreatorMessagePeer::doSelect($c) ;
			$appCreatorMessagesMap = array() ;
			foreach($appCreatorMessages as $appCreatorMessage){
				$appCreatorId = $appCreatorMessage->getAppCreatorId() ;
				if(!$appCreatorMessagesMap[$appCreatorId]){
					$appCreatorMessagesMap[$appCreatorId] = array() ;
				}
				if(count($appCreatorMessagesMap[$appCreatorId]) < 5){
					$appCreatorMessagesMap[$appCreatorId][] = $appCreatorMessage ;
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

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
	  	$c->addJoin(AppPeer::ID,AppCreatorMessageLatestPeer::APP_ID) ;
	  	$c->add(AppCreatorMessageLatestPeer::DEL_FLG,0) ;
		if($kind == MESSAGE_ACTION_KIND_FROM_CREATOR){
		    $c->add(AppCreatorMessageLatestPeer::DIRECTION, 1) ;
		} else if($kind == MESSAGE_ACTION_KIND_TO_CREATOR){
		    $c->add(AppCreatorMessageLatestPeer::DIRECTION, 2) ;
		}
		$allApps = AppPeer::doSelect($c) ;
		$appMap = AdminTools::getMapForObjects($allApps) ;

		$this->appCreatorMessageLatests = $appCreatorMessageLatests ;
		$this->appCreatorMessagesMap = $appCreatorMessagesMap ;
		$this->appCreatorMap = $appCreatorMap ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
	}



	public function executeReply(sfWebRequest $request)
	{
		$appCreatorId = $request->getParameter('c') ;

		$appCreator = AppCreatorPeer::retrieveByPk($appCreatorId) ;
		if($appCreator){
			$this->prepareMessageSet($request,MESSAGE_ACTION_KIND_REPLY) ;
			$this->appCreator = $appCreator ;
			$this->appCreatorId = $appCreatorId ;
		} else {
			return sfView::NONE ;
		}
	}


	public function executeSendreply(sfWebRequest $request)
	{
		$appCreatorId = $request->getParameter('c') ;

		$appCreator = AppCreatorPeer::retrieveByPk($appCreatorId) ;
		if($appCreator){
			$reply = $request->getParameter('r') ;
			$appId = $appCreator->getAppId() ;

			$app = AppPeer::retrieveByPk($appId) ;
			if($app){

				AdminTools::sendMessageToAppCreator($appCreator,$reply,0,$this->getUser()->getUsername()) ;
				/*
				$appCreatorMessage = new AppCreatorMessage() ;
				$appCreatorMessage->setAppId($appId) ;
				$appCreatorMessage->setAppCreatorId($appCreator->getId()) ;
				$appCreatorMessage->setMcnId($app->getMcnId()) ;
				$appCreatorMessage->setMcnUserName($this->getUser()->getUsername()) ;
				$appCreatorMessage->setDirection(2) ; // MCN to Creator
				$appCreatorMessage->setKind(0) ;
				$appCreatorMessage->setMessage($reply) ;
				$appCreatorMessage->save() ;
				$appCreatorMessageId = $appCreatorMessage->getId() ;

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
					$appCreatorMessageLatest->setMcnUserName($this->getUser()->getUsername()) ;
					$appCreatorMessageLatest->setDirection(2) ; // MCN to Creator
					$appCreatorMessageLatest->setKind(0) ;
				}
				$appCreatorMessageLatest->setMessage($reply) ;
				$appCreatorMessageLatest->save() ;
				*/
			}

			$this->forward('message','showdetail') ;

		} else {
			return sfView::NONE ;
		}
	}

	public function executeShowdetail(sfWebRequest $request)
	{
		$appCreatorId = $request->getParameter('c') ;

		$appCreator = AppCreatorPeer::retrieveByPk($appCreatorId) ;
		if($appCreator){
			$page = $request->getParameter('p') ;
			if(!$page){
				$page = 1 ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppCreatorMessagePeer::DEL_FLG,0) ;

		  	$c->add(AppCreatorMessagePeer::APP_CREATOR_ID,$appCreatorId) ;
			$c->addDescendingOrderByColumn(AppCreatorMessagePeer::UPDATED_AT) ;

			$pager = new sfPropelPager('AppCreatorMessage',10) ;
			$pager->setCriteria($c) ;
			$pager->setPage($page) ;
			$pager->init() ;

			$lastPage = $pager->getLastPage() ;

			if($page <= $lastPage){
				$appCreatorMessages = $pager->getResults() ;
			}

			$startPage = $page - 4 ;
			if($startPage <= 0){
				$startPage = 1 ;
			}
			$endPage = $startPage + 8 ;
			if($endPage > $lastPage){
				$endPage = $lastPage ;
			}

			$this->appCreatorId = $appCreatorId ;
			$this->appCreator = $appCreator ;
			$this->appCreatorMessages = $appCreatorMessages ;
			$this->page = $page ;
			$this->lastPage = $lastPage ;
			$this->startPage = $startPage ;
			$this->endPage = $endPage ;
		}
	}

	public function executeComposetocreator(sfWebRequest $request)
	{
		$apps = AdminTools::getAppsForMcn($this->mcnId) ;
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



}
