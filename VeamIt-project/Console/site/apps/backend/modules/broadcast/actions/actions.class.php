<?php

/**
 * 	broadcast actions.
 *
 * @package    console
 * @subpackage broadcast
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class broadcastActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeList(sfWebRequest $request)
	{
		$status = $request->getParameter('s') ;
		if(!$status){
			$status = 0 ; 
		}
		$pageNo = $request->getParameter('p') ;
		if($pageNo == 0){
			$pageNo = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(BroadcastNotificationPeer::DEL_FLG,0);
	  	$c->add(BroadcastNotificationPeer::STATUS,$status);
		if(($status == 2) || ($status == 3)){
			$c->addDescendingOrderByColumn(BroadcastNotificationPeer::START_AT) ;
		} else {
			$c->addAscendingOrderByColumn(BroadcastNotificationPeer::START_AT) ;
		}

		$pager = new sfPropelPager('BroadcastNotification', 100);
		$pager->setCriteria($c);
		$pager->setPage($pageNo);
		$pager->init();
		if($pageNo <= $pager->getLastPage()){
			$this->broadcastNotifications = $pager->getResults() ;
			$this->makeDiffs() ;
		}

		$this->pageNo = $pageNo ;
		$this->status = $status ;

		$this->makeAppMap() ;
	}

	public function makeDiffs()
	{
		$this->diffs = array() ;
		$currentTime = time() ;
		foreach($this->broadcastNotifications as $broadcastNotification){
			$diff = $currentTime - strtotime($broadcastNotification->getStartAt()) ;
			if($diff < 0){
				$diffString = sprintf("%s later",$this->timeDescription(-$diff)) ;
			} else {
				$diffString = sprintf("%s ago",$this->timeDescription($diff)) ;
			}
			$this->diffs[$broadcastNotification->getId()] = $diffString ;
		}
	}

	public function makeAppMap()
	{
	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
		$apps = AppPeer::doSelect($c) ;
		$this->appMap = array() ;
		foreach($apps as $app){
			$this->appMap[$app->getId()] = $app ;
		}
	}


	public function timeDescription($sec)
	{
		if($sec < 60){
			$retValue = sprintf("%d[s]",$sec) ;
		} else if($sec < 3600){
			$retValue = sprintf("%d[m]",$sec/60) ;
		} else {
			$retValue = sprintf("%d[h]",$sec/3600) ;
		}
		return $retValue ;
	}


	public function executeEdit(sfWebRequest $request)
	{
		$broadcastNotificationId = $request->getParameter('id') ;

		$this->appId = '' ;
		$this->message = '' ;
		$this->badge = '0' ;
		$this->status = '0' ;
		$this->startAt = date('Y-m-d H:i:s',time()+3600) ;

		if($broadcastNotificationId){
			$broadcastNotification = BroadcastNotificationPeer::retrieveByPk($broadcastNotificationId) ;
			if($broadcastNotification){
				$this->appId = $broadcastNotification->getAppId() ;
				$this->message = $broadcastNotification->getMessage() ;
				$this->badge = $broadcastNotification->getBadge() ;
				$this->status = $broadcastNotification->getStatus() ;
				$this->startAt = $broadcastNotification->getStartAt() ;
			}
		}
		$this->broadcastNotificationId = $broadcastNotificationId ;

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
		$this->apps = AppPeer::doSelect($c) ;
	}

	public function executeSave(sfWebRequest $request)
	{
		$broadcastNotificationId = $request->getParameter('id') ;
		$appId = $request->getParameter('app_id') ;
		$message = $request->getParameter('message') ;
		$badge = $request->getParameter('badge') ;
		$status = $request->getParameter('status') ;
		$startAt = $request->getParameter('start_at') ;

		$isNew = 0 ; 
		if($broadcastNotificationId){
			$broadcastNotification = BroadcastNotificationPeer::retrieveByPk($broadcastNotificationId) ;
		} else {
			$isNew = 1 ;
			$broadcastNotification = new BroadcastNotification() ;
		}
		if($broadcastNotification){
			$broadcastNotification->setAppId($appId) ;
			$broadcastNotification->setMessage($message) ;
			$broadcastNotification->setBadge($badge) ;
			$broadcastNotification->setStatus($status) ;
			$broadcastNotification->setStartAt($startAt) ;
			$broadcastNotification->save() ;
		}

		$this->redirect('broadcast/list') ;

		return sfView::NONE ;
	}



	public function executeConfirmdelete(sfWebRequest $request)
	{
		$broadcastNotificationId = $request->getParameter('id') ;

		if($broadcastNotificationId){
		  	$c = new Criteria() ;
		  	$c->add(BroadcastNotificationPeer::DEL_FLG,0);
		  	$c->add(BroadcastNotificationPeer::ID,$broadcastNotificationId);
			$c->addDescendingOrderByColumn(BroadcastNotificationPeer::ID) ;

			$this->broadcastNotifications = BroadcastNotificationPeer::doSelect($c) ;
			$this->makeDiffs() ;

		}

		$this->makeAppMap() ;
	}

	public function executeDelete(sfWebRequest $request)
	{
		$broadcastNotificationId = $request->getParameter('id') ;

		$broadcastNotification = BroadcastNotificationPeer::retrieveByPk($broadcastNotificationId) ;
		if($broadcastNotification){
			$broadcastNotification->delete() ;
			$message = sprintf("BroadcastNotification deleted\n%s",var_export($broadcastNotification,true)) ;
			$this->logMessage($message, 'info');
		} else {
			$this->message = 'Failed. broadcastNotification not found.' ;
		}
	}

}

