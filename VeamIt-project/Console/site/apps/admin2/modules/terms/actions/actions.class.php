<?php

/**
 * terms actions.
 *
 * @package    console
 * @subpackage terms
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class termsActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListterms(sfWebRequest $request)
	{
		$page = $request->getParameter('p') ;
		$appId = $request->getParameter('a') ;
		//$sortKind = $request->getParameter('so') ;
		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
		if($appId){
		  	$c->add(AppPeer::ID,$appId) ;
		}
		if($sortKind == 1){
			$c->addAscendingOrderByColumn(AppPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(AppPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('App', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$apps = $pager->getResults() ;
		}

		$appMap = AdminTools::getMapForObjects($apps) ;

		$appIds = AdminTools::getIdsForObjects($apps) ;
		$appIds[] = 0 ; // add default

	  	$c = new Criteria() ;
	  	$c->add(AppTextPeer::DEL_FLG,0) ;
	  	$c->add(AppTextPeer::APP_ID,$appIds,Criteria::IN) ;
	  	$c->add(AppTextPeer::KIND,2) ; // terms
		$terms = AppTextPeer::doSelect($c) ;
		$termMapForAppId = array() ;
		foreach($terms as $term){
			$appId = $term->getAppId() ;
			$termMapForAppId[$appId] = $term ;
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

		$this->apps = $apps ;
		$this->page = $page ;
		$this->termMapForAppId = $termMapForAppId ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
	}

	public function executeEdit(sfWebRequest $request)
	{

		$appId = $request->getParameter('a') ;
		if($appId){
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
		  	$c->add(AppPeer::ID,$appId) ;
		  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
			$app = AppPeer::doSelectOne($c) ;
			if($app){
			  	$c = new Criteria() ;
			  	$c->add(AppTextPeer::DEL_FLG,0) ;
			  	$c->add(AppTextPeer::APP_ID,$appId) ;
			  	$c->add(AppTextPeer::KIND,2) ; // terms
				$term = AppTextPeer::doSelectOne($c) ;
				if(!$term){
				  	$c = new Criteria() ;
				  	$c->add(AppTextPeer::DEL_FLG,0) ;
				  	$c->add(AppTextPeer::APP_ID,0) ; // default
				  	$c->add(AppTextPeer::KIND,2) ; // terms
					$term = AppTextPeer::doSelectOne($c) ;
				}

				$this->app = $app ;
				$this->term = $term ;
			}
		}
	}

	public function executeSave(sfWebRequest $request)
	{

		$appId = $request->getParameter('a') ;
		if($appId){
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
		  	$c->add(AppPeer::ID,$appId) ;
		  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
			$app = AppPeer::doSelectOne($c) ;
			if($app){
				$description = $request->getParameter('d') ;

			  	$c = new Criteria() ;
			  	$c->add(AppTextPeer::DEL_FLG,0) ;
			  	$c->add(AppTextPeer::APP_ID,$appId) ;
			  	$c->add(AppTextPeer::KIND,2) ; // terms
				$term = AppTextPeer::doSelectOne($c) ;
				if(!$term){
					$term = new AppText() ;
					$term->setAppId($appId) ;
					$term->setKind(2) ; // terms
				}
				$term->setDescription($description) ;
				$term->save() ;

				$this->forward('terms','listterms') ;
			}
		}
		return sfView::NONE ;
	}

}
