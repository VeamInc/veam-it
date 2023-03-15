<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Upload APS key</h5></div>
		<?php if($errorMessage): ?>
		<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
		<?php endif ?>
		<form enctype="multipart/form-data" action="<?php echo url_for('app/uploadapskey') ?>" method="POST">
			<input type="hidden" name="a" value="<?php echo $appId ?>" />
			<input type="hidden" name="t" value="<?php echo $type ?>" />
			<input type="hidden" name="MAX_FILE_SIZE" value="100000" />
			Select the file "<strong>APS_<?php echo ($type == 'p')?"PRO":"DEV" ?>_<?php echo $appId ?>.p12</strong>" : <input name="apsfile" type="file" /><br /><br />
			<input type="submit" value="upload" />
		</form>
	</div>
</div>
<!-- end: Right Content -->
