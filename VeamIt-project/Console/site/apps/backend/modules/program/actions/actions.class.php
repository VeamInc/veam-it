<?php

/**
 * 	program actions.
 *
 * @package    console
 * @subpackage program
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class programActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeList(sfWebRequest $request)
	{
		$pageNo = $request->getParameter('p') ;
		if($pageNo == 0){
			$pageNo = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(ProgramPeer::DEL_FLG,0);
		$c->addDescendingOrderByColumn(ProgramPeer::ID) ;

		$pager = new sfPropelPager('Program', 100);
		$pager->setCriteria($c);
		$pager->setPage($pageNo);
		$pager->init();
		if($pageNo <= $pager->getLastPage()){
			$this->programs = $pager->getResults() ;
		}

		$this->pageNo = $pageNo ;
	}


	public function executeShow(sfWebRequest $request)
	{
		$programId = $request->getParameter('id') ;

		if($programId){
		  	$c = new Criteria() ;
		  	$c->add(ProgramPeer::DEL_FLG,0);
		  	$c->add(ProgramPeer::ID,$programId);
			$c->addDescendingOrderByColumn(ProgramPeer::ID) ;

			$this->programs = ProgramPeer::doSelect($c) ;
		}
	}

	public function executeEdit(sfWebRequest $request)
	{
		$programId = $request->getParameter('id') ;

		$this->appId = '' ;
		$this->kind = '' ;
		$this->author = '' ;
		$this->duration = '' ;
		$this->title = '' ;
		$this->description = '' ;

		if($programId){
			$program = ProgramPeer::retrieveByPk($programId) ;
			if($program){
				$this->appId = $program->getAppId() ;
				$this->kind = $program->getKind() ;
				$this->author = $program->getAuthor() ;
				$this->duration = $program->getDuration() ;
				$this->title = $program->getTitle() ;
				$this->description = $program->getDescription() ;
			}
		}
		$this->programId = $programId ;
	}

	public function executeSave(sfWebRequest $request)
	{
		$programId = $request->getParameter('id') ;
		$appId = $request->getParameter('app_id') ;
		$kind = $request->getParameter('kind') ;
		$author = $request->getParameter('author') ;
		$duration = $request->getParameter('duration') ;
		$title = $request->getParameter('title') ;
		$description = $request->getParameter('description') ;

		$imageUrl = $request->getParameter('image_url') ;
		$dataUrl = $request->getParameter('data_url') ;

		$isNew = 0 ; 
		if($programId){
			$program = ProgramPeer::retrieveByPk($programId) ;
		} else {
			$isNew = 1 ;
			$program = new Program() ;
		}
		if($program){
			$program->setAppId($appId) ;
			$program->setKind($kind) ;
			$program->setAuthor($author) ;
			$program->setDuration($duration) ;
			$program->setTitle($title) ;
			$program->setDescription($description) ;
			$program->save() ;
			if($isNew){
				$programSource = new ProgramSource() ;
				$programSource->setProgramId($program->getId()) ;
				$programSource->setAppId($appId) ;
				$programSource->setImageUrl($imageUrl) ;
				$programSource->setDataUrl($dataUrl) ;
				$programSource->setStatus(0) ;
				$programSource->save() ;
			}
		}

		$this->redirect('program/list') ;

		return sfView::NONE ;
	}



	public function executeConfirmdelete(sfWebRequest $request)
	{
		$programId = $request->getParameter('id') ;

		if($programId){
		  	$c = new Criteria() ;
		  	$c->add(ProgramPeer::DEL_FLG,0);
		  	$c->add(ProgramPeer::ID,$programId);
			$c->addDescendingOrderByColumn(ProgramPeer::ID) ;

			$this->programs = ProgramPeer::doSelect($c) ;
		}
	}

	public function executeConfirmdeploy(sfWebRequest $request)
	{
		$programId = $request->getParameter('id') ;

		if($programId){
		  	$c = new Criteria() ;
		  	$c->add(ProgramPeer::DEL_FLG,0);
		  	$c->add(ProgramPeer::ID,$programId);
			$c->addDescendingOrderByColumn(ProgramPeer::ID) ;

			$this->programs = ProgramPeer::doSelect($c) ;
		}
	}

	public function executeDeploy(sfWebRequest $request)
	{
		$programId = $request->getParameter('id') ;

		$libDir = sfConfig::get("sf_lib_dir") ; 
		$commandDir = sprintf("%s/../../bin/program",$libDir) ;
		//$command = sprintf("perl %s/deploy.pl %s work"  ,$commandDir,$programId) ;
		$command = sprintf("perl %s/deploy.pl %s public",$commandDir,$programId) ;

		system($command) ;

		$this->message = 'Done' ;
	}

	public function executeDelete(sfWebRequest $request)
	{
		$programId = $request->getParameter('id') ;

		$program = ProgramPeer::retrieveByPk($programId) ;

		if($program){
			$program->delete() ;

			$message = sprintf("Program deleted\n%s",var_export($program,true)) ;
			$this->logMessage($message, 'info');

			$this->message = 'Removed' ;
		} else {
			$this->message = 'Failed' ;
		}
	}

}

