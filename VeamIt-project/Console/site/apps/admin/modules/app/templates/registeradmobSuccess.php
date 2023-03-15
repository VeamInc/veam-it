<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Register AdMob</h5></div>
		<?php if($errorMessage): ?>
		<p class="main"><?php echo $sf_data->getRaw('errorMessage') ; ?></p>
		<?php else: ?>
		<p class="main">The Ad Unit IDs have been registred.</p>
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
