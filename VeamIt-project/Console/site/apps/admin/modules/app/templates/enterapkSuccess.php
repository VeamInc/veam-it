<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Upload APK file</h5></div>
		<?php if($errorMessage): ?>
		<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
		<?php endif ?>
		<form enctype="multipart/form-data" action="<?php echo url_for('app/uploadapk') ?>" method="POST">
			<input type="hidden" name="a" value="<?php echo $appId ?>" />
			<input type="hidden" name="MAX_FILE_SIZE" value="100000000" />
			Select the file "<strong>veam<?php echo $appId ?>-release.apk</strong>" : <input name="apkfile" type="file" /><br /><br />
			<input type="submit" value="upload" />
		</form>
	</div>
</div>
<!-- end: Right Content -->
