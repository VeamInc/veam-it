<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://itunesconnect.apple.com/" target="_blank">iTunes Connect</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button and select [New App]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [iOS] in the [Platform] section</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>"><?php echo $app->getStoreAppName() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>English</strong>" for [Primary Language]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $app->getName() ?> - co.veam.veam<?php echo $app->getId() ?></strong>" for [Bundle ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>"><?php echo $app->getId() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [SKU]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Create] button</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
<script src="/js/tools/ZeroClipboard.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){

	for(index = 1 ; index < <?php echo $lineNo?> ; index++){
		var buttonId = 'copy-button-' + index ;
		var buttonElement = document.getElementById(buttonId);
		if (buttonElement != null){
			var clip = new ZeroClipboard($("#"+buttonId));
		    clip.on("ready", function() {});
		    clip.on("beforecopy", function() {});
		    clip.on("copy", function() {});
		    clip.on("aftercopy", function() {alert('copy');});
		    clip.on("destroy", function() {});
		    clip.on("error", function() {});
		}
	}
});
</script>

