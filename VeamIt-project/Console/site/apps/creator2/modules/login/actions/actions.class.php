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

		$this->redirect('/creator.php/login/index');
		/*
		$this->form = new LoginForm() ;

		if($request->isMethod('post')){
			$login = $request->getParameter('login') ;
			// authenticate user and redirect them
			$userName = $login['username'] ;
			$password = $login['password'] ;

			$this->getUser()->setAuthenticated(true);
			$this->getUser()->addCredential('creator');
			$this->getUser()->setAttribute('app_id','31000287');

			$this->redirect('/creator2.php/forum/posts');
		}
		*/
	}

	public function executeLogout()
	{
		$this->getUser()->clearCredentials() ;
		$this->getUser()->setAuthenticated(false) ;
		$this->redirect('/creator.php/login/index') ;
	}
}
