<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Keychain Access application in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates] in the [Category]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Right-click on the "<strong>Apple Development iOS Push Services: co.veam.veam<?php echo $app->getId() ?></strong>" and select [Export]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter the file name "<strong id="copy_text_<?php echo $lineNo?>">APS_DEV_<?php echo $app->getId() ?>.p12</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> and click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Leave the password empty and click on the [OK] button</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter the mac login password and click on the [Allow] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the file "<strong>APS_DEV_<?php echo $app->getId() ?>.p12</strong>" to the <?php echo AdminTools::link_to("upload page", "app/enterapskey", array("target"=>"_blank","query_string"=>sprintf("a=%d&t=d",$app->getId()))) ; ?></td></tr>

				<tr><td>-</td><td>The same process above applies when uploading the production certificate</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates] in the [Category]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Right-click on the "<strong>Apple Push Services: co.veam.veam<?php echo $app->getId() ?></strong>" and select [Export]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter the file name "<strong id="copy_text_<?php echo $lineNo?>">APS_PRO_<?php echo $app->getId() ?>.p12</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> and click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Leave the password empty and click on the [OK] button</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter the mac login password and click on the [Allow] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the file "<strong>APS_PRO_<?php echo $app->getId() ?>.p12</strong>" to the <?php echo AdminTools::link_to("upload page", "app/enterapskey", array("target"=>"_blank","query_string"=>sprintf("a=%d&t=p",$app->getId()))) ; ?></td></tr>

				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
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

