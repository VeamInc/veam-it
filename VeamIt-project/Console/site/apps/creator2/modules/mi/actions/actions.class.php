<?php

/**
 * mi actions.
 *
 * @package    console
 * @subpackage mi
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */

class miActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeForumuser(sfWebRequest $request)
	{
		$countPerPage = 50 ;

		$apps = array() ;
		$app = AppPeer::retrieveByPk($this->appId) ;
		$apps[] = $app ;
		$appMap = AdminTools::getMapForObjects($apps) ;

		$page = $request->getParameter('p') ;
		$sortKind = $request->getParameter('so') ;
		$userName = $request->getParameter('na') ;
		$notificationGroupId = $request->getParameter('ng') ;
		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(SocialUserPeer::DEL_FLG,0) ;
	  	$c->add(SocialUserPeer::APP_ID,$this->appId) ;

		if($userName){
		  	$c->add(SocialUserPeer::NAME,'%'.$userName.'%',Criteria::LIKE) ;
		}

		if($notificationGroupId){
			$c->addJoin(NotificationGroupMemberPeer::SOCIAL_USER_ID, SocialUserPeer::ID) ;
			$c->add(NotificationGroupMemberPeer::NOTIFICATION_GROUP_ID,$notificationGroupId) ;
		}

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(SocialUserPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(SocialUserPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('SocialUser', $countPerPage) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$numberOfResults = $pager->getNbResults() ;
		$startIndex = $numberOfResults - ($page - 1) * $countPerPage ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$users = $pager->getResults() ;
		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}



		$userIds = array() ;
		foreach($users as $user){
			$userIds[] = $user->getId() ;
		}

	  	$c = new Criteria() ;
	  	$c->add(SocialUserPermissionPeer::DEL_FLAG,0) ;
	  	$c->add(SocialUserPermissionPeer::APP_ID,$this->appId) ;
	  	$c->add(SocialUserPermissionPeer::KIND,1) ; // forum message
	  	$c->add(SocialUserPermissionPeer::SOCIAL_USER_ID,$userIds,Criteria::IN) ;
		$socialUserPermissions = SocialUserPermissionPeer::doSelect($c) ;
		$socialUserPermissionMap = array() ;
		foreach($socialUserPermissions as $socialUserPermission){
			$socialUserPermissionMap[$socialUserPermission->getSocialUserId()] = $socialUserPermission ;
		}


	  	$c = new Criteria() ;
	  	$c->add(NotificationGroupMemberPeer::DEL_FLAG,0) ;
	  	$c->add(NotificationGroupMemberPeer::APP_ID,$this->appId) ;
	  	$c->add(NotificationGroupMemberPeer::SOCIAL_USER_ID,$userIds,Criteria::IN) ;
		$notificationGroupMembers = NotificationGroupMemberPeer::doSelect($c) ;
		
	  	$c = new Criteria() ;
	  	$c->add(NotificationGroupPeer::DEL_FLAG,0) ;
	  	$c->add(NotificationGroupPeer::APP_ID,$this->appId) ;
		$notificationGroups = NotificationGroupPeer::doSelect($c) ;

		$notificationGroupMap = array() ;
		foreach($notificationGroups as $workNotificationGroup){
			$notificationGroupMap[$workNotificationGroup->getId()] = $workNotificationGroup ;
		}

		$userNotificationGroupsMap = array() ;
		foreach($notificationGroupMembers as $notificationGroupMember){
			$userId = $notificationGroupMember->getSocialUserId() ;
			if(!$userNotificationGroupsMap[$userId]){
				$userNotificationGroupsMap[$userId] = array() ;
			}
			$notificationGroup = $notificationGroupMap[$notificationGroupMember->getNotificationGroupId()] ;
			if($notificationGroup){
				$userNotificationGroupsMap[$userId][] = $notificationGroup ;
			}
		}




	  	$c = new Criteria() ;
	  	$c->add(NotificationGroupPeer::DEL_FLAG,0) ;
	  	$c->add(NotificationGroupPeer::APP_ID,$this->appId) ;
		$notificationGroups = NotificationGroupPeer::doSelect($c) ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$this->users = $users ;
		$this->userName = $userName ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->notificationGroups = $notificationGroups ;
		$this->notificationGroupId = $notificationGroupId ;
		$this->notificationGroupMap = $notificationGroupMap ;
		$this->userNotificationGroupsMap = $userNotificationGroupsMap ;
		$this->socialUserPermissionMap = $socialUserPermissionMap ;
		$this->startIndex = $startIndex ;

	}


	public function executeGrantuserpermission(sfWebRequest $request)
	{
		$socialUserId = $request->getParameter('su') ;

		if($socialUserId){
		  	$c = new Criteria() ;
		  	$c->add(SocialUserPermissionPeer::DEL_FLAG,0) ;
		  	$c->add(SocialUserPermissionPeer::APP_ID,$this->appId) ;
		  	$c->add(SocialUserPermissionPeer::KIND,1) ; // forum message
		  	$c->add(SocialUserPermissionPeer::SOCIAL_USER_ID,$socialUserId) ;
			$socialUserPermission = SocialUserPermissionPeer::doSelectOne($c) ;
			if(!$socialUserPermission){
				$socialUserPermission = new SocialUserPermission() ;
				$socialUserPermission->setAppId($this->appId) ;
				$socialUserPermission->setKind(1) ;
				$socialUserPermission->setSocialUserId($socialUserId) ;
				$socialUserPermission->save() ;
			}
		}

		$this->forward('mi','forumuser') ;
	}

	public function executeRevokeuserpermission(sfWebRequest $request)
	{
		$socialUserId = $request->getParameter('su') ;

		if($socialUserId){
		  	$c = new Criteria() ;
		  	$c->add(SocialUserPermissionPeer::DEL_FLAG,0) ;
		  	$c->add(SocialUserPermissionPeer::APP_ID,$this->appId) ;
		  	$c->add(SocialUserPermissionPeer::KIND,1) ; // forum message
		  	$c->add(SocialUserPermissionPeer::SOCIAL_USER_ID,$socialUserId) ;
			$socialUserPermission = SocialUserPermissionPeer::doSelectOne($c) ;
			if($socialUserPermission){
				$socialUserPermission->delete() ;
			}
		}

		$this->forward('mi','forumuser') ;
	}



	public function executeNotification(sfWebRequest $request)
	{
		$countPerPage = 50 ;

		$apps = array() ;
		$app = AppPeer::retrieveByPk($this->appId) ;
		$apps[] = $app ;
		$appMap = AdminTools::getMapForObjects($apps) ;

		$page = $request->getParameter('p') ;
		$sortKind = $request->getParameter('so') ;
		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(BroadcastNotificationPeer::DEL_FLG,0) ;
	  	$c->add(BroadcastNotificationPeer::APP_ID,$this->appId) ;

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(BroadcastNotificationPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(BroadcastNotificationPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('BroadcastNotification', $countPerPage) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$numberOfResults = $pager->getNbResults() ;
		$startIndex = $numberOfResults - ($page - 1) * $countPerPage ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$notifications = $pager->getResults() ;
			$notificationGroupIds = array() ;
			foreach($notifications as $notification){
				$notificationGroupId = $notification->getNotificationGroupId() ;
				if($notificationGroupId){
					$notificationGroupIds[] = $notificationGroupId ;
				}
			}

			if(count($notificationGroupIds) > 0){
			  	$c = new Criteria() ;
			  	$c->add(NotificationGroupPeer::DEL_FLAG,0) ;
			  	$c->add(NotificationGroupPeer::ID,$notificationGroupIds,Criteria::IN) ;
				$notificationGroups = NotificationGroupPeer::doSelect($c) ;
				$notificationGroupMap = array() ;
				foreach($notificationGroups as $notificationGroup){
					$notificationGroupMap[$notificationGroup->getId()] = $notificationGroup ;
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
			'0' => 'Waiting',
			'1' => 'Sending',
			'2' => 'Completed',
			'3' => 'Error',
			'4' => 'Setting',
		) ;

		$this->notifications = $notifications ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->statuses = $statuses ;
		$this->startIndex = $startIndex ;
		$this->notificationGroupMap = $notificationGroupMap ;

	}


	public function executeEditnotification(sfWebRequest $request)
	{
		/*
		$notificationId = $request->getParameter('i') ;
		if(!$notificationId){
			$notification = new BroadCastNotification() ;
			$notification->setAppId($this->appId) ;
			//$notification->setMessage('Message') ;
			$notification->setBadge(0) ;
			$notification->setStatus(4) ; // setting
			$notification->setStartAt(date('Y-m-d h:i:s')) ;
			$notification->save() ;
		} else {
			$notification = BroadCastNotificationPeer::retrieveByPk($notificationId) ;
			if(!$notification){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			if($notification->getAppId() != $this->appId){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}
		}

		$this->notification = $notification ;
		*/

	  	$c = new Criteria() ;
	  	$c->add(NotificationGroupPeer::DEL_FLAG,0) ;
	  	$c->add(NotificationGroupPeer::APP_ID,$this->appId) ;
		$notificationGroups = NotificationGroupPeer::doSelect($c) ;

		$this->notificationGroups = $notificationGroups ;
	}


	public function executeDeletenotification(sfWebRequest $request)
	{
		$notificationId = $request->getParameter('i') ;
		if(!$notificationId){
			$request->setParameter('m','Invalid parameters') ;
			$this->forward('error','index') ;
			return sfView::NONE ;
		} else {
			$notification = BroadCastNotificationPeer::retrieveByPk($notificationId) ;
			if(!$notification){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			if($notification->getAppId() != $this->appId){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			$notification->delete() ;
		}
		$this->forward('mi','notification') ;
	}


	public function executeSavenotification(sfWebRequest $request)
	{
		$message = $request->getParameter('m') ;
		$notificationGroupId = $request->getParameter('ng') ;
		
		if(!$message){
			$request->setParameter('m','Invalid parameters') ;
			$this->forward('error','index') ;
			return sfView::NONE ;
		}

		$escapedMessage = str_replace('$','\$',$message) ;

		$broadcastNotification = new BroadcastNotification() ;
		$broadcastNotification->setAppId($this->appId) ;
		$broadcastNotification->setPriority(1) ;
		$broadcastNotification->setBadge(0) ;
		$broadcastNotification->setStatus(0) ; // waiting
		$broadcastNotification->setStartAt(date('Y-m-d H:i:s')) ;
		$broadcastNotification->setMessage($escapedMessage) ;

		if($notificationGroupId){
			$broadcastNotification->setKind(1) ; // group
			$broadcastNotification->setNotificationGroupId($notificationGroupId) ;
		} else {
			$broadcastNotification->setKind(0) ; // all users
			$broadcastNotification->setNotificationGroupId(0) ;
		}

		$broadcastNotification->save() ;

		$commandLine = sprintf("nohup php /data/console/%s/site/symfony broadcastNotification > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommandId) ;
		//print("$commandLine\n") ;
		exec($commandLine) ;

		$this->forward('mi','notification') ;
	}






	public function executeNotificationgroup(sfWebRequest $request)
	{
		$countPerPage = 50 ;

		$apps = array() ;
		$app = AppPeer::retrieveByPk($this->appId) ;
		$apps[] = $app ;
		$appMap = AdminTools::getMapForObjects($apps) ;

		$page = $request->getParameter('p') ;
		$sortKind = $request->getParameter('so') ;
		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(NotificationGroupPeer::DEL_FLAG,0) ;
	  	$c->add(NotificationGroupPeer::APP_ID,$this->appId) ;

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(NotificationGroupPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(NotificationGroupPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('NotificationGroup', $countPerPage) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$numberOfResults = $pager->getNbResults() ;
		$startIndex = $numberOfResults - ($page - 1) * $countPerPage ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$notificationGroups = $pager->getResults() ;
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

		$this->notificationGroups = $notificationGroups ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->startIndex = $startIndex ;

	}

	public function executeEditnotificationgroup(sfWebRequest $request)
	{
		$notificationGroupId = $request->getParameter('i') ;
		if(!$notificationGroupId){
			$notificationGroup = new NotificationGroup() ;
			$notificationGroup->setAppId($this->appId) ;
			$notificationGroup->setName('') ;
			$notificationGroup->save() ;
		} else {
			$notificationGroup = NotificationGroupPeer::retrieveByPk($notificationGroupId) ;
			if(!$notificationGroup){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			if($notificationGroup->getAppId() != $this->appId){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}
		}

		$this->notificationGroup = $notificationGroup ;
	}


	public function executeSavenotificationgroup(sfWebRequest $request)
	{
		$notificationGroupId = $request->getParameter('i') ;
		$name = $request->getParameter('n') ;
		if(!$notificationGroupId){
			$request->setParameter('m','Invalid parameters') ;
			$this->forward('error','index') ;
			return sfView::NONE ;
		} else {
			$notificationGroup = NotificationGroupPeer::retrieveByPk($notificationGroupId) ;
			if(!$notificationGroup){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			if($notificationGroup->getAppId() != $this->appId){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			$notificationGroup->setAppId($this->appId) ;
			$notificationGroup->setName($name) ;
			$notificationGroup->save() ;

		}

		$this->forward('mi','notificationgroup') ;
	}


	public function executeDeletenotificationgroup(sfWebRequest $request)
	{
		$notificationGroupId = $request->getParameter('i') ;
		if(!$notificationGroupId){
			$request->setParameter('m','Invalid parameters') ;
			$this->forward('error','index') ;
			return sfView::NONE ;
		} else {
			$notificationGroup = NotificationGroupPeer::retrieveByPk($notificationGroupId) ;
			if(!$notificationGroup){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			if($notificationGroup->getAppId() != $this->appId){
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

			$notificationGroup->delete() ;
		}
		$this->forward('mi','notificationgroup') ;
	}



	public function addUserToNotificationGroup(sfWebRequest $request)
	{
		$socialUserId = $request->getParameter('su') ;
		$notificationGroupId = $request->getParameter('ngid') ;

		if($socialUserId && $notificationGroupId){
		  	$c = new Criteria() ;
		  	$c->add(NotificationGroupMemberPeer::DEL_FLAG,0) ;
		  	$c->add(NotificationGroupMemberPeer::APP_ID,$this->appId) ;
		  	$c->add(NotificationGroupMemberPeer::SOCIAL_USER_ID,$socialUserId) ;
		  	$c->add(NotificationGroupMemberPeer::NOTIFICATION_GROUP_ID,$notificationGroupId) ;
			$notificationGroupMember = NotificationGroupMemberPeer::doSelectOne($c) ;
			if(!$notificationGroupMember){
				$notificationGroupMember = new NotificationGroupMember() ;
				$notificationGroupMember->setAppId($this->appId) ;
				$notificationGroupMember->setSocialUserId($socialUserId) ;
				$notificationGroupMember->setNotificationGroupId($notificationGroupId) ;
				$notificationGroupMember->save() ;
			}
		}
	}

	public function executeAddusertonotificationgroup(sfWebRequest $request)
	{
		$this->addUserToNotificationGroup($request) ;
		$this->forward('mi','forumuser') ;
	}

	public function executeAddusertonotificationgroupapi(sfWebRequest $request)
	{
		$this->addUserToNotificationGroup($request) ;
		$socialUserId = $request->getParameter('su') ;
		$this->printGroupJson($socialUserId) ;
		return sfView::NONE ;
	}

	public function printGroupJson($socialUserId)
	{
		$data = array() ;
	  	$c = new Criteria() ;
	  	$c->add(NotificationGroupMemberPeer::DEL_FLAG,0) ;
	  	$c->add(NotificationGroupMemberPeer::APP_ID,$this->appId) ;
	  	$c->add(NotificationGroupMemberPeer::SOCIAL_USER_ID,$socialUserId) ;
		$notificationGroupMembers = NotificationGroupMemberPeer::doSelect($c) ;

	  	$c = new Criteria() ;
	  	$c->add(NotificationGroupPeer::DEL_FLAG,0) ;
	  	$c->add(NotificationGroupPeer::APP_ID,$this->appId) ;
		$notificationGroups = NotificationGroupPeer::doSelect($c) ;

		$notificationGroupMap = array() ;
		foreach($notificationGroups as $workNotificationGroup){
			$notificationGroupMap[$workNotificationGroup->getId()] = $workNotificationGroup ;
		}

		$userNotificationGroupsMap = array() ;
		foreach($notificationGroupMembers as $notificationGroupMember){
			$userId = $notificationGroupMember->getSocialUserId() ;
			if(!$userNotificationGroupsMap[$userId]){
				$userNotificationGroupsMap[$userId] = array() ;
			}
			$notificationGroup = $notificationGroupMap[$notificationGroupMember->getNotificationGroupId()] ;
			if($notificationGroup){
				$userNotificationGroupsMap[$userId][] = $notificationGroup ;
			}
		}

		$groups = $userNotificationGroupsMap[$socialUserId] ;
		$html = '' ;
		$numberOfGroups = 0 ; 
	 	foreach($groups as $group){
			$notificationGroup = $notificationGroupMap[$group->getId()] ;
			if($notificationGroup){
				$notificationGroupName = $notificationGroup->getName() ;
				$numberOfGroups++ ;
				$html .= sprintf("<li><label>%s</label>&nbsp;&nbsp;[<i class=\"icon-trash\"></i><a onclick=\"return removeUserFromGroup(this)\" href=\"/creator2.php/mi/deleteuserfromnotificationgroupapi?su=%d&amp;ngid=%d&amp;p=1&amp;so=0&amp;ng=0&amp;na=\">Remove user from this group</a>]</li>",$notificationGroupName,$socialUserId,$group->getId()) ;
			}
		}
		$data['html'] = $html ;
		$data['html_target'] = sprintf('div#usr_groups_%d',$socialUserId) ;
		$data['number_of_groups'] = $numberOfGroups ;
		$data['number_of_groups_target'] = sprintf('div#number_of_groups_%d',$socialUserId) ;

		echo json_encode($data) ;
	}

	public function executeDeleteuserfromnotificationgroup(sfWebRequest $request)
	{
		$this->deleteUserFromNotificationGroup($request) ;
		$this->forward('mi','forumuser') ;
	}

	public function executeDeleteuserfromnotificationgroupapi(sfWebRequest $request)
	{
		$this->deleteUserFromNotificationGroup($request) ;
		$socialUserId = $request->getParameter('su') ;
		$this->printGroupJson($socialUserId) ;
		return sfView::NONE ;
	}

	public function deleteUserFromNotificationGroup(sfWebRequest $request)
	{
		$socialUserId = $request->getParameter('su') ;
		$notificationGroupId = $request->getParameter('ngid') ;

		if($socialUserId && $notificationGroupId){
		  	$c = new Criteria() ;
		  	$c->add(NotificationGroupMemberPeer::DEL_FLAG,0) ;
		  	$c->add(NotificationGroupMemberPeer::APP_ID,$this->appId) ;
		  	$c->add(NotificationGroupMemberPeer::SOCIAL_USER_ID,$socialUserId) ;
		  	$c->add(NotificationGroupMemberPeer::NOTIFICATION_GROUP_ID,$notificationGroupId) ;
			$notificationGroupMember = NotificationGroupMemberPeer::doSelectOne($c) ;
			if($notificationGroupMember){
				$notificationGroupMember->delete() ;
			}
		}
	}










	public function executeForumposts(sfWebRequest $request)
	{
		$countPerPage = 50 ;

		$forumId = $request->getParameter('f') ;
		$page = $request->getParameter('p') ;
		if(!$page){
			$page = 1 ;
		}
		$sortKind = $request->getParameter('so') ;

		$forumsForList = array() ;

		$apps = array() ;
		$app = AppPeer::retrieveByPk($this->appId) ;
		$apps[] = $app ;

		$appMap = AdminTools::getMapForObjects($apps) ;

		$forums = AdminTools::getForumsForApps($apps) ;
		$forumIds = AdminTools::getIdsForObjects($forums) ;
		$forumMap = AdminTools::getMapForObjects($forums) ;

	  	$c = new Criteria() ;
	  	$c->add(PicturePeer::DEL_FLAG,0) ;
		if($forumId && in_array($forumId,$forumIds)){
		  	$c->add(PicturePeer::FORUM_ID,$forumId) ;
		} else {
		  	$c->add(PicturePeer::FORUM_ID,$forumIds,Criteria::IN) ;
		}

		if($sortKind == 1){
			$c->addAscendingOrderByColumn(PicturePeer::ID) ;
		} else {
			$c->addDescendingOrderByColumn(PicturePeer::ID) ;
		}

		$pager = new sfPropelPager('Picture', $countPerPage) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$numberOfResults = $pager->getNbResults() ;
		$startIndex = $numberOfResults - ($page - 1) * $countPerPage ;

		$lastPage = $pager->getLastPage() ;


		$socialUserIds = array() ;
		if($page <= $lastPage){
			$pictures = $pager->getResults() ;

			$pictureIds = AdminTools::getIdsForObjects($pictures) ;

			$commentsForPictureId = array() ;
		  	$c = new Criteria() ;
		  	//$c->add(PictureCommentPeer::DEL_FLAG,0) ;
			$c->add(PictureCommentPeer::PICTURE_ID,$pictureIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(PictureCommentPeer::ID) ;
			$comments = PictureCommentPeer::doSelect($c) ;
			foreach($comments as $comment){
				if(!isset($commentsForPictureId[$comment->getPictureId()])){
					$commentsForPictureId[$comment->getPictureId()] = array() ;
				}
				$commentsForPictureId[$comment->getPictureId()][] = $comment ;

				$socialUserId = $comment->getSocialUserId() ;
				if($socialUserId){
					if(!in_array($socialUserId,$socialUserIds)){
						$socialUserIds[] = $socialUserId ;
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

		$uri = $request->getUri() ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$this->uri = $uri ;
		$this->commentsForPictureId = $commentsForPictureId ;
		$this->pictures = $pictures ;
		$this->forumId = $forumId ;
		$this->page = $page ;
		$this->allApps = $allApps ;
		$this->appMap = $appMap ;
		$this->forums = $forums ;
		$this->forumMap = $forumMap ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->socialUserMap = $socialUserMap ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
		$this->startIndex = $startIndex ;
	}


	public function executeDeleteforumpost(sfWebRequest $request)
	{
		$page = $request->getParameter('p') ;
		$pictureId = $request->getParameter('pid') ;

		// need permission to delete picture
		$picture = PicturePeer::retrieveByPk($pictureId) ;
		if($picture && ($picture->getDelFlag() == 0)){
			$forumId = $picture->getForumId() ;
			$appIdForForum = AdminTools::getAppIdForForum($forumId) ;
			if($appIdForForum == $this->appId){
				$picture->setDelFlag(2) ;
				$picture->save() ;

				$forum = ForumPeer::retrieveByPk($forumId) ;
				$socialUserId = $picture->getSocialUserId() ;

				$socialUser = SocialUserPeer::retrieveByPk($socialUserId) ;
				if($socialUser){
					$numberOfPictures = $socialUser->getNumberOfPictures() ;
					$numberOfPictures-- ;
					if($numberOfPictures < 0){
						$numberOfPictures = 0 ;
					}
					$socialUser->setNumberOfPictures($numberOfPictures) ;
					$socialUser->save() ;
				}

			  	$c = new Criteria() ;
			  	$c->add(ReportSetPeer::DEL_FLG,0) ;
			  	$c->add(ReportSetPeer::KIND,1) ; // picture
			  	$c->add(ReportSetPeer::CONTENT,$pictureId) ;
				$c->addAscendingOrderByColumn(ReportSetPeer::ID) ;
				$reportSet = ReportSetPeer::doSelectOne($c) ;
				if($reportSet){
					$reportSet->setRemoved(1) ;
					$reportSet->save() ;
				}

				$message = sprintf("Picture deleted\nid=%s\nforum_id=%s\nsocial_user_id=%s\nnumber_of_likes=%s\nurl=%s\ndel_flag=%s\ncreated_at=%s\nupdated_at=%s\napp_id=%s",
							$picture->getId(),$picture->getForumId(),$picture->getSocialUserId(),$picture->getNumberOfLikes(),$picture->getUrl(),$picture->getDelFlag(),$picture->getCreatedAt(),$picture->getUpdatedAt(),$this->appId) ;
				$this->logMessage($message, 'info');

				ConsoleTools::forumChanged($forumId,$this->appId) ;
				ConsoleTools::someonesPostChanged($socialUserId) ;
			} else {
				$request->setParameter('m','Invalid parameters') ;
				$this->forward('error','index') ;
				return sfView::NONE ;
			}

		} else {
			$request->setParameter('m','Invalid parameters') ;
			$this->forward('error','index') ;
			return sfView::NONE ;
		}

		$this->forward('mi','forumposts') ;
	}



}

