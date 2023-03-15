<?php

/**
 * revenue actions.
 *
 * @package    console
 * @subpackage revenue
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class revenueActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeInput(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error') ;
	}


	public function executeUpload(sfWebRequest $request)
	{
		$year = $request->getParameter('year') ;
		$month = $request->getParameter('month') ;

		if($year && $month){
			$dataDir = sprintf('%s/revenue/%08d/%04d/%02d',sfConfig::get("sf_data_dir"),$this->mcnId,$year,$month) ;
			mkdir($dataDir,0777,true) ;

			$iosPayment = $request->getParameter('ios_payment') ;
			$iosPaymentList = $request->getParameter('ios_payment_list') ;
			$iadPayment = $request->getParameter('iad_payment') ;
			$androidPayment = $request->getParameter('android_payment') ;

			$allApps = AdminTools::getAppsForMcn($this->mcnId) ;

			$appNames = array() ;
			foreach($allApps as $app){
				$appNames[sprintf('co.veam.veam%d',$app->getId())] = $app->getName() ;
			}


			$info = array(
				'ios_payment'=>$iosPayment,
				'iad_payment'=>$iadPayment,
				'android_payment'=>$androidPayment,
				'app_names'=> $appNames,
			) ;

			file_put_contents($dataDir.'/info.txt',json_encode($info));

			file_put_contents($dataDir.'/payment.txt',$iosPaymentList);

			$count = count($_FILES['iosfiles']['name']) ;
			for($i = 0 ; $i < $count ; $i++) {
			    $fileName = $_FILES['iosfiles']['name'][$i] ;
				$filePath = sprintf("%s/%s",$dataDir,$fileName) ;
				$tmpName = $_FILES["iosfiles"]["tmp_name"][$i] ;
				if(is_uploaded_file($tmpName)){
					if(move_uploaded_file($tmpName, $filePath)){
						chmod($filePath, 0644) ;
					} else {
						// echo "ファイルをアップロードできません。<br>" ;
					}
				} else {
					// echo "ファイルが選択されていません。<br>";
				}
			}

			$count = count($_FILES['androidfiles']['name']) ;
			for($i = 0 ; $i < $count ; $i++) {
			    $fileName = $_FILES['androidfiles']['name'][$i] ;
				$filePath = sprintf("%s/%s",$dataDir,$fileName) ;
				$tmpName = $_FILES["androidfiles"]["tmp_name"][$i] ;
				if(is_uploaded_file($tmpName)){
					if(move_uploaded_file($tmpName, $filePath)){
						chmod($filePath, 0644) ;
					} else {
						// echo "ファイルをアップロードできません。<br>" ;
					}
				} else {
					// echo "ファイルが選択されていません。<br>";
				}
			}


			$commandLine = sprintf('perl %s/revenue/makereport.pl %d %d %d',sfConfig::get("sf_data_dir"),$this->mcnId,$year,$month) ;
			exec($commandLine) ;

			$errorFilePath = sprintf("%s/error.txt",$dataDir) ;
			$iosFilePath = sprintf("%s/ios_result.txt",$dataDir) ;
			$androidFilePath = sprintf("%s/android_result.txt",$dataDir) ;

			if(file_exists($errorFilePath)){
				$errorMessage = file_get_contents($errorFilePath) ;
				$request->setParameter('error',$errorMessage) ;
				$this->forward('revenue','input') ;
			}

			$c = new Criteria() ;
			$c->add(RevenuePeer::DEL_FLG,0) ;
			$c->add(RevenuePeer::YEAR,$year) ;
			$c->add(RevenuePeer::MONTH,$month) ;
			$revenues = RevenuePeer::doSelect($c) ;
			$revenueMapForAppId = array() ;
			foreach($revenues as $revenue){
				$revenueMapForAppId[$revenue->getAppId()] = $revenue ;
			}

			if(file_exists($iosFilePath)){
				$iosRevenues = json_decode(file_get_contents($iosFilePath)) ;
				foreach($iosRevenues as $bundleId=>$iosRevenue){
					$appId = substr($bundleId,12,8) ;
					$revenue = $revenueMapForAppId[$appId] ;
					if(!$revenue){
						$revenue = new Revenue() ;
						$revenue->setAppId($appId) ;
						$revenue->setYear($year) ;
						$revenue->setMonth($month) ;
						$revenueMapForAppId[$appId] = $revenue ;
					}
					$revenue->setIos($iosRevenue) ;

					if($appId == 31000015){
						$revenue->setEtc($iadPayment) ;
						$revenue->setEtcDescription('iAd') ;
					}

					$revenue->save() ;
				}
			}

			if(file_exists($androidFilePath)){
				$androidRevenues = json_decode(file_get_contents($androidFilePath)) ;
				foreach($androidRevenues as $bundleId=>$androidRevenue){
					$appId = substr($bundleId,12,8) ;
					$revenue = $revenueMapForAppId[$appId] ;
					if(!$revenue){
						$revenue = new Revenue() ;
						$revenue->setAppId($appId) ;
						$revenue->setYear($year) ;
						$revenue->setMonth($month) ;
						$revenueMapForAppId[$appId] = $revenue ;
					}
					$revenue->setAndroid($androidRevenue) ;
					$revenue->save() ;
				}
			}

			$this->forward('revenue','listrevenue') ;
		}

		return sfView::NONE ;
	}





	public function executeListrevenue(sfWebRequest $request)
	{
		$page = $request->getParameter('p') ;
		$appId = $request->getParameter('a') ;
		//$sortKind = $request->getParameter('so') ;
		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::MCN_ID,$this->mcnId) ;
		if($appId){
		  	$c->add(AppPeer::ID,$appId) ;
		}
		if($sortKind == 1){
			$c->addAscendingOrderByColumn(AppPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(AppPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('App', 10) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$apps = $pager->getResults() ;
		}

		$appMap = AdminTools::getMapForObjects($apps) ;

		$appIds = AdminTools::getIdsForObjects($apps) ;
		$appIds[] = 0 ; // add default

	  	$c = new Criteria() ;
	  	$c->add(RevenuePeer::DEL_FLG,0) ;
	  	$c->add(RevenuePeer::APP_ID,$appIds,Criteria::IN) ;
		$c->addDescendingOrderByColumn(RevenuePeer::YEAR) ;
		$c->addDescendingOrderByColumn(RevenuePeer::MONTH) ;
		$revenues = RevenuePeer::doSelect($c) ;
		$revenuesMapForAppId = array() ;
		foreach($revenues as $revenue){
			$appId = $revenue->getAppId() ;
			if(!$revenuesMapForAppId[$appId]){
				$revenuesMapForAppId[$appId] = array() ;
			}
			$revenuesMapForAppId[$appId][] = $revenue ;
		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

		$this->apps = $apps ;
		$this->page = $page ;
		$this->revenuesMapForAppId = $revenuesMapForAppId ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
	}


}
