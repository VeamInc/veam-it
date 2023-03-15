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


		if($this->getModuleName() == 'language'){
			if($this->getActionName() == 'set'){
				$language = $request->getParameter('l') ;
				if($language){
					$user->setAttribute('forced_language',$language) ;
				}

				$lastModule = $user->getAttribute('last_module');
				$lastAction = $user->getAttribute('last_action');

				if($lastModule && $lastAction){
					$this->redirect(sprintf('/creator.php/%s/%s',$lastModule,$lastAction));
				} else {
					$this->redirect('/creator.php/app/submit');
				}
			}
		}


		$language = $user->getAttribute('forced_language') ;
		if(!$language){
			$language = $request->getPreferredCulture(array('en', 'ja')) ;
		}

		$culture = 'en_US' ;
		if($language == 'ja'){
			$culture = 'ja_JP' ;
		}
		$user->setCulture($culture) ;


		$appNames = array() ;
		$appIds = array() ;

		$appId = $user->getAttribute('app_id') ;
		$userName = $user->getAttribute('user_id') ;

		$appIds[] = $appId ;

		$app = AppPeer::retrieveByPk($appId) ;
		$appNames[$app->getId()] = $app->getName() ;

		if(!$appId){
			if($this->getModuleName() != 'error'){
				$request->setParameter('m',' Invalid parameters ') ;
				$this->forward('error', 'index') ;
			}
		}

		$user->setAttribute('app_id',$appId) ;
		$values['target_app_id'] = $appId ;
		$values['app_names'] = $appNames ;
		$values['target_app'] = $app ;
		$values['user_name'] = $userName ;
		$this->response->setSlot('values', $values) ;
		$this->appId = $appId ;
		$this->appNames = $appNames ;

		$user->setAttribute('last_module',$this->getModuleName()) ;
		$user->setAttribute('last_action',$this->getActionName()) ;


		AdminTools::saveConsoleLoginLog($appId,$userName,$_SERVER['REMOTE_ADDR'],$_SERVER['HTTP_USER_AGENT'],date('Y-m-d H:i:s')) ;

	}
}
