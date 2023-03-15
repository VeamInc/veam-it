<?php


/**
 * payment actions.
 *
 * @package    console
 * @subpackage payment
 * @author     Your name here
 * @version    SVN: $Id: actions.class.php 23810 2009-11-12 11:07:44Z Kris.Wallsmith $
 */
class paymentActions extends myActions
{
 /**
  * Executes index action
  *
  * @param sfRequest $request A request object
  */
	public function executeListaccount(sfWebRequest $request)
	{
		$page = $request->getParameter('p') ;
		//$paymentAccountId = $request->getParameter('c') ;
		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		if($paymentAccountId){
		  	$c->add(PaymentAccountPeer::ID,$paymentAccountId) ;
		}
	  	//$c->addJoin(PaymentAccountPeer::APP_ID,AppPeer::ID) ;
	  	//$c->add(AppPeer::MCN_ID,$this->mcnId) ;
		$c->addDescendingOrderByColumn(PaymentAccountPeer::ID) ;

		$pager = new sfPropelPager('PaymentAccount', 100) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$accounts = $pager->getResults() ;
		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}



		$appIds = array() ;
		foreach($accounts as $account){
			$appIds[] = $account->getAppId() ;
		}
	  	$c = new Criteria() ;
	  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$apps = AppPeer::doSelect($c) ;
		$appMap = AdminTools::getMapForObjects($apps) ;


