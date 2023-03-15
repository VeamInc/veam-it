<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://developer.apple.com/account/ios/profile/" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Provisioning Profiles]-[All]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [iOS App Development] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo sprintf("co.veam.veam%s",$app->getId()) ?></strong>" for the [App ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [___(iOS App Development)] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the devices you wish to include in this provisioning profile and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>"><?php echo $app->getId() ?> Dev Profile</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Profile Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong><?php echo $app->getId() ?>_Dev_Profile.mobileprovision</strong>" to install it in the XCode application</td></tr>

				<tr><td>-</td><td>The same process above applies when generating the distribution profile</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://developer.apple.com/account/ios/profile/" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Provisioning Profiles]-[All]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [App Store] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo sprintf("co.veam.veam%s",$app->getId()) ?></strong>" for the [App ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [___(iOS Distribution)] and click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>"><?php echo $app->getId() ?> Distribution Profile</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Profile Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong><?php echo $app->getId() ?>_Distribution_Profile.mobileprovision</strong>" to install it in the XCode application</td></tr>

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

