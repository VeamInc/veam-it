<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Register Facebook App ID</h5></div>
		<?php if($errorMessage): ?>
		<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
		<?php endif ?>
		<form action="<?php echo url_for('app/registerfacebookappid') ?>" method="post">
			<input type="hidden" name="a" value="<?php echo $appId ?>" />
			Enter Facebook App ID : <input name="f" type="text" value="<?php echo $facebookAppId ?>"/> <input type="submit" value="Register" />
		</form>
	</div>
</div>
<!-- end: Right Content -->
