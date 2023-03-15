<?php

class myActions extends sfActions
{
	public function preExecute()
	{
		parent::preExecute();

		$errorInfo = "" ;

		$values = array() ;

		$request = $this->getRequest();
		$user = $this->getUser() ;

		$mcnNames = array() ;
		$mcnIds = array() ;
		if($user->isSuperAdmin()){
		  	$c = new Criteria() ;
		  	$c->add(McnPeer::DEL_FLAG,0) ;
			$c->addAscendingOrderByColumn(McnPeer::ID) ;
			$mcns = McnPeer::doSelect($c) ;
			foreach($mcns as $mcn){
				$mcnNames[$mcn->getId()] = $mcn->getName() ;
				$mcnIds[] = $mcn->getId() ;
			}
		} else {
			$groups = $user->getGroups() ;
			foreach($groups as $group){
				$elements = explode('_',$group) ;
				if($elements[0] == 'mcn'){
					$targetMcnId = $elements[1] ;
					$mcnIds[] = $targetMcnId ;
				}
			}

		  	$c = new Criteria() ;
		  	$c->add(McnPeer::DEL_FLAG,0) ;
		  	$c->add(McnPeer::ID,$mcnIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(McnPeer::ID) ;
			$mcns = McnPeer::doSelect($c) ;
			foreach($mcns as $mcn){
				$mcnNames[$mcn->getId()] = $mcn->getName() ;
			}
		}

		$mcnId = $request->getParameter('mcn') ;
		if(!$mcnId){
			$errorInfo .= "mcn not specified:" ;
			$mcnId = $user->getAttribute('mcn_id') ;
		}

		if(!$mcnId){
			if(count($mcnIds) > 0){
				$mcnId = $mcnIds[0] ;
				$errorInfo .= "first mcn used:" ;
			} else {
				$errorInfo .= "no candidate mcn:" ;
			}

		}


		if(!$user->isSuperAdmin() && !in_array($mcnId,$mcnIds)){
			$errorInfo .= "not permitted " . $mcnId . ":" ;
			$mcnId = 0 ; 
		}

		if(!$mcnId){
			if($this->getModuleName() != 'error'){
				$request->setParameter('m',' Invalid parameters '/*.$errorInfo*/) ;
				$this->forward('error', 'index') ;
			}
		}


	  	$c = new Criteria() ;
	  	$c->add(AppProcessCategoryPeer::DEL_FLAG,0) ;
		$c->addAscendingOrderByColumn(AppProcessCategoryPeer::ID) ;
		$appProcessCategories = AppProcessCategoryPeer::doSelect($c) ;

	  	$c = new Criteria() ;
	  	$c->add(AppProcessPeer::DEL_FLAG,0) ;
		$c->addAscendingOrderByColumn(AppProcessPeer::ORDER) ;
		$appProcesses = AppProcessPeer::doSelect($c) ;
		$appProcessesMap = array() ;
		foreach($appProcesses as $appProcess){
			$appProcessCategoryId = $appProcess->getAppProcessCategoryId() ;
			if(!isset($appProcessesMap[$appProcessCategoryId])){
				$appProcessesMap[$appProcessCategoryId] = array() ;
			}
			$appProcessesMap[$appProcessCategoryId][] = $appProcess ;
		}


		$user->setAttribute('mcn_id',$mcnId) ;
		$values['target_mcn_id'] = $mcnId ;
		$values['mcn_names'] = $mcnNames ;
		$values['app_process_categories'] = $appProcessCategories ;
		$values['app_processes_map'] = $appProcessesMap ;
		$this->response->setSlot('values', $values) ;
		$this->mcnId = $mcnId ;
		$this->appProcessCategories = $appProcessCategories ;
		$this->appProcessesMap = $appProcessesMap ;

	}
}