		$this->accounts = $accounts ;
		$this->appMap = $appMap ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
	}


	public function executeAccountinputnew(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
		$this->name = $request->getParameter('name') ;
		$this->email = $request->getParameter('email') ;
		$this->appId = $request->getParameter('appid') ;
		$this->share = $request->getParameter('share') ;

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::DEL_FLG,0) ;
	  	$c->add(AppPeer::STATUS,1,Criteria::NOT_EQUAL) ;
	  	$c->addAnd(AppPeer::STATUS,4,Criteria::NOT_EQUAL) ;
	  	//$c->add(AppPeer::MCN_ID,$this->mcnId) ;

	  	$c->addJoin(AppPeer::ID,PaymentAccountPeer::APP_ID,Criteria::LEFT_JOIN) ;
		$c->add(PaymentAccountPeer::APP_ID,null,Criteria::ISNULL); 
	  	//$c->add(AppPeer::MCN_ID,$this->mcnId) ;

		$c->addAscendingOrderByColumn(AppPeer::ID) ;
		$this->allApps = AppPeer::doSelect($c) ;
	}

	public function executeAddnewaccount(sfWebRequest $request)
	{
		$name = $request->getParameter('name') ;
		$email = $request->getParameter('email') ;
		$appId = $request->getParameter('appid') ;
		$share = $request->getParameter('share') ;

		$errorMessage = "" ;

		if(!$name){
			$errorMessage .= "Please input account name.\n" ;
		}
		if(!$email){
			$errorMessage .= "Please input email.\n" ;
		}
		if(!$appId){
			$errorMessage .= "Please input app ID.\n" ;
		}
		if(!$share){
			$errorMessage .= "Please input share.\n" ;
		}
		if(!((0 < $share) && ($share <= 100))){
			$errorMessage .= "Invalid share value.\n" ;
		}

		if(!$errorMessage){
		  	$c = new Criteria();
		  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		  	$c->add(PaymentAccountPeer::APP_ID,$appId) ;
			$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
			if($paymentAccount){
				$errorMessage .= sprintf('%s already exists',$appId) ;
			} else {
				$paymentAccount = new PaymentAccount() ;
				$paymentAccount->setAppId($appId) ;
				$paymentAccount->setEmail($email) ;
				$paymentAccount->setName($name) ;
				$paymentAccount->setShare($share) ;
				$paymentAccount->save() ;

				$this->forward('payment','listaccount') ;
			}
		}

		if($errorMessage){
			$request->setParameter('error_message',$errorMessage) ;
			$this->forward('payment','accountinputnew') ;
		}
	}



	public function executeAccountinputedit(sfWebRequest $request)
	{
		$paymentAccountId = $request->getParameter('c') ;

		$paymentAccount = PaymentAccountPeer::retrieveByPk($paymentAccountId) ;
		if($paymentAccount){
			$appId = $paymentAccount->getAppId() ;
			$this->app = AppPeer::retrieveByPk($appId) ;
			$this->errorMessage = $request->getParameter('error_message') ;
			$this->appId = $paymentAccount->getAppId() ;
			$this->name = $paymentAccount->getName() ;
			$this->email = $paymentAccount->getEmail() ;
			$this->share = $paymentAccount->getShare() ;
			$this->paymentAccountId = $paymentAccountId ;
		}
	}

	public function executeSaveaccount(sfWebRequest $request)
	{
		$paymentAccountId = $request->getParameter('c') ;
		$name = $request->getParameter('name') ;
		$email = $request->getParameter('email') ;
		$share = $request->getParameter('share') ;

		$paymentAccount = PaymentAccountPeer::retrieveByPk($paymentAccountId) ;
		if($paymentAccount){
			$appId = $paymentAccount->getAppId() ;
		  	$c = new Criteria() ;
		  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		  	$c->add(PaymentAccountPeer::ID,$paymentAccountId) ;
			$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
			if($paymentAccount){
				if($name){
					$paymentAccount->setName($name) ;
				}
				if($email){
					$paymentAccount->setEmail($email) ;
				}
				if($share){
					$paymentAccount->setShare($share) ;
				}
				$paymentAccount->save() ;

				$this->forward('payment','listaccount') ;
				return sfView::NONE ;
			} else {
				$request->setParameter('error_message',sprintf('%s not exists',$paymentAccountId)) ;
				$this->forward('payment','accountinputedit') ;
				return sfView::NONE ;
			}
		}
		$this->forward('payment','listaccount') ;
	}






	public function executeListrevenue(sfWebRequest $request)
	{
		$page = $request->getParameter('p') ;
		$appId = $request->getParameter('a') ;
		$yearMonth = $request->getParameter('ym') ;
		$sortKind = $request->getParameter('sort') ;

		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		$c->addDescendingOrderByColumn(PaymentAccountPeer::ID) ;
		$paymentAccounts = PaymentAccountPeer::doSelect($c) ;
		$appIds = array() ;
		foreach($paymentAccounts as $paymentAccount){
			$appIds[] = $paymentAccount->getAppId() ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(AppPeer::NAME) ;
		$this->allApps = AppPeer::doSelect($c) ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;


	  	$c = new Criteria() ;
		$c->addSelectColumn(MonthlyRevenuePeer::YEAR_MONTH);
		$c->setDistinct();
		$c->addDescendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH);
		$monthlyRevenues = MonthlyRevenuePeer::doSelect($c);
		$yearMonths = array() ;
		foreach($monthlyRevenues as $monthlyRevenue){
			$workYearMonth = $monthlyRevenue->getId() ;
			$yearMonths[$workYearMonth] = substr($workYearMonth,0,4) . "/" . substr($workYearMonth,4,2) ;
		}


	  	$c = new Criteria() ;
	  	$c->add(MonthlyRevenuePeer::DEL_FLG,0) ;
		if($appId){
		  	$c->add(MonthlyRevenuePeer::APP_ID,$appId) ;
		}
		if($yearMonth){
		  	$c->add(MonthlyRevenuePeer::YEAR_MONTH,$yearMonth) ;
		}
		if($sortKind){
			$c->addAscendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH) ;
		} else {
			$c->addDescendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH) ;
		}

		$pager = new sfPropelPager('MonthlyRevenue', 100) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$revenues = $pager->getResults() ;

			$appIds = array() ;
			foreach($revenues as $revenue){
				$appIds[] = $revenue->getAppId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
			$apps = AppPeer::doSelect($c) ;
			$appMap = AdminTools::getMapForObjects($apps) ;

			$accountIds = array() ;
			foreach($revenues as $revenue){
				$accountIds[] = $revenue->getPaymentAccountId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(PaymentAccountPeer::ID,$accountIds,Criteria::IN) ;
			$accounts = PaymentAccountPeer::doSelect($c) ;
			$accountMap = AdminTools::getMapForObjects($accounts) ;

		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}



		$this->revenues = $revenues ;
		$this->appMap = $appMap ;
		$this->accountMap = $accountMap ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->appId = $appId ;
		$this->yearMonths = $yearMonths ;
		$this->yearMonth = $yearMonth ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
	}

	public function executeRevenueinputnew(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
		$this->data = $request->getParameter('data') ;
	}

	public function executeAddnewrevenue(sfWebRequest $request)
	{
		$data = $request->getParameter('data') ;

		$lines = explode("\n",$data) ;
		$firstLine = array_shift($lines) ;
		$elements = explode(",",rtrim($firstLine)) ;
		$yearMonth = $elements[0] ;
		$os = $elements[1] ;
		$overwrite = $elements[2] ;
		if(!preg_match("/^20[0-9]{4}$/",$yearMonth)){
			$request->setParameter('error_message',"Invalid YearMonth value") ;
			$this->forward('payment','revenueinputnew') ;
			return sfView::NONE ;
		}

		if(!preg_match("/^20[0-9]{4}$/",$yearMonth)){
			$request->setParameter('error_message',"Invalid YearMonth value") ;
			$this->forward('payment','revenueinputnew') ;
			return sfView::NONE ;
		}

		if(($os != 'ios') && ($os != 'android')){
			$request->setParameter('error_message',"Invalid OS value") ;
			$this->forward('payment','revenueinputnew') ;
			return sfView::NONE ;
		}

		foreach($lines as $line){
			$line = rtrim($line) ;
			if($line){
				$elements = explode(",",$line) ;
				$appId = $elements[0] ;
				$amount = $elements[1] ;
				$flag = $elements[2] ;

				if(!preg_match("/^31[0-9]{6}$/",$appId)){
					$errorMessage .= "Invalid appId:".$line ;
				} else {
				  	$c = new Criteria() ;
				  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
				  	$c->add(PaymentAccountPeer::APP_ID,$appId) ;
					$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
					if(!$paymentAccount){
						$app = AppPeer::retrieveByPk($appId) ;
						if($app){
							$appName = $app->getName() ;
						} else {
							$appName = 'Unknown' ;
						}
						$errorMessage .= sprintf("Account not found for %d(%s)\n",$appId,$appName) ;
					} else {
						if(!$overwrite){
						  	$c = new Criteria() ;
						  	$c->add(MonthlyRevenuePeer::DEL_FLG,0) ;
						  	$c->add(MonthlyRevenuePeer::PAYMENT_ACCOUNT_ID,$paymentAccount->getId()) ;
						  	$c->add(MonthlyRevenuePeer::YEAR_MONTH,$yearMonth) ;
							$paymentRevenue = MonthlyRevenuePeer::doSelectOne($c) ;
							if($paymentRevenue){
								if($os == 'ios'){
									if($paymentRevenue->getIosAmount()){
										$errorMessage .= sprintf("Revenue already exists %d\n",$appId) ;
									}
								} else if($os == 'android'){
									if($paymentRevenue->getAndroidAmount()){
										$errorMessage .= sprintf("Revenue already exists %d\n",$appId) ;
									}
								}
							}
						}
					}
				}

				if(!preg_match("/^[0-9.]+$/",$amount)){
					$errorMessage .= "Invalid amount value\n".$line ;
				}
			}
		}

		if($errorMessage){
			$request->setParameter('error_message',$errorMessage) ;
			$this->forward('payment','revenueinputnew') ;
			return sfView::NONE ;
		}




		foreach($lines as $line){
			$line = rtrim($line) ;
			if($line){
				$elements = explode(",",$line) ;
				$appId = $elements[0] ;
				$amount = $elements[1] ;
				$flag = $elements[2] ;

				if(preg_match("/^31[0-9]{6}$/",$appId)){
				  	$c = new Criteria() ;
				  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
				  	$c->add(PaymentAccountPeer::APP_ID,$appId) ;
					$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
					if($paymentAccount){
						$share = $paymentAccount->getShare() ;
					  	$c = new Criteria() ;
					  	$c->add(MonthlyRevenuePeer::DEL_FLG,0) ;
					  	$c->add(MonthlyRevenuePeer::PAYMENT_ACCOUNT_ID,$paymentAccount->getId()) ;
					  	$c->add(MonthlyRevenuePeer::YEAR_MONTH,$yearMonth) ;
						$paymentRevenue = MonthlyRevenuePeer::doSelectOne($c) ;
						if(!$paymentRevenue){
							$paymentRevenue = new MonthlyRevenue() ;
							$paymentRevenue->setPaymentAccountId($paymentAccount->getId()) ;
							$paymentRevenue->setAppId($appId) ;
							$paymentRevenue->setYearMonth($yearMonth) ;
							$paymentRevenue->setShare($paymentAccount->getShare()) ;
						}

						if($os == 'ios'){
							$paymentRevenue->setIosAmount($amount) ;
							$paymentRevenue->setIosShareAmount($amount*$share/100) ;
						} else if($os == 'android'){
							$paymentRevenue->setAndroidAmount($amount) ;
							$paymentRevenue->setAndroidShareAmount($amount*$share/100) ;
						}

						$paymentRevenue->save() ;
					}
				}
			}
		}

		$this->forward('payment','listrevenue') ;
		return sfView::NONE ;
	}




















	public function executeListbalance(sfWebRequest $request)
	{
		//$page = $request->getParameter('p') ;
		//$appId = $request->getParameter('a') ;
		$start = $request->getParameter('start') ;
		$end = $request->getParameter('end') ;

	  	$c = new Criteria() ;
	  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		$c->addDescendingOrderByColumn(PaymentAccountPeer::ID) ;
		$paymentAccounts = PaymentAccountPeer::doSelect($c) ;
		$appIds = array() ;
		foreach($paymentAccounts as $paymentAccount){
			$appIds[] = $paymentAccount->getAppId() ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(AppPeer::NAME) ;
		$this->allApps = AppPeer::doSelect($c) ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;

	  	$c = new Criteria() ;
		$c->addSelectColumn(MonthlyRevenuePeer::YEAR_MONTH);
		$c->setDistinct();
		$c->addDescendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH);
		$monthlyRevenues = MonthlyRevenuePeer::doSelect($c);
		$yearMonths = array() ;
		foreach($monthlyRevenues as $monthlyRevenue){
			$workYearMonth = $monthlyRevenue->getId() ;
			$yearMonths[$workYearMonth] = substr($workYearMonth,0,4) . "/" . substr($workYearMonth,4,2) ;
		}


	  	$c = new Criteria() ;
	  	$c->add(MonthlyRevenuePeer::DEL_FLG,0) ;
		/*
		if($appId){
		  	$c->add(MonthlyRevenuePeer::APP_ID,$appId) ;
		}
		*/

		if($start){
		  	$c->addAnd(MonthlyRevenuePeer::YEAR_MONTH,$start,Criteria::GREATER_EQUAL) ;
		}

		if($end){
		  	$c->addAnd(MonthlyRevenuePeer::YEAR_MONTH,$end,Criteria::LESS_EQUAL) ;
		}

		/*
		if($sortKind){
			$c->addAscendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH) ;
		} else {
			$c->addDescendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH) ;
		}
		*/

		$monthlyRevenues = MonthlyRevenuePeer::doSelect($c) ;

		$revenueData = array() ;
		$paymentData = array() ;
		$balanceData = array() ;
		$existYearMonth = array() ;
		$appIds = array() ;
		foreach($monthlyRevenues as $monthlyRevenue){
			$totalShare = sprintf("%.2f",$monthlyRevenue->getIosShareAmount() + $monthlyRevenue->getAndroidShareAmount()) ;
			$appId = $monthlyRevenue->getAppId() ;
			$yearMonth = $monthlyRevenue->getYearMonth() ;
			$revenueData[$appId][$yearMonth] = $totalShare ;

		  	$c = new Criteria() ;
		  	$c->add(MonthlyPaymentPeer::DEL_FLG,0) ;
		  	$c->add(MonthlyPaymentPeer::APP_ID,$appId) ;
		  	$c->add(MonthlyPaymentPeer::YEAR_MONTH,$yearMonth) ;
			$payments = MonthlyPaymentPeer::doSelect($c) ;
			$totalPayment = 0 ;
			foreach($payments as $payment){
				$totalPayment += $payment->getAmount() ;
			}
			$paymentData[$appId][$yearMonth] = $totalPayment ;

			$balanceData[$appId][$yearMonth] = $totalShare - $totalPayment ;

			$existYearMonth[$monthlyRevenue->getYearMonth()]++ ;
			$appIds[] = $monthlyRevenue->getAppId() ;
		}
	  	$c = new Criteria() ;
	  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(AppPeer::NAME) ;
		$apps = AppPeer::doSelect($c) ;
		$dataApps = $apps ;
		$appMap = AdminTools::getMapForObjects($apps) ;

		$keys = array_keys($existYearMonth) ;
		sort($keys) ;

		$this->dataApps = $dataApps ;
		$this->revenueData = $revenueData ;
		$this->paymentData = $paymentData ;
		$this->balanceData = $balanceData ;
		$this->appMap = $appMap ;
		$this->existYearMonth = $keys ;
		$this->yearMonths = $yearMonths ;
		$this->start = $start ;
		$this->end = $end ;

	}


	public function executePaymentinputnew(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
		$this->appId = $request->getParameter('a') ;
		$this->yearMonth = $request->getParameter('ym') ;
		$this->amount = $request->getParameter('amount') ;
		$this->paymentId = $request->getParameter('payment_id') ;

		$appId = $this->appId ;
		$yearMonth = $this->yearMonth ;

		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$c = new Criteria() ;
			$c->add(MonthlyRevenuePeer::DEL_FLG,0) ;
			$c->add(MonthlyRevenuePeer::YEAR_MONTH,$this->yearMonth) ;
			$c->add(MonthlyRevenuePeer::APP_ID,$appId) ;
			$monthlyRevenue = MonthlyRevenuePeer::doSelectOne($c) ;
			if($monthlyRevenue){
				$c = new Criteria() ;
				$c->add(PaymentAccountPeer::DEL_FLG,0) ;
				$c->add(PaymentAccountPeer::APP_ID,$appId) ;
				$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
				if($paymentAccount){
					
				} else {
					AdminTools::assert(false,"payment account not found appId=$appId , yearMonth=$yearMonth",__FILE__,__LINE__) ;
					print("Payment account not found") ;
					return sfView::NONE ;
				}
			} else {
				AdminTools::assert(false,"revenue not found appId=$appId , yearMonth=$yearMonth",__FILE__,__LINE__) ;
				print("Revenue not found") ;
				return sfView::NONE ;
			}
		} else {
			AdminTools::assert(false,"app not found appId=$appId",__FILE__,__LINE__) ;
			print("App not found") ;
			return sfView::NONE ;
		}

		$this->paymentAccount = $paymentAccount ;
		$this->app = $app ;

	}


	public function executeAddnewpayment(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$yearMonth = $request->getParameter('ym') ;
		$paymentId = $request->getParameter('payment_id') ;
		$amount = $request->getParameter('amount') ;

		$errorMessage = "" ;

		if(!$amount){
			$errorMessage .= "Please input amount.\n" ;
		}
		if(!$paymentId){
			$errorMessage .= "Please input the payment ID.\n" ;
		}
		if(!$appId){
			$errorMessage .= "Please input app ID.\n" ;
		}

		if(!$errorMessage){
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$c = new Criteria() ;
				$c->add(MonthlyRevenuePeer::DEL_FLG,0) ;
				$c->add(MonthlyRevenuePeer::YEAR_MONTH,$yearMonth) ;
				$c->add(MonthlyRevenuePeer::APP_ID,$appId) ;
				$monthlyRevenue = MonthlyRevenuePeer::doSelectOne($c) ;
				if($monthlyRevenue){
					$c = new Criteria() ;
					$c->add(PaymentAccountPeer::DEL_FLG,0) ;
					$c->add(PaymentAccountPeer::APP_ID,$appId) ;
					$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
					if($paymentAccount){

						$c = new Criteria() ;
						$c->add(MonthlyPaymentPeer::DEL_FLG,0) ;
						$c->add(MonthlyPaymentPeer::MEMO,$paymentId) ;
						$monthlyPayment = PaymentAccountPeer::doSelectOne($c) ;
						if($monthlyPayment){
							$errorMessage = "The same payment ID already registered." ;
						} else {
							$monthlyPayment = new MonthlyPayment() ;
							$monthlyPayment->setAppId($appId) ;
							$monthlyPayment->setPaymentAccountId($paymentAccount->getId()) ;
							$monthlyPayment->setMonthlyRevenueId($monthlyRevenue->getId()) ;
							$monthlyPayment->setYearMonth($yearMonth) ;
							$monthlyPayment->setAmount($amount) ;
							$monthlyPayment->setMemo($paymentId) ;
							$monthlyPayment->save() ;

							$this->forward('payment','listpayment') ;
						}
					} else {
						AdminTools::assert(false,"payment account not found appId=$appId , yearMonth=$yearMonth",__FILE__,__LINE__) ;
						print("Payment account not found") ;
						return sfView::NONE ;
					}
				} else {
					AdminTools::assert(false,"revenue not found appId=$appId , yearMonth=$yearMonth",__FILE__,__LINE__) ;
					print("Revenue not found") ;
					return sfView::NONE ;
				}
			} else {
				AdminTools::assert(false,"app not found appId=$appId",__FILE__,__LINE__) ;
				print("App not found") ;
				return sfView::NONE ;
			}

		}

		if($errorMessage){
			$request->setParameter('error_message',$errorMessage) ;
			$this->forward('payment','paymentinputnew') ;
		}
	}









	public function executeListpayment(sfWebRequest $request)
	{
		$page = $request->getParameter('p') ;
		$appId = $request->getParameter('a') ;
		$yearMonth = $request->getParameter('ym') ;
		$sortKind = $request->getParameter('sort') ;

		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		$c->addDescendingOrderByColumn(PaymentAccountPeer::ID) ;
		$paymentAccounts = PaymentAccountPeer::doSelect($c) ;
		$appIds = array() ;
		foreach($paymentAccounts as $paymentAccount){
			$appIds[] = $paymentAccount->getAppId() ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(AppPeer::NAME) ;
		$this->allApps = AppPeer::doSelect($c) ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;


	  	$c = new Criteria() ;
		$c->addSelectColumn(MonthlyPaymentPeer::YEAR_MONTH);
		$c->setDistinct();
		$c->addDescendingOrderByColumn(MonthlyPaymentPeer::YEAR_MONTH);
		$monthlyPayments = MonthlyPaymentPeer::doSelect($c);
		$yearMonths = array() ;
		foreach($monthlyPayments as $monthlyPayment){
			$workYearMonth = $monthlyPayment->getId() ;
			$yearMonths[$workYearMonth] = substr($workYearMonth,0,4) . "/" . substr($workYearMonth,4,2) ;
		}


	  	$c = new Criteria() ;
	  	$c->add(MonthlyPaymentPeer::DEL_FLG,0) ;
		if($appId){
		  	$c->add(MonthlyPaymentPeer::APP_ID,$appId) ;
		}
		if($yearMonth){
		  	$c->add(MonthlyPaymentPeer::YEAR_MONTH,$yearMonth) ;
		}
		if($sortKind){
			$c->addAscendingOrderByColumn(MonthlyPaymentPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(MonthlyPaymentPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('MonthlyPayment', 100) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$payments = $pager->getResults() ;

			$appIds = array() ;
			foreach($payments as $payment){
				$appIds[] = $payment->getAppId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
			$apps = AppPeer::doSelect($c) ;
			$appMap = AdminTools::getMapForObjects($apps) ;

			$accountIds = array() ;
			foreach($payments as $payment){
				$accountIds[] = $payment->getPaymentAccountId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(PaymentAccountPeer::ID,$accountIds,Criteria::IN) ;
			$accounts = PaymentAccountPeer::doSelect($c) ;
			$accountMap = AdminTools::getMapForObjects($accounts) ;

		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}



		$this->payments = $payments ;
		$this->appMap = $appMap ;
		$this->accountMap = $accountMap ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->appId = $appId ;
		$this->yearMonths = $yearMonths ;
		$this->yearMonth = $yearMonth ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
	}





	public function executeDownloadevidence(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$yearMonth = $request->getParameter('ym') ;

		$app = AppPeer::retrieveByPk($appId) ;
		if($app){
			$appName = $this->getEscapedAppName($app->getName());

			$dataDir = sfConfig::get("sf_data_dir") ; 
			$filePath = sprintf("%s/monthly_revenue/%s/%d.zip",$dataDir,$yearMonth,$appId) ;
			$fileName = sprintf("%s_%s.zip",$appName,$yearMonth) ;

			if(file_exists($filePath)){

				$mimeType = mime_content_type($filePath);

				/** @var $response sfWebResponse */
				$response = $this->getResponse();
				$response->clearHttpHeaders();
				$response->setContentType($mimeType);
				$response->setHttpHeader('Content-Disposition', 'attachment; filename="' . $fileName . '"');
				$response->setHttpHeader('Content-Description', 'File Transfer');
				$response->setHttpHeader('Content-Transfer-Encoding', 'binary');
				$response->setHttpHeader('Content-Length', filesize($filePath));
				$response->setHttpHeader('Cache-Control', 'public, must-revalidate');
				// if https then always give a Pragma header like this  to overwrite the "pragma: no-cache" header which
				// will hint IE8 from caching the file during download and leads to a download error!!!
				$response->setHttpHeader('Pragma', 'public');
				//$response->setContent(file_get_contents($filePath)); # will produce a memory limit exhausted error
				$response->sendHttpHeaders();

				ob_end_flush();
				return $this->renderText(readfile($filePath));

			} else {
				AdminTools::assert(false,"file not found appId=$appId yearMonth=$yearMonth filePath=$filePath",__FILE__,__LINE__) ;
				print("File not found") ;
				return sfView::NONE ;
			}
		} else {
			AdminTools::assert(false,"app not found appId=$appId yearMonth=$yearMonth",__FILE__,__LINE__) ;
			print("App not found") ;
			return sfView::NONE ;
		}

		return sfView::NONE ;

	}





	public function executeListmail(sfWebRequest $request)
	{
		$page = $request->getParameter('p') ;
		$appId = $request->getParameter('a') ;
		//$yearMonth = $request->getParameter('ym') ;
		$sortKind = $request->getParameter('sort') ;

		if(!$page){
			$page = 1 ;
		}

	  	$c = new Criteria() ;
	  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		$c->addDescendingOrderByColumn(PaymentAccountPeer::ID) ;
		$paymentAccounts = PaymentAccountPeer::doSelect($c) ;
		$appIds = array() ;
		foreach($paymentAccounts as $paymentAccount){
			$appIds[] = $paymentAccount->getAppId() ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(AppPeer::NAME) ;
		$this->allApps = AppPeer::doSelect($c) ;

		$sortKinds = array(
			'0' => 'Newest',
			'1' => 'Oldest',
		) ;


		/*
	  	$c = new Criteria() ;
		$c->addSelectColumn(MonthlyPaymentPeer::YEAR_MONTH);
		$c->setDistinct();
		$c->addDescendingOrderByColumn(MonthlyPaymentPeer::YEAR_MONTH);
		$monthlyPayments = MonthlyPaymentPeer::doSelect($c);
		$yearMonths = array() ;
		foreach($monthlyPayments as $monthlyPayment){
			$workYearMonth = $monthlyPayment->getId() ;
			$yearMonths[$workYearMonth] = substr($workYearMonth,0,4) . "/" . substr($workYearMonth,4,2) ;
		}
		*/


	  	$c = new Criteria() ;
	  	$c->add(PaymentMailPeer::DEL_FLG,0) ;
		if($appId){
		  	$c->add(PaymentMailPeer::APP_ID,$appId) ;
		}
		/*
		if($yearMonth){
		  	$c->add(PaymentMailPeer::YEAR_MONTH,$yearMonth) ;
		}
		*/
		if($sortKind){
			$c->addAscendingOrderByColumn(PaymentMailPeer::CREATED_AT) ;
		} else {
			$c->addDescendingOrderByColumn(PaymentMailPeer::CREATED_AT) ;
		}

		$pager = new sfPropelPager('PaymentMail', 100) ;
		$pager->setCriteria($c) ;
		$pager->setPage($page) ;
		$pager->init() ;

		$lastPage = $pager->getLastPage() ;

		if($page <= $lastPage){
			$paymentMails = $pager->getResults() ;

			$appIds = array() ;
			foreach($paymentMails as $paymentMail){
				$appIds[] = $paymentMail->getAppId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
			$apps = AppPeer::doSelect($c) ;
			$appMap = AdminTools::getMapForObjects($apps) ;

			/*
			$accountIds = array() ;
			foreach($paymentMails as $paymentMail){
				$accountIds[] = $paymentMail->getPaymentAccountId() ;
			}
		  	$c = new Criteria() ;
		  	$c->add(PaymentAccountPeer::ID,$accountIds,Criteria::IN) ;
			$accounts = PaymentAccountPeer::doSelect($c) ;
			$accountMap = AdminTools::getMapForObjects($accounts) ;
			*/
		}

		$startPage = $page - 4 ;
		if($startPage <= 0){
			$startPage = 1 ;
		}
		$endPage = $startPage + 8 ;
		if($endPage > $lastPage){
			$endPage = $lastPage ;
		}



		$this->paymentMails = $paymentMails ;
		$this->appMap = $appMap ;
		//$this->accountMap = $accountMap ;
		$this->page = $page ;
		$this->lastPage = $lastPage ;
		$this->startPage = $startPage ;
		$this->endPage = $endPage ;
		$this->appId = $appId ;
		//$this->yearMonths = $yearMonths ;
		//$this->yearMonth = $yearMonth ;
		$this->sortKind = $sortKind ;
		$this->sortKinds = $sortKinds ;
	}


	public function executeMailinputnew(sfWebRequest $request)
	{
		$this->errorMessage = $request->getParameter('error_message') ;
		$this->appId = $request->getParameter('a') ;
		$this->startYearMonth = $request->getParameter('sym') ;
		$this->endYearMonth = $request->getParameter('eym') ;
		/*
		$this->amount = $request->getParameter('amount') ;
		$this->paymentId = $request->getParameter('payment_id') ;
		*/

	  	$c = new Criteria() ;
		$c->addSelectColumn(MonthlyRevenuePeer::YEAR_MONTH);
		$c->setDistinct();
		$c->addDescendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH);
		$monthlyRevenues = MonthlyRevenuePeer::doSelect($c);
		$yearMonths = array() ;
		foreach($monthlyRevenues as $monthlyRevenue){
			$workYearMonth = $monthlyRevenue->getId() ;
			$yearMonths[$workYearMonth] = substr($workYearMonth,0,4) . "/" . substr($workYearMonth,4,2) ;
		}


	  	$c = new Criteria() ;
	  	$c->add(PaymentAccountPeer::DEL_FLG,0) ;
		$c->addDescendingOrderByColumn(PaymentAccountPeer::ID) ;
		$paymentAccounts = PaymentAccountPeer::doSelect($c) ;
		$appIds = array() ;
		foreach($paymentAccounts as $paymentAccount){
			$appIds[] = $paymentAccount->getAppId() ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AppPeer::ID,$appIds,Criteria::IN) ;
		$c->addAscendingOrderByColumn(AppPeer::NAME) ;
		$this->allApps = AppPeer::doSelect($c) ;


		$appId = $this->appId ;
		$startYearMonth = $this->startYearMonth ;
		$endYearMonth = $this->endYearMonth ;

		if($appId){
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				/*
				$c = new Criteria() ;
				$c->add(MonthlyRevenuePeer::DEL_FLG,0) ;
				$c->add(MonthlyRevenuePeer::YEAR_MONTH,$this->yearMonth) ;
				$c->add(MonthlyRevenuePeer::APP_ID,$appId) ;
				$monthlyRevenue = MonthlyRevenuePeer::doSelectOne($c) ;
				if($monthlyRevenue){
					$c = new Criteria() ;
					$c->add(PaymentAccountPeer::DEL_FLG,0) ;
					$c->add(PaymentAccountPeer::APP_ID,$appId) ;
					$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
					if($paymentAccount){
						
					} else {
						AdminTools::assert(false,"payment account not found appId=$appId , yearMonth=$yearMonth",__FILE__,__LINE__) ;
						print("Payment account not found") ;
						return sfView::NONE ;
					}
				} else {
					AdminTools::assert(false,"revenue not found appId=$appId , yearMonth=$yearMonth",__FILE__,__LINE__) ;
					print("Revenue not found") ;
					return sfView::NONE ;
				}
				*/
			} else {
				AdminTools::assert(false,"app not found appId=$appId",__FILE__,__LINE__) ;
				print("App not found") ;
				return sfView::NONE ;
			}
		}

		//$this->paymentAccount = $paymentAccount ;
		$this->app = $app ;
		$this->yearMonths = $yearMonths ;


	}




	public function executeConfirmmail(sfWebRequest $request)
	{
		$this->appId = $request->getParameter('a') ;
		$this->startYearMonth = $request->getParameter('sym') ;
		$this->endYearMonth = $request->getParameter('eym') ;

		$appId = $this->appId ;
		$startYearMonth = $this->startYearMonth ;
		$endYearMonth = $this->endYearMonth ;

		if($endYearMonth < $startYearMonth){
			$workYearMonth = $startYearMonth ;
			$startYearMonth = $endYearMonth ;
			$endYearMonth = $workYearMonth ;

			$this->startYearMonth = $startYearMonth ;
			$this->endYearMonth = $endYearMonth ;
		}

		if($appId){
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				$c = new Criteria() ;
				$c->add(PaymentAccountPeer::DEL_FLG,0) ;
				$c->add(PaymentAccountPeer::APP_ID,$appId) ;
				$paymentAccount = PaymentAccountPeer::doSelectOne($c) ;
				if($paymentAccount){
					if($startYearMonth){
						if($endYearMonth){
							if($startYearMonth == $endYearMonth){
								$subjectPart = sprintf("%s",$startYearMonth) ;
							} else {
								$subjectPart = sprintf("%s to %s",$startYearMonth,$endYearMonth) ;
							}
							$subject = sprintf("Revenue Share Payment Report %s - %s",$subjectPart,$app->getName()) ;



$template = <<< EOT
Hi __APP_NAME__,

The revenue share payment __PERIOD__ will be as follows.
Excuse us for the delay in reporting the numbers. 
We had a custom of transferring the revenue share when the total transfer amount exceeds $30.

Total Sales __TOTAL_SALES__ =  iPhone __IOS_SALES__ + Android __ANDROID_SALES__

__SHARE__% of total = __SHARE_AMOUNT__

Attached are the payment data from Apple and Google.
We will make the transfer via Paypal.

Looking forward to seeing your next update to the Exclusive section!

Thanks, 
Veam Inc
www.veam.co
EOT;

							if($startYearMonth == $endYearMonth){
								$period = sprintf("%s",$startYearMonth) ;
							} else {
								$period = sprintf("from %s to %s",$startYearMonth,$endYearMonth) ;
							}


							$c = new Criteria() ;
							$c->add(MonthlyRevenuePeer::APP_ID,$appId);
							$c->add(MonthlyRevenuePeer::YEAR_MONTH,$startYearMonth,Criteria::GREATER_EQUAL);
							$c->addAnd(MonthlyRevenuePeer::YEAR_MONTH,$endYearMonth,Criteria::LESS_EQUAL);
							$c->addAscendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH);
							$monthlyRevenues = MonthlyRevenuePeer::doSelect($c);
							$iosSales = '' ;
							$iosAmount = 0 ;
							$androidSales = '' ;
							$androidAmount = 0 ;
							$shareRatio = 0 ;
							foreach($monthlyRevenues as $monthlyRevenue){
								if($shareRatio == 0){
									$shareRatio = $monthlyRevenue->getShare() ;
								}
								if($iosSales){
									$iosSales .= '+' ;
								}
								$iosSales .= '$'.sprintf("%.2f",$monthlyRevenue->getIosAmount()) ;
								$iosAmount += sprintf("%.2f",$monthlyRevenue->getIosAmount()) ;

								if($androidSales){
									$androidSales .= '+' ;
								}
								$androidSales .= '$'.sprintf("%.2f",$monthlyRevenue->getAndroidAmount()) ;
								$androidAmount += sprintf("%.2f",$monthlyRevenue->getAndroidAmount()) ;
							}
							$totalAmount = $iosAmount + $androidAmount ;

							$shareAmount = $totalAmount * $shareRatio / 100 ;


							$body = str_replace("__APP_NAME__",$app->getName(),$template) ;
							$body = str_replace("__PERIOD__",$period,$body) ;
							$body = str_replace("__IOS_SALES__",$iosSales,$body) ;
							$body = str_replace("__ANDROID_SALES__",$androidSales,$body) ;
							$body = str_replace("__TOTAL_SALES__",sprintf("$%.2f",$totalAmount),$body) ;
							$body = str_replace("__SHARE__",sprintf("%d",$shareRatio),$body) ;
							$body = str_replace("__SHARE_AMOUNT__",sprintf("$%.2f",$shareAmount),$body) ;


						} else {
							$request->setParameter('error_message','Please select end month') ;
							$this->forward('payment','mailinputnew') ;
						}

					} else {
						$request->setParameter('error_message','Please select start month') ;
						$this->forward('payment','mailinputnew') ;
					}

				} else {
					AdminTools::assert(false,"payment account not found appId=$appId",__FILE__,__LINE__) ;
					print("Payment account not found") ;
					return sfView::NONE ;
				}
			} else {
				AdminTools::assert(false,"app not found appId=$appId",__FILE__,__LINE__) ;
				print("App not found") ;
				return sfView::NONE ;
			}
		} else {
			$request->setParameter('error_message','Please select app') ;
			$this->forward('payment','mailinputnew') ;
		}

		$this->app = $app ;
		$this->paymentAccount = $paymentAccount ;
		$this->subject = $subject ;
		$this->body = $body ;
	}


	public function executeSendmail(sfWebRequest $request)
	{
		$appId = $request->getParameter('a') ;
		$startYearMonth = $request->getParameter('sym') ;
		$endYearMonth = $request->getParameter('eym') ;
		$receiver = $request->getParameter('r') ;
		$body = $request->getParameter('body') ;
		$subject = $request->getParameter('subject') ;


		$encodedSubject = mb_convert_encoding($subject, "SJIS", "UTF-8");
		$encodedBody = mb_convert_encoding($body, "SJIS", "UTF-8");

		mb_language('japanese');
		$encodedSubject = mb_convert_encoding($encodedSubject,"ISO-2022-JP","SJIS");
		$encodedSubject = mb_convert_kana($encodedSubject, 'KV', "SJIS");
		$encodedBody = mb_convert_encoding($encodedBody,"ISO-2022-JP","SJIS");
		$encodedBody = mb_convert_kana($encodedBody, 'KV', "SJIS");
		//$from = "no-reply@veam.co" ;
		$from = "revshare@veam.co" ;


		$numberOfAttachedFiles = 0 ;
		$app = AppPeer::retrieveByPk($appId) ;
		if($app){

			$header = '';
			$header .= "Content-Type: multipart/mixed;boundary=\"__BOUNDARY__\"\n";
			$header .= "Return-Path: " . $from . " \n";
			$header .= "From: " . $from ." \n";
			$header .= "Sender: " . $from ." \n";
			$header .= "Reply-To: " . $from . " \n";
			$header .= "Bcc: tech@veam.co";

			// テキストメッセージを記述
			$contentBody = "--__BOUNDARY__\n";
			$contentBody .= "Content-Type: text/plain; charset=\"ISO-2022-JP\"\n\n";
			$contentBody .= $encodedBody . "\n";
			$contentBody .= "--__BOUNDARY__\n";

			$c = new Criteria() ;
			$c->add(MonthlyRevenuePeer::APP_ID,$appId);
			$c->add(MonthlyRevenuePeer::YEAR_MONTH,$startYearMonth,Criteria::GREATER_EQUAL);
			$c->addAnd(MonthlyRevenuePeer::YEAR_MONTH,$endYearMonth,Criteria::LESS_EQUAL);
			$c->addAscendingOrderByColumn(MonthlyRevenuePeer::YEAR_MONTH);
			$monthlyRevenues = MonthlyRevenuePeer::doSelect($c);

			$appName = $this->getEscapedAppName($app->getName());

			$dataDir = sfConfig::get("sf_data_dir") ; 
			foreach($monthlyRevenues as $monthlyRevenue){
				$yearMonth = $monthlyRevenue->getYearMonth() ;
				$filePath = sprintf("%s/monthly_revenue/%s/%d.zip",$dataDir,$yearMonth,$appId) ;
				$fileName = sprintf("%s_%s.zip",$appName,$yearMonth) ;

				if(file_exists($filePath)){
					$numberOfAttachedFiles++ ;
					// ファイルを添付
					$contentBody .= "Content-Type: application/octet-stream; name=\"{$fileName}\"\n";
					$contentBody .= "Content-Disposition: attachment; filename=\"{$fileName}\"\n";
					$contentBody .= "Content-Transfer-Encoding: base64\n";
					$contentBody .= "\n";
					$contentBody .= chunk_split(base64_encode(file_get_contents($filePath)));
					$contentBody .= "--__BOUNDARY__\n";
				}
			}
			$contentBody .= "--" ;

//print("$contentBody") ;



			//mb_send_mail($receiver, $encodedSubject, $encodedBody, $from);
			mb_send_mail($receiver, $encodedSubject, $contentBody, $header);

			$paymentMail = new PaymentMail() ;
			$paymentMail->setAppId($appId) ;
			$paymentMail->setEmail($receiver) ;
			$paymentMail->setSubject($subject) ;
			$paymentMail->setMessage($body) ;
			$paymentMail->setStartYearMonth($startYearMonth) ;
			$paymentMail->setEndYearMonth($endYearMonth) ;
			$paymentMail->setNumberOfAttachedFiles($numberOfAttachedFiles) ;
			$paymentMail->save() ;

			$this->forward('payment','listmail') ;

		} else {
			AdminTools::assert(false,"app not found appId=$appId yearMonth=$yearMonth",__FILE__,__LINE__) ;
			print("App not found") ;
			return sfView::NONE ;
		}

	}


	public function getEscapedAppName($appName)
	{
		$escapes = array(" ", "'");
		return str_replace($escapes, "_", $appName);
	}

}
