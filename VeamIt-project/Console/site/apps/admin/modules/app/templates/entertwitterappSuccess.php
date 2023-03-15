<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Register Twitter App</h5></div>
		<?php if($errorMessage): ?>
		<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
		<?php endif ?>
		<form action="<?php echo url_for('app/registertwitterapp') ?>" method="post">
			<input type="hidden" name="a" value="<?php echo $appId ?>" />
			Enter Twitter Consumer Key : <input name="tk" type="text" value="<?php echo $twitterConsumerKey ?>"/><br />
			Enter Twitter Consumer Secret : <input name="ts" type="text" value="<?php echo $twitterConsumerSecret ?>"/><br />
			<input type="submit" value="Register" />
		</form>
	</div>
</div>
<!-- end: Right Content -->
