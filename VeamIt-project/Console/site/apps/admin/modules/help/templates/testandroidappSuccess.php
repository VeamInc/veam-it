<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<?php if($app->getApkUrl()): ?>
					<tr><td><?php echo $lineNo++ ?></td><td>Download and install app from <?php echo $app->getApkUrl() ?> to android device<br /><img src="/admin.php/help/qrapk?a=<?php echo $app->getId() ?>"></td></tr>
					<tr><td><?php echo $lineNo++ ?></td><td>Test the sections(Premium,YouTube,Forum,Links,etc.)</td></tr>
				<?php else: ?>
					<tr><td><?php echo $lineNo++ ?></td><td>Please upload apk before testing</td></tr>
				<?php endif ?>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
