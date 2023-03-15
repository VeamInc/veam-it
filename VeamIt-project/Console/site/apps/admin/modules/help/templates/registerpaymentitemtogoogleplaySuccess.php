<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://play.google.com/apps/publish/" target="_blank">Google Play Developer Console</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [<?php echo $app->getName() ?>]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [APK]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [ALPHA TESTING]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Upload your first APK to Alpha]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the file "veam<?php echo $app->getId() ?>-release.apk"</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [In-app Products]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+ Add new product]</td></tr>
<?php if($templateSubscrpition->getKind() == 4){ /*Subscription*/?>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>Subscription</strong>"</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>co.veam.veam<?php echo $app->getId() ?>.subscription<?php echo $subscriptionIndex ?>.1m</strong>" for [Product ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Continue]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>Premium Content</strong>" for [Title]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getName() ?> - Premium Content</strong>" for [Description]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $priceString ?></strong>" for [Default price]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>Monthly</strong>" for [Period]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>None</strong>" for [Grace Period]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Auto-convert prices now]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [- Inactive] and then select [Activate]</td></tr>
<?php } else if($templateSubscrpition->getKind() == 5){ /*PPC*/?>
				<tr><td><?php echo $lineNo++ ?></td>
					<td>
<?php foreach($sellVideos as $sellVideo): ?>
						Title : <?php echo $videoMap[$sellVideo->getVideoId()]->getTitle() ?><br />
						ProductID : <?php echo $sellVideo->getProduct() ?><br />
						Price : <?php echo $sellVideo->getPriceText() ?><br />
						<br />
<?php endforeach ?>
<?php foreach($sellAudios as $sellAudio): ?>
						Title : <?php echo $audioMap[$sellAudio->getAudioId()]->getTitle() ?><br />
						ProductID : <?php echo $sellAudio->getProduct() ?><br />
						Price : <?php echo $sellAudio->getPriceText() ?><br />
						<br />
<?php endforeach ?>
<?php foreach($sellPdfs as $sellPdf): ?>
						Title : <?php echo $pdfMap[$sellPdf->getPdfId()]->getTitle() ?><br />
						ProductID : <?php echo $sellPdf->getProduct() ?><br />
						Price : <?php echo $sellPdf->getPriceText() ?><br />
						<br />
<?php endforeach ?>
					</td>
				</tr>
<?php } else if($templateSubscrpition->getKind() == 6){ /*PPS*/?>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>Premium Content</strong>" for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>co.veam.veam<?php echo $app->getId() ?>.section.0</strong>" for [Product ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $priceTier ?></strong>" for [Price Tier] to set <?php echo $priceString ?></td></tr>
<?php } ?>


				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Content Rating] and apply the appropriate content ratings</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Pricing and Distribution] and check the required elements</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save as draft]</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Publish]</td></tr>

				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
