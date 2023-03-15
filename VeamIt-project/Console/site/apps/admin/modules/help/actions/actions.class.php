<?php

/**
 * help actions.
 *
 * @package    console
 * @subpackage help
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class helpActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */

	public function executeContentscheck(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;

			  	$c = new Criteria() ;
			  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
				$this->questions = AppRatingQuestionPeer::doSelect($c) ;

			  	$c = new Criteria() ;
			  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
			  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
				$answers = AppRatingAnswerPeer::doSelect($c) ;
				$answerMapForQuestion = array() ;
				foreach($answers as $answer){
					$answerMapForQuestion[$answer->getAppRatingQuestionId()] = $answer ;
				}
				$this->answerMapForQuestion = $answerMapForQuestion ;

				//// subscription

				//// Template Subscription
			  	$c = new Criteria() ;
			  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
			  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
				$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
				$this->templateSubscription = $templateSubscription ;

			  	$c = new Criteria() ;
			  	$c->add(MixedPeer::DEL_FLG,0) ;
			  	$c->add(MixedPeer::APP_ID,$appId) ;
			  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
				$c->addDescendingOrderByColumn(MixedPeer::UPDATED_AT) ;
				$mixeds = MixedPeer::doSelect($c) ;
				foreach($mixeds as $mixed){
					$kind = $mixed->getKind() ;
					if(($kind == 7) || ($kind == 8)){
						$videoIds[] = $mixed->getContentId() ;
					} else if(($kind == 9) || ($kind == 10)){
						$audioIds[] = $mixed->getContentId() ;
					}
				}

			  	$c = new Criteria() ;
			  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
			  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellSectionItemPeer::UPDATED_AT) ;
				$sellSectionItems = SellSectionItemPeer::doSelect($c) ;
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

			  	$c = new Criteria() ;
			  	$c->add(SellSectionCategoryPeer::DEL_FLG,0) ;
			  	$c->add(SellSectionCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellSectionCategoryPeer::UPDATED_AT) ;
				$sellSectionCategories = SellSectionCategoryPeer::doSelect($c) ;
				if($sellSectionCategories){
					$sellSectionCategoryMap = AdminTools::getMapForObjects($sellSectionCategories) ;
				}







			  	$c = new Criteria() ;
			  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
			  	$c->add(SellVideoPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellVideoPeer::UPDATED_AT) ;
				$sellVideos = SellVideoPeer::doSelect($c) ;
				foreach($sellVideos as $sellVideo){
					$videoIds[] = $sellVideo->getVideoId() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
			  	$c->add(SellAudioPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellAudioPeer::UPDATED_AT) ;
				$sellAudios = SellAudioPeer::doSelect($c) ;
				foreach($sellAudios as $sellAudio){
					$audioIds[] = $sellAudio->getAudioId() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
			  	$c->add(SellPdfPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellPdfPeer::UPDATED_AT) ;
				$sellPdfs = SellPdfPeer::doSelect($c) ;
				foreach($sellPdfs as $sellPdf){
					$pdfIds[] = $sellPdf->getPdfId() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(VideoCategoryPeer::DEL_FLG,0) ;
			  	$c->add(VideoCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(VideoCategoryPeer::UPDATED_AT) ;
				$videoCategories = VideoCategoryPeer::doSelect($c) ;
				if($videoCategories){
					$videoCategoryMap = AdminTools::getMapForObjects($videoCategories) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(AudioCategoryPeer::DEL_FLG,0) ;
			  	$c->add(AudioCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(AudioCategoryPeer::UPDATED_AT) ;
				$audioCategories = AudioCategoryPeer::doSelect($c) ;
				if($audioCategories){
					$audioCategoryMap = AdminTools::getMapForObjects($audioCategories) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(PdfCategoryPeer::DEL_FLG,0) ;
			  	$c->add(PdfCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(PdfCategoryPeer::UPDATED_AT) ;
				$pdfCategories = PdfCategoryPeer::doSelect($c) ;
				if($pdfCategories){
					$pdfCategoryMap = AdminTools::getMapForObjects($pdfCategories) ;
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

				$this->mixeds = $mixeds ;
				$this->sellSectionItems = $sellSectionItems ;
				$this->sellVideos = $sellVideos ;
				$this->sellAudios = $sellAudios ;
				$this->sellPdfs = $sellPdfs ;
				$this->audioMap = $audioMap ;
				$this->videoMap = $videoMap ;
				$this->pdfMap = $pdfMap ;
				$this->sellSectionCategoryMap = $sellSectionCategoryMap ;
				$this->sellItemCategoryMap = $sellItemCategoryMap ;
				$this->videoCategoryMap = $videoCategoryMap ;
				$this->audioCategoryMap = $audioCategoryMap ;
				$this->pdfCategoryMap = $pdfCategoryMap ;

				//// youtube
			  	$c = new Criteria() ;
			  	$c->add(CategoryPeer::DEL_FLG,0) ;
			  	$c->add(CategoryPeer::DISABLED,0) ;
			  	$c->add(CategoryPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
				$youtubeCategories = CategoryPeer::doSelect($c) ;

				$this->youtubeCategories = $youtubeCategories ;


				//// forum
			  	$c = new Criteria() ;
			  	$c->add(ForumPeer::DEL_FLAG,0) ;
			  	$c->add(ForumPeer::APP_ID,$appId) ;
			  	$c->add(ForumPeer::KIND,1) ;
				$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
				$forums = ForumPeer::doSelect($c) ;
				$forumMap = AdminTools::getMapForObjects($forums) ;

				$this->forums = $forums ;
				$this->forumMap = $forumMap ;



				//// link
			  	$c = new Criteria() ;
			  	$c->add(WebPeer::DEL_FLAG,0) ;
			  	$c->add(WebPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
				$webs = WebPeer::doSelect($c) ;

				$this->webs = $webs ;





				//// About Subscription
			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	$c->add(AppDataPeer::NAME,'subscription_0_description') ;
				$aboutSubscription = AppDataPeer::doSelectOne($c) ;
				if($aboutSubscription){
					$this->aboutSubscription = $this->unescapeXml($aboutSubscription->getData()) ;
				}

			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}


	public function executeMisc(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;

			  	$c = new Criteria() ;
			  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
				$this->questions = AppRatingQuestionPeer::doSelect($c) ;

			  	$c = new Criteria() ;
			  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
			  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
				$answers = AppRatingAnswerPeer::doSelect($c) ;
				$answerMapForQuestion = array() ;
				foreach($answers as $answer){
					$answerMapForQuestion[$answer->getAppRatingQuestionId()] = $answer ;
				}
				$this->answerMapForQuestion = $answerMapForQuestion ;

				//// subscription

				//// Template Subscription
			  	$c = new Criteria() ;
			  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
			  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
				$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
				$this->templateSubscription = $templateSubscription ;

			  	$c = new Criteria() ;
			  	$c->add(MixedPeer::DEL_FLG,0) ;
			  	$c->add(MixedPeer::APP_ID,$appId) ;
			  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
				$c->addDescendingOrderByColumn(MixedPeer::UPDATED_AT) ;
				$mixeds = MixedPeer::doSelect($c) ;
				foreach($mixeds as $mixed){
					$kind = $mixed->getKind() ;
					if(($kind == 7) || ($kind == 8)){
						$videoIds[] = $mixed->getContentId() ;
					} else if(($kind == 9) || ($kind == 10)){
						$audioIds[] = $mixed->getContentId() ;
					}
				}

			  	$c = new Criteria() ;
			  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
			  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellSectionItemPeer::UPDATED_AT) ;
				$sellSectionItems = SellSectionItemPeer::doSelect($c) ;
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

			  	$c = new Criteria() ;
			  	$c->add(SellSectionCategoryPeer::DEL_FLG,0) ;
			  	$c->add(SellSectionCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellSectionCategoryPeer::UPDATED_AT) ;
				$sellSectionCategories = SellSectionCategoryPeer::doSelect($c) ;
				if($sellSectionCategories){
					$sellSectionCategoryMap = AdminTools::getMapForObjects($sellSectionCategories) ;
				}







			  	$c = new Criteria() ;
			  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
			  	$c->add(SellVideoPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellVideoPeer::UPDATED_AT) ;
				$sellVideos = SellVideoPeer::doSelect($c) ;
				foreach($sellVideos as $sellVideo){
					$videoIds[] = $sellVideo->getVideoId() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
			  	$c->add(SellAudioPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellAudioPeer::UPDATED_AT) ;
				$sellAudios = SellAudioPeer::doSelect($c) ;
				foreach($sellAudios as $sellAudio){
					$audioIds[] = $sellAudio->getAudioId() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
			  	$c->add(SellPdfPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellPdfPeer::UPDATED_AT) ;
				$sellPdfs = SellPdfPeer::doSelect($c) ;
				foreach($sellPdfs as $sellPdf){
					$pdfIds[] = $sellPdf->getPdfId() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(VideoCategoryPeer::DEL_FLG,0) ;
			  	$c->add(VideoCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(VideoCategoryPeer::UPDATED_AT) ;
				$videoCategories = VideoCategoryPeer::doSelect($c) ;
				if($videoCategories){
					$videoCategoryMap = AdminTools::getMapForObjects($videoCategories) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(AudioCategoryPeer::DEL_FLG,0) ;
			  	$c->add(AudioCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(AudioCategoryPeer::UPDATED_AT) ;
				$audioCategories = AudioCategoryPeer::doSelect($c) ;
				if($audioCategories){
					$audioCategoryMap = AdminTools::getMapForObjects($audioCategories) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(PdfCategoryPeer::DEL_FLG,0) ;
			  	$c->add(PdfCategoryPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(PdfCategoryPeer::UPDATED_AT) ;
				$pdfCategories = PdfCategoryPeer::doSelect($c) ;
				if($pdfCategories){
					$pdfCategoryMap = AdminTools::getMapForObjects($pdfCategories) ;
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

				$this->mixeds = $mixeds ;
				$this->sellSectionItems = $sellSectionItems ;
				$this->sellVideos = $sellVideos ;
				$this->sellAudios = $sellAudios ;
				$this->sellPdfs = $sellPdfs ;
				$this->audioMap = $audioMap ;
				$this->videoMap = $videoMap ;
				$this->pdfMap = $pdfMap ;
				$this->sellSectionCategoryMap = $sellSectionCategoryMap ;
				$this->sellItemCategoryMap = $sellItemCategoryMap ;
				$this->videoCategoryMap = $videoCategoryMap ;
				$this->audioCategoryMap = $audioCategoryMap ;
				$this->pdfCategoryMap = $pdfCategoryMap ;

				//// youtube
			  	$c = new Criteria() ;
			  	$c->add(CategoryPeer::DEL_FLG,0) ;
			  	$c->add(CategoryPeer::DISABLED,0) ;
			  	$c->add(CategoryPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
				$youtubeCategories = CategoryPeer::doSelect($c) ;

				$this->youtubeCategories = $youtubeCategories ;


				//// forum
			  	$c = new Criteria() ;
			  	$c->add(ForumPeer::DEL_FLAG,0) ;
			  	$c->add(ForumPeer::APP_ID,$appId) ;
			  	$c->add(ForumPeer::KIND,1) ;
				$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
				$forums = ForumPeer::doSelect($c) ;
				$forumMap = AdminTools::getMapForObjects($forums) ;

				$this->forums = $forums ;
				$this->forumMap = $forumMap ;



				//// link
			  	$c = new Criteria() ;
			  	$c->add(WebPeer::DEL_FLAG,0) ;
			  	$c->add(WebPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
				$webs = WebPeer::doSelect($c) ;

				$this->webs = $webs ;





				//// About Subscription
			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	$c->add(AppDataPeer::NAME,'subscription_0_description') ;
				$aboutSubscription = AppDataPeer::doSelectOne($c) ;
				if($aboutSubscription){
					$this->aboutSubscription = $this->unescapeXml($aboutSubscription->getData()) ;
				}

				//// About Subscription
			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	//$c->add(AppDataPeer::NAME,'subscription_0_description') ;
				$appDatas = AppDataPeer::doSelect($c) ;
				if($appDatas){
					foreach($appDatas as $appData){
						$dataName = $appData->getName() ;
						if($dataName == 'subscription_0_description'){
							$this->aboutSubscription = $this->unescapeXml($appData->getData()) ;
						}
						if($dataName == 'subscription_0_button_text'){
							$this->subscriptionPurchaseButton = $this->unescapeXml($appData->getData()) ;
						}
					}
				}

			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}


	public function unescapeXml($text)
	{
		$retValue = $text ;
		$retValue = str_replace('&amp;',"&",$retValue) ;
		$retValue = str_replace('&quot;','"',$retValue) ;
		$retValue = str_replace('&gt;',">",$retValue) ;
		$retValue = str_replace('&lt;',"<",$retValue) ;
		$retValue = str_replace('&#xA;',"\n",$retValue) ;
		return $retValue ;
	}


	public function executeRegisterapptoiosdevcenter(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}


	public function executeRegisterapnsseystoiosdevcenter(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeUploadapnskeystoveam(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeCreateprovisioningprofile(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeRegisterapptoitunesconnect(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeRegisterpaymentitemtoitunesconnect(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;

			  	$c = new Criteria() ;
			  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
			  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
				$templateSubscrpition = TemplateSubscriptionPeer::doSelectOne($c) ;
				$this->templateSubscrpition = $templateSubscrpition ;
				$priceString = "" ;
				if($templateSubscrpition){
					$priceString = $templateSubscrpition->getPrice() ;
				}
				if(!$priceString){
					$priceString = "$0.99" ;
				}

				$priceList = array(
					"$0.99" => "Tier 1",
					"$1.99" => "Tier 2",
					"$2.99" => "Tier 3",
					"$3.99" => "Tier 4",
					"$4.99" => "Tier 5",
					"$5.99" => "Tier 6",
					"$6.99" => "Tier 7",
					"$7.99" => "Tier 8",
					"$8.99" => "Tier 9",
					"$9.99" => "Tier 10",
				) ;

				$priceTier = $priceList[$priceString] ;
				if(!$priceTier){
					$priceTier = "Tier X" ;
					AdminTools::assert(false,"Tier string not found priceString=$priceString",__FILE__,__LINE__) ;
				}

				$this->priceString = $priceString ;
				$this->priceTier = $priceTier ;

			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	$c->add(AppDataPeer::NAME,"subscription_index",Criteria::LIKE) ;
				$appData = AppDataPeer::doSelectOne($c) ;
				if($appData){
					$this->subscriptionIndex = $appData->getData() ;
				} else {
					$this->subscriptionIndex = 0 ;
				}

				if($templateSubscrpition->getKind() == 5){ // PPC
				  	$c = new Criteria() ;
				  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
				  	$c->add(SellVideoPeer::APP_ID,$appId) ;
					$sellVideos = SellVideoPeer::doSelect($c) ;
					if($sellVideos){
						$this->sellVideos = $sellVideos ;
						$videoIds = array() ;
						foreach($sellVideos as $sellVideo){
							$videoIds[] = $sellVideo->getVideoId() ;
						}
					  	$c = new Criteria() ;
					  	$c->add(VideoPeer::DEL_FLG,0) ;
					  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
						$videos = VideoPeer::doSelect($c) ;
						$videoMap = array() ;
						foreach($videos as $video){
							$videoMap[$video->getId()] = $video ;
						}
						$this->videoMap = $videoMap ;
					}

				  	$c = new Criteria() ;
				  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
				  	$c->add(SellAudioPeer::APP_ID,$appId) ;
					$sellAudios = SellAudioPeer::doSelect($c) ;
					if($sellAudios){
						$this->sellAudios = $sellAudios ;
						$audioIds = array() ;
						foreach($sellAudios as $sellAudio){
							$audioIds[] = $sellAudio->getAudioId() ;
						}
					  	$c = new Criteria() ;
					  	$c->add(AudioPeer::DEL_FLG,0) ;
					  	$c->add(AudioPeer::ID,$audioIds,Criteria::IN) ;
						$audios = AudioPeer::doSelect($c) ;
						$audioMap = array() ;
						foreach($audios as $audio){
							$audioMap[$audio->getId()] = $audio ;
						}
						$this->audioMap = $audioMap ;
					}

				  	$c = new Criteria() ;
				  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
				  	$c->add(SellPdfPeer::APP_ID,$appId) ;
					$sellPdfs = SellPdfPeer::doSelect($c) ;
					if($sellPdfs){
						$this->sellPdfs = $sellPdfs ;
						$pdfIds = array() ;
						foreach($sellPdfs as $sellPdf){
							$pdfIds[] = $sellPdf->getPdfId() ;
						}
					  	$c = new Criteria() ;
					  	$c->add(PdfPeer::DEL_FLG,0) ;
					  	$c->add(PdfPeer::ID,$pdfIds,Criteria::IN) ;
						$pdfs = PdfPeer::doSelect($c) ;
						$pdfMap = array() ;
						foreach($pdfs as $pdf){
							$pdfMap[$pdf->getId()] = $pdf ;
						}
						$this->pdfMap = $pdfMap ;
					}

				}

			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeRegisterpaymentitemtogoogleplay(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;

			  	$c = new Criteria() ;
			  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
			  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
				$templateSubscrpition = TemplateSubscriptionPeer::doSelectOne($c) ;
				$this->templateSubscrpition = $templateSubscrpition ;
				$priceString = "" ;
				if($templateSubscrpition){
					$priceString = $templateSubscrpition->getPrice() ;
				}
				if(!$priceString){
					$priceString = "$0.99" ;
				}

				$priceList = array(
					"$0.99" => "Tier 1",
					"$1.99" => "Tier 2",
					"$2.99" => "Tier 3",
					"$3.99" => "Tier 4",
					"$4.99" => "Tier 5",
					"$5.99" => "Tier 6",
					"$6.99" => "Tier 7",
					"$7.99" => "Tier 8",
					"$8.99" => "Tier 9",
					"$9.99" => "Tier 10",
				) ;

				$priceTier = $priceList[$priceString] ;
				if(!$priceTier){
					$priceTier = "Tier X" ;
					AdminTools::assert(false,"Tier string not found priceString=$priceString",__FILE__,__LINE__) ;
				}

				$this->priceString = $priceString ;
				$this->priceTier = $priceTier ;

			  	$c = new Criteria() ;
			  	$c->add(AppDataPeer::DEL_FLG,0) ;
			  	$c->add(AppDataPeer::APP_ID,$appId) ;
			  	$c->add(AppDataPeer::NAME,"subscription_index",Criteria::LIKE) ;
				$appData = AppDataPeer::doSelectOne($c) ;
				if($appData){
					$this->subscriptionIndex = $appData->getData() ;
				} else {
					$this->subscriptionIndex = 0 ;
				}

				if($templateSubscrpition->getKind() == 5){ // PPC
				  	$c = new Criteria() ;
				  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
				  	$c->add(SellVideoPeer::APP_ID,$appId) ;
					$sellVideos = SellVideoPeer::doSelect($c) ;
					if($sellVideos){
						$this->sellVideos = $sellVideos ;
						$videoIds = array() ;
						foreach($sellVideos as $sellVideo){
							$videoIds[] = $sellVideo->getVideoId() ;
						}
					  	$c = new Criteria() ;
					  	$c->add(VideoPeer::DEL_FLG,0) ;
					  	$c->add(VideoPeer::ID,$videoIds,Criteria::IN) ;
						$videos = VideoPeer::doSelect($c) ;
						$videoMap = array() ;
						foreach($videos as $video){
							$videoMap[$video->getId()] = $video ;
						}
						$this->videoMap = $videoMap ;
					}

				  	$c = new Criteria() ;
				  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
				  	$c->add(SellAudioPeer::APP_ID,$appId) ;
					$sellAudios = SellAudioPeer::doSelect($c) ;
					if($sellAudios){
						$this->sellAudios = $sellAudios ;
						$audioIds = array() ;
						foreach($sellAudios as $sellAudio){
							$audioIds[] = $sellAudio->getAudioId() ;
						}
					  	$c = new Criteria() ;
					  	$c->add(AudioPeer::DEL_FLG,0) ;
					  	$c->add(AudioPeer::ID,$audioIds,Criteria::IN) ;
						$audios = AudioPeer::doSelect($c) ;
						$audioMap = array() ;
						foreach($audios as $audio){
							$audioMap[$audio->getId()] = $audio ;
						}
						$this->audioMap = $audioMap ;
					}

				  	$c = new Criteria() ;
				  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
				  	$c->add(SellPdfPeer::APP_ID,$appId) ;
					$sellPdfs = SellPdfPeer::doSelect($c) ;
					if($sellPdfs){
						$this->sellPdfs = $sellPdfs ;
						$pdfIds = array() ;
						foreach($sellPdfs as $sellPdf){
							$pdfIds[] = $sellPdf->getPdfId() ;
						}
					  	$c = new Criteria() ;
					  	$c->add(PdfPeer::DEL_FLG,0) ;
					  	$c->add(PdfPeer::ID,$pdfIds,Criteria::IN) ;
						$pdfs = PdfPeer::doSelect($c) ;
						$pdfMap = array() ;
						foreach($pdfs as $pdf){
							$pdfMap[$pdf->getId()] = $pdf ;
						}
						$this->pdfMap = $pdfMap ;
					}
				}

			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}










	public function executeRegisterppc(sfWebRequest $request)
	{
		$sellItemId = $request->getParameter('i') ;
		$kind = $request->getParameter('k') ; // 1:Video 2:Audio 3:PDF

		if($kind == 1){
		  	$c = new Criteria() ;
		  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
		  	$c->add(SellVideoPeer::ID,$sellItemId) ;
			$sellItem = SellVideoPeer::doSelectOne($c) ;

		  	$c = new Criteria() ;
		  	$c->add(VideoPeer::DEL_FLG,0) ;
		  	$c->add(VideoPeer::ID,$sellItem->getVideoId()) ;
			$video = VideoPeer::doSelectOne($c) ;
			$title = $video->getTitle() ;
		} else if($kind == 2){
		  	$c = new Criteria() ;
		  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
		  	$c->add(SellAudioPeer::ID,$sellItemId) ;
			$sellItem = SellAudioPeer::doSelectOne($c) ;

		  	$c = new Criteria() ;
		  	$c->add(AudioPeer::DEL_FLG,0) ;
		  	$c->add(AudioPeer::ID,$sellItem->getAudioId()) ;
			$audio = AudioPeer::doSelectOne($c) ;
			$title = $audio->getTitle() ;
		} else if($kind == 3){
		  	$c = new Criteria() ;
		  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
		  	$c->add(SellPdfPeer::ID,$sellItemId) ;
			$sellItem = SellPdfPeer::doSelectOne($c) ;

		  	$c = new Criteria() ;
		  	$c->add(PdfPeer::DEL_FLG,0) ;
		  	$c->add(PdfPeer::ID,$sellItem->getPdfId()) ;
			$pdf = PdfPeer::doSelectOne($c) ;
			$title = $pdf->getTitle() ;
		}
		if($sellItem){
			$appId = $sellItem->getAppId() ;
		}

		if($appId){
			if($this->isValidApp($appId)){
				$app = AppPeer::retrieveByPk($appId) ;

				$this->setActionValues($request) ;

				$priceString = "" ;
				if($sellItem){
					$priceString = $sellItem->getPriceText() ;
				}
				if(!$priceString){
					$priceString = "$0.99" ;
				}

				$priceList = array(
					"$0.99" => "Tier 1",
					"$1.99" => "Tier 2",
					"$2.99" => "Tier 3",
					"$3.99" => "Tier 4",
					"$4.99" => "Tier 5",
					"$5.99" => "Tier 6",
					"$6.99" => "Tier 7",
					"$7.99" => "Tier 8",
					"$8.99" => "Tier 9",
					"$9.99" => "Tier 10",
				) ;

				$priceTier = $priceList[$priceString] ;
				if(!$priceTier){
					$priceTier = "Tier X" ;
					AdminTools::assert(false,"Tier string not found priceString=$priceString",__FILE__,__LINE__) ;
				}

				$this->app = $app ;
				$this->priceString = $priceString ;
				$this->priceTier = $priceTier ;
				$this->title = $title ;
				$this->sellItem = $sellItem ;

			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}


















	public function executeRegisterapptogoogleplay(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				AdminTools::createAndroidResource($appId) ;
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}



	public function executeRegisterapptofacebook(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeRegisterapptotwitter(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeRegisterapptokiip(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;

			  	$c = new Criteria() ;
			  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
			  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
			  	$c->add(AlternativeImagePeer::FILE_NAME,'c_small_icon.png') ;
				$alternativeImage = AlternativeImagePeer::doSelectOne($c) ;
				if($alternativeImage){
					$this->smallIconUrl = $alternativeImage->getUrl() ;
				} else {
					AdminTools::assert(false,"small icon not found appId=$appId",__FILE__,__LINE__) ;
				}
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeRegisterapptoadmob(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeCreatexcodeproject(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeCreateandroidproject(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeTestandroidapp(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}



	public function executeBuildappandtest(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeDownloadandroidappandtest(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeBuildappanduploadtoitunesconnect(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeSubmitforapplereview(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeUploadpaymentscreenshottoitunesconnect(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeSetmetatoitunesconnect(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;

			  	$c = new Criteria() ;
			  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
				$this->questions = AppRatingQuestionPeer::doSelect($c) ;

			  	$c = new Criteria() ;
			  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
			  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
				$answers = AppRatingAnswerPeer::doSelect($c) ;
				$answerMapForQuestion = array() ;
				foreach($answers as $answer){
					$answerMapForQuestion[$answer->getAppRatingQuestionId()] = $answer ;
				}
				$this->answerMapForQuestion = $answerMapForQuestion ;

			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}



	public function executeStats(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
			} else {
				return sfView::NONE ;
			}
		} else {
			return sfView::NONE ;
		}
	}

	public function executeQrapk(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		if($appId){
			if($this->isValidApp($appId)){
				$this->setActionValues($request) ;
				require(dirname(__FILE__)."/qrcode_img.php");

				$response = $this->getResponse();
				$response->clearHttpHeaders();
				$response->setContentType("Content-type: image/png");
				$response->sendHttpHeaders();

				ob_end_flush();

				$data = $this->app->getApkUrl() ;

				$z = new Qrcode_image;

				$z->qrcode_image_out($data,"png");

			}
		}
		return sfView::NONE ;
	}













	public function setActionValues($request)
	{
		$appId = $request->getParameter('a') ;
		$this->app = AppPeer::retrieveByPk($appId) ;
		$appProcessId = $request->getParameter('p') ;
		$this->appProcess = AppProcessPeer::retrieveByPk($appProcessId) ;

		$this->appDescription = $this->app->getDescription() ;
		$this->appDescription = str_replace('     including',' including',$this->appDescription) ;
		$this->appDescription = str_replace('Instagram like feature in the ','',$this->appDescription) ;
		$this->appDescription = str_replace('Instagram','',$this->appDescription) ;
		$this->appDescription = str_replace('instagram','',$this->appDescription) ;
		$this->appDescription = str_replace('[Your Name]',$this->app->getName(),$this->appDescription) ;
	}

	public function isValidApp($appId)
	{
		$app = AppPeer::retrieveByPk($appId) ;
		$isValid = ($app->getMcnId() == $this->mcnId) ;
		if(!$isValid){
			$request->setParameter('m','Invalid app') ;
			$this->forward('error','index') ;
		}

		return $isValid ;
	}




}
