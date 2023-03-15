<?php

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
	public function executePlaylistorder(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			//// youtube
		  	$c = new Criteria() ;
		  	$c->add(CategoryPeer::DEL_FLG,0) ;
		  	$c->add(CategoryPeer::DISABLED,0) ;
		  	$c->add(CategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
			$c->addDescendingOrderByColumn(CategoryPeer::CREATED_AT) ;
			$youtubeCategories = CategoryPeer::doSelect($c) ;

			$this->youtubeCategories = $youtubeCategories ;
		} else {
			return sfView::NONE ;
		}
	}


	public function executeChangecategoryorderapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$idsString = $request->getParameter('ids') ;
			if($idsString){
				$categoryIds = explode(",",$idsString) ;
				if(count($categoryIds) > 0){
				  	$c = new Criteria() ;
				  	$c->add(CategoryPeer::DEL_FLG,0) ;
				  	$c->add(CategoryPeer::APP_ID,$appId) ;
				  	$c->add(CategoryPeer::ID,$categoryIds,Criteria::IN) ;
					$categories = CategoryPeer::doSelect($c) ;

					$categoryMap = array() ;
					foreach($categories as $category){
						$categoryMap[$category->getId()] = $category ;
					}

					$orderCount = 1 ;
					foreach($categoryIds as $categoryId){
						$category = $categoryMap[$categoryId] ;
						if($category){
							$category->setDisplayOrder($orderCount) ;
							$category->save() ;
							$orderCount++ ;
						}
					}
					ConsoleTools::clearContentCache($appId) ;
					ConsoleTools::consoleContentsChanged($appId) ;
				}
			} else {
				$this->forward('youtube','playlistorder') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}




	public function executePlaylistactivation(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){

			$this->app = $app ;

			//// youtube
		  	$c = new Criteria() ;
		  	//$c->add(CategoryPeer::DEL_FLG,0) ;
		  	$c->add(CategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
			$c->addDescendingOrderByColumn(CategoryPeer::CREATED_AT) ;
			$youtubeCategories = CategoryPeer::doSelect($c) ;

			$this->youtubeCategories = $youtubeCategories ;

		} else {
			return sfView::NONE ;
		}
	}


	public function executeChangecategoryactivationapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$categoryId = $request->getParameter('id') ;
			$activation = $request->getParameter('ac') ;
			if($categoryId){
			  	$c = new Criteria() ;
			  	$c->add(CategoryPeer::DEL_FLG,0) ;
			  	$c->add(CategoryPeer::APP_ID,$appId) ;
			  	$c->add(CategoryPeer::ID,$categoryId) ;
				$category = CategoryPeer::doSelectOne($c) ;
				if($category){
					if($activation){
						$category->setDisabled(0) ;
					} else {
						$category->setDisabled(1) ;
					}
					$category->save() ;
					ConsoleTools::clearContentCache($appId) ;
					ConsoleTools::consoleContentsChanged($appId) ;
				}
			} else {
				$this->forward('youtube','playlistactivation') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}


}
