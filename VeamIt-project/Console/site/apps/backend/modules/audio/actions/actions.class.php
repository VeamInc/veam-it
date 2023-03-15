<?php

/**
 * 	audio actions.
 *
 * @package    console
 * @subpackage audio
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class audioActions extends sfActions
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
	  	$c->add(AudioPeer::DEL_FLG,0);
		$c->addDescendingOrderByColumn(AudioPeer::ID) ;

		$pager = new sfPropelPager('Audio', 100);
		$pager->setCriteria($c);
		$pager->setPage($pageNo);
		$pager->init();
		if($pageNo <= $pager->getLastPage()){
			$this->audios = $pager->getResults() ;
		}

		$this->makeMixedMap($this->audios) ;

		$this->pageNo = $pageNo ;
	}


	public function executeShow(sfWebRequest $request)
	{
		$audioId = $request->getParameter('id') ;

		if($audioId){
		  	$c = new Criteria() ;
		  	$c->add(AudioPeer::DEL_FLG,0);
		  	$c->add(AudioPeer::ID,$audioId);
			$c->addDescendingOrderByColumn(AudioPeer::ID) ;

			$this->audios = AudioPeer::doSelect($c) ;
		}

		$this->makeMixedMap($this->audios) ;
	}

	public function makeMixedMap($audios)
	{
		$audioIds = array() ;
		foreach($audios as $audio){
			$audioIds[] = $audio->getId() ;
		}

	  	$c = new Criteria() ;
	  	$c->add(MixedPeer::DEL_FLG,0) ;
	  	$c->add(MixedPeer::CONTENT_ID,$audioIds,Criteria::IN) ;
	  	$c->add(MixedPeer::KIND,9) ;
	  	$c->addOr(MixedPeer::KIND,10) ;
		$mixeds = MixedPeer::doSelect($c) ;

		$this->mixedMap = array() ;
		foreach($mixeds as $mixed){
			$this->mixedMap[$mixed->getContentId()] = $mixed ;
		}
	}

	public function executeEdit(sfWebRequest $request)
	{
		$audioId = $request->getParameter('id') ;

		$this->appId = '' ;
		$this->kind = '' ;
		$this->author = '' ;
		$this->duration = '' ;
		$this->title = '' ;
		$this->description = '' ;
		$this->linkUrl = '' ;

		if($audioId){
			$audio = AudioPeer::retrieveByPk($audioId) ;
			if($audio){
				$this->appId = $audio->getAppId() ;
				$this->kind = $audio->getKind() ;
				$this->author = $audio->getAuthor() ;
				$this->duration = $audio->getDuration() ;
				$this->title = $audio->getTitle() ;
				$this->description = $audio->getDescription() ;
				$this->linkUrl = $audio->getLinkUrl() ;
			}
		}
		$this->audioId = $audioId ;
	}

	public function executeSave(sfWebRequest $request)
	{
		$audioId = $request->getParameter('id') ;
		$appId = $request->getParameter('app_id') ;
		$kind = $request->getParameter('kind') ;
		$author = $request->getParameter('author') ;
		$duration = $request->getParameter('duration') ;
		$title = $request->getParameter('title') ;
		$description = $request->getParameter('description') ;
		$linkUrl = $request->getParameter('link_url') ;

		$imageUrl = $request->getParameter('image_url') ;
		$dataUrl = $request->getParameter('data_url') ;

		$isNew = 0 ; 
		if($audioId){
			$audio = AudioPeer::retrieveByPk($audioId) ;
		} else {
			$isNew = 1 ;
			$audio = new Audio() ;
		}
		if($audio){
			$audio->setAppId($appId) ;
			$audio->setKind($kind) ;
			$audio->setAuthor($author) ;
			$audio->setDuration($duration) ;
			$audio->setTitle($title) ;
			$audio->setDescription($description) ;
			$audio->setLinkUrl($linkUrl) ;
			$audio->save() ;
			if($isNew){
				$mixed = new Mixed() ;
				$mixed->setAppId($appId) ;
				$mixed->setMixedCategoryId(0) ;
				$mixed->setMixedSubCategoryId(0) ;
				$mixed->setKind(10) ; // Periodical subscription audio
				$mixed->setContentId($audio->getId()) ;
				$mixed->setName($audio->getTitle()) ;
				$mixed->save() ;

				$audioSource = new AudioSource() ;
				$audioSource->setAudioId($audio->getId()) ;
				$audioSource->setAppId($appId) ;
				$audioSource->setImageUrl($imageUrl) ;
				$audioSource->setDataUrl($dataUrl) ;
				$audioSource->setStatus(0) ;
				$audioSource->save() ;
			}
		}

		$this->redirect('audio/list') ;

		return sfView::NONE ;
	}



	public function executeConfirmdelete(sfWebRequest $request)
	{
		$audioId = $request->getParameter('id') ;

		if($audioId){
		  	$c = new Criteria() ;
		  	$c->add(AudioPeer::DEL_FLG,0);
		  	$c->add(AudioPeer::ID,$audioId);
			$c->addDescendingOrderByColumn(AudioPeer::ID) ;

			$this->audios = AudioPeer::doSelect($c) ;
		}

		$this->makeMixedMap($this->audios) ;

	}

	public function executeConfirmdeploy(sfWebRequest $request)
	{
		$audioId = $request->getParameter('id') ;

		if($audioId){
		  	$c = new Criteria() ;
		  	$c->add(AudioPeer::DEL_FLG,0);
		  	$c->add(AudioPeer::ID,$audioId);
			$c->addDescendingOrderByColumn(AudioPeer::ID) ;

			$this->audios = AudioPeer::doSelect($c) ;
		}

		$this->makeMixedMap($this->audios) ;
	}

	public function executeDeploy(sfWebRequest $request)
	{
		$audioId = $request->getParameter('id') ;
		$mixedId = $request->getParameter('mid') ;

		$libDir = sfConfig::get("sf_lib_dir") ; 
		$commandDir = sprintf("%s/../../bin/audio",$libDir) ;
		//$command = sprintf("perl %s/deploy.pl %s work"  ,$commandDir,$audioId) ;
		$command = sprintf("perl %s/deploy.pl %s %s public",$commandDir,$audioId,$mixedId) ;

		system($command) ;

		$this->message = 'Done' ;
	}

	public function executeDelete(sfWebRequest $request)
	{
		$audioId = $request->getParameter('id') ;
		$mixedId = $request->getParameter('mid') ;

		$audio = AudioPeer::retrieveByPk($audioId) ;
		if($audio){
			$audio->delete() ;
			$message = sprintf("Audio deleted\n%s",var_export($audio,true)) ;
			$this->logMessage($message, 'info');
			$mixed = MixedPeer::retrieveByPk($mixedId) ;
			if($mixed){
				$mixed->delete() ;
				$message = sprintf("Mixed deleted\n%s",var_export($mixed,true)) ;
				$this->logMessage($message, 'info');
				$this->message = 'Removed' ;
			} else {
				$this->message = 'Failed. mixed not found.' ;
			}
		} else {
			$this->message = 'Failed. audio not found.' ;
		}
	}

}

