<?php

/**
 * language actions.
 *
 * @package    console
 * @subpackage language
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class languageActions extends myActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeSet(sfWebRequest $request)
	{
		return sfView::NONE ;
	}


}
