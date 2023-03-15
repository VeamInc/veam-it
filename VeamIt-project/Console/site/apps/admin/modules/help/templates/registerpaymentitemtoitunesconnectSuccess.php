<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://itunesconnect.apple.com/" target="_blank">iTunes Connect</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [<?php echo $app->getName() ?>]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Features]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button</td></tr>
<?php if($templateSubscrpition->getKind() == 4){ /*Subscription*/?>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Select] of [Auto-Renewable Subscription]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">Premium Content</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add Duration] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>1 Month</strong>" for [Duration]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">co.veam.veam<?php echo $app->getId() ?>.subscription<?php echo $subscriptionIndex ?>.1m</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Product ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $priceTier ?></strong>" for [Price Tier] to set <?php echo $priceString ?></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Add Language] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>English</strong>" for [Language]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">Premium Content</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Display Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>"><?php echo $app->getName() ?> - Premium Content</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Description]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">Premium Content</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Publication Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">http://veam.co/top/guideline</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [English] and click on the [Save] button</td></tr>
<?php } else if($templateSubscrpition->getKind() == 5){ /*PPC*/?>
				<tr><td><?php echo $lineNo++ ?></td>
					<td>
<?php foreach($sellVideos as $sellVideo): ?>
						Title : "<strong id="copy_text_<?php $lineNo++;echo $lineNo?>"><?php echo $videoMap[$sellVideo->getVideoId()]->getTitle() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a><br />
						ProductID : "<strong id="copy_text_<?php $lineNo++;echo $lineNo?>"><?php echo $sellVideo->getProduct() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a><br />
						Price : <?php echo $sellVideo->getPriceText() ?><br />
						<br />
<?php endforeach ?>
<?php foreach($sellAudios as $sellAudio): ?>
						Title : "<strong id="copy_text_<?php $lineNo++;echo $lineNo?>"><?php echo $audioMap[$sellAudio->getAudioId()]->getTitle() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a><br />
						ProductID : "<strong id="copy_text_<?php $lineNo++;echo $lineNo?>"><?php echo $sellAudio->getProduct() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a><br />
						Price : <?php echo $sellAudio->getPriceText() ?><br />
						<br />
<?php endforeach ?>
<?php foreach($sellPdfs as $sellPdf): ?>
						Title : "<strong id="copy_text_<?php $lineNo++;echo $lineNo?>"><?php echo $pdfMap[$sellPdf->getPdfId()]->getTitle() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a><br />
						ProductID : "<strong id="copy_text_<?php $lineNo++;echo $lineNo?>"><?php echo $sellPdf->getProduct() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a><br />
						Price : <?php echo $sellPdf->getPriceText() ?><br />
						<br />
<?php endforeach ?>
					</td>
				</tr>
<?php } else if($templateSubscrpition->getKind() == 6){ /*PPS*/?>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">Premium Content</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Name]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>">co.veam.veam<?php echo $app->getId() ?>.section.0</strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Product ID]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $priceTier ?></strong>" for [Price Tier] to set <?php echo $priceString ?></td></tr>
<?php } ?>

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

	for(index = 1 ; index <= <?php echo $lineNo?> ; index++){
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

