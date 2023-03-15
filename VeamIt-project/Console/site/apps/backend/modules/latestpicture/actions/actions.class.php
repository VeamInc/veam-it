<?php

/**
 * latestpicture actions.
 *
 * @package    console
 * @subpackage latestpicture
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class latestpictureActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeIndex(sfWebRequest $request)
	{
		$pageNo = $request->getParameter('p') ;
		if($pageNo == 0){
			$pageNo = 1 ;
		}
		$appId = $request->getParameter('a') ;

	  	$c = new Criteria() ;
	  	$c->add(PicturePeer::DEL_FLAG,0);
		if($appId){
		    $c->addJoin(PicturePeer::FORUM_ID, ForumPeer::ID) ;
		  	$c->add(ForumPeer::APP_ID,$appId) ; // need join
		}
		$c->addDescendingOrderByColumn(PicturePeer::ID) ;

		$pager = new sfPropelPager('Picture', 100);
		$pager->setCriteria($c);
		$pager->setPage($pageNo);
		$pager->init();
		if($pageNo <= $pager->getLastPage()){
			$this->pictures = $pager->getResults() ;

			$swatchPictureIds = array() ;
			$pictureIds = array() ;

			foreach($this->pictures as $picture){
				$pictureIds[] = $picture->getId() ;
				if($picture->getUrl() == 'SWATCH'){
					$swatchPictureIds[] = $picture->getId() ;
				}
			}


			$this->commentsForPictureId = array() ;
		  	$c = new Criteria() ;
		  	$c->add(PictureCommentPeer::DEL_FLAG,0) ;
			$c->add(PictureCommentPeer::PICTURE_ID,$pictureIds,Criteria::IN) ;
			$c->addAscendingOrderByColumn(PictureCommentPeer::ID) ;
			$comments = PictureCommentPeer::doSelect($c) ;
			foreach($comments as $comment){
				$this->commentsForPictureId[$comment->getPictureId()] .= sprintf("%s : %s\n",$comment->getSocialUserId(),$comment->getComment()) ;
			}


			if(count($swatchPictureIds) > 0){
				$this->swatchesForPictureId = array() ;
			  	$c = new Criteria() ;
			  	$c->add(SwatchPeer::DEL_FLAG,0) ;
				$c->add(SwatchPeer::PICTURE_ID,$swatchPictureIds,Criteria::IN) ;
				$swatches = SwatchPeer::doSelect($c) ;
				foreach($swatches as $swatch){
					$this->swatchesForPictureId[$swatch->getPictureId()] = $swatch ;
				}
			}
		}

		$this->appId = $appId ;
		$this->pageNo = $pageNo ;
	}
}
