<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Payments</h5></div>

	<p style="clear:both" />

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

	<div class="element-select">
		App :
		<select onChange="selectJump(this)">
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&ym=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),0,$yearMonth,$sortKind), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
			<?php foreach($allApps as $workApp): ?>
			<?php if($workApp->getStatus() == 0):?>
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&ym=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId(),$yearMonth,$sortKind), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
			<?php endif ?>
			<?php endforeach ?>
		</select>
		Year/Month :
		<select onChange="selectJump(this)">
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&ym=0&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$sortKind), false) ?>" <?php if(!$yearMonth) echo 'selected' ; ?>>All</option>
			<?php foreach($yearMonths as $workYearMonth => $yearMonthName): ?>
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&ym=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$workYearMonth,$sortKind), false) ?>" <?php if($yearMonth == $workYearMonth) echo 'selected' ; ?>><?php echo AdminTools::unescapeName($yearMonthName) ?></option>
			<?php endforeach ?>
		</select>

		<span class="pull-right">
		View :
		<select onChange="selectJump(this)">
			<?php foreach($sortKinds as $workSortKind => $sortName): ?>
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&ym=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$yearMonth,$workSortKind), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
			<?php endforeach ?>
		</select>
		</span>
		<p style="clear:both" />
	</div>

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->


	<?php if(count($payments) > 0): ?>

	<table class="table table-bordered">
		<thead><tr><th>Year Month</th><th>App Name</th><th>Amount</th><th>Payment ID</th><th>Paid At</th></th></tr></thead>
		<tbody>
	<?php 
		foreach($payments as $payment):
			$account = $accountMap[$payment->getPaymentAccountId()] ;

			if($account){
				$userName = $account->getName() ;
			} else {
				$userName = 'Unknown' ;
			}

			$app = $appMap[$account->getAppId()] ;
			if($app){
				$appName = $app->getName() ;
			} else {
				$appName = "Unknown" ;
			}

			$totalAmount = $payment->getAmount() ;
	?>
			<tr>
				<td><?php echo $payment->getYearMonth() ?></td>
				<td><?php echo $appName ?></td>
				<td><?php echo sprintf("%.2f",$totalAmount) ?></td>
				<td><?php echo $payment->getMemo() ?></td>
				<td><?php echo $payment->getCreatedAt() ?></td>
			</tr>

	<!-- end divider -->
	<?php endforeach ?>
	</tbody>
	</table>

	<!-- Start pagination-->
	<div id="pagination">
		<span class="all">Page <?php echo $page ?> of <?php echo $lastPage ?></span>
		<?php if($page != 1): ?>
		<?php echo AdminTools::link_to("<<", "payment/listpayment", array("class"=>"inactive", "query_string"=>sprintf("p=1"))) ; ?>
		<?php echo AdminTools::link_to("<", "payment/listpayment", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page-1))) ; ?>
		<?php endif ?>
		<?php 
			for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
				if($workPage == $page){
					echo sprintf('<span class="current">%d</span>',$workPage) ;
				} else {
					echo AdminTools::link_to($workPage, "payment/listpayment", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$workPage))) ;
				}
			}
		?>
		<?php if($page != $lastPage): ?>
		<?php echo AdminTools::link_to(">", "payment/listpayment", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page+1) )) ; ?>
		<?php echo AdminTools::link_to(">>", "payment/listpayment", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$lastPage) )) ; ?>
		<?php endif ?>
	</div>
	<!-- End pagination-->

	<?php else: ?>
	There are no results.
	<?php endif ?>

</div>
<!-- end: Right Content -->
