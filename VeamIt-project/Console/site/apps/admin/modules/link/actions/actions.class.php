<?php

define('LINK_ACTION_KIND_NORMAL',1) ;

/**
 * link actions.
 *
 * @package    console
 * @subpackage link
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class linkActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListlinks(sfWebRequest $request)
	{
		$this->prepareLinkList($request,LINK_ACTION_KIND_NORMAL) ;
	}

	public function prepareLinkList(sfWebRequest $request,$kind)
	{
		$appId = $request->getParameter('a') ;
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}

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
	  	$c->add(WebPeer::DEL_FLAG,0) ;
	  	$c->add(WebPeer::APP_ID,$appIds,Criteria::IN) ;
		if($appId){
			$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
		} else {
			$c->addDescendingOrderByColumn(WebPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('Web', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$webs = array() ;
		if($page <= $lastPage){
			$webs = $pager->getResults() ;
		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}

		$this->webs = $webs ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
	}
}
