<?php

/**
 * app actions.
 *
 * @package    console
 * @subpackage app
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class appActions extends myActions
{

	public function executeAndroidpreview(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
		} else {
			return sfView::NONE ;
		}
	}

	public function executeSendandroidpreviewurl(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
		    $email = $request->getParameter('email') ;
			if($email){
				AdminTools::sendNotificationMail("Veam Preview App for Android",$email,"\n\nhttp://veam.co/apk/veamit/veamit.apk\n\n") ;
			} else {
				$this->forward('app','androidpreview') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}

	public function executePublish(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
			if($app->getStatus() == 0){ // released
				$isAppReleased = true ;

				//// youtube
			  	$c = new Criteria() ;
			  	$c->add(CategoryPeer::DEL_FLG,0) ;
			  	$c->add(CategoryPeer::DISABLED,0) ;
			  	$c->add(CategoryPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
				$youtubeCategories = CategoryPeer::doSelect($c) ;

			  	$c = new Criteria() ;
			  	$c->add(ForumPeer::DEL_FLAG,0) ;
			  	$c->add(ForumPeer::APP_ID,$appId) ;
			  	$c->add(ForumPeer::KIND,1) ;
				$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
				$forums = ForumPeer::doSelect($c) ;

				//// link
			  	$c = new Criteria() ;
			  	$c->add(WebPeer::DEL_FLAG,0) ;
			  	$c->add(WebPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
				$webs = WebPeer::doSelect($c) ;

				if(true){ // Subscription
				  	$c = new Criteria() ;
				  	$c->add(MixedPeer::DEL_FLG,0) ;
				  	$c->add(MixedPeer::APP_ID,$appId) ;
				  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
					$c->addDescendingOrderByColumn(MixedPeer::CREATED_AT) ;
					$c->setLimit(10) ;
					$mixeds = MixedPeer::doSelect($c) ;
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
			} else {
				$isAppReleased = false ;
			}

			$this->isAppReleased = $isAppReleased ;
			$this->youtubeCategories = $youtubeCategories ;
			$this->forums = $forums ;
			$this->webs = $webs ;
			$this->mixeds = $mixeds ;
			$this->audioMap = $audioMap ;
			$this->videoMap = $videoMap ;

		} else {
			return sfView::NONE ;
		}
	}



	public function executeSubmit(sfWebRequest $request)
	{
		$appId = $this->appId ;

		if($appId == 31024533){ // Musicians Institute
			$this->redirect('/creator2.php/mi/forumuser');
		}

		$app = AppPeer::retrieveByPk($appId) ;
		$isSubmittable = true ;
		if($app){
			$this->app = $app ;

			if(!$app->getBackgroundImage()){
				$isSubmittable = false ;
			}

			if(!$app->getIconImage()){
				$isSubmittable = false ;
			}

			if(!$app->getTermsAcceptedAt()){
				$isSubmittable = false ;
			}

			if(!$app->getDescription()){
				$isSubmittable = false ;
			}

			if(!$app->getKeyWord()){
				$isSubmittable = false ;
			}

			if(!$app->getCategory()){
				$isSubmittable = false ;
			}

		  	$c = new Criteria() ;
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
		  	$c->add(ForumPeer::KIND,1) ;
			$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
			$forums = ForumPeer::doSelect($c) ;
			if(count($forums) == 0){
				$isSubmittable = false ;
			}

			//// link
		  	$c = new Criteria() ;
		  	$c->add(WebPeer::DEL_FLAG,0) ;
		  	$c->add(WebPeer::APP_ID,$appId) ;
		  	$c->add(WebPeer::URL,'https://twitter.com/VeamApp',Criteria::NOT_LIKE) ;
		  	$c->addAnd(WebPeer::URL,'https://www.facebook.com/VeamApp',Criteria::NOT_LIKE) ;
			$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
			$webs = WebPeer::doSelect($c) ;
			if(count($webs) == 0){
				$isSubmittable = false ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
		  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
		  	$appRatingAnswers = AppRatingAnswerPeer::doSelect($c) ;
			$appRatingAnswerMap = array() ;
			foreach($appRatingAnswers as $appRatingAnswer){
				$appRatingAnswerMap[$appRatingAnswer->getAppRatingQuestionId()] = $appRatingAnswer ;
			}

			$allQuestionsAnswered = true ;
		  	$c = new Criteria() ;
		  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
		  	$c->addAscendingOrderByColumn(AppRatingQuestionPeer::DISPLAY_ORDER) ;
		  	$appRatingQuestions = AppRatingQuestionPeer::doSelect($c) ;
			foreach($appRatingQuestions as $appRatingQuestion){
				if(!$appRatingAnswerMap[$appRatingQuestion->getId()]){
					$isSubmittable = false ;
					$allQuestionsAnswered = false ;
				}
			}


		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
			$subscriptionKind = $templateSubscription->getKind() ;
			if($subscriptionKind == 4){ // Subscription
			  	$c = new Criteria() ;
			  	$c->add(MixedPeer::DEL_FLG,0) ;
			  	$c->add(MixedPeer::APP_ID,$appId) ;
			  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
				$c->addDescendingOrderByColumn(MixedPeer::CREATED_AT) ;
				$c->setLimit(20) ;
				$mixeds = MixedPeer::doSelect($c) ;
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
			} else if($subscriptionKind == 5){ // Pay Per Content








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









			} else if($subscriptionKind == 6){ // Pay Per Section











			  	$c = new Criteria() ;
			  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
			  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellSectionItemPeer::CREATED_AT) ;
				$c->setLimit(10) ;

				$audioIds = array() ;
				$videoIds = array() ;
				$pdfIds = array() ;
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

		  	$c = new Criteria() ;
		  	$c->add(AppProcessLogPeer::DEL_FLAG,0) ;
		  	$c->add(AppProcessLogPeer::APP_ID,$appId) ;
		  	$c->add(AppProcessLogPeer::APP_PROCESS_ID,10500) ;
			$appProcessLog = AppProcessLogPeer::doSelectOne($c) ;
			$submittedAt = "" ;
			if($appProcessLog){
				$submittedAt = $appProcessLog->getCreatedAt() ;
			}



			$this->isSubmittable = $isSubmittable ;
			$this->forums = $forums ;
			$this->webs = $webs ;
			$this->allQuestionsAnswered = $allQuestionsAnswered ;
			$this->appRatingAnswerMap = $appRatingAnswerMap ;
			$this->appRatingQuestions = $appRatingQuestions ;
			$this->subscriptionKind = $subscriptionKind ;
			$this->mixeds = $mixeds ;
			$this->sellItems = $sellItems ;
			$this->sellSectionItems = $sellSectionItems ;
			$this->audioMap = $audioMap ;
			$this->videoMap = $videoMap ;
			$this->pdfMap = $pdfMap ;
			$this->submittedAt = $submittedAt ;

		} else {
			return sfView::NONE ;
		}


	}

	public function executeDesign(sfWebRequest $request)
	{

		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
		  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
		  	$c->add(AlternativeImagePeer::FILE_NAME,'t1_top_right.png') ;
		  	$alternativeImage = AlternativeImagePeer::doSelectOne($c) ;
			$rightImageUrl = '' ;
			if($alternativeImage){
				$rightImageUrl = $alternativeImage->getUrl() ;
			}
			$this->rightImageUrl = $rightImageUrl ;


		  	$c = new Criteria() ;
		  	$c->add(AppColorPeer::DEL_FLG,0) ;
		  	$c->add(AppColorPeer::APP_ID,$appId) ;
		  	$c->add(AppColorPeer::NAME,'concept_color_argb') ;
		  	$appColor = AppColorPeer::doSelectOne($c) ;
			$appColorCode = 'FFFFFF' ;
			if($appColor){
				$appColorCode = substr($appColor->getColor(),2,6) ;
			}
			$this->appColorCode = $appColorCode ;

		} else {
			return sfView::NONE ;
		}
	}

	public function executeStore(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

		  	$c = new Criteria() ;
		  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
		  	$c->addAscendingOrderByColumn(AppRatingQuestionPeer::DISPLAY_ORDER) ;
		  	$appRatingQuestions = AppRatingQuestionPeer::doSelect($c) ;
			$this->appRatingQuestions = $appRatingQuestions ;


		  	$c = new Criteria() ;
		  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
		  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
		  	$appRatingAnswers = AppRatingAnswerPeer::doSelect($c) ;
			$appRatingAnswerMap = array() ;
			foreach($appRatingAnswers as $appRatingAnswer){
				$appRatingAnswerMap[$appRatingAnswer->getAppRatingQuestionId()] = $appRatingAnswer ;
			}
			$this->appRatingAnswerMap = $appRatingAnswerMap ;

		} else {
			return sfView::NONE ;
		}

		$categoryString = "Business|Catalogs|Education|Entertainment|Finance|Food & Drink|Games|Health & Fitness|Lifestyle|Medical|Music|Navigation|News|Photo & Video|Productivity|Social Networking|Sports|Travel|Utilities|Weather" ;
		$categories = explode('|',$categoryString) ;
		$this->categories = $categories ;

	}


	public function executePaymenttype(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			$selection = array(
				4 => 'Subscription',
				5 => 'Pay per content',
				6 => 'One time payment for all content',
				/*-1 =>'Free',*/
			) ;
			$this->selection = $selection ;

		  	$c = new Criteria() ;
		  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
		  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
			$currentType = 0 ; 
			if($templateSubscription){
				$currentType = $templateSubscription->getKind() ;
				if($templateSubscription->getPrice() == '0'){
					$currentType = -1 ;
				}
			}
			$this->currentType = $currentType ;

		} else {
			return sfView::NONE ;
		}
	}


	public function executeTerms(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;
		} else {
			return sfView::NONE ;
		}
	}


	public function executeUploadsplash(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$result = array() ;
		if($app){
			if(is_uploaded_file($_FILES["upfile"]["tmp_name"])){
				$this->app = $app ;
				$imageUrls = ConsoleTools::uploadBackgroundPNGFileToS3($appId) ;
				if(count($imageUrls) > 1){
					$app->setBackgroundImage($imageUrls[0]) ;
					$app->save() ;
					$result['image_url'] = $imageUrls[0] ;

					ConsoleTools::setAlternativeImage($appId,'background.png',$imageUrls[1]) ;
					ConsoleTools::setAlternativeImage($appId,'initial_background.png',$imageUrls[0]) ;
					ConsoleTools::setAlternativeImage($appId,'splash.png',$imageUrls[1]) ;
					ConsoleTools::setAlternativeImage($appId,'splash_short.png',$imageUrls[1]) ;

					$skipInitialKey = 'skip_initial' ;

					$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,$skipInitialKey) ;
					$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setName($skipInitialKey) ;
						$appData->setAppId($appId) ;
					}
					$appData->setData('0') ;
					$appData->save() ;

					ConsoleTools::saveConsoleLog($request,$app) ;
					ConsoleTools::consoleContentsChanged($appId) ;

					ConsoleTools::executeConsoleCommand($appId,'UPDATE_SCREEN_SHOT','') ;
				}
			} else {
				$this->forward('app','design') ;
			}

		} else {
			return sfView::NONE ;
		}

		echo json_encode($result) ;
		return sfView::NONE ;
	}


	public function executeUploadicon(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$result = array() ;
		if($app){
			if(is_uploaded_file($_FILES["upfile"]["tmp_name"])){
				$this->app = $app ;

				$imageUrls = ConsoleTools::uploadIconPNGFileToS3($appId) ;
				if(count($imageUrls) > 1){
					$app->setIconImage($imageUrls[0]) ;
					$app->setStatus(1) ; // 1:Setting
					$app->save() ;

					$result['image_url'] = $imageUrls[0] ;

					ConsoleTools::setAlternativeImage($appId,'c_veam_icon.png',$imageUrls[0]) ;
					ConsoleTools::setAlternativeImage($appId,'c_small_icon.png',$imageUrls[1]) ;

				  	$c = new Criteria() ;
				  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
				  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
				  	$c->add(AlternativeImagePeer::FILE_NAME,'t1_top_right.png') ;
				  	$alternativeImage = AlternativeImagePeer::doSelectOne($c) ;
					if(!$alternativeImage){
						ConsoleTools::setAlternativeImage($appId,'t1_top_right.png',$imageUrls[0]) ;
					}

					ConsoleTools::saveConsoleLog($request,$app) ;
					ConsoleTools::consoleContentsChanged($appId) ;
					//TODO ConsoleTools::executeConsoleCommand($appId,'DEPLOY_APP','') ;
				}
			} else {
				$this->forward('app','design') ;
			}
		} else {
			return sfView::NONE ;
		}

		echo json_encode($result) ;
		return sfView::NONE ;
	}



	public function executeUploadrightimage(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$result = array() ;
		if($app){
			if(is_uploaded_file($_FILES["upfile"]["tmp_name"])){
				$this->app = $app ;

				$imageUrl = ConsoleTools::uploadPNGFileToS3($appId,1024,1024) ;
				if($imageUrl){

				  	$c = new Criteria() ;
				  	$c->add(TemplateYoutubePeer::DEL_FLG,0) ;
				  	$c->add(TemplateYoutubePeer::APP_ID,$appId) ;
				  	$templateYoutube = TemplateYoutubePeer::doSelectOne($c) ;
					if($templateYoutube){
						$name = 't1_top_right.png' ;
						$templateYoutube->setRightImageUrl($imageUrl) ;
						$templateYoutube->save() ;

						$result['image_url'] = $imageUrl ;

						ConsoleTools::setAlternativeImage($appId,$name,$imageUrl) ;
						if($name == 't1_top_right.png'){
							ConsoleTools::setAlternativeImage($appId,'t8_top_right.png',$imageUrl) ;
						}

						ConsoleTools::saveConsoleLog($request,$templateYoutube) ;
						ConsoleTools::consoleContentsChanged($appId) ;
						ConsoleTools::executeConsoleCommand($appId,'UPDATE_SCREEN_SHOT','') ;
					}
				}
			} else {
				$this->forward('app','design') ;
			}

		} else {
			return sfView::NONE ;
		}

		echo json_encode($result) ;
		return sfView::NONE ;
	}




	public function executeChangeconceptcolorapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
		    $colorValue = $request->getParameter('cv') ;
			if($colorValue){
				$color = sprintf('FF%s',strtoupper(substr($colorValue,0,6))) ;

			    $name = 'concept_color_argb' ;
				$appColor = $this->getAppColor($appId,$name) ;
				$appColor->setColor($color) ;
				$appColor->save() ;

			    $name = 'new_videos_text_color_argb' ;
				$appColor = $this->getAppColor($appId,$name) ;
				$appColor->setColor($color) ;
				$appColor->save() ;

				$selectionColor = '30' . substr($color,2,6) ;
			    $name = 'table_selection_color_argb' ;
				$appColor = $this->getAppColor($appId,$name) ;
				$appColor->setColor($selectionColor) ;
				$appColor->save() ;

				ConsoleTools::saveConsoleLog($request,$appColor) ;
				ConsoleTools::consoleContentsChanged($appId) ;

				ConsoleTools::executeConsoleCommand($appId,'UPDATE_CONCEPT_COLOR','') ;
				ConsoleTools::executeConsoleCommand($appId,'UPDATE_SCREEN_SHOT','') ;
			} else {
				$this->forward('app','design') ;
			}

		}
		echo json_encode('') ;
		return sfView::NONE ;
	}



	public function getAppColor($appId,$name){
	  	$c = new Criteria() ;
	  	$c->add(AppColorPeer::DEL_FLG,0) ;
	  	$c->add(AppColorPeer::APP_ID,$appId) ;
	  	$c->add(AppColorPeer::NAME,$name) ;
	  	$appColor = AppColorPeer::doSelectOne($c) ;
		return $appColor ;
	}



	public function executeSavestoreinfoapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$appName = $request->getParameter('app_name') ;
			if($appName){
				$app->setName($appName) ;
			}

			$storeAppName = $request->getParameter('store_app_name') ;
			if($storeAppName){
				$app->setStoreAppName($storeAppName) ;
			}

			$keywords = $request->getParameter('keywords') ;
			if($keywords){
				$app->setKeyWord($keywords) ;
			}

			$description = $request->getParameter('description') ;
			if($description){
				$app->setDescription($description) ;
			}

			$category = $request->getParameter('category') ;
			if($category){
				$app->setCategory($category) ;
			}

			if($appName || $storeAppName || $keywords || $description || $category){
				$app->save() ;

			  	$c = new Criteria() ;
			  	$c->add(AppRatingQuestionPeer::DEL_FLG,0) ;
			  	$appRatingQuestions = AppRatingQuestionPeer::doSelect($c) ;
				foreach($appRatingQuestions as $appRatingQuestion){
					$appRatingQuestionId = $appRatingQuestion->getId() ;
					$answer = $request->getParameter(sprintf('answer_%d',$appRatingQuestionId)) ;
					if($answer){
					  	$c = new Criteria() ;
					  	$c->add(AppRatingAnswerPeer::DEL_FLG,0) ;
					  	$c->add(AppRatingAnswerPeer::APP_ID,$appId) ;
					  	$c->add(AppRatingAnswerPeer::APP_RATING_QUESTION_ID,$appRatingQuestionId) ;
					  	$appRatingAnswer = AppRatingAnswerPeer::doSelectOne($c) ;
						if(!$appRatingAnswer){
							$appRatingAnswer = new AppRatingAnswer() ;
							$appRatingAnswer->setAppId($appId) ;
							$appRatingAnswer->setAppRatingQuestionId($appRatingQuestionId) ;
						}
						$appRatingAnswer->setAnswer($answer) ;
						$appRatingAnswer->save() ;
					}
				}

				ConsoleTools::saveConsoleLog($request,$app) ;
				ConsoleTools::consoleContentsChanged($appId) ;
			} else {
				$this->forward('app','store') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeSavepaymenttypeapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$kind = $request->getParameter('payment_type') ;
			if($kind){
			  	$c = new Criteria() ;
			  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
			  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
			  	$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;

				// kind:4 layout:2
				// kind:5 layout:""
				if($kind == '4'){
					$layout = '2' ;
					if(($templateSubscription->getKind() != 4) || ($templateSubscription->getPrice() == '0')){
						$templateSubscription->setPrice('$0.99') ;
					}
				} else if($kind == '5'){
					$layout = '' ;
					// 都度課金に必要なものがそろっているかどうかチェック
					// sell_item_category が１つ以上あるか
				  	$c = new Criteria() ;
				  	$c->add(SellItemCategoryPeer::DEL_FLG,0) ;
				  	$c->add(SellItemCategoryPeer::APP_ID,$appId) ;
				  	$sellItemCategory = SellItemCategoryPeer::doSelectOne($c) ;
					if(!$sellItemCategory){
						// sell_item_category がなければ Premium Video で作成
						// INSERT INTO `video_category` (`id`, `app_id`, `name`, `display_order`, `del_flg`, `created_at`, `updated_at`) VALUES
						// (9268, 31000251, 'Premium Video', 1, 0, NOW(),NOW());
						$videoCategory = new VideoCategory() ;
						$videoCategory->setAppId($appId) ;
						$videoCategory->setName('Premium Content List') ;
						$videoCategory->setDisplayOrder(1) ;
						$videoCategory->save() ;

						// INSERT INTO `sell_item_category` (`id` ,`app_id` ,`target_category_id` ,`kind` ,`display_order` ,`del_flg` ,`created_at` ,`updated_at`)VALUES 
						// (1,'31003057', '3060', '1', '1', '0', NOW( ) , NOW( )),
						$sellItemCategory = new SellItemCategory() ;
						$sellItemCategory->setAppId($appId) ;
						$sellItemCategory->setTargetCategoryId($videoCategory->getId()) ;
						$sellItemCategory->setKind(1) ; // 1:video    2:pdf    3:audio
						$sellItemCategory->setDisplayOrder(1) ;
						$sellItemCategory->save() ;
					}
				} else if($kind == '6'){
					$layout = '' ;
					// 一括課金に必要なものがそろっているかどうかチェック
					// sell_section_category が１つ以上あるか
				  	$c = new Criteria() ;
				  	$c->add(SellSectionCategoryPeer::DEL_FLG,0) ;
				  	$c->add(SellSectionCategoryPeer::APP_ID,$appId) ;
				  	$sellSectionCategory = SellSectionCategoryPeer::doSelectOne($c) ;
					if(!$sellSectionCategory){
						$sellSectionCategory = new SellSectionCategory() ;
						$sellSectionCategory->setAppId($appId) ;
						$sellSectionCategory->setName('Premium Content List') ;
						$sellSectionCategory->setKind(0) ; // 1:video    2:pdf    3:audio
						$sellSectionCategory->setDisplayOrder(1) ;
						$sellSectionCategory->save() ;
					}

				  	$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,'section_0_description') ;
				  	$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setAppId($appId) ;
						$appData->setName('section_0_description') ;
						$appData->setData('Welcome to the Exclusive section!&#xA;You will find uploads exclusive to the app!&#xA;') ;
						$appData->setAppId($appId) ;
						$appData->save() ;
					}

				  	$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,'section_payment_0_description') ;
				  	$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setAppId($appId) ;
						$appData->setName('section_payment_0_description') ;
						$appData->setData('By making a one time payment, you can have full access to all the Exclusive contents that will be uploaded to this section.&#xA;') ;
						$appData->setAppId($appId) ;
						$appData->save() ;
					}

				  	$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,'section_payment_0_button_text') ;
				  	$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setAppId($appId) ;
						$appData->setName('section_payment_0_button_text') ;
						$appData->setData('Tap to purchase - US$0.99') ;
						$appData->setAppId($appId) ;
						$appData->save() ;
					}

				  	$c = new Criteria() ;
				  	$c->add(AppDataPeer::DEL_FLG,0) ;
				  	$c->add(AppDataPeer::APP_ID,$appId) ;
				  	$c->add(AppDataPeer::NAME,'section_0_product_id') ;
				  	$appData = AppDataPeer::doSelectOne($c) ;
					if(!$appData){
						$appData = new AppData() ;
						$appData->setAppId($appId) ;
						$appData->setName('section_0_product_id') ;
						$appData->setData(sprintf('co.veam.veam%s.section.0',$appId)) ;
						$appData->setAppId($appId) ;
						$appData->save() ;
					}
				} else if($kind == '-1'){
					$kind = 4 ;
					$layout = '2' ;
					$templateSubscription->setPrice(0) ;
				} 


				//$templateSubscription->setTitle($title) ;
				$templateSubscription->setLayout($layout) ;
				$templateSubscription->setKind($kind) ;
				$templateSubscription->save() ;

				ConsoleTools::saveConsoleLog($request,$app) ;
				ConsoleTools::consoleContentsChanged($appId) ;
			} else {
				$this->forward('app','paymenttype') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}

	public function executeAccepttermsapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			if($_SERVER["REQUEST_METHOD"] == "POST"){
				$app->setTermsAcceptedAt(date('Y-m-d H:i:s')) ;
				$app->save() ;
			} else {
				$this->forward('app','terms') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeSubmitappapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			if($_SERVER["REQUEST_METHOD"] == "POST"){
				$appProcessId = 10500 ;
				$appProcess = AppProcessPeer::retrieveByPk($appProcessId) ;
				if($appProcess){
					$dependsOn = $appProcess->getDependsOn() ;
					$dependencyOk = true ;
					if($dependsOn){
						$appProcessIds = explode(",",$dependsOn) ;
						$c = new Criteria() ;
						$c->add(AppProcessLogPeer::DEL_FLAG,0) ;
						$c->add(AppProcessLogPeer::APP_PROCESS_ID,$appProcessIds,Criteria::IN) ;
						$appProcessLogs = AppProcessLogPeer::doSelect($c) ;
						$appProcessLogMapForAppProcess = array() ;
						foreach($appProcessLogs as $appProcessLog){
							$appProcessLogMapForAppProcess[$appProcessLog->getAppProcessId()] = $appProcessLog ;
						}
						foreach($appProcessIds as $workId){
							if(!$appProcessLogMapForAppProcess[$workId]){
								$dependencyOk = false ;
							}
						}
					}
								
					if($dependencyOk){
						$app->setStatus(2) ; // MCN Review
						$app->save() ;

						ConsoleTools::saveConsoleLog($request,$app) ;
						ConsoleTools::consoleContentsChanged($appId) ;

					  	$c = new Criteria() ;
					  	$c->add(AppProcessLogPeer::DEL_FLAG,0) ;
					  	$c->add(AppProcessLogPeer::APP_ID,$appId) ;
					  	$c->add(AppProcessLogPeer::APP_PROCESS_ID,$appProcessId) ;
						$appProcessLog = AppProcessLogPeer::doSelectOne($c) ;
						if(!$appProcessLog){
							AdminTools::completeProcess($appId,$appProcessId,1,"-") ;
						}

					} else {
						ConsoleTools::assert(false,"mcn submit depenency NG appId=".$appId,__FILE__,__LINE__) ;
					}
				} else {
					ConsoleTools::assert(false,"app process not found appProcessId=".$appProcessId,__FILE__,__LINE__) ;
				}
			} else {
				$this->forward('app','submit') ;
			}
		}
		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executePublishappapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$result = array() ;
		if($app){
			if($_SERVER["REQUEST_METHOD"] == "POST"){
				$c = new Criteria() ;
				$c->add(MixedPeer::DEL_FLG,0) ;
				$c->add(MixedPeer::APP_ID,$appId) ;
				$c->add(MixedPeer::STATUS,2) ; // preparing
				$mixeds = MixedPeer::doSelect($c) ;
				if($mixeds){
					$result['message'] = "Your content is not ready yet. Please try again later." ;
				} else {
					AdminTools::deployAppContents($appId) ;
					ConsoleTools::assert(false,"App Contents Deployed appId=$appId",__FILE__,__LINE__) ;
				}
			} else {
				$this->forward('app','publish') ;
			}
		}
		echo json_encode($result) ;
		return sfView::NONE ;
	}

}



function compareTime($a, $b) {
    if ($a->getCreatedAt() == $b->getCreatedAt()) {
        return 0;
    }
    return ($a->getCreatedAt() > $b->getCreatedAt()) ? -1 : 1;
}
