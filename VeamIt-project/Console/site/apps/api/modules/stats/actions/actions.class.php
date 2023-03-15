<?php

/**
 * stats actions.
 *
 * @package    console
 * @subpackage stats
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class statsActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executePicturecount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s 12:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s 12:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureCounts = PictureCountPeer::doSelect($c) ;
				foreach($pictureCounts as $pictureCount){
					$pictureCountMap[$pictureCount->getDate()] = $pictureCount ;
				}

				$targetTime = $startTime ;
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$pictureCount = $pictureCountMap[$targetDate] ;
					if($pictureCount){
						$result['apps'][$appId][$targetDate] = $pictureCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetDate] = 0 ;
					}
					$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_COUNT_RESULT ;
		}

PICTURE_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}



	public function executePictureuucount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s 12:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s 12:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_UU_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_UU_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_UU_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_UU_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureUuCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureUuCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureUuCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureUuCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureUuCounts = PictureUuCountPeer::doSelect($c) ;
				foreach($pictureUuCounts as $pictureUuCount){
					$pictureUuCountMap[$pictureUuCount->getDate()] = $pictureUuCount ;
				}

				$targetTime = $startTime ;
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$pictureUuCount = $pictureUuCountMap[$targetDate] ;
					if($pictureUuCount){
						$result['apps'][$appId][$targetDate] = $pictureUuCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetDate] = 0 ;
					}
					$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_UU_COUNT_RESULT ;
		}

PICTURE_UU_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}



	public function executePicturemuucount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s-01 00:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s-28 00:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_MUU_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_MUU_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_MUU_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_MUU_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureMuuCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureMuuCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureMuuCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureMuuCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureMuuCounts = PictureMuuCountPeer::doSelect($c) ;
				foreach($pictureMuuCounts as $pictureMuuCount){
					$pictureMuuCountMap[$pictureMuuCount->getDate()] = $pictureMuuCount ;
				}

				$targetTime = $startTime ;
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$targetMonth = date("Y-m",$targetTime) ;
					$pictureMuuCount = $pictureMuuCountMap[$targetDate] ;
					if($pictureMuuCount){
						$result['apps'][$appId][$targetMonth] = $pictureMuuCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetMonth] = 0 ;
					}

					$targetTime = strtotime($targetDate." +1 month") ;
					//$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_MUU_COUNT_RESULT ;
		}

PICTURE_MUU_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}

	public function executePicturewuucount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s 00:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s 00:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_WUU_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_WUU_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_WUU_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_WUU_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureWuuCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureWuuCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureWuuCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureWuuCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureWuuCounts = PictureWuuCountPeer::doSelect($c) ;
				foreach($pictureWuuCounts as $pictureWuuCount){
					$pictureWuuCountMap[$pictureWuuCount->getDate()] = $pictureWuuCount ;
				}

				if(date('D',$startTime) == 'Sun'){
					$targetTime = $startTime ;
				} else {
					$targetTime = strtotime('next Sunday', $startTime) ;
				}
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$pictureWuuCount = $pictureWuuCountMap[$targetDate] ;
					if($pictureWuuCount){
						$result['apps'][$appId][$targetDate] = $pictureWuuCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetDate] = 0 ;
					}

					$targetTime = strtotime($targetDate." +1 week") ;
					//$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_WUU_COUNT_RESULT ;
		}

PICTURE_WUU_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}



























	public function executePicturecommentcount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s 12:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s 12:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_COMMENT_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_COMMENT_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_COMMENT_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_COMMENT_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureCommentCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureCommentCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureCommentCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureCommentCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureCommentCounts = PictureCommentCountPeer::doSelect($c) ;
				foreach($pictureCommentCounts as $pictureCommentCount){
					$pictureCommentCountMap[$pictureCommentCount->getDate()] = $pictureCommentCount ;
				}

				$targetTime = $startTime ;
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$pictureCommentCount = $pictureCommentCountMap[$targetDate] ;
					if($pictureCommentCount){
						$result['apps'][$appId][$targetDate] = $pictureCommentCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetDate] = 0 ;
					}
					$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_COMMENT_COUNT_RESULT ;
		}

PICTURE_COMMENT_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}

	public function executePicturecommentuucount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s 12:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s 12:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_COMMENT_UU_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_COMMENT_UU_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_COMMENT_UU_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_COMMENT_UU_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureCommentUuCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureCommentUuCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureCommentUuCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureCommentUuCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureCommentUuCounts = PictureCommentUuCountPeer::doSelect($c) ;
				foreach($pictureCommentUuCounts as $pictureCommentUuCount){
					$pictureCommentUuCountMap[$pictureCommentUuCount->getDate()] = $pictureCommentUuCount ;
				}

				$targetTime = $startTime ;
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$pictureCommentUuCount = $pictureCommentUuCountMap[$targetDate] ;
					if($pictureCommentUuCount){
						$result['apps'][$appId][$targetDate] = $pictureCommentUuCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetDate] = 0 ;
					}
					$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_COMMENT_UU_COUNT_RESULT ;
		}

PICTURE_COMMENT_UU_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}


	public function executePicturecommentmuucount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s-01 00:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s-28 00:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_COMMENT_MUU_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_COMMENT_MUU_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_COMMENT_MUU_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_COMMENT_MUU_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureCommentMuuCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureCommentMuuCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureCommentMuuCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureCommentMuuCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureCommentMuuCounts = PictureCommentMuuCountPeer::doSelect($c) ;
				foreach($pictureCommentMuuCounts as $pictureCommentMuuCount){
					$pictureCommentMuuCountMap[$pictureCommentMuuCount->getDate()] = $pictureCommentMuuCount ;
				}

				$targetTime = $startTime ;
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$targetMonth = date("Y-m",$targetTime) ;
					$pictureCommentMuuCount = $pictureCommentMuuCountMap[$targetDate] ;
					if($pictureCommentMuuCount){
						$result['apps'][$appId][$targetMonth] = $pictureCommentMuuCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetMonth] = 0 ;
					}

					$targetTime = strtotime($targetDate." +1 month") ;
					//$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_COMMENT_MUU_COUNT_RESULT ;
		}

PICTURE_COMMENT_MUU_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}

















	public function executePicturecommentwuucount(sfWebRequest $request)
	{

		$apiKey = $request->getParameter('key') ;
		$result = array() ;
		if($this->isValidApiKey($apiKey)){
			$appId = $request->getParameter('appId') ;
			$startDate = $request->getParameter('start') ;
			$endDate = $request->getParameter('end') ;

			$startTime = strtotime(sprintf("%s 00:00:00",$startDate)) ;
			$endTime = strtotime(sprintf("%s 00:00:00",$endDate)) ;
			$currentTime = time() ;

			// 1262271600 2010/01/01 00:00:00
			if($startTime < 1262271600){
				$result['error'] = 'Invalid start date' ;
				goto PICTURE_COMMENT_WUU_COUNT_RESULT ;
			}

			if($endTime < 1262271600){
				$result['error'] = 'Invalid end date' ;
				goto PICTURE_COMMENT_WUU_COUNT_RESULT ;
			}

			if($endTime < $startTime){
				$result['error'] = 'Invalid date' ;
				goto PICTURE_COMMENT_WUU_COUNT_RESULT ;
			}

		  	$c = new Criteria() ;
		  	$c->add(AppPeer::DEL_FLG,0) ;
			if($appId){
			  	$c->add(AppPeer::ID,$appId) ;
			}
			$apps = AppPeer::doSelect($c) ;
			if(count($apps) == 0){
				$result['error'] = 'No app found' ;
				goto PICTURE_COMMENT_WUU_COUNT_RESULT ;
			} 

			$results['apps'] = array() ;
			foreach($apps as $app){
				$appId = $app->getId() ;
				$results['apps'][$appId] = array() ;

				$pictureCommentWuuCountMap = array() ;

			  	$c = new Criteria() ;
			  	$c->add(PictureCommentWuuCountPeer::APP_ID,$appId) ;
			  	$c->add(PictureCommentWuuCountPeer::DATE,$startDate,Criteria::GREATER_EQUAL) ;
			  	$c->add(PictureCommentWuuCountPeer::DATE,$endDate,Criteria::LESS_EQUAL) ;
				$pictureCommentWuuCounts = PictureCommentWuuCountPeer::doSelect($c) ;
				foreach($pictureCommentWuuCounts as $pictureCommentWuuCount){
					$pictureCommentWuuCountMap[$pictureCommentWuuCount->getDate()] = $pictureCommentWuuCount ;
				}

				if(date('D',$startTime) == 'Sun'){
					$targetTime = $startTime ;
				} else {
					$targetTime = strtotime('next Sunday', $startTime) ;
				}
				while(($targetTime <= $endTime) && ($targetTime < $currentTime)){
					$targetDate = date("Y-m-d",$targetTime) ;
					$pictureCommentWuuCount = $pictureCommentWuuCountMap[$targetDate] ;
					if($pictureCommentWuuCount){
						$result['apps'][$appId][$targetDate] = $pictureCommentWuuCount->getCount() ;
					} else {
						$result['apps'][$appId][$targetDate] = 0 ;
					}

					$targetTime = strtotime($targetDate." +1 week") ;
					//$targetTime += 86400 ;
				}
			}
		} else {
			$result['error'] = 'Invalid API key' ;
			goto PICTURE_COMMENT_WUU_COUNT_RESULT ;
		}

PICTURE_COMMENT_WUU_COUNT_RESULT:
		print(json_encode($result)) ;

		return sfView::NONE ;
	}


















	public function isValidApiKey($apiKey)
	{
		$isValid = false ; 
		if($apiKey == '__VEAM_API_KEY__'){
			$isValid = true ;
		}
		return $isValid ;
	}
}


