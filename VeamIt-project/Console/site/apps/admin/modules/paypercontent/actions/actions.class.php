<?php

define('PAYPERCONTENT_ACTION_KIND_NORMAL',1) ;

define('PAYPERCONTENT_ACTION_KIND_DELAYED_NORMAL',2) ;
define('PAYPERCONTENT_ACTION_KIND_DELAYED_LONG',3) ;

/**
 * paypercontent actions.
 *
 * @package    console
 * @subpackage paypercontent
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class paypercontentActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListvideo(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if(!$appId){
			$appId = 0 ; 
		}
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}
		$sortKind = $request->getParameter('so') ;
		$status = $request->getParameter('s') ;
		if($status === null){
			$status = -1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::STATUS,1,Criteria::NOT_EQUAL) ;
	  	$c->addAnd(AppPeer::STATUS,4,Criteria::NOT_EQUAL) ;
	  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
		$c->addAscendingOrderByColumn(AppPeer::ID) ;
		$allApps = AppPeer::doSelect($c) ;

		if($appId != 0){
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
	  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
	  	$c->add(SellVideoPeer::APP_ID,$appIds,Criteria::IN) ;
		if($status != -1){
		  	$c->add(SellVideoPeer::STATUS,$status) ;
		}

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(SellVideoPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(SellVideoPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('SellVideo', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$videoIds = array() ;
		if($page <= $lastPage){
			$sellVideos = $pager->getResults() ;
			foreach($sellVideos as $sellVideo){
				$videoIds[] = $sellVideo->getVideoId() ;
			}

			if(count($videoIds) > 0){
			  	$c = new Criteria() ;
			  	$c->add(VideoPeer::DEL_FLG,0) ;
			  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
				$videos = VideoPeer::doSelect($c) ;
				if($videos){
					$videoMap = AdminTools::getMapForObjects($videos) ;
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

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$statuses = array(
			'0' => 'Live',
			'3' => 'Waiting for submission to iTunesConnect',
		) ;

		$this->sellVideos = $sellVideos ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->videoMap = $videoMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->status = $status ;
		$this->statuses = $statuses ;
	}






	public function executeListaudio(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if(!$appId){
			$appId = 0 ; 
		}
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}
		$sortKind = $request->getParameter('so') ;
		$status = $request->getParameter('s') ;
		if($status === null){
			$status = -1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::STATUS,1,Criteria::NOT_EQUAL) ;
	  	$c->addAnd(AppPeer::STATUS,4,Criteria::NOT_EQUAL) ;
	  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
		$c->addAscendingOrderByColumn(AppPeer::ID) ;
		$allApps = AppPeer::doSelect($c) ;

		if($appId != 0){
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
	  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
	  	$c->add(SellAudioPeer::APP_ID,$appIds,Criteria::IN) ;
		if($status != -1){
		  	$c->add(SellAudioPeer::STATUS,$status) ;
		}

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(SellAudioPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(SellAudioPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('SellAudio', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$audioIds = array() ;
		if($page <= $lastPage){
			$sellAudios = $pager->getResults() ;
			foreach($sellAudios as $sellAudio){
				$audioIds[] = $sellAudio->getAudioId() ;
			}

			if(count($audioIds) > 0){
			  	$c = new Criteria() ;
			  	$c->add(AudioPeer::DEL_FLG,0) ;
			  	$c->add(AudioPeer::ID,$audioIds,Criteria::IN) ;
				$audios = AudioPeer::doSelect($c) ;
				if($audios){
					$audioMap = AdminTools::getMapForObjects($audios) ;
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

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$statuses = array(
			'0' => 'Live',
			'3' => 'Waiting for submission to iTunesConnect',
		) ;

		$this->sellAudios = $sellAudios ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->audioMap = $audioMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->status = $status ;
		$this->statuses = $statuses ;
	}



	public function executeListpdf(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if(!$appId){
			$appId = 0 ; 
		}
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}
		$sortKind = $request->getParameter('so') ;
		$status = $request->getParameter('s') ;
		if($status === null){
			$status = -1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::STATUS,1,Criteria::NOT_EQUAL) ;
	  	$c->addAnd(AppPeer::STATUS,4,Criteria::NOT_EQUAL) ;
	  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
		$c->addAscendingOrderByColumn(AppPeer::ID) ;
		$allApps = AppPeer::doSelect($c) ;

		if($appId != 0){
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
	  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
	  	$c->add(SellPdfPeer::APP_ID,$appIds,Criteria::IN) ;
		if($status != -1){
		  	$c->add(SellPdfPeer::STATUS,$status) ;
		}

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(SellPdfPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(SellPdfPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('SellPdf', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		$pdfIds = array() ;
		if($page <= $lastPage){
			$sellPdfs = $pager->getResults() ;
			foreach($sellPdfs as $sellPdf){
				$pdfIds[] = $sellPdf->getPdfId() ;
			}

			if(count($pdfIds) > 0){
			  	$c = new Criteria() ;
			  	$c->add(PdfPeer::DEL_FLG,0) ;
			  	$c->add(PdfPeer::ID,$pdfIds,Criteria::IN) ;
				$pdfs = PdfPeer::doSelect($c) ;
				if($pdfs){
					$pdfMap = AdminTools::getMapForObjects($pdfs) ;
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

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$statuses = array(
			'0' => 'Live',
			'3' => 'Waiting for submission to iTunesConnect',
		) ;

		$this->sellPdfs = $sellPdfs ;
		$this->appId = $appId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->pdfMap = $pdfMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->status = $status ;
		$this->statuses = $statuses ;
	}



}
