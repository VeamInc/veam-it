<?php

/**
 * 	picture actions.
 *
 * @package    console
 * @subpackage picture
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class pictureActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeShow(sfWebRequest $request)
	{
		$pictureId = $request->getParameter('id') ;
		if($pictureId){
		  	$c = new Criteria() ;
		  	$c->add(PicturePeer::DEL_FLAG,0);
		  	$c->add(PicturePeer::ID,$pictureId);
			$c->addDescendingOrderByColumn(PicturePeer::ID) ;
			$this->pictures = PicturePeer::doSelect($c) ;


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
	}


	public function executeConfirmdelete(sfWebRequest $request)
	{
		$pictureId = $request->getParameter('id') ;
		if($pictureId){
		  	$c = new Criteria() ;
		  	$c->add(PicturePeer::DEL_FLAG,0);
		  	$c->add(PicturePeer::ID,$pictureId);
			$c->addDescendingOrderByColumn(PicturePeer::ID) ;
			$this->pictures = PicturePeer::doSelect($c) ;


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
	}

	public function executeDelete(sfWebRequest $request)
	{
		$pictureId = $request->getParameter('id') ;
		/*
		$userId = $request->getParameter('u') ;
		$appId = $request->getParameter('a') ;
		$socialUserId = $request->getParameter('sid') ;
		$signature = $request->getParameter('s') ;
		*/

	  	$c = new Criteria();
	  	$c->add(PicturePeer::DEL_FLAG,0) ;
	  	$c->add(PicturePeer::ID,$pictureId) ;
	  	//$c->add(PicturePeer::SOCIAL_USER_ID,$socialUserId) ;
	  	$pictures = PicturePeer::doSelect($c) ;
		if(count($pictures) > 0){
			$picture = $pictures[0] ;
			$forumId = $picture->getForumId() ;
			$forum = ForumPeer::retrieveByPk($forumId) ;
			if($forum){
				$appId = $forum->getAppId() ;
			}
			$forumId = $picture->getForumId() ;
			$socialUserId = $picture->getSocialUserId() ;
			$picture->delete() ;

			$socialUser = SocialUserPeer::retrieveByPk($socialUserId) ;
			$numberOfPictures = $socialUser->getNumberOfPictures() ;
			$numberOfPictures-- ;
			if($numberOfPictures < 0){
				$numberOfPictures = 0 ;
			}
			$socialUser->setNumberOfPictures($numberOfPictures) ;
			$socialUser->save() ;

			$message = sprintf("Picture deleted\nid=%s\nforum_id=%s\nsocial_user_id=%s\nnumber_of_likes=%s\nurl=%s\ndel_flag=%s\ncreated_at=%s\nupdated_at=%s\n",
							$picture->getId(),$picture->getForumId(),$picture->getSocialUserId(),$picture->getNumberOfLikes(),$picture->getUrl(),$picture->getDelFlag(),$picture->getCreatedAt(),$picture->getUpdatedAt()) ;
			$this->logMessage($message, 'info');

			$this->message = 'Removed' ;
		} else {
			$this->message = 'Failed' ;
		}

		ConsoleTools::forumChanged($forumId,$appId) ;
		ConsoleTools::someonesPostChanged($socialUserId) ;
	}

}

