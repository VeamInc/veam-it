<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://play.google.com/apps/publish/" target="_blank">Google Play Developer Console</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+ Add new application]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>en-US</strong>" for [Default Language]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong id="copy_text_<?php echo $lineNo?>"><?php echo $app->getStoreAppName() ?></strong>"<a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a> for [Title]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Prepare Store Listing]</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Enter the following text for [Short Description]<br />
					<pre id="copy_text_<?php echo $lineNo?>">Finally you can carry <?php echo $app->getStoreAppName() ?> in your pocket...FOR FREE!</pre><a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a>
				</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Enter the following text for [Description]<br />
					<pre id="copy_text_<?php echo $lineNo?>"><?php echo $appDescription ?></pre><a href='#' data-clipboard-target='copy_text_<?php echo $lineNo?>' id="copy-button-<?php echo $lineNo?>">©</a>
				</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Download the following 4 inch screenshots<br />
					<?php if($app->getScreenShot1()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot1() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot2()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot2() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot3()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot3() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot4()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot4() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot5()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot5() ?>" alt="" width="120" height="213" /></div><?php endif ?>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload these screenshots to the Google Play Developer Console<br />

				<tr><td><?php echo $lineNo++ ?></td><td>Download the following icon image<br />
					<div class="thumbnail pull-left"><img src="http://<?php echo $_SERVER['SERVER_NAME'] ?>/uploads/<?php echo $app->getId() ?>/icon512.png" alt="" width="128" height="128" /></div>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the icon to the Google Play Developer Console<br />

				<tr><td><?php echo $lineNo++ ?></td><td>Download one of the following promotion images<br />
					<div class="thumbnail pull-left">Crop top and bottom<img src="http://<?php echo $_SERVER['SERVER_NAME'] ?>/uploads/<?php echo $app->getId() ?>/promo1.png" alt="" width="512" height="250" /></div><br />
					<div class="thumbnail pull-left">Add black<img src="http://<?php echo $_SERVER['SERVER_NAME'] ?>/uploads/<?php echo $app->getId() ?>/promo2.png" alt="" width="512" height="250" /></div><br />
					<div class="thumbnail pull-left">Add white<img src="http://<?php echo $_SERVER['SERVER_NAME'] ?>/uploads/<?php echo $app->getId() ?>/promo3.png" alt="" width="512" height="250" /></div><br />
					<div class="thumbnail pull-left">Expand edge<img src="http://<?php echo $_SERVER['SERVER_NAME'] ?>/uploads/<?php echo $app->getId() ?>/promo4.png" alt="" width="512" height="250" /></div><br />
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the promotion image to the Google Play Developer Console<br />
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong>Application</strong>" for [Type of application]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $app->getCategory() ?></strong>" for [Category]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select appropriate rating for [Rating]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://help.veam.co/contact/app.php/inquiry?m=<?php echo $mcnId ?>&a=<?php echo $app->getId() ?></strong>" for [Web site]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>support@veam.co</strong>" for [Email]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://veam.co/top/guideline</strong>" for Privacy URL</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save as a draft]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Pricing and Distribution]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select [FREE]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check [SELECT ALL COUNTRIES]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save as draft]</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Services & APIs]</td></tr>

				<tr><td><?php echo $lineNo++ ?></td><td>Register License Key to the <?php echo AdminTools::link_to("register page", "app/enteriabpublic", array("target"=>"_blank","query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>

				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?>.</td></tr>
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

