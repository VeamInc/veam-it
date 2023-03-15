<?php

/**
 * subscription actions.
 *
 * @package    console
 * @subpackage subscription
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class subscriptionActions extends myActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeContent(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
			if($templateSubscription){
				$currentType = $templateSubscription->getKind() ;
				if($currentType == 4){
					$this->forward('subscription','contentforsubscription') ;
				} else if($currentType == 5){
					$this->forward('subscription','contentforppc') ;
				} else if($currentType == 6){
					$this->forward('subscription','contentforpps') ;
				}
			}
		} else {
			return sfView::NONE ;
		}
		return sfView::NONE ;

	}


	public function setPrices()
	{
		$this->prices = array(
			'$0.99',
			'$1.99',
			'$2.99',
			'$3.99',
			'$4.99',
			'$5.99',
			'$6.99',
			'$7.99',
			'$8.99',
			'$9.99',
		) ;
	}


	public function executeAddnewvideoforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(SellItemCategoryPeer::DEL_FLG,0) ;
		  	$c->add(SellItemCategoryPeer::APP_ID,$appId) ;
		  	$c->add(SellItemCategoryPeer::KIND,1) ;
			$c->addAscendingOrderByColumn(SellItemCategoryPeer::DISPLAY_ORDER) ;
		  	$sellItemCategories = SellItemCategoryPeer::doSelect($c) ;
			$videoCategoryIds = array() ;
			foreach($sellItemCategories as $sellItemCategory){
				$videoCategoryIds[] = $sellItemCategory->getTargetCategoryId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(VideoCategoryPeer::DEL_FLG,0) ;
		  	$c->add(VideoCategoryPeer::APP_ID,$appId) ;
		  	$c->add(VideoCategoryPeer::ID,$videoCategoryIds,Criteria::IN) ;
		  	$videoCategories = VideoCategoryPeer::doSelect($c) ;

			$this->setPrices() ;
		} else {
			return sfView::NONE ;
		}

		$this->videoCategories = $videoCategories ;
	}


	public function executeAddnewaudioforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(SellItemCategoryPeer::DEL_FLG,0) ;
		  	$c->add(SellItemCategoryPeer::APP_ID,$appId) ;
		  	$c->add(SellItemCategoryPeer::KIND,3) ;
			$c->addAscendingOrderByColumn(SellItemCategoryPeer::DISPLAY_ORDER) ;
		  	$sellItemCategories = SellItemCategoryPeer::doSelect($c) ;
			$audioCategoryIds = array() ;
			foreach($sellItemCategories as $sellItemCategory){
				$audioCategoryIds[] = $sellItemCategory->getTargetCategoryId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(AudioCategoryPeer::DEL_FLG,0) ;
		  	$c->add(AudioCategoryPeer::APP_ID,$appId) ;
		  	$c->add(AudioCategoryPeer::ID,$audioCategoryIds,Criteria::IN) ;
		  	$audioCategories = AudioCategoryPeer::doSelect($c) ;

			$this->setPrices() ;
		} else {
			return sfView::NONE ;
		}

		$this->audioCategories = $audioCategories ;
	}


	public function executeAddnewpdfforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(SellItemCategoryPeer::DEL_FLG,0) ;
		  	$c->add(SellItemCategoryPeer::APP_ID,$appId) ;
		  	$c->add(SellItemCategoryPeer::KIND,2) ;
			$c->addAscendingOrderByColumn(SellItemCategoryPeer::DISPLAY_ORDER) ;
		  	$sellItemCategories = SellItemCategoryPeer::doSelect($c) ;
			$pdfCategoryIds = array() ;
			foreach($sellItemCategories as $sellItemCategory){
				$pdfCategoryIds[] = $sellItemCategory->getTargetCategoryId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(PdfCategoryPeer::DEL_FLG,0) ;
		  	$c->add(PdfCategoryPeer::APP_ID,$appId) ;
		  	$c->add(PdfCategoryPeer::ID,$pdfCategoryIds,Criteria::IN) ;
		  	$pdfCategories = PdfCategoryPeer::doSelect($c) ;

			$this->setPrices() ;
		} else {
			return sfView::NONE ;
		}

		$this->pdfCategories = $pdfCategories ;
	}

	public function executeRegistervideoforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
			$videoCategoryId = $request->getParameter('category') ;
			if($videoCategoryId){
				$title = ConsoleTools::xmlEscape($request->getParameter('title')) ;
				$sourceUrl = $request->getParameter('video_url') ;
				$imageUrl = $request->getParameter('thumbnail_url') ;
				$price = $request->getParameter('price') ;
				$description = ConsoleTools::xmlEscape($request->getParameter('description')) ;
				$sellVideoId = 0 ;

				$sourceUrl = str_replace('?dl=0','',$sourceUrl) ;
				$imageUrl = str_replace('?dl=0','',$imageUrl) ;

				$isNew = 0 ; 
				if($sellVideoId){
					$sellVideo = SellVideoPeer::retrieveByPk($sellVideoId) ;
				} else {
					$isNew = 1 ; 
					$sellVideo = new SellVideo() ;
					$sellVideo->setAppId($appId) ;
					$sellVideo->setDisplayOrder(0) ;
				}

				$video = new Video() ;
				$video->setAppId($appId) ;
				$video->setTitle($title) ;
				$video->setVideoCategoryId($videoCategoryId) ;
				$video->setVideoSubCategoryId(0) ;
				$video->setKind(0) ;
				$video->setSourceUrl($sourceUrl) ;
				$video->save() ;
				ConsoleTools::saveConsoleLog($request,$video) ;

				$videoSource = new VideoSource() ;
				$videoSource->setAppId($appId) ;
				$videoSource->setVideoId($video->getId()) ;
				$videoSource->setUrl($sourceUrl) ;
				$videoSource->setImageUrl($imageUrl) ;
				$videoSource->setStatus(0) ;
				$videoSource->save() ;

				$videoId = $video->getId() ;
				$sellVideo->setVideoId($videoId) ;
				$sellVideo->setProduct(sprintf('co.veam.veam%s.video.%s',$appId,$videoId)) ;
				$sellVideo->setPrice($price) ;
				$sellVideo->setPriceText($price) ;
				$sellVideo->setDescription($description) ;
				$sellVideo->setButton(sprintf('Tap to purchase - US%s',$price)) ;
				$sellVideo->setStatus(2) ;
				$sellVideo->setStatusText('Preparing') ;
				$sellVideo->save() ;
				ConsoleTools::saveConsoleLog($request,$sellVideo) ;

				if($isNew){
				  	$c = new Criteria() ;
				  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
				  	$c->add(SellVideoPeer::APP_ID,$appId) ;
					$c->addAscendingOrderByColumn(SellVideoPeer::DISPLAY_ORDER) ;
				  	$sellVideos = SellVideoPeer::doSelect($c) ;

					$orderNo = 1 ;
					foreach($sellVideos as $workSellVideo){
						$workSellVideo->setDisplayOrder($orderNo) ;
						$workSellVideo->save() ;
						$orderNo++ ;
					}
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			}

			$this->forward('subscription','content') ;

		} else {
			return sfView::NONE ;
		}

	}



	public function executeRegisteraudioforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$audioCategoryId = $request->getParameter('category') ;
			if($audioCategoryId){
				$description = ConsoleTools::xmlEscape($request->getParameter('description')) ;
				$sellAudioId = 0 ;
				$imageUrl = $request->getParameter('thumbnail_url') ;
				$pdfUrl = $request->getParameter('pdf_url') ;
				$price = $request->getParameter('price') ;
				$sourceUrl = $request->getParameter('audio_url') ;
				$title = ConsoleTools::xmlEscape($request->getParameter('title')) ;

				$sourceUrl = str_replace('?dl=0','',$sourceUrl) ;
				$imageUrl = str_replace('?dl=0','',$imageUrl) ;

				$isNew = 0 ; 
				if($sellAudioId){
					$sellAudio = SellAudioPeer::retrieveByPk($sellAudioId) ;
				} else {
					$isNew = 1 ; 
					$sellAudio = new SellAudio() ;
					$sellAudio->setAppId($appId) ;
					$sellAudio->setDisplayOrder(0) ;
				}


				$audio = new Audio() ;
				$audio->setAppId($appId) ;
				$audio->setTitle($title) ;
				$audio->setAudioCategoryId($audioCategoryId) ;
				$audio->setAudioSubCategoryId(0) ;
				$audio->setKind(1) ;
				$audio->save() ;
				ConsoleTools::saveConsoleLog($request,$audio) ;

				$audioSource = new AudioSource() ;
				$audioSource->setAppId($appId) ;
				$audioSource->setAudioId($audio->getId()) ;
				$audioSource->setDataUrl($sourceUrl) ;
				$audioSource->setLinkDataUrl($pdfUrl) ;
				$audioSource->setImageUrl($imageUrl) ;
				$audioSource->setStatus(0) ;
				$audioSource->save() ;

				$audioId = $audio->getId() ;
				$sellAudio->setAudioId($audioId) ;
				$sellAudio->setProduct(sprintf('co.veam.veam%s.audio.%s',$appId,$audioId)) ;
				$sellAudio->setPrice($price) ;
				$sellAudio->setPriceText($price) ;
				$sellAudio->setDescription($description) ;
				$sellAudio->setButton(sprintf('Tap to purchase - US%s',$price)) ;
				$sellAudio->setStatus(2) ;
				$sellAudio->setStatusText('Preparing') ;
				$sellAudio->save() ;
				ConsoleTools::saveConsoleLog($request,$sellAudio) ;

				if($isNew){
				  	$c = new Criteria() ;
				  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
				  	$c->add(SellAudioPeer::APP_ID,$appId) ;
					$c->addAscendingOrderByColumn(SellAudioPeer::DISPLAY_ORDER) ;
				  	$sellAudios = SellAudioPeer::doSelect($c) ;

					$orderNo = 1 ;
					foreach($sellAudios as $workSellAudio){
						$workSellAudio->setDisplayOrder($orderNo) ;
						$workSellAudio->save() ;
						$orderNo++ ;
					}
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			}

			$this->forward('subscription','content') ;

		} else {
			return sfView::NONE ;
		}

	}

	public function executeRegisterpdfforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;


			$pdfCategoryId = $request->getParameter('category') ;
			if($pdfCategoryId){
				$description = ConsoleTools::xmlEscape($request->getParameter('description')) ;
				$sellPdfId = 0 ;
				$imageUrl = $request->getParameter('thumbnail_url') ;
				$price = $request->getParameter('price') ;
				$sourceUrl = $request->getParameter('pdf_url') ;
				$title = ConsoleTools::xmlEscape($request->getParameter('title')) ;

				$sourceUrl = str_replace('?dl=0','',$sourceUrl) ;
				$imageUrl = str_replace('?dl=0','',$imageUrl) ;

				$isNew = 0 ; 
				if($sellPdfId){
					$sellPdf = SellPdfPeer::retrieveByPk($sellPdfId) ;
				} else {
					$isNew = 1 ; 
					$sellPdf = new SellPdf() ;
					$sellPdf->setAppId($appId) ;
					$sellPdf->setDisplayOrder(0) ;
				}


				$alpha = 'abcdefghkmnprstwxy' ;
				$token = substr($alpha,rand(0,strlen($alpha)-1),1).substr($alpha,rand(0,strlen($alpha)-1),1).sprintf("%d",rand(10000,99999)) ;

				$pdf = new Pdf() ;
				$pdf->setAppId($appId) ;
				$pdf->setTitle($title) ;
				$pdf->setPdfCategoryId($pdfCategoryId) ;
				$pdf->setPdfSubCategoryId(0) ;
				$pdf->setKind(1) ;
				$pdf->setToken($token) ;
				$pdf->save() ;
				ConsoleTools::saveConsoleLog($request,$pdf) ;

				$pdfSource = new PdfSource() ;
				$pdfSource->setAppId($appId) ;
				$pdfSource->setPdfId($pdf->getId()) ;
				$pdfSource->setUrl($sourceUrl) ;
				$pdfSource->setImageUrl($imageUrl) ;
				$pdfSource->setStatus(0) ;
				$pdfSource->save() ;

				$pdfId = $pdf->getId() ;
				$sellPdf->setPdfId($pdfId) ;
				$sellPdf->setProduct(sprintf('co.veam.veam%s.pdf.%s',$appId,$pdfId)) ;
				$sellPdf->setPrice($price) ;
				$sellPdf->setPriceText($price) ;
				$sellPdf->setDescription($description) ;
				$sellPdf->setButton(sprintf('Tap to purchase - US%s',$price)) ;
				$sellPdf->setStatus(2) ;
				$sellPdf->setStatusText('Preparing') ;
				$sellPdf->save() ;
				ConsoleTools::saveConsoleLog($request,$sellPdf) ;

				if($isNew){
				  	$c = new Criteria() ;
				  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
				  	$c->add(SellPdfPeer::APP_ID,$appId) ;
					$c->addAscendingOrderByColumn(SellPdfPeer::DISPLAY_ORDER) ;
				  	$sellPdfs = SellPdfPeer::doSelect($c) ;

					$orderNo = 1 ;
					foreach($sellPdfs as $workSellPdf){
						$workSellPdf->setDisplayOrder($orderNo) ;
						$workSellPdf->save() ;
						$orderNo++ ;
					}
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			}

			$this->forward('subscription','content') ;

		} else {
			return sfView::NONE ;
		}

	}


	public function executeCategory(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
			if($templateSubscription){
				$currentType = $templateSubscription->getKind() ;
				if($currentType == 4){
					$this->forward('subscription','categoryforsubscription') ;
				} else if($currentType == 5){
					$this->forward('subscription','categoryforppc') ;
				} else if($currentType == 6){
					$this->forward('subscription','categoryforpps') ;
				}
			}
		} else {
			return sfView::NONE ;
		}
		return sfView::NONE ;

	}

	public function executeAddsellitemcategoryapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			$this->app = $app ;

			if($_SERVER["REQUEST_METHOD"] == "POST"){
				$kind = $request->getParameter('k') ;
				$name = 'New Category' ;

				$sellItemCategory = new SellItemCategory() ;
				$sellItemCategory->setAppId($appId) ;
				$sellItemCategory->setKind($kind) ;
				$sellItemCategory->setDisplayOrder(0) ;

				$newTargetId = $this->setTargetCategory($appId,$kind,0,$name) ;
				$sellItemCategory->setTargetCategoryId($newTargetId) ;
				$sellItemCategory->save() ;
				ConsoleTools::saveConsoleLog($request,$sellItemCategory) ;

				$data = array('sellItemCategoryId'=>$sellItemCategory->getId()) ;

			  	$c = new Criteria() ;
			  	$c->add(SellItemCategoryPeer::DEL_FLG,0) ;
			  	$c->add(SellItemCategoryPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(SellItemCategoryPeer::DISPLAY_ORDER) ;
			  	$sellItemCategories = SellItemCategoryPeer::doSelect($c) ;

				$orderNo = 1 ;
				foreach($sellItemCategories as $catetory){
					$catetory->setDisplayOrder($orderNo) ;
					$catetory->save() ;
					$orderNo++ ;
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			} else {
				$this->forward('subscription','category') ;
			}
		}
		echo json_encode($data) ;
		return sfView::NONE ;
	}

	public function executeChangesellitemcategorynameapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			$this->app = $app ;

			$id = $request->getParameter('id') ;
			if($id){
				$name = $request->getParameter('na') ;

				$sellItemCategory = SellItemCategoryPeer::retrieveByPk($id) ;
				if($sellItemCategory){
					$kind = $sellItemCategory->getKind() ;
					$targetCategoryId = $sellItemCategory->getTargetCategoryId() ;
					$this->setTargetCategory($appId,$kind,$targetCategoryId,$name) ;
				}
			} else {
				$this->forward('subscription','category') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeRemovesellitemcategoryapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			$this->app = $app ;

			$id = $request->getParameter('id') ;
			if($id){
				$sellItemCategory = SellItemCategoryPeer::retrieveByPk($id) ;
				$sellItemCategory->delete() ;
			} else {
				$this->forward('subscription','category') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function setTargetCategory($appId,$kind,$targetCategoryId,$name)
	{
		$workId = $targetCategoryId ;
		if($workId){
			// 1:video 2:pdf 3:audio
			if($kind == '1'){
				$videoCategory = VideoCategoryPeer::retrieveByPk($workId) ;
				if($videoCategory){
					$videoCategory->setName($name) ;
					$videoCategory->save() ;
				} else {
					ConsoleTools::assert(false,sprintf("video category not found appId=%s videoCategoryId=%s",$appId,$targetCategoryId()),__FILE__,__LINE__) ;
				}
			} else if($kind == '2'){
				$pdfCategory = PdfCategoryPeer::retrieveByPk($workId) ;
				if($pdfCategory){
					$pdfCategory->setName($name) ;
					$pdfCategory->save() ;
				} else {
					ConsoleTools::assert(false,sprintf("pdf category not found appId=%s pdfCategoryId=%s",$appId,$targetCategoryId()),__FILE__,__LINE__) ;
				}
			} else if($kind == '3'){
				$audioCategory = AudioCategoryPeer::retrieveByPk($workId) ;
				if($audioCategory){
					$audioCategory->setName($name) ;
					$audioCategory->save() ;
				} else {
					ConsoleTools::assert(false,sprintf("audio category not found appId=%s audioCategoryId=%s",$appId,$targetCategoryId()),__FILE__,__LINE__) ;
				}
			} else {
				ConsoleTools::assert(false,sprintf("invalid sell item category kind appId=%s kind=%s",$appId,$kind),__FILE__,__LINE__) ;
			}
		} else {
			// new item
			if($kind == '1'){
				$videoCategory = new VideoCategory() ;
				$videoCategory->setAppId($appId) ;
				$videoCategory->setName($name) ;
				$videoCategory->save() ;
				$workId = $videoCategory->getId() ;
			} else if($kind == '2'){
				$pdfCategory = new PdfCategory() ;
				$pdfCategory->setAppId($appId) ;
				$pdfCategory->setName($name) ;
				$pdfCategory->save() ;
				$workId = $pdfCategory->getId() ;
			} else if($kind == '3'){
				$audioCategory = new AudioCategory() ;
				$audioCategory->setAppId($appId) ;
				$audioCategory->setName($name) ;
				$audioCategory->save() ;
				$workId = $audioCategory->getId() ;
			} else {
				ConsoleTools::assert(false,sprintf("invalid sell item category kind appId=%s kind=%s",$appId,$kind),__FILE__,__LINE__) ;
			}
		}
		return $workId ;
	}

	public function executeRemovecategory($request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if(ConsoleTools::isValidConsoleRequest($request,array('i'),__FILE__,__LINE__)){
				$sellItemCategoryId = $request->getParameter('i') ;

				$sellItemCategory = SellItemCategoryPeer::retrieveByPk($sellItemCategoryId) ;
				if($sellItemCategory){
					if($appId == $sellItemCategory->getAppId()){
						$sellItemCategory->delete() ;
						ConsoleTools::saveConsoleLog($request,$sellItemCategory) ;
					} else {
						ConsoleTools::assert(false,sprintf("app id not match appId=%s categoryAppId=%s sellItemCategoryId=%s",$appId,$sellItemCategory->getAppId(),$sellItemCategory->getId()),__FILE__,__LINE__) ;
					}
				}

				ConsoleTools::consoleContentsChanged($appId) ;

				print("OK\n") ;
				print(sprintf("%d\n",$sellItemCategory->getId())) ;
			}
		}

		return sfView::NONE ;
	}


	public function executeContentforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
		  	$c->add(SellVideoPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(SellVideoPeer::DISPLAY_ORDER) ;
			$sellVideos = SellVideoPeer::doSelect($c) ;
			$sellVideoMap = array() ;
			$videoIds = array() ;
			foreach($sellVideos as $sellVideo){
				$sellVideoMap[sprintf('video_%d',$sellVideo->getId())] = $sellVideo ;
				$videoIds[] = $sellVideo->getVideoId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(VideoPeer::DEL_FLG,0) ;
		  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
			$videos = VideoPeer::doSelect($c) ;
			$videoMap = AdminTools::getMapForObjects($videos) ;

		  	$c = new Criteria() ;
		  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
		  	$c->add(SellAudioPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(SellAudioPeer::DISPLAY_ORDER) ;
			$sellAudios = SellAudioPeer::doSelect($c) ;
			$sellAudioMap = array() ;
			$audioIds = array() ;
			foreach($sellAudios as $sellAudio){
				$sellAudioMap[sprintf('audio_%d',$sellAudio->getId())] = $sellAudio ;
				$audioIds[] = $sellAudio->getAudioId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(AudioPeer::DEL_FLG,0) ;
		  	$c->add(AudioPeer::ID,$audioIds,Criteria::IN) ;
			$audios = AudioPeer::doSelect($c) ;
			$audioMap = AdminTools::getMapForObjects($audios) ;

		  	$c = new Criteria() ;
		  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
		  	$c->add(SellPdfPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(SellPdfPeer::DISPLAY_ORDER) ;
			$sellPdfs = SellPdfPeer::doSelect($c) ;
			$sellPdfMap = array() ;
			$pdfIds = array() ;
			foreach($sellPdfs as $sellPdf){
				$sellPdfMap[sprintf('pdf_%d',$sellPdf->getId())] = $sellPdf ;
				$pdfIds[] = $sellPdf->getPdfId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(PdfPeer::DEL_FLG,0) ;
		  	$c->add(PdfPeer::ID,$pdfIds,Criteria::IN) ;
			$pdfs = PdfPeer::doSelect($c) ;
			$pdfMap = AdminTools::getMapForObjects($pdfs) ;

			$sellItems = array_merge($sellVideoMap,$sellAudioMap,$sellPdfMap) ;
			uasort($sellItems, 'compareTime');

		} else {
			return sfView::NONE ;
		}

		$this->sellItems = $sellItems ;
		$this->videoMap = $videoMap ;
		$this->audioMap = $audioMap ;
		$this->pdfMap = $pdfMap ;
	}


	public function executeCategoryforsubscription(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
		} else {
			return sfView::NONE ;
		}
	}


	public function executeCategoryforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			if($app->getStatus() == 0){
				$this->deleteEnabled = 0 ;
			} else {
				$this->deleteEnabled = 1 ;
			}

		  	$c = new Criteria() ;
		  	$c->add(SellItemCategoryPeer::DEL_FLG,0) ;
		  	$c->add(SellItemCategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(SellItemCategoryPeer::DISPLAY_ORDER) ;
			$sellItemCategories = SellItemCategoryPeer::doSelect($c) ;

			$videoCategoryMap = array() ;
			$pdfCategoryMap = array() ;
			$audioCategoryMap = array() ;
			foreach($sellItemCategories as $sellItemCategory){
				$kind = $sellItemCategory->getKind() ;
				$targetCategoryId = $sellItemCategory->getTargetCategoryId() ;
				if($kind == 1){ // video
					$videoCategory = VideoCategoryPeer::retrieveByPk($targetCategoryId) ;
					if($videoCategory){
						$videoCategoryMap[$targetCategoryId] = $videoCategory ;
					}
				} else if($kind == 2){ // pdf
					$pdfCategory = PdfCategoryPeer::retrieveByPk($targetCategoryId) ;
					if($pdfCategory){
						$pdfCategoryMap[$targetCategoryId] = $pdfCategory ;
					}
				} else if($kind == 3){ // audio
					$audioCategory = AudioCategoryPeer::retrieveByPk($targetCategoryId) ;
					if($audioCategory){
						$audioCategoryMap[$targetCategoryId] = $audioCategory ;
					}
				}
			}
		} else {
			return sfView::NONE ;
		}

		$this->sellItemCategories = $sellItemCategories ;
		$this->videoCategoryMap = $videoCategoryMap ;
		$this->pdfCategoryMap = $pdfCategoryMap ;
		$this->audioCategoryMap = $audioCategoryMap ;
	}



	public function executeCategoryforpps(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			if($app->getStatus() == 0){
				$this->deleteEnabled = 0 ;
			} else {
				$this->deleteEnabled = 1 ;
			}

		  	$c = new Criteria() ;
		  	$c->add(SellSectionCategoryPeer::DEL_FLG,0) ;
		  	$c->add(SellSectionCategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(SellSectionCategoryPeer::DISPLAY_ORDER) ;
			$sellSectionCategories = SellSectionCategoryPeer::doSelect($c) ;

		} else {
			return sfView::NONE ;
		}

		$this->sellSectionCategories = $sellSectionCategories ;
	}



	public function executeContentforsubscription(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$page = $request->getParameter('p') ;
			if(!$page){
				$page = 1 ;
			}
			$sortKind = $request->getParameter('so') ;

		  	$c = new Criteria() ;
		  	$c->add(MixedPeer::DEL_FLG,0) ;
		  	$c->add(MixedPeer::APP_ID,$appId) ;
		  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription

			if($sortKind == 1){
				$c->addAscendingOrderByColumn(MixedPeer::CREATED_AT) ;
			} else {
				$c->addDescendingOrderByColumn(MixedPeer::CREATED_AT) ;
			}

			$pager = new sfPropelPager('Mixed', 10) ;
			$pager->setCriteria($c) ;
			$pager->setPage($page) ;
			$pager->init() ;

			$lastPage = $pager->getLastPage() ;

			$audioIds = array() ;
			$videoIds = array() ;
			$socialUserIds = array() ;
			if($page <= $lastPage){
				$mixeds = $pager->getResults() ;
				foreach($mixeds as $mixed){
					$kind = $mixed->getKind() ;
					if(($kind == 7) || ($kind == 8)){
						$videoIds[] = $mixed->getContentId() ;
					} else if(($kind == 9) || ($kind == 10)){
						$audioIds[] = $mixed->getContentId() ;
					}
				}

				if(count($audioIds) > 0){
				  	$c = new Criteria() ;
				  	$c->add(AudioPeer::DEL_FLG,0) ;
				  	$c->add(AudioPeer::ID,$audioIds,Criteria::IN) ;
					$audios = AudioPeer::doSelect($c) ;
					if($audios){
						$audioMap = AdminTools::getMapForObjects($audios) ;
					}

				  	$c = new Criteria() ;
				  	$c->add(AudioLikePeer::DEL_FLAG,0) ;
				  	$c->add(AudioLikePeer::AUDIO_ID,$audioIds,Criteria::IN) ;
					$audioLikes = AudioLikePeer::doSelect($c) ;
					$numberOfAudioLikes = array() ;
					foreach($audioLikes as $audioLike){
						$numberOfAudioLikes[$audioLike->getAudioId()]++ ;
					}

				  	$c = new Criteria() ;
				  	$c->add(AudioCommentPeer::DEL_FLAG,0) ;
				  	$c->add(AudioCommentPeer::AUDIO_ID,$audioIds,Criteria::IN) ;
				  	$c->addAscendingOrderByColumn(AudioCommentPeer::CREATED_AT) ;
					$audioComments = AudioCommentPeer::doSelect($c) ;
					$audioCommentsMap = array() ;
					foreach($audioComments as $audioComment){
						if(!isset($audioCommentsMap[$audioComment->getAudioId()])){
							$audioCommentsMap[$audioComment->getAudioId()] = array() ;
						}
						$audioCommentsMap[$audioComment->getAudioId()][] = $audioComment ;

						$socialUserId = $audioComment->getSocialUserId() ;
						if($socialUserId){
							if(!in_array($socialUserId,$socialUserIds)){
								$socialUserIds[] = $socialUserId ;
							}
						}
					}

				}

				if(count($videoIds) > 0){
				  	$c = new Criteria() ;
				  	$c->add(VideoPeer::DEL_FLG,0) ;
				  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
					$videos = VideoPeer::doSelect($c) ;
					if($videos){
						$videoMap = AdminTools::getMapForObjects($videos) ;
					}

				  	$c = new Criteria() ;
				  	$c->add(VideoLikePeer::DEL_FLAG,0) ;
				  	$c->add(VideoLikePeer::VIDEO_ID,$videoIds,Criteria::IN) ;
					$videoLikes = VideoLikePeer::doSelect($c) ;
					$numberOfVideoLikes = array() ;
					foreach($videoLikes as $videoLike){
						$numberOfVideoLikes[$videoLike->getVideoId()]++ ;
					}

				  	$c = new Criteria() ;
				  	$c->add(VideoCommentPeer::DEL_FLAG,0) ;
				  	$c->add(VideoCommentPeer::VIDEO_ID,$videoIds,Criteria::IN) ;
				  	$c->addAscendingOrderByColumn(VideoCommentPeer::CREATED_AT) ;
					$videoComments = VideoCommentPeer::doSelect($c) ;
					$videoCommentsMap = array() ;
					foreach($videoComments as $videoComment){
						if(!isset($videoCommentsMap[$videoComment->getVideoId()])){
							$videoCommentsMap[$videoComment->getVideoId()] = array() ;
						}
						$videoCommentsMap[$videoComment->getVideoId()][] = $videoComment ;

						$socialUserId = $videoComment->getSocialUserId() ;
						if($socialUserId){
							if(!in_array($socialUserId,$socialUserIds)){
								$socialUserIds[] = $socialUserId ;
							}
						}
					}
				}

			  	$c = new Criteria() ;
			  	$c->add(SocialUserPeer::DEL_FLG,0) ;
				$c->add(SocialUserPeer::ID,$socialUserIds,Criteria::IN) ;
				$c->addAscendingOrderByColumn(SocialUserPeer::ID) ;
				$socialUsers = SocialUserPeer::doSelect($c) ;
				$socialUserMap = AdminTools::getMapForObjects($socialUsers) ;

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

			$this->mixeds = $mixeds ;
			$this->appId = $appId ;
			$this->page = $page ;
			$this->audioMap = $audioMap ;
			$this->videoMap = $videoMap ;
			$this->lastPage = $lastPage ;
			$this->startPage = $startPage ;
			$this->endPage = $endPage ;
			$this->sortKind = $sortKind ;
			$this->sortKinds = $sortKinds ;
			$this->numberOfAudioLikes = $numberOfAudioLikes ;
			$this->audioCommentsMap = $audioCommentsMap ;
			$this->numberOfVideoLikes = $numberOfVideoLikes ;
			$this->videoCommentsMap = $videoCommentsMap ;
			$this->socialUserMap = $socialUserMap ;

		} else {
			return sfView::NONE ;
		}

	}


	public function executeAddnewvideoforsubscription(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
		} else {
			return sfView::NONE ;
		}
	}

	public function executeRegistervideoforsubscription(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$title = $request->getParameter('title') ;
			if($title){
				$sourceUrl = $request->getParameter('video_url') ;
				$imageUrl = $request->getParameter('thumbnail_url') ;
				$kind = 8 ; // 8:video 10:audio

				$sourceUrl = str_replace('?dl=0','',$sourceUrl) ;
				$imageUrl = str_replace('?dl=0','',$imageUrl) ;

				$video = new Video() ;
				$video->setAppId($appId) ;
				$video->setDisplayOrder(0) ;
				$video->setTitle($title) ;
				$video->setVideoCategoryId(0) ;
				$video->setVideoSubCategoryId(0) ;
				$video->setKind(1) ;
				$video->setSourceUrl($sourceUrl) ;
				$video->save() ;
				ConsoleTools::saveConsoleLog($request,$video) ;

				$videoSource = new VideoSource() ;
				$videoSource->setAppId($appId) ;
				$videoSource->setVideoId($video->getId()) ;
				$videoSource->setUrl($sourceUrl) ;
				$videoSource->setImageUrl($imageUrl) ;
				$videoSource->setStatus(0) ;
				$videoSource->save() ;


				$mixed = new Mixed() ;
				$mixed->setAppId($appId) ;
				$mixed->setDisplayOrder(0) ;
				$mixed->setKind($kind) ;
				$mixed->setName($title) ;
				$mixed->setDisplayName($title) ;
				$mixed->setMixedCategoryId(0) ;
				$mixed->setMixedSubCategoryId(0) ;
				$mixed->setContentId($video->getId()) ;
				$mixed->setStatus(2) ; // Preparing
				$mixed->setStatusText("Preparing") ; // Preparing
				$mixed->save() ;
				ConsoleTools::saveConsoleLog($request,$mixed) ;

			  	$c = new Criteria() ;
			  	$c->add(MixedPeer::DEL_FLG,0) ;
			  	$c->add(MixedPeer::APP_ID,$appId) ;
			  	$c->add(MixedPeer::MIXED_CATEGORY_ID,0) ;
			  	$c->add(MixedPeer::MIXED_SUB_CATEGORY_ID,0) ;
				$c->addAscendingOrderByColumn(MixedPeer::DISPLAY_ORDER) ;
			  	$mixeds = MixedPeer::doSelect($c) ;

				$orderNo = 1 ;
				foreach($mixeds as $workMixed){
					$workMixed->setDisplayOrder($orderNo) ;
					$workMixed->save() ;
					$orderNo++ ;
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			}

			$this->forward('subscription','content') ;

		} else {
			return sfView::NONE ;
		}

	}



	public function executeAddnewaudioforsubscription(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
		} else {
			return sfView::NONE ;
		}

	}

	public function executeRegisteraudioforsubscription(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$title = $request->getParameter('title') ;
			if($title){
				$sourceUrl = $request->getParameter('audio_url') ;
				$imageUrl = $request->getParameter('thumbnail_url') ;
				$linkUrl = $request->getParameter('pdf_url') ;
				$kind = 10 ; // 8:video 10:audio

				$sourceUrl = str_replace('?dl=0','',$sourceUrl) ;
				$imageUrl = str_replace('?dl=0','',$imageUrl) ;
				$linkUrl = str_replace('?dl=0','',$linkUrl) ;

				$audio = new Audio() ;
				$audio->setAppId($appId) ;
				$audio->setDisplayOrder(0) ;
				$audio->setTitle($title) ;
				$audio->setAudioCategoryId(0) ;
				$audio->setAudioSubCategoryId(0) ;
				$audio->setKind(1) ;
				$audio->setDataUrl($sourceUrl) ;
				$audio->save() ;
				ConsoleTools::saveConsoleLog($request,$audio) ;

				$audioSource = new AudioSource() ;
				$audioSource->setAppId($appId) ;
				$audioSource->setAudioId($audio->getId()) ;
				$audioSource->setDataUrl($sourceUrl) ;
				$audioSource->setLinkDataUrl($linkUrl) ;
				$audioSource->setImageUrl($imageUrl) ;
				$audioSource->setStatus(0) ;
				$audioSource->save() ;


				$mixed = new Mixed() ;
				$mixed->setAppId($appId) ;
				$mixed->setDisplayOrder(0) ;
				$mixed->setKind($kind) ;
				$mixed->setName($title) ;
				$mixed->setDisplayName($title) ;
				$mixed->setMixedCategoryId(0) ;
				$mixed->setMixedSubCategoryId(0) ;
				$mixed->setContentId($audio->getId()) ;
				$mixed->setStatus(2) ; // Preparing
				$mixed->setStatusText("Preparing") ; // Preparing
				$mixed->save() ;
				ConsoleTools::saveConsoleLog($request,$mixed) ;

			  	$c = new Criteria() ;
			  	$c->add(MixedPeer::DEL_FLG,0) ;
			  	$c->add(MixedPeer::APP_ID,$appId) ;
			  	$c->add(MixedPeer::MIXED_CATEGORY_ID,0) ;
			  	$c->add(MixedPeer::MIXED_SUB_CATEGORY_ID,0) ;
				$c->addAscendingOrderByColumn(MixedPeer::DISPLAY_ORDER) ;
			  	$mixeds = MixedPeer::doSelect($c) ;

				$orderNo = 1 ;
				foreach($mixeds as $workMixed){
					$workMixed->setDisplayOrder($orderNo) ;
					$workMixed->save() ;
					$orderNo++ ;
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			}

			$this->forward('subscription','content') ;

		} else {
			return sfView::NONE ;
		}

	}














	public function executeContentforpps(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$page = $request->getParameter('p') ;
			if(!$page){
				$page = 1 ;
			}
			$sortKind = $request->getParameter('so') ;

		  	$c = new Criteria() ;
		  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
		  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;

			if($sortKind == 1){
				$c->addAscendingOrderByColumn(SellSectionItemPeer::CREATED_AT) ;
			} else {
				$c->addDescendingOrderByColumn(SellSectionItemPeer::CREATED_AT) ;
			}

			$pager = new sfPropelPager('SellSectionItem', 10) ;
			$pager->setCriteria($c) ;
			$pager->setPage($page) ;
			$pager->init() ;

			$lastPage = $pager->getLastPage() ;

			$audioIds = array() ;
			$videoIds = array() ;
			$pdfIds = array() ;
			if($page <= $lastPage){
				$sellSectionItems = $pager->getResults() ;
				foreach($sellSectionItems as $sellSectionItem){
					$kind = $sellSectionItem->getKind() ;
					if($kind == 1){
						$videoIds[] = $sellSectionItem->getContentId() ;
					} else if($kind == 2){
						$pdfIds[] = $sellSectionItem->getContentId() ;
					} else if($kind == 3){
						$audioIds[] = $sellSectionItem->getContentId() ;
					}
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

				if(count($videoIds) > 0){
				  	$c = new Criteria() ;
				  	$c->add(VideoPeer::DEL_FLG,0) ;
				  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
					$videos = VideoPeer::doSelect($c) ;
					if($videos){
						$videoMap = AdminTools::getMapForObjects($videos) ;
					}
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

			$this->sellSectionItems = $sellSectionItems ;
			$this->appId = $appId ;
			$this->page = $page ;
			$this->audioMap = $audioMap ;
			$this->videoMap = $videoMap ;
			$this->pdfMap = $pdfMap ;
			$this->lastPage = $lastPage ;
			$this->startPage = $startPage ;
			$this->endPage = $endPage ;
			$this->sortKind = $sortKind ;
			$this->sortKinds = $sortKinds ;

		} else {
			return sfView::NONE ;
		}

	}
























	public function executeAddsellsectioncategoryapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			$this->app = $app ;

			if($_SERVER["REQUEST_METHOD"] == "POST"){

				$kind = 0 ;
				$name = 'New Category' ;
				$sellSectionCategoryId = 0 ;

				$isNew = 0 ; 
				if($sellSectionCategoryId){
					$sellSectionCategory = SellSectionCategoryPeer::retrieveByPk($sellSectionCategoryId) ;
				} else {
					$isNew = 1 ; 
					$sellSectionCategory = new SellSectionCategory() ;
					$sellSectionCategory->setAppId($appId) ;
					$sellSectionCategory->setKind($kind) ;
					$sellSectionCategory->setDisplayOrder(0) ;
				}

				$sellSectionCategory->setName($name) ;
				$sellSectionCategory->save() ;
				ConsoleTools::saveConsoleLog($request,$sellSectionCategory) ;
				$data = array('sellSectionCategoryId'=>$sellSectionCategory->getId()) ;


				if($isNew){
				  	$c = new Criteria() ;
				  	$c->add(SellSectionCategoryPeer::DEL_FLG,0) ;
				  	$c->add(SellSectionCategoryPeer::APP_ID,$appId) ;
					$c->addAscendingOrderByColumn(SellSectionCategoryPeer::DISPLAY_ORDER) ;
				  	$sellSectionCategories = SellSectionCategoryPeer::doSelect($c) ;

					$orderNo = 1 ;
					foreach($sellSectionCategories as $catetory){
						$catetory->setDisplayOrder($orderNo) ;
						$catetory->save() ;
						$orderNo++ ;
					}
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			} else {
				$this->forward('subscription','category') ;
			}

		}
		echo json_encode($data) ;
		return sfView::NONE ;
	}

	public function executeChangesellsectioncategorynameapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			$this->app = $app ;

			$id = $request->getParameter('id') ;
			if($id){
				$name = $request->getParameter('na') ;

				$sellSectionCategory = SellSectionCategoryPeer::retrieveByPk($id) ;
				if($sellSectionCategory){
					$sellSectionCategory->setName($name) ;
					$sellSectionCategory->save() ;
					ConsoleTools::saveConsoleLog($request,$sellSectionCategory) ;
				}
			} else {
				$this->forward('subscription','category') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeRemovesellsectioncategoryapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			$this->app = $app ;

			$id = $request->getParameter('id') ;
			if($id){
				$sellSectionCategory = SellSectionCategoryPeer::retrieveByPk($id) ;
				$sellSectionCategory->delete() ;
			} else {
				$this->forward('subscription','category') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}

























	public function executeAddnewvideoforpps(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(SellSectionCategoryPeer::DEL_FLG,0) ;
		  	$c->add(SellSectionCategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(SellSectionCategoryPeer::DISPLAY_ORDER) ;
		  	$sellSectionCategories = SellSectionCategoryPeer::doSelect($c) ;
		} else {
			return sfView::NONE ;
		}

		$this->sellSectionCategories = $sellSectionCategories ;
	}


	public function executeAddnewaudioforpps(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(SellSectionCategoryPeer::DEL_FLG,0) ;
		  	$c->add(SellSectionCategoryPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(SellSectionCategoryPeer::DISPLAY_ORDER) ;
		  	$sellSectionCategories = SellSectionCategoryPeer::doSelect($c) ;
		} else {
			return sfView::NONE ;
		}

		$this->sellSectionCategories = $sellSectionCategories ;
	}

























	public function executeRegistervideoforpps(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$sellSectionCategoryId = $request->getParameter('category') ;
			if($sellSectionCategoryId){
				$sellSectionItemId = 0 ;
				$imageUrl = $request->getParameter('thumbnail_url') ;
				$sourceUrl = $request->getParameter('video_url') ;
				$title = ConsoleTools::xmlEscape($request->getParameter('title')) ;

				$sourceUrl = str_replace('?dl=0','',$sourceUrl) ;
				$imageUrl = str_replace('?dl=0','',$imageUrl) ;

				$isNew = 0 ; 
				if($sellSectionItemId){
					$sellSectionItem = SellSectionItemPeer::retrieveByPk($sellSectionItemId) ;
				} else {
					$isNew = 1 ; 
					$sellSectionItem = new SellSectionItem() ;
					$sellSectionItem->setAppId($appId) ;
					$sellSectionItem->setDisplayOrder(0) ;
				}


				$video = new Video() ;
				$video->setAppId($appId) ;
				$video->setTitle($title) ;
				$video->setVideoCategoryId(0) ;
				$video->setVideoSubCategoryId(0) ;
				$video->setKind(0) ;
				$video->setSourceUrl($sourceUrl) ;
				$video->save() ;
				ConsoleTools::saveConsoleLog($request,$video) ;

				$videoSource = new VideoSource() ;
				$videoSource->setAppId($appId) ;
				$videoSource->setVideoId($video->getId()) ;
				$videoSource->setUrl($sourceUrl) ;
				$videoSource->setImageUrl($imageUrl) ;
				$videoSource->setStatus(0) ;
				$videoSource->save() ;

				$videoId = $video->getId() ;
				$sellSectionItem->setSellSectionCategoryId($sellSectionCategoryId) ;
				$sellSectionItem->setSellSectionSubCategoryId(0) ;
				$sellSectionItem->setKind(1) ; // Video
				$sellSectionItem->setContentId($videoId) ;
				$sellSectionItem->setTitle($title) ;
				$sellSectionItem->setStatus(2) ;
				$sellSectionItem->setStatusText('Preparing') ;
				$sellSectionItem->save() ;
				ConsoleTools::saveConsoleLog($request,$sellSectionItem) ;

				if($isNew){
				  	$c = new Criteria() ;
				  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
				  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
					$c->addAscendingOrderByColumn(SellSectionItemPeer::DISPLAY_ORDER) ;
				  	$sellSectionItems = SellSectionItemPeer::doSelect($c) ;

					$orderNo = 1 ;
					foreach($sellSectionItems as $worksellSectionItem){
						$worksellSectionItem->setDisplayOrder($orderNo) ;
						$worksellSectionItem->save() ;
						$orderNo++ ;
					}
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			}

			$this->forward('subscription','content') ;

		} else {
			return sfView::NONE ;
		}

	}

















	public function executeRegisteraudioforpps(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$sellSectionCategoryId = $request->getParameter('category') ;
			if($sellSectionCategoryId){
				$sellSectionItemId = 0 ;
				$imageUrl = $request->getParameter('thumbnail_url') ;
				$pdfUrl = $request->getParameter('pdf_url') ;
				$sourceUrl = $request->getParameter('audio_url') ;
				$title = ConsoleTools::xmlEscape($request->getParameter('title')) ;

				$sourceUrl = str_replace('?dl=0','',$sourceUrl) ;
				$imageUrl = str_replace('?dl=0','',$imageUrl) ;

				$isNew = 0 ; 
				if($sellSectionItemId){
					$sellSectionItem = SellSectionItemPeer::retrieveByPk($sellSectionItemId) ;
				} else {
					$isNew = 1 ; 
					$sellSectionItem = new SellSectionItem() ;
					$sellSectionItem->setAppId($appId) ;
					$sellSectionItem->setDisplayOrder(0) ;
				}


				$audio = new Audio() ;
				$audio->setAppId($appId) ;
				$audio->setTitle($title) ;
				$audio->setAudioCategoryId(0) ;
				$audio->setAudioSubCategoryId(0) ;
				$audio->setKind(1) ;
				$audio->save() ;
				ConsoleTools::saveConsoleLog($request,$audio) ;

				$audioSource = new AudioSource() ;
				$audioSource->setAppId($appId) ;
				$audioSource->setAudioId($audio->getId()) ;
				$audioSource->setDataUrl($sourceUrl) ;
				$audioSource->setLinkDataUrl($pdfUrl) ;
				$audioSource->setImageUrl($imageUrl) ;
				$audioSource->setStatus(0) ;
				$audioSource->save() ;

				$audioId = $audio->getId() ;
				$sellSectionItem->setSellSectionCategoryId($sellSectionCategoryId) ;
				$sellSectionItem->setSellSectionSubCategoryId(0) ;
				$sellSectionItem->setKind(3) ; // Audio
				$sellSectionItem->setContentId($audioId) ;
				$sellSectionItem->setTitle($title) ;
				$sellSectionItem->setStatus(2) ;
				$sellSectionItem->setStatusText('Preparing') ;
				$sellSectionItem->save() ;
				ConsoleTools::saveConsoleLog($request,$sellSectionItem) ;

				if($isNew){
				  	$c = new Criteria() ;
				  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
				  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
					$c->addAscendingOrderByColumn(SellSectionItemPeer::DISPLAY_ORDER) ;
				  	$sellSectionItems = SellSectionItemPeer::doSelect($c) ;

					$orderNo = 1 ;
					foreach($sellSectionItems as $worksellSectionItem){
						$worksellSectionItem->setDisplayOrder($orderNo) ;
						$worksellSectionItem->save() ;
						$orderNo++ ;
					}
				}

				ConsoleTools::consoleContentsChanged($appId) ;
			}

			$this->forward('subscription','content') ;

		} else {
			return sfView::NONE ;
		}

	}












	public function executeSectioninfo(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
			if($templateSubscription){
				$currentType = $templateSubscription->getKind() ;
				if($currentType == 4){
					$this->forward('subscription','sectioninfoforsubscription') ;
				} else if($currentType == 5){
					$this->forward('subscription','sectioninfoforppc') ;
				} else if($currentType == 6){
					$this->forward('subscription','sectioninfoforpps') ;
				}
			}
		} else {
			return sfView::NONE ;
		}
		return sfView::NONE ;

	}



	public function executeSectioninfoforpps(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;

			if($templateSubscription){

				$subscriptionPrice = $templateSubscription->getPrice() ;

			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	$c->add(AppDataPeer::NAME,'section_0_description') ;
			  	$appData = AppDataPeer::doSelectOne($c) ;
				if($appData){
					$subscriptionDescription = $appData->getData() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	$c->add(AppDataPeer::NAME,'section_payment_0_description') ;
			  	$appData = AppDataPeer::doSelectOne($c) ;
				if($appData){
					$subscriptionPaymentDescription = $appData->getData() ;
				}



				$this->setPrices() ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}

		$this->subscriptionPrice = $subscriptionPrice ;
		$this->subscriptionDescription = $subscriptionDescription ;
		$this->subscriptionPaymentDescription = $subscriptionPaymentDescription ;
	}



	public function executeSavesectioninfoforppsapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;

			if($templateSubscription){

				$description = $request->getParameter('description') ;
				$purchaseDescription = $request->getParameter('purchase_description') ;
				$price = $request->getParameter('price') ;
				if($price){
					$templateSubscription->setPrice($price) ;
					$templateSubscription->save() ;

				  	$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,'section_0_description') ;
				  	$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setAppId($appId) ;
						$appData->setName('section_0_description') ;
					}
					$appData->setData(ConsoleTools::xmlEscape($description)) ;
					$appData->save() ;

				  	$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,'section_payment_0_description') ;
				  	$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setAppId($appId) ;
						$appData->setName('section_payment_0_description') ;
					}
					$appData->setData(ConsoleTools::xmlEscape($purchaseDescription)) ;
					$appData->save() ;
				} else {
					$this->forward('subscription','sectioninfo') ;
				}
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}
























	public function executeSectioninfoforsubscription(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;

			if($templateSubscription){

				$subscriptionPrice = $templateSubscription->getPrice() ;

			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	$c->add(AppDataPeer::NAME,'subscription_0_description') ;
			  	$appData = AppDataPeer::doSelectOne($c) ;
				if($appData){
					$subscriptionDescription = $appData->getData() ;
				}

				$this->setPrices() ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}

		$this->subscriptionPrice = $subscriptionPrice ;
		$this->subscriptionDescription = $subscriptionDescription ;
	}



	public function executeSavesectioninfoforsubscriptionapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;

			if($templateSubscription){

				$description = $request->getParameter('description') ;
				if($description){
					$price = $request->getParameter('price') ;
					$templateSubscription->setPrice($price) ;
					$templateSubscription->save() ;

				  	$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,'subscription_0_description') ;
				  	$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setAppId($appId) ;
						$appData->setName('subscription_0_description') ;
					}
					$appData->setData(ConsoleTools::xmlEscape($description)) ;
					$appData->save() ;
				} else {
					$this->forward('subscription','sectioninfo') ;
				}
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}





	public function executeSectioninfoforppc(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
		} else {
			return sfView::NONE ;
		}

	}





}


function compareTime($a, $b) {
    if ($a->getCreatedAt() == $b->getCreatedAt()) {
        return 0;
    }
    return ($a->getCreatedAt() > $b->getCreatedAt()) ? -1 : 1;
}
