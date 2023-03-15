<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Monthly Revenue</h5></div>

	<span class="pull-right">
		<?php echo AdminTools::link_to('<i class="icon-plus-sign"></i>Add New', "payment/revenueinputnew", array("class"=>"btn btn-mini")) ; ?>
	</span>
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


	<?php if(count($revenues) > 0): ?>

	<table class="table table-bordered">
		<thead><tr><th>Year Month</th><th>App Name</th><th>iOS</th><th>Android</th><th>Total</th><th>Share</th><th>iOS Share</th><th>Android Share</th><th>Total Share</th></tr></thead>
		<tbody>
	<?php 
		foreach($revenues as $revenue):
			$account = $accountMap[$revenue->getPaymentAccountId()] ;

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

			$totalAmount = $revenue->getIosAmount() + $revenue->getAndroidAmount() ;
			$totalShare = $revenue->getIosShareAmount() + $revenue->getAndroidShareAmount() ;
	?>
			<tr>
				<td><?php echo $revenue->getYearMonth() ?></td>
				<td><?php echo $appName ?></td>
				<td><?php echo sprintf("%.2f",$revenue->getIosAmount()) ?></td>
				<td><?php echo sprintf("%.2f",$revenue->getAndroidAmount()) ?></td>
				<td><?php echo sprintf("%.2f",$totalAmount) ?></td>
				<td><?php echo $revenue->getShare() ?></td>
				<td><?php echo sprintf("%.2f",$revenue->getIosShareAmount()) ?></td>
				<td><?php echo sprintf("%.2f",$revenue->getAndroidShareAmount()) ?></td>
				<td><?php echo sprintf("%.2f",$totalShare) ?></td>
			</tr>

<!--
	<div class="media">
		<div class="media-body">
			<div class="media-content">
				<h6><?php echo $appName ?></h6>
				<div class="bottom-article-no-margin">
					<ul class="meta-post">
						<li><i class="icon-calendar"></i>Registered at <?php echo $revenue->getCreatedAt() ?></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
-->
	<!-- end divider -->
	<?php endforeach ?>
	</tbody>
	</table>

	<!-- Start pagination-->
	<div id="pagination">
		<span class="all">Page <?php echo $page ?> of <?php echo $lastPage ?></span>
		<?php if($page != 1): ?>
		<?php echo AdminTools::link_to("<<", "payment/listrevenue", array("class"=>"inactive", "query_string"=>sprintf("p=1"))) ; ?>
		<?php echo AdminTools::link_to("<", "payment/listrevenue", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page-1))) ; ?>
		<?php endif ?>
		<?php 
			for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
				if($workPage == $page){
					echo sprintf('<span class="current">%d</span>',$workPage) ;
				} else {
					echo AdminTools::link_to($workPage, "payment/listrevenue", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$workPage))) ;
				}
			}
		?>
		<?php if($page != $lastPage): ?>
		<?php echo AdminTools::link_to(">", "payment/listrevenue", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page+1) )) ; ?>
		<?php echo AdminTools::link_to(">>", "payment/listrevenue", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$lastPage) )) ; ?>
		<?php endif ?>
	</div>
	<!-- End pagination-->

	<?php else: ?>
	There are no results.
	<?php endif ?>

</div>
<!-- end: Right Content -->
