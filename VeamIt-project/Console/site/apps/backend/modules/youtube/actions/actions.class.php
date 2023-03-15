<?php

/**
 * 	youtube actions.
 *
 * @package    console
 * @subpackage youtube
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class youtubeActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeList(sfWebRequest $request)
	{
		$pageNo = $request->getParameter('p') ;
		$appId = $request->getParameter('a') ;
		$this->setUpNames($appId) ;
		if($pageNo == 0){
			$pageNo = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(YoutubeVideoPeer::DEL_FLG,0) ;
		if($appId){
		  	$c->add(YoutubeVideoPeer::APP_ID,$appId) ;
		}
		$c->addDescendingOrderByColumn(YoutubeVideoPeer::ID) ;

		$pager = new sfPropelPager('YoutubeVideo', 100);
		$pager->setCriteria($c);
		$pager->setPage($pageNo);
		$pager->init();
		if($pageNo <= $pager->getLastPage()){
			$this->youtubes = $pager->getResults() ;
		}

		$this->pageNo = $pageNo ;
		$this->appId = $appId ;
	}


	public function executeShow(sfWebRequest $request)
	{
		$youtubeId = $request->getParameter('id') ;

		if($youtubeId){
		  	$c = new Criteria() ;
		  	$c->add(YoutubeVideoPeer::DEL_FLG,0);
		  	$c->add(YoutubeVideoPeer::ID,$youtubeId);
			$c->addDescendingOrderByColumn(YoutubeVideoPeer::ID) ;

			$this->youtubes = YoutubeVideoPeer::doSelect($c) ;
		}
	}

	public function executeNew(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('app_id') ;
		$this->setUpNames($this->appId) ;
	}

	public function executeSave(sfWebRequest $request)
	{
		$appId = $request->getParameter('app_id') ;
		$duration = $request->getParameter('duration') ;
		$title = $this->titleEscape($request->getParameter('title')) ;
		$description = $this->descriptionEscape($request->getParameter('description')) ;
		$youtubeCode = $request->getParameter('youtube_code') ;
		$subCategoryId = $request->getParameter('sub_category') ;

		if(($appId == '31000015') && ($subCategoryId == 0)){
			$categoryId = 14 ; // Cheap Clean Eats
		} else if(($appId == '31000015') && ($subCategoryId == -1)){
			$categoryId = 0;
			$subCategoryId = 0;
		} else {
			$subCategory = SubCategoryPeer::retrieveByPk($subCategoryId) ;
			$categoryId = $subCategory->getCategoryId() ;
		}

		$youtube = new YoutubeVideo() ;
		$youtube->setAppId($appId) ;
		$youtube->setKind(1) ;
		$youtube->setDuration($duration) ;
		$youtube->setTitle($title) ;
		$youtube->setDescription($description) ;
		$youtube->setDisplayOrder(0) ;
		$youtube->setYoutubeCode($youtubeCode) ;
		$youtube->setCategoryId($categoryId) ;
		$youtube->setSubCategoryId($subCategoryId) ;
		$youtube->save() ;

		$this->redirect('youtube/list') ;

		return sfView::NONE ;
	}



	public function executeConfirmdelete(sfWebRequest $request)
	{
		$youtubeId = $request->getParameter('id') ;

		if($youtubeId){
		  	$c = new Criteria() ;
		  	$c->add(YoutubeVideoPeer::DEL_FLG,0);
		  	$c->add(YoutubeVideoPeer::ID,$youtubeId);
			$c->addDescendingOrderByColumn(YoutubeVideoPeer::ID) ;

			$this->youtubes = YoutubeVideoPeer::doSelect($c) ;
		}
	}

	public function executeConfirmdeploy(sfWebRequest $request)
	{
		$youtubeId = $request->getParameter('id') ;

		if($youtubeId){
		  	$c = new Criteria() ;
		  	$c->add(YoutubeVideoPeer::DEL_FLG,0);
		  	$c->add(YoutubeVideoPeer::ID,$youtubeId);
			$c->addDescendingOrderByColumn(YoutubeVideoPeer::ID) ;

			$this->youtubes = YoutubeVideoPeer::doSelect($c) ;
		}
	}

	public function executeDeploy(sfWebRequest $request)
	{
		$youtubeId = $request->getParameter('id') ;

		$libDir = sfConfig::get("sf_lib_dir") ; 
		$commandDir = sprintf("%s/../../bin/youtube",$libDir) ;
		//$command = sprintf("perl %s/deploy.pl %s work"  ,$commandDir,$youtubeId) ;
		$command = sprintf("perl %s/deploy.pl %s public",$commandDir,$youtubeId) ;

		system($command) ;

		$this->message = 'Done' ;
	}

	public function executeDelete(sfWebRequest $request)
	{
		$youtubeId = $request->getParameter('id') ;

		$youtube = YoutubeVideoPeer::retrieveByPk($youtubeId) ;

		if($youtube){
			$youtube->delete() ;

			$message = sprintf("Youtube deleted\n%s",var_export($youtube,true)) ;
			$this->logMessage($message, 'info');

			$this->message = 'Removed' ;
		} else {
			$this->message = 'Failed' ;
		}
	}

	public function setUpNames($appId)
	{

		if(!$appId){
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::STATUS,0);
			$apps = AppPeer::doSelect($c) ;
			$appIds = AdminTools::getIdsForObjects($apps) ;
		}


	  	$c = new Criteria() ;
	  	$c->add(CategoryPeer::DEL_FLG,0);
		if($appId){
		  	$c->add(CategoryPeer::APP_ID,$appId);
		} else {
		  	$c->add(CategoryPeer::APP_ID,$appIds,Criteria::IN);
		}
		$categories = CategoryPeer::doSelect($c) ;
		$this->categoryNames = array() ;
		foreach($categories as $category){
			$this->categoryNames[$category->getId()] = $category->getName() ;
		}


	  	$c = new Criteria() ;
	  	$c->add(SubCategoryPeer::DEL_FLG,0);
		if($appId){
		  	$c->add(SubCategoryPeer::APP_ID,$appId);
		} else {
		  	$c->add(SubCategoryPeer::APP_ID,$appIds,Criteria::IN);
		}
		$subCategories = SubCategoryPeer::doSelect($c) ;
		$this->subCategoryNames = array() ;
		foreach($subCategories as $subCategory){
			$this->subCategoryNames[$subCategory->getId()] = sprintf("%s - %s",$this->categoryNames[$subCategory->getCategoryId()],$subCategory->getName()) ;
		}

		if($appId == '31000015'){
			$this->subCategoryNames[0] = "Cheap Clean Eats" ;
			$this->subCategoryNames[-1] = "for Calendar" ;
		}
	}

	public function titleEscape($string){
		$escapedString = $string ;
		$escapedString = str_replace('&',"&amp;",$escapedString) ;
		$escapedString = str_replace('"',"&quot;",$escapedString) ;
		$escapedString = str_replace('<',"&lt;",$escapedString) ;
		$escapedString = str_replace('>',"&gt;",$escapedString) ;
		$escapedString = str_replace("\r\n","&#xA;",$escapedString) ;
		return $escapedString ;
	}

	public function descriptionEscape($string){
		$escapedString = $string ;
		$escapedString = str_replace('&',"&amp;amp;",$escapedString) ;
		$escapedString = str_replace('"',"&quot;",$escapedString) ;
		$escapedString = str_replace('<',"&amp;lt;",$escapedString) ;
		$escapedString = str_replace('>',"&amp;gt;",$escapedString) ;
		$escapedString = str_replace("\r\n","&#xA;",$escapedString) ;
		return $escapedString ;
	}

}

