<?php

/**
 * forum actions.
 *
 * @package    console
 * @subpackage forum
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class forumActions extends myActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeCategoryorder(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){

			$this->app = $app ;

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

		} else {
			return sfView::NONE ;
		}
	}


	public function executeChangecategoryorderapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$idsString = $request->getParameter('ids') ;
			if($idsString){
				$forumIds = explode(",",$idsString) ;
				if(count($forumIds) > 0){
				  	$c = new Criteria() ;
				  	$c->add(ForumPeer::DEL_FLAG,0) ;
				  	$c->add(ForumPeer::APP_ID,$appId) ;
				  	$c->add(ForumPeer::ID,$forumIds,Criteria::IN) ;
					$forums = ForumPeer::doSelect($c) ;

					$forumMap = array() ;
					foreach($forums as $forum){
						$forumMap[$forum->getId()] = $forum ;
					}

					$orderCount = 1 ;
					foreach($forumIds as $forumId){
						$forum = $forumMap[$forumId] ;
						if($forum){
							$forum->setDisplayOrder($orderCount) ;
							$forum->save() ;
							$orderCount++ ;
						}
					}
					ConsoleTools::clearContentCache($appId) ;
					ConsoleTools::consoleContentsChanged($appId) ;
				}
			} else {
				$this->forward('forum','categoryorder') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}




	public function executeCategorylist(sfWebRequest $request)
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
		  	$c->add(ForumPeer::DEL_FLAG,0) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ;
		  	$c->add(ForumPeer::KIND,1) ;
			$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
			$forums = ForumPeer::doSelect($c) ;
			$forumMap = AdminTools::getMapForObjects($forums) ;

			$this->forums = $forums ;
			$this->forumMap = $forumMap ;

		} else {
			return sfView::NONE ;
		}
	}


	public function executeChangecategorynameapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$forumId = $request->getParameter('id') ;
			if($forumId){
				$name = $request->getParameter('na') ;
				if($forumId){
				  	$c = new Criteria() ;
				  	$c->add(ForumPeer::DEL_FLAG,0) ;
				  	$c->add(ForumPeer::APP_ID,$appId) ;
				  	$c->add(ForumPeer::ID,$forumId) ;
					$forum = ForumPeer::doSelectOne($c) ;
					if($forum){
						$forum->setName(ConsoleTools::xmlEscape($name)) ;
						$forum->save() ;
						ConsoleTools::clearContentCache($appId) ;
						ConsoleTools::consoleContentsChanged($appId) ;
					}
				}
			} else {
				$this->forward('forum','categorylist') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeRemovecategoryapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$forumId = $request->getParameter('id') ;
			if($forumId){
			  	$c = new Criteria() ;
			  	$c->add(ForumPeer::DEL_FLAG,0) ;
			  	$c->add(ForumPeer::APP_ID,$appId) ;
			  	$c->add(ForumPeer::ID,$forumId) ;
				$forum = ForumPeer::doSelectOne($c) ;
				if($forum){
					$forum->delete() ;
					ConsoleTools::clearContentCache($appId) ;
					ConsoleTools::consoleContentsChanged($appId) ;
				}
			} else {
				$this->forward('forum','categorylist') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeAddcategoryapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			if($_SERVER["REQUEST_METHOD"] == "POST"){
				$forum = new Forum() ;
				$forum->setAppId($appId) ;
				$forum->setName("New Category") ;
				$forum->setDisplayOrder(0) ;
				$forum->save() ;

				$forumId = $forum->getId() ;
				if($forumId){
					$data = array('forumId'=>$forumId) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(ForumPeer::DEL_FLAG,0) ;
			  	$c->add(ForumPeer::APP_ID,$appId) ;
			  	$c->add(ForumPeer::KIND,1) ;
				$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
				$forums = ForumPeer::doSelect($c) ;

				$orderCount = 1 ;
				foreach($forums as $forum){
					$forum->setDisplayOrder($orderCount) ;
					$forum->save() ;
					$orderCount++ ;
				}

				ConsoleTools::saveConsoleLog($request,$app) ;
				ConsoleTools::consoleContentsChanged($appId) ;
			} else {
				$this->forward('forum','categorylist') ;
			}
		}

		echo json_encode($data) ;
		return sfView::NONE ;
	}



}
