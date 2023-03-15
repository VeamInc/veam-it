<?php

define('CREATOR_ACTION_KIND_ALL'			,1) ;

/**
 * creator actions.
 *
 * @package    console
 * @subpackage creator
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class creatorActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListall(sfWebRequest $request)
	{
		$this->prepareCreatorList($request,CREATOR_ACTION_KIND_ALL) ;
	}

	public function prepareCreatorList(sfWebRequest $request,$kind)
	{
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}

		$apps = AdminTools::getAppsForMcn($this->mcnId) ;
		$appIds = AdminTools::getIdsForObjects($apps) ;
		$appMap = AdminTools::getMapForObjects($apps) ;

	  	$c = new Criteria() ;
	  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
	  	$c->add(AppCreatorPeer::APP_ID,$appIds,Criteria::IN) ;
		$c->addDescendingOrderByColumn(AppCreatorPeer::ID) ;

		$pager = new sfPropelPager('AppCreator', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$creators = $pager->getResults() ;
		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}

		$this->creators = $creators ;
		$this->appMap = $appMap ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
	}


	public function executeInputnew(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
		$this->firstName = $request->getParameter('fname') ;
		$this->lastName = $request->getParameter('lname') ;
		$this->email = $request->getParameter('email') ;
		$this->password = $request->getParameter('pass') ;
		$this->youtubeUserName = $request->getParameter('y') ;
	}

	public function executeAddnew(sfWebRequest $request)
	{
		$firstName = $request->getParameter('fname') ;
		$lastName = $request->getParameter('lname') ;
		$appCreatorName = $request->getParameter('email') ;
		$appCreatorPassword = $request->getParameter('pass') ;
		$youtubeUserName = $request->getParameter('y') ;
		$language = $request->getParameter('lang') ;

		$errorMessage = "" ;

		if(!$firstName){
			$errorMessage .= "Please input your first name.\n" ;
		}
		if(!$lastName){
			$errorMessage .= "Please input your last name.\n" ;
		}
		if(!$appCreatorName){
			$errorMessage .= "Please input email.\n" ;
		}
		if(!$appCreatorPassword){
			$errorMessage .= "Please input password.\n" ;
		}
		if(!$youtubeUserName){
			$errorMessage .= "Please input YouTube user name.\n" ;
		}

		if(!$errorMessage){
		  	$c = new Criteria();
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::USERNAME,$appCreatorName) ;
			$appCreator = AppCreatorPeer::doSelectOne($c) ;
			if($appCreator){
				$errorMessage .= sprintf('%s already exists',$appCreatorName) ;
			} else {

				$channels = AdminTools::getYoutubeChannels($youtubeUserName) ;
				if(count($channels) > 0){

					$item = $channels[0] ;
					$channelName = $item->{'snippet'}->{'title'} ;
					#print("title = ".$channelName) ;

					$app = new App() ;
					$app->setName($channelName) ;
					$app->setStoreAppName($channelName) ;
					$app->setDescription('This is a description') ;
					$app->setStatus(4) ; // 4:Initialized
					$app->setMcnId($this->mcnId) ;
					$app->setCurrentProcess(10100) ; 
					$app->save() ;

					$appId = $app->getId() ;



					$c = new Criteria() ;
				  	$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
				  	$c->add(YoutubeUserPeer::APP_ID,$appId) ;
					$youtubeUser = YoutubeUserPeer::doSelectOne($c) ;
					if(!$youtubeUser){
						$youtubeUser = new YoutubeUser() ;
						$youtubeUser->setAppId($appId) ;
						$youtubeUser->setAutoList(1) ;
					}
					$youtubeUser->setName($youtubeUserName) ;
					$youtubeUser->save() ;

					//print("item count = ".count($channels)) ;

					$appCreator = new AppCreator() ;
					$appCreator->setAppId($appId) ;
					$appCreator->setUserName($appCreatorName) ;
					$appCreator->setFirstName($firstName) ;
					$appCreator->setLastName($lastName) ;
					$appCreator->setPassword(strtolower(sha1($appCreatorPassword))) ;
					$appCreator->save() ;

					$creatorNotificationAddress = new CreatorNotificationAddress() ;
					$creatorNotificationAddress->setAppId($appId) ;
					$creatorNotificationAddress->setEmail($appCreatorName) ;
					$creatorNotificationAddress->setKind(65535) ;
					$creatorNotificationAddress->save() ;

					AdminTools::setAppDefaultValues($appId,$language) ;


					// create youtube list
					$seedString = sprintf("%d%d%d",time(),rand(),rand()) ;
					$secret = sha1($seedString) ;
					$remoteCommand = new RemoteCommand() ;
					$remoteCommand->setAppId($appId) ;
					$remoteCommand->setName('UPDATE_YOUTUBE_LIST') ;
					$remoteCommand->setSecret($secret) ;
					$remoteCommand->setStatus(0) ;
					$remoteCommand->setParams('') ;
					$remoteCommand->save() ;

					$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateYoutubelist --command_id=%d > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommand->getId()) ;
					//print("$commandLine\n") ;
					exec($commandLine) ;



					$this->forward('creator','listall') ;
				} else {
					$errorMessage .= "Wrong YouTube user name.\n" ;
				}
			}
		}

		if($errorMessage){
			$request->setParameter('error_message',$errorMessage) ;
			$this->forward('creator','inputnew') ;
		}
	}

}
