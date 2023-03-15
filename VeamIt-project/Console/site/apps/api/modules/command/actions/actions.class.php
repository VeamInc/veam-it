<?php

/**
 * command actions.
 *
 * @package    console
 * @subpackage command
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class commandActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeExecute(sfWebRequest $request)
	{

		$remoteCommandId = $request->getParameter('i') ;
		$secret = $request->getParameter('s') ;
		$appId = $request->getParameter('a') ;

	  	$c = new Criteria() ;
	  	$c->add(RemoteCommandPeer::ID,$remoteCommandId) ;
	  	$c->add(RemoteCommandPeer::APP_ID,$appId) ;
	  	$c->add(RemoteCommandPeer::SECRET,$secret) ;
		$remoteCommand = RemoteCommandPeer::doSelectOne($c) ;
		if($remoteCommand){
			$commandName = $remoteCommand->getName() ;
			print("EXECUTE ".$commandName) ;
			if($commandName == 'UPDATE_CONCEPT_COLOR'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateConceptcolor --command_id=%d > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommandId) ;
			} else if($commandName == 'UPDATE_SCREEN_SHOT'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateScreenshot --command_id=%d > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommandId) ;
			} else if($commandName == 'UPDATE_YOUTUBE_LIST'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony updateYoutubelist --command_id=%d > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommandId) ;
			} else if($commandName == 'COMPLETE_APP_PROCESS'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony completeAppprocess --command_id=%d > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommandId) ;
			} else if($commandName == 'DEPLOY_APP'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony deployApp --command_id=%d > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommandId) ;
			} else if($commandName == 'DEPLOY_APP_CONTENTS'){
				$commandLine = sprintf("nohup php /data/console/%s/site/symfony deployAppcontents --command_id=%d > /dev/null &",$_SERVER['SERVER_NAME'],$remoteCommandId) ;
			} else {
				ConsoleTools::assert(false,sprintf("unknown command commandname=%s id=%s appid=%s secret=%s",$commandName,$remoteCommandId,$appId,$secret),__FILE__,__LINE__) ;
			}

			if($commandLine){
				print("$commandLine\n") ;
				exec($commandLine) ;
			}
		} else {
			ConsoleTools::assert(false,sprintf("remote command not found id=%s appid=%s secret=%s",$remoteCommandId,$appId,$secret),__FILE__,__LINE__) ;
		}

		return sfView::NONE ;
	}
}


