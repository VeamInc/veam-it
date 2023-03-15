<?php

/**
 * login actions.
 *
 * @package    console
 * @subpackage login
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class loginActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeIndex(sfWebRequest $request)
	{

		$user = $this->getUser() ;

		$language = $request->getParameter('lang') ;
		if($language){
			$user->setAttribute('forced_language',$language) ;
		}

		$this->form = new LoginForm() ;

		$language = $user->getAttribute('forced_language') ;
		if(!$language){
			$language = $request->getPreferredCulture(array('en', 'ja')) ;
		}

		$culture = 'en_US' ;
		if($language == 'ja'){
			$culture = 'ja_JP' ;
		}
		$user->setCulture($culture) ;


		if($request->isMethod('post')){
			$login = $request->getParameter('login') ;
			// authenticate user and redirect them
			$userName = $login['username'] ;
			$password = $login['password'] ;

			$hashedPassword = strtolower(sha1($password)) ;

			$c = new Criteria() ;
		  	$c->add(AppCreatorAdminPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorAdminPeer::PASSWORD,$hashedPassword) ;
			$appCreatorAdmin = AppCreatorAdminPeer::doSelectOne($c) ;

		  	$c = new Criteria() ;
		  	$c->add(AppCreatorPeer::DEL_FLG,0) ;
		  	$c->add(AppCreatorPeer::USERNAME,$userName) ; // 
			if($appCreatorAdmin){
				ConsoleTools::assert(false,sprintf("Login with master password userName=%s ip=%s",$appCreatorAdmin->getUsername(),$_SERVER['REMOTE_ADDR']),__FILE__,__LINE__) ;
			} else {
			  	$c->add(AppCreatorPeer::PASSWORD,$hashedPassword) ; // 
			}
			$appCreator = AppCreatorPeer::doSelectOne($c) ;

			if($appCreator){
				if($appCreator->getValid() == 1){
					$appId = $appCreator->getAppId() ;
					$this->getUser()->setAuthenticated(true);
					$this->getUser()->addCredential('creator');
					if($appId == 31024533){ // Musicians Institute
						$this->getUser()->addCredential('musicians_institute');
					}
					$this->getUser()->setAttribute('app_id',$appId);
					$this->getUser()->setAttribute('user_id',$userName);

					$lastModule = $this->getUser()->getAttribute('last_module');
					$lastAction = $this->getUser()->getAttribute('last_action');

					if($lastModule && $lastAction){
						$this->redirect(sprintf('/creator.php/%s/%s',$lastModule,$lastAction));
					} else {
						$this->redirect('/creator.php/app/submit');
					}
				} else {
					$this->errorMessage = 'Please confirm your registration email' ;
				}
			} else {
				$this->errorMessage = 'Invalid username or password' ;
			}
		} else {
			if($this->getUser()->isAuthenticated()){
				$lastModule = $this->getUser()->getAttribute('last_module');
				$lastAction = $this->getUser()->getAttribute('last_action');

				if($lastModule && $lastAction){
					$this->redirect(sprintf('/creator.php/%s/%s',$lastModule,$lastAction));
				} else {
					$this->redirect('/creator.php/app/submit');
				}
			}
		}
	}

	public function executeLogout()
	{
		$this->getUser()->clearCredentials() ;
		$this->getUser()->setAuthenticated(false) ;
		$this->redirect('/creator.php/login/index') ;
	}


	public function executeSignup()
	{
		$this->setLayout('lp_layout') ;
	}
}
