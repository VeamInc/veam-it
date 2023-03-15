<?php

/**
 * veamit actions.
 *
 * @package    console
 * @subpackage veamit
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class veamitActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */

	public function executeInputlogincountlist(sfWebRequest $request)
	{
	}

	public function executeShowlogincount(sfWebRequest $request)
	{
		$names = $request->getParameter("names") ;

		$appNames = explode("\r\n",$names) ;
		$counts = array() ;
		foreach($appNames as $appName){
			if($appName){
				$c = new Criteria() ;
				$c->add(AppCreatorPeer::FIRST_NAME,$appName) ;
				$appCreators = AppCreatorPeer::doSelect($c) ;
				if(!$appCreators){
				  	$c = new Criteria() ;
				  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
				  	$c->addJoin(AppCreatorPeer::APP_ID,AppPeer::ID) ;
				  	$c->add(AppPeer::NAME,$appName) ;
					$appCreators = AppCreatorPeer::doSelect($c) ;
				}

				if(!$appCreators){
					$counts[$appName] = 'NOT FOUND' ;
				} else if(count($appCreators) == 1){
					$appCreator = $appCreators[0] ;
					$userName =	$appCreator->getUsername() ;

					$c = new Criteria() ;
					$c->add(ConsoleLoginLogPeer::USER_NAME,$userName) ;
					$loginCount = ConsoleLoginLogPeer::doCount($c) ;
					$counts[$appName] = $loginCount ;
				} else {
					$counts[$appName] = 'MORE THAN ONE APP FOUND' ;
				}
			}
		}

		$this->appNames = $appNames ;
		$this->counts = $counts ;
	}


	public function executeInputpremiumcountlist(sfWebRequest $request)
	{
	}

	public function executeShowpremiumcount(sfWebRequest $request)
	{
		$names = $request->getParameter("names") ;

		$appNames = explode("\r\n",$names) ;
		$counts = array() ;
		$messages = array() ;
		$forumCounts = array() ;
		$channelUrls = array() ;
		$numberOfForumWeeks = 8 ;
		$forumCounts['dates'] = $this->getForumDates($numberOfForumWeeks) ;

		foreach($appNames as $appName){
			if($appName){
				$c = new Criteria() ;
				$c1 = $c->getNewCriterion(AppPeer::NAME,$appName);
				$c2 = $c->getNewCriterion(AppPeer::STORE_APP_NAME,$appName);
				$c1->addOr($c2) ;
				$c->add($c1) ;
				$c->add(AppPeer::STATUS,0) ;
				$apps = AppPeer::doSelect($c) ;

				if(!$apps){
					$counts[$appName] = 'NOT FOUND' ;
					$messages[$appName] = 'NOT FOUND' ;
				} else if(count($apps) == 1){
					$app = $apps[0] ;
					$appId = $app->getId() ;

					$counts[$appName] = $this->getPremiumCount($appId) ;
					$messages[$appName] = "" ;
					if($this->templateSubscription){
						$kinds[$appName] = $this->templateSubscription->getKind() ;
					} else {
						$kinds[$appName] = 0 ;
					}
					$categories[$appName] = $app->getCategory() ;

					$forumCounts[$appName] = $this->getForumCount($appId,$numberOfForumWeeks) ;

				  	$c = new Criteria() ;
				  	$c->add(YoutubeUserPeer::APP_ID,$appId) ;
					$youtubeUser = YoutubeUserPeer::doSelectOne($c) ;
					if($youtubeUser){
						$name = $youtubeUser->getName() ;
						// UCbN45H2GeOXIfcFxnCpXxrA
						if(length($name) == 24){
							$url = sprintf("https://www.youtube.com/channel/%s",$name) ;
						} else {
							$url = sprintf("https://www.youtube.com/user/%s",$name) ;
						}
						$channelUrls[$appName] = $url ;
					}

				} else {
					$counts[$appName] = 'MORE THAN ONE APP FOUND' ;
					$messages[$appName] = 'MORE THAN ONE APP FOUND' ;
				}
			}
		}

		$timestamp = strtotime(date('Y-m-15'));
		for($i = 0 ; $i < 6 ; $i++){
			$dates[] = date('Y-m',$timestamp - 2592000 * $i ) ; // 3600*24*30=2592000
		}

		$this->dates = $dates ;
		$this->appNames = $appNames ;
		$this->counts = $counts ;
		$this->kinds = $kinds ;
		$this->messages = $messages ;
		$this->categories = $categories ;
		$this->forumCounts = $forumCounts ;
		$this->channelUrls = $channelUrls ;
	}


	public function getPremiumCount($appId){
		//// Template Subscription
	  	$c = new Criteria() ;
	  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
	  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
		$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
		$this->templateSubscription = $templateSubscription ;

		$premiumCounts = array() ;

		if($templateSubscription){
			$kind = $templateSubscription->getKind() ; // 4:subscription 5:Pay Per Content 6:OneTime
			if($kind == 4){
			  	$c = new Criteria() ;
			  	$c->add(MixedPeer::DEL_FLG,0) ;
			  	$c->add(MixedPeer::APP_ID,$appId) ;
			  	$c->add(MixedPeer::KIND,array(7,8,9,10),Criteria::IN) ; // for subscription
				$c->addDescendingOrderByColumn(MixedPeer::CREATED_AT) ;
				$mixeds = MixedPeer::doSelect($c) ;
				foreach($mixeds as $mixed){
					$date = substr($mixed->getCreatedAt(),0,7) ;
					$premiumCounts[$date]++ ;
				}
			} else if($kind == 6){
			  	$c = new Criteria() ;
			  	$c->add(SellSectionItemPeer::DEL_FLAG,0) ;
			  	$c->add(SellSectionItemPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellSectionItemPeer::CREATED_AT) ;
				$sellSectionItems = SellSectionItemPeer::doSelect($c) ;
				foreach($sellSectionItems as $sellSectionItem){

					$date = substr($sellSectionItem->getCreatedAt(),0,7) ;
					$premiumCounts[$date]++ ;
				}
			} else if($kind == 5){
			  	$c = new Criteria() ;
			  	$c->add(SellVideoPeer::DEL_FLAG,0) ;
			  	$c->add(SellVideoPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellVideoPeer::CREATED_AT) ;
				$sellVideos = SellVideoPeer::doSelect($c) ;
				foreach($sellVideos as $sellVideo){
					$date = substr($sellVideo->getCreatedAt(),0,7) ;
					$premiumCounts[$date]++ ;
				}

			  	$c = new Criteria() ;
			  	$c->add(SellAudioPeer::DEL_FLAG,0) ;
			  	$c->add(SellAudioPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellAudioPeer::CREATED_AT) ;
				$sellAudios = SellAudioPeer::doSelect($c) ;
				foreach($sellAudios as $sellAudio){
					$date = substr($sellAudio->getCreatedAt(),0,7) ;
					$premiumCounts[$date]++ ;
				}

			  	$c = new Criteria() ;
			  	$c->add(SellPdfPeer::DEL_FLAG,0) ;
			  	$c->add(SellPdfPeer::APP_ID,$appId) ;
				$c->addDescendingOrderByColumn(SellPdfPeer::CREATED_AT) ;
				$sellPdfs = SellPdfPeer::doSelect($c) ;
				foreach($sellPdfs as $sellPdf){
					$date = substr($sellPdf->getCreatedAt(),0,7) ;
					$premiumCounts[$date]++ ;
				}

			}
		}

		return $premiumCounts ;

	}



	public function getForumEndTime($numberOfWeeks){
		$nextSunday = strtotime("next sunday") ;
		$endTime = strtotime(date('Y/m/d 00:00:00',$nextSunday)) ;
		return $endTime ;
	}

	public function getForumStartTime($endTime,$numberOfWeeks){
		$startTime = $endTime - 604800 * $numberOfWeeks ; // 8weeks
		return $startTime ;
	}

	public function getForumDates($numberOfWeeks){
		$forumDates = array() ;

		$endTime = $this->getForumEndTime($numberOfWeeks) ;
		$startTime = $this->getForumStartTime($endTime,$numberOfWeeks) ;

		for($index = 0 ; $index < $numberOfWeeks ; $index++){
			$no = $numberOfWeeks - $index - 1 ;
			$weekStartDate = date('m/d',$startTime + 604800 * $no) ;
			$weekEndDate = date('m/d',$startTime + 604800 * ($no + 1) - 43200) ; // 43200 = 12h
			$forumDates[$no] = sprintf("%s - %s",$weekStartDate,$weekEndDate) ;
		}
		return $forumDates ;
	}

	public function getForumCount($appId,$numberOfWeeks){

		$pictureCounts = array() ;

		$endTime = $this->getForumEndTime($numberOfWeeks) ;
		$startTime = $this->getForumStartTime($endTime,$numberOfWeeks) ;

		$startDate = date('Y-m-d h:i:s',$startTime) ;
		$endDate = date('Y-m-d h:i:s',$endTime) ;

	  	$c = new Criteria() ;
	  	$c->add(PicturePeer::DEL_FLAG,0) ;
	  	$c->add(PicturePeer::CREATED_AT,$startDate,Criteria::GREATER_EQUAL) ;
	  	$c->addAnd(PicturePeer::CREATED_AT,$endDate,Criteria::LESS_THAN) ;
	  	$c->addJoin(PicturePeer::FORUM_ID,ForumPeer::ID) ;
	  	$c->add(ForumPeer::APP_ID,$appId) ;
		$pictures = PicturePeer::doSelect($c) ;

		foreach($pictures as $picture){
			$createdAt = $picture->getCreatedAt() ;
			$createdAtTime = strtotime($createdAt) ;
			$diff = $endTime - $createdAtTime ;
			$index = floor($diff / 604800) ; // 604800 = 1week
			$pictureCounts[$index]++ ;
		}

		return $pictureCounts ;

	}





}
