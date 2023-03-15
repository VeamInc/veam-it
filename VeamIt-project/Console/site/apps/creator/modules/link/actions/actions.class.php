<?php

/**
 * link actions.
 *
 * @package    console
 * @subpackage link
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class linkActions extends myActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeLinkorder(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			//// link
		  	$c = new Criteria() ;
		  	$c->add(WebPeer::DEL_FLAG,0) ;
		  	$c->add(WebPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
			$webs = WebPeer::doSelect($c) ;

			$this->webs = $webs ;
		} else {
			return sfView::NONE ;
		}
	}


	public function executeChangelinkorderapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$idsString = $request->getParameter('ids') ;
			if($idsString){
				$webIds = explode(",",$idsString) ;
				if(count($webIds) > 0){
				  	$c = new Criteria() ;
				  	$c->add(WebPeer::DEL_FLAG,0) ;
				  	$c->add(WebPeer::APP_ID,$appId) ;
				  	$c->add(WebPeer::ID,$webIds,Criteria::IN) ;
					$webs = WebPeer::doSelect($c) ;

					$webMap = array() ;
					foreach($webs as $web){
						$webMap[$web->getId()] = $web ;
					}

					$orderCount = 1 ;
					foreach($webIds as $webId){
						$web = $webMap[$webId] ;
						if($web){
							$web->setDisplayOrder($orderCount) ;
							$web->save() ;
							$orderCount++ ;
						}
					}
					ConsoleTools::clearContentCache($appId) ;
					ConsoleTools::consoleContentsChanged($appId) ;
				}
			} else {
				$this->forward('link','linkorder') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}




	public function executeLinklist(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$this->app = $app ;

			//// link
		  	$c = new Criteria() ;
		  	$c->add(WebPeer::DEL_FLAG,0) ;
		  	$c->add(WebPeer::APP_ID,$appId) ;
			$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
			$webs = WebPeer::doSelect($c) ;

			$this->webs = $webs ;
		} else {
			return sfView::NONE ;
		}
	}


	public function executeChangelinknameapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$webId = $request->getParameter('id') ;
			if($webId){
				$name = $request->getParameter('na') ;
				if($webId){
				  	$c = new Criteria() ;
				  	$c->add(WebPeer::DEL_FLAG,0) ;
				  	$c->add(WebPeer::APP_ID,$appId) ;
				  	$c->add(WebPeer::ID,$webId) ;
					$web = WebPeer::doSelectOne($c) ;
					if($web){
						$web->setTitle(ConsoleTools::xmlEscape($name)) ;
						$web->save() ;
						ConsoleTools::clearContentCache($appId) ;
						ConsoleTools::consoleContentsChanged($appId) ;
					}
				}
			} else {
				$this->forward('link','linklist') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeChangelinkurlapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$webId = $request->getParameter('id') ;
			if($webId){
				$url = $request->getParameter('na') ;
				if($webId){
				  	$c = new Criteria() ;
				  	$c->add(WebPeer::DEL_FLAG,0) ;
				  	$c->add(WebPeer::APP_ID,$appId) ;
				  	$c->add(WebPeer::ID,$webId) ;
					$web = WebPeer::doSelectOne($c) ;
					if($web){
						$web->setUrl(ConsoleTools::xmlEscape($url)) ;
						$web->save() ;
						ConsoleTools::clearContentCache($appId) ;
						ConsoleTools::consoleContentsChanged($appId) ;
					}
				}
			} else {
				$this->forward('link','linklist') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeRemovelinkapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$webId = $request->getParameter('id') ;
			if($webId){
			  	$c = new Criteria() ;
			  	$c->add(WebPeer::DEL_FLAG,0) ;
			  	$c->add(WebPeer::APP_ID,$appId) ;
			  	$c->add(WebPeer::ID,$webId) ;
				$web = WebPeer::doSelectOne($c) ;
				if($web){
					$web->delete() ;
					ConsoleTools::clearContentCache($appId) ;
					ConsoleTools::consoleContentsChanged($appId) ;
				}
			} else {
				$this->forward('link','linklist') ;
			}
		}

		echo json_encode('') ;
		return sfView::NONE ;
	}


	public function executeAddlinkapi(sfWebRequest $request)
	{
		$appId = $this->appId ;
		$app = AppPeer::retrieveByPk($appId) ;
		$data = array() ;
		if($app){
			if($_SERVER["REQUEST_METHOD"] == "POST"){
				$web = new Web() ;
				$web->setAppId($appId) ;
				$web->setTitle("New Link") ;
				$web->setUrl("http://veam.co/") ;
				$web->setDisplayOrder(0) ;
				$web->save() ;
				$webId = $web->getId() ;
				if($webId){
					$data = array('webId'=>$webId) ;
				}

			  	$c = new Criteria() ;
			  	$c->add(WebPeer::DEL_FLAG,0) ;
			  	$c->add(WebPeer::APP_ID,$appId) ;
				$c->addAscendingOrderByColumn(WebPeer::DISPLAY_ORDER) ;
				$webs = WebPeer::doSelect($c) ;

				$orderCount = 1 ;
				foreach($webs as $web){
					$web->setDisplayOrder($orderCount) ;
					$web->save() ;
					$orderCount++ ;
				}

				ConsoleTools::clearContentCache($appId) ;
				ConsoleTools::consoleContentsChanged($appId) ;
			} else {
				$this->forward('link','linklist') ;
			}
		}

		echo json_encode($data) ;
		return sfView::NONE ;
	}



}
