<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Register Kiip App</h5></div>
		<?php if($errorMessage): ?>
		<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
		<?php endif ?>
		<form action="<?php echo url_for('app/registerkiipapp') ?>" method="post">
			<input type="hidden" name="a" value="<?php echo $appId ?>" />
			Enter Kiip App Key : <input name="kk" type="text" value="<?php echo $kiipAppKey ?>"/><br />
			Enter Kiip App Secret : <input name="ks" type="text" value="<?php echo $kiipAppSecret ?>"/><br />
			<input type="submit" value="Register" />
		</form>
	</div>
</div>
<!-- end: Right Content -->
