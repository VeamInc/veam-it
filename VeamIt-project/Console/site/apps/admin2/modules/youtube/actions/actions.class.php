<?php

define('YOUTUBE_ACTION_KIND_NORMAL',1) ;

/**
 * youtube actions.
 *
 * @package    console
 * @subpackage youtube
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class youtubeActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListvideos(sfWebRequest $request)
	{
		$this->prepareYoutubeVideoList($request,YOUTUBE_ACTION_KIND_NORMAL) ;
	}

	public function prepareYoutubeVideoList(sfWebRequest $request,$kind)
	{
		$appId = $request->getParameter('a') ;
		$categoryId = $request->getParameter('c') ;
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}
		$sortKind = $request->getParameter('so') ;


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


		$allCategories = AdminTools::getCategoriesForApps($apps) ;
		$categoryMap = AdminTools::getMapForObjects($allCategories) ;

		if($appId){
			$categoriesForList = $allCategories ;
		} else {
			$categoriesForList = array() ;
		}

		$appMap = AdminTools::getMapForObjects($apps) ;

	  	$c = new Criteria() ;
	  	$c->add(YoutubeVideoPeer::DEL_FLG,0) ;
	  	$c->add(YoutubeVideoPeer::CATEGORY_ID,0,Criteria::NOT_EQUAL) ;
	  	$c->add(YoutubeVideoPeer::APP_ID,$appIds,Criteria::IN) ;
		if($categoryId){
		  	$c->add(YoutubeVideoPeer::CATEGORY_ID,$categoryId) ;
			//$c->addAscendingOrderByColumn(YoutubeVideoPeer::DISPLAY_ORDER) ;
		} else {
			//$c->addDescendingOrderByColumn(YoutubeVideoPeer::CREATED_AT) ;
		}

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(YoutubeVideoPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(YoutubeVideoPeer::CREATED_AT) ;
		}


		$pager = new sfPropelPager('YoutubeVideo', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$youtubeVideos = array() ;
		if($page <= $lastPage){
			$youtubeVideos = $pager->getResults() ;
			//$youtubeVideoIds = AdminTools::getIdsForObjects($youtubeVideos) ;
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

		$this->youtubeVideos = $youtubeVideos ;
		$this->appId = $appId ;
		$this->categoryId = $categoryId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->categoriesForList = $categoriesForList ;
		$this->categoryMap = $categoryMap ;
		$this->appMap = $appMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;

	}
}
