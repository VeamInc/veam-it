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














	public function setActionValues($request)
	{
		$appId = $request->getParameter('a') ;
		$this->app = AppPeer::retrieveByPk($appId) ;
		$appProcessId = $request->getParameter('p') ;
		$this->appProcess = AppProcessPeer::retrieveByPk($appProcessId) ;
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
