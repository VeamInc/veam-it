<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Terminal application in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change directory to the Veam directory</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Execute command "<strong>perl GenerateVeam.pl <?php echo $app->getId() ?></strong>"</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
