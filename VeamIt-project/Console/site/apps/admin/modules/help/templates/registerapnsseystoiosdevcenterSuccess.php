<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Keychain Access application in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select [Keychain Access]->[Certificate Assistant]->[Request a Certificate From a Certificate Authority]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter your email address for the [User Email Address]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">APS DEV <?php echo $app->getId() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for the [Common Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Saved to disk]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Save the certificate request using the name "<strong id="copy_text_<?php echo $lineNo?>">CSR_<?php echo $app->getId() ?>_APS_DEV.certSigningRequest</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Done] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://developer.apple.com/account/ios/certificate/" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates]-[All]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Apple Push Notification service SSL (Sandbox)] in the [Development] section
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the name "<strong>XXXXXXXXXX_co.veam.veam<?php echo $app->getId() ?></strong>" then click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click the [Choose File] button to locate the "<strong>CSR_<?php echo $app->getId() ?>_APS_DEV.certSigningRequest</strong>" that you have saved earlier</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change the downloaded file name "aps_developer_identity.cer" to "<strong id="copy_text_<?php echo $lineNo?>">aps_developer_<?php echo $app->getId() ?>.cer</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong>aps_developer_<?php echo $app->getId() ?>.cer</strong>" to install it in the Keychain Access application</td></tr>

				<tr><td>-</td><td>The same process above applies when generating the production certificate</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Keychain Access application in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select [Keychain Access]->[Certificate Assistant]->[Request a Certificate From a Certificate Authority]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter your email address for the [User Email Address]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">APS PRO <?php echo $app->getId() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for the [Common Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Saved to disk]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Save the certificate request using the name "<strong id="copy_text_<?php echo $lineNo?>">CSR_<?php echo $app->getId() ?>_APS_PRO.certSigningRequest</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Done] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://developer.apple.com/account/ios/certificate/" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates]-[All]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Apple Push Notification service SSL (Sandbox &amp; Production)] in the [Production] section
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the name "<strong>XXXXXXXXXX_co.veam.veam<?php echo $app->getId() ?></strong>" then click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click the [Choose File] button to locate the "<strong>CSR_<?php echo $app->getId() ?>_APS_PRO.certSigningRequest</strong>" that you have saved earlier</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change the downloaded file name "aps.cer" to "<strong id="copy_text_<?php echo $lineNo?>">aps_production_<?php echo $app->getId() ?>.cer</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong>aps_production_<?php echo $app->getId() ?>.cer</strong>" to install it in the Keychain Access application</td></tr>

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

