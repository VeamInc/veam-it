<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">All Payment Accounts</h5></div>

	<span class="pull-right">
		<?php echo AdminTools::link_to('<i class="icon-plus-sign"></i>Add New', "payment/accountinputnew", array("class"=>"btn btn-mini")) ; ?>
	</span>
	<p style="clear:both" />

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

	<?php if(count($accounts) > 0): ?>

	<table class="table table-bordered">
		<thead><tr><th>App Name</th><th>Name</th><th>Email</th><th>Share</th><th>Registered At</th><th>Action</th></tr></thead>
		<tbody>
	<?php 
		foreach($accounts as $account):
			$userName = $account->getName() ;
			$app = $appMap[$account->getAppId()] ;
			if($app){
				$appName = $app->getName() ;
			} else {
				$appName = "Unknown" ;
			}
	?>
			<tr>
				<td><?php echo $appName ?></td>
				<td><?php echo $account->getName() ?></td>
				<td><?php echo $account->getEmail() ?></td>
				<td><?php echo $account->getShare() ?></td>
				<td><?php echo $account->getCreatedAt() ?></td>
				<td><?php echo AdminTools::link_to_admin_preview('Edit', "payment/accountinputedit", array("class"=>"inactive", "query_string"=>sprintf("c=%d",$account->getId()))) ; ?></td>
			</tr>

	<?php endforeach ?>

	</tbody>
	</table>


	<!-- Start pagination-->
	<div id="pagination">
		<span class="all">Page <?php echo $page ?> of <?php echo $lastPage ?></span>
		<?php if($page != 1): ?>
		<?php echo AdminTools::link_to("<<", "account/listall", array("class"=>"inactive", "query_string"=>sprintf("p=1"))) ; ?>
		<?php echo AdminTools::link_to("<", "account/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page-1))) ; ?>
		<?php endif ?>
		<?php 
			for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
				if($workPage == $page){
					echo sprintf('<span class="current">%d</span>',$workPage) ;
				} else {
					echo AdminTools::link_to($workPage, "account/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$workPage))) ;
				}
			}
		?>
		<?php if($page != $lastPage): ?>
		<?php echo AdminTools::link_to(">", "account/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page+1) )) ; ?>
		<?php echo AdminTools::link_to(">>", "account/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$lastPage) )) ; ?>
		<?php endif ?>
	</div>
	<!-- End pagination-->

	<?php else: ?>
	There are no results.
	<?php endif ?>

</div>
<!-- end: Right Content -->
