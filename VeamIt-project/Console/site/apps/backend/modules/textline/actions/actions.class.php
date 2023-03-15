<?php

require_once dirname(__FILE__).'/../lib/textlineGeneratorConfiguration.class.php';
require_once dirname(__FILE__).'/../lib/textlineGeneratorHelper.class.php';

/**
 * textline actions.
 *
 * @package    console
 * @subpackage textline
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 12474 2008-10-31 10:41:27Z fabien $
 */
class textlineActions extends autoTextlineActions
{
	public function executeNew(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('app_id') ;
	}


	public function executeSave(sfWebRequest $request)
	{
		$appId = $request->getParameter('app_id') ;
		$title = $this->titleEscape($request->getParameter('title')) ;
		$text = $this->descriptionEscape($request->getParameter('text')) ;

		$textlinePackage = new TextlinePackage();
		$textlinePackage->setAppId($appId) ;
		$textlinePackage->setProduct('co.veam.veam31000018.packageXXX');
		$textlinePackage->setTitle('Package XXX');
		$textlinePackage->setCaption('Package XXX');
		$textlinePackage->setPrice('99');
		$textlinePackage->save();

		$textlinePackageId = $textlinePackage->getId();
		$packageId = sprintf("%03d",$textlinePackageId-1000);

		$textlinePackage->setProduct(sprintf('co.veam.veam31000018.package%s',$packageId));
		$textlinePackage->setTitle(sprintf('Package %s',$packageId));
		$textlinePackage->setCaption(sprintf('Package %s',$packageId));
		$textlinePackage->save();


		$textline = new Textline() ;

		$textline->setAppId($appId);
		$textline->setTextlinePackageId($textlinePackageId);
		$textline->setTextlineCategoryId(0);
		$textline->setTextlineSubCategoryId(0);
		$textline->setKind(3);
		$textline->setTitle($title);
		$textline->setSubTitle($title);
		$textline->setText($text);
		$textline->save();

		$this->redirect('textline/list') ;

		return sfView::NONE ;
	}


	public function executeList(sfWebRequest $request)
	{
		$pageNo = $request->getParameter('p') ;
		$appId = $request->getParameter('a') ;
		if(!$appId){
			$appId = 31000018;
		}
		if($pageNo == 0){
			$pageNo = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(TextlinePeer::DEL_FLG,0) ;
		if($appId){
		  	$c->add(TextlinePeer::APP_ID,$appId) ;
		}
		$c->addDescendingOrderByColumn(TextlinePeer::ID) ;

		$pager = new sfPropelPager('Textline', 10);
		$pager->setCriteria($c);
		$pager->setPage($pageNo);
		$pager->init();
		if($pageNo <= $pager->getLastPage()){
			$this->textlines = $pager->getResults() ;
		}

		$this->pageNo = $pageNo ;
		$this->appId = $appId ;
	}

	public function executeShow(sfWebRequest $request)
	{
		$textlineId = $request->getParameter('id') ;

		if($textlineId){
		  	$c = new Criteria() ;
		  	$c->add(TextlinePeer::ID,$textlineId);
			$this->textline = TextlinePeer::doSelectOne($c) ;


			$textlinePackageId = $this->textline->getTextlinePackageId();
		  	$c = new Criteria() ;
		  	$c->add(TextlinePackagePeer::ID,$textlinePackageId);
			$this->textlinePackage = TextlinePackagePeer::doSelectOne($c) ;

		}
	}

	public function executeConfirmdeploy(sfWebRequest $request)
	{
		$textlineId = $request->getParameter('id') ;

		if($textlineId){
		  	$c = new Criteria() ;
		  	$c->add(TextlinePeer::ID,$textlineId);

			$this->textlines = TextlinePeer::doSelect($c) ;
		}
	}


	public function executeDeploy(sfWebRequest $request)
	{
		$textlineId = $request->getParameter('id') ;

	  	$c = new Criteria() ;
	  	$c->add(TextlinePeer::ID,$textlineId);
		$textline = TextlinePeer::doSelectOne($c) ;
		$textlinePackageId = $textline->getTextlinePackageId();

		$libDir = sfConfig::get("sf_lib_dir") ; 
		$commandDir = sprintf("%s/../../bin/textline",$libDir) ;
		$command = sprintf("perl %s/deploy.pl %s %s public",$commandDir,$textlineId,$textlinePackageId) ;

		system($command) ;

		$this->message = 'Done' ;
	}




	public function titleEscape($string){
		$escapedString = $string ;
		$escapedString = str_replace('&',"&amp;",$escapedString) ;
		$escapedString = str_replace('"',"&quot;",$escapedString) ;
		$escapedString = str_replace('<',"&lt;",$escapedString) ;
		$escapedString = str_replace('>',"&gt;",$escapedString) ;
		$escapedString = str_replace("\r\n","&#xA;",$escapedString) ;

		$escapedString = str_replace("～","-",$escapedString) ;
		return $escapedString ;
	}


	public function descriptionEscape($string){
		$escapedString = $string ;

		$escapedString = str_replace('&',"&amp;amp;",$escapedString) ;
		$escapedString = str_replace('"',"&quot;",$escapedString) ;
		$escapedString = str_replace('<',"&amp;lt;",$escapedString) ;
		$escapedString = str_replace('>',"&amp;gt;",$escapedString) ;
		$escapedString = str_replace("\r\n","&#xA;",$escapedString) ;

		$escapedString = str_replace("～","-",$escapedString) ;

		return $escapedString ;
	}





}
