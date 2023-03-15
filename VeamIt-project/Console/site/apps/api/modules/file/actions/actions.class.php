<?php

/**
 * file actions.
 *
 * @package    console
 * @subpackage file
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class fileActions extends sfActions
{
	/**
	* Executes index action
	*
	* @param sfRequest $request A request object
	*/
	public function executeUpload(sfWebRequest $request)
	{

		$appId = $request->getParameter('a') ;
		$kind = $request->getParameter('k') ;
		$fileName = $request->getParameter('f') ;

		$libDir = sfConfig::get("sf_lib_dir") ; 
		$commandDir = sprintf("%s/../../bin/encode",$libDir) ;

		$filePath = sprintf('%s/%s_%s',$commandDir,$appId,$fileName) ;

		sfContext::getInstance()->getLogger()->info("fileAction::executeUpload") ;

		// Get the Request body
		$request_body = @file_get_contents('php://input') ;

		file_put_contents($filePath, $request_body);

		chmod($filePath, 0666) ;

/*
		// Get some information on the file
		$file_info = new finfo(FILEINFO_MIME) ;

		// Extract the mime type
		$mime_type = $file_info->buffer($request_body) ;

		sfContext::getInstance()->getLogger()->info("MIME ".$mime_type) ;
		// Logic to deal with the type returned
		switch($mime_type) 
		{
			default:
				// Write the request body to file
				file_put_contents($filePath, $request_body);
				break ;
		}
*/

/*
		$fileName = sprintf("c_%s_%s_%04d.mov",$appId,date('YmdHis'),rand()%10000) ;
		$filePath = "/tmp/" . $fileName ;

		sfContext::getInstance()->getLogger()->info(sprintf('filePath=%s',$filePath));

		if(is_uploaded_file($_FILES["upfile"]["tmp_name"])){
			if(move_uploaded_file($_FILES["upfile"]["tmp_name"], $filePath)){
				sfContext::getInstance()->getLogger()->info(sprintf('uploaded'));
			} else {
				sfContext::getInstance()->getLogger()->info(sprintf('failed to upload'));
			}
		} else {
			sfContext::getInstance()->getLogger()->info(sprintf('not uploaded'));
		}
*/
		return sfView::NONE ;
	}





}


