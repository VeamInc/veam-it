<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Mails</h5></div>
	<span class="pull-right">
		<?php echo AdminTools::link_to('<i class="icon-plus-sign"></i>Add New', "payment/mailinputnew", array("class"=>"btn btn-mini")) ; ?>
	</span>
	<p style="clear:both" />

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

	<div class="element-select">
		App :
		<select onChange="selectJump(this)">
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),0,$sortKind), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
			<?php foreach($allApps as $workApp): ?>
			<?php if($workApp->getStatus() == 0):?>
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId(),$sortKind), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
			<?php endif ?>
			<?php endforeach ?>
		</select>

		<span class="pull-right">
		View :
		<select onChange="selectJump(this)">
			<?php foreach($sortKinds as $workSortKind => $sortName): ?>
			<option value="<?php echo url_for(sprintf('%s/%s?a=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$workSortKind), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
			<?php endforeach ?>
		</select>
		</span>
		<p style="clear:both" />
	</div>

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->


	<?php if(count($paymentMails) > 0): ?>

	<table class="table table-bordered">
		<thead><tr><th>No.</th><th></th><th></th></tr></thead>
		<tbody>
	<?php 
		foreach($paymentMails as $paymentMail):
			$no++ ;
			/*
			$account = $accountMap[$paymentMail->getPaymentAccountId()] ;

			if($account){
				$userName = $account->getName() ;
			} else {
				$userName = 'Unknown' ;
			}
			*/

			$app = $appMap[$paymentMail->getAppId()] ;
			if($app){
				$appName = $app->getName() ;
			} else {
				$appName = "Unknown" ;
			}

			//$totalAmount = $payment->getAmount() ;
	?>
			<tr><td rowspan="7"><?php echo $no ?></td><td style="background:#EEFFFF">App Name</td><td style="background:#EEFFFF"><?php echo $appName ?></td></tr>
			<tr><td>Start</td><td><?php echo $paymentMail->getStartYearMonth() ?></td></tr>
			<tr><td>End</td><td><?php echo $paymentMail->getEndYearMonth() ?></td></tr>
			<tr><td>Receiver</td><td><?php echo $paymentMail->getEmail() ?></td></tr>
			<tr><td>Subject</td><td><?php echo $paymentMail->getSubject() ?></td></tr>
			<tr><td>Message</td><td>
				<div class="accordion stripped" id="accordion-comment<?php echo $no ?>">
					<div class="accordion-group">
						<div class="accordion-heading">
							<a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion-comment<?php echo $no ?>" href="#collapse-comment<?php echo $no ?>">+ Show Message </a>
						</div>
						<div id="collapse-comment<?php echo $no ?>" class="accordion-body collapse" style="height: 0px;">
							<div class="accordion-inner">
								<ul class="folio-detail">
									<li class=""><?php echo str_replace("\n","<br/>",$paymentMail->getMessage()) ?></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</td></tr>
			<tr><td>Sent At</td><td><?php echo $paymentMail->getCreatedAt() ?></td></tr>

	<!-- end divider -->
	<?php endforeach ?>
	</tbody>
	</table>

	<!-- Start pagination-->
	<div id="pagination">
		<span class="all">Page <?php echo $page ?> of <?php echo $lastPage ?></span>
		<?php if($page != 1): ?>
		<?php echo AdminTools::link_to("<<", "payment/listmail", array("class"=>"inactive", "query_string"=>sprintf("p=1"))) ; ?>
		<?php echo AdminTools::link_to("<", "payment/listmail", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page-1))) ; ?>
		<?php endif ?>
		<?php 
			for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
				if($workPage == $page){
					echo sprintf('<span class="current">%d</span>',$workPage) ;
				} else {
					echo AdminTools::link_to($workPage, "payment/listmail", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$workPage))) ;
				}
			}
		?>
		<?php if($page != $lastPage): ?>
		<?php echo AdminTools::link_to(">", "payment/listmail", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page+1) )) ; ?>
		<?php echo AdminTools::link_to(">>", "payment/listmail", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$lastPage) )) ; ?>
		<?php endif ?>
	</div>
	<!-- End pagination-->

	<?php else: ?>
	There are no results.
	<?php endif ?>

</div>
<!-- end: Right Content -->
