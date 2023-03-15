<?php

/**
 * analytics actions.
 *
 * @package    console
 * @subpackage analytics
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class analyticsActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListall(sfWebRequest $request)
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
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
	}


	public function executeShow(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			$app = AppPeer::retrieveByPk($appId) ;
			if($app->getMcnId() == $this->mcnId){
				$json = file_get_contents(sprintf("http://stats.veam.co/api/veamapp_detail.php?veamid=%d",$appId)) ;
				//$this->json = $json ;
				$elements = json_decode($json) ;
				foreach($elements as $element){
					switch($element->ProductType){
					case 'App':
						$element->show = true ;
						$element->ProductType = 'Downloads' ;
						break ;
					case 'In-App':
						$element->show = true ;
						$element->ProductType = sprintf('Purchase (%s)',$element->Title) ;
						break ;
					case 'Posts':
						$element->show = true ;
						break ;
					case 'Comments':
						$element->show = true ;
						break ;
					}
				}
				$this->elements = $elements ;
				$this->app = $app ;
			}
		}
	}



}
