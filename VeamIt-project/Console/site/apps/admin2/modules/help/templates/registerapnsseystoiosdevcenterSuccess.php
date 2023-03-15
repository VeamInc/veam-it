<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Keychain Access application in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select [Keychain Access]->[Certificate Assistant]->[Request a Certificate From a Certificate Authority]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter your email address for the [User Email Address]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>APS DEV <?php echo $app->getId() ?></strong>" for the [Common Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Saved to disk]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Save the certificate request using the name "<strong>CSR_<?php echo $app->getId() ?>_APS_DEV.certSigningRequest</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Done] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="http://developer.apple.com/devcenter/ios/index.action" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates, Identifires & Profiles] on the right of the page</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Apple Push Notification service SSL (Sandbox)] in the [Development] section
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the name "<strong>XXXXXXXXXX_co.veam.veam<?php echo $app->getId() ?></strong>" then click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click the [Choose File] button to locate the "<strong>CSR_<?php echo $app->getId() ?>_APS_DEV.certSigningRequest</strong>" that you have saved earlier</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change the downloaded file name "aps_developer_identity.cer" to "<strong>aps_developer_<?php echo $app->getId() ?>.cer</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong>aps_developer_<?php echo $app->getId() ?>.cer</strong>" to install it in the Keychain Access application</td></tr>

				<tr><td>-</td><td>The same process above applies when generating the production certificate</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Keychain Access application in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select [Keychain Access]->[Certificate Assistant]->[Request a Certificate From a Certificate Authority]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter your email address for the [User Email Address]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>APS PRO <?php echo $app->getId() ?></strong>" for the [Common Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Saved to disk]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Save the certificate request using the name "<strong>CSR_<?php echo $app->getId() ?>_APS_PRO.certSigningRequest</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Done] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="http://developer.apple.com/devcenter/ios/index.action" target="_blank">iOS Dev Center</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates, Identifires & Profiles] on the right of the page</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Certificates]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Apple Push Notification service SSL (Production)] in the [Production] section
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the name "<strong>XXXXXXXXXX_co.veam.veam<?php echo $app->getId() ?></strong>" then click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click the [Choose File] button to locate the "<strong>CSR_<?php echo $app->getId() ?>_APS_PRO.certSigningRequest</strong>" that you have saved earlier</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Generate] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Download] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Change the downloaded file name "aps_production.cer" to "<strong>aps_production_<?php echo $app->getId() ?>.cer</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Double-click on the file "<strong>aps_production_<?php echo $app->getId() ?>.cer</strong>" to install it in the Keychain Access application</td></tr>

				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
