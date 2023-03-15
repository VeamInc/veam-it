<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Edit Notification Group</h5></div>

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('mi/savenotificationgroup') ?>" method="post" class="validateform" name="send-contact">
		<input name="i" type="hidden" value="<?php echo $notificationGroup->getId() ?>">
		<div class="row">
			<div class="span9 field">
				<input name="n" placeholder="* Enter group name" data-rule="maxlen:1" data-msg="Please enter at least 1 chars" type="text" <?php if($notificationGroup->getName()){echo sprintf('value="%s"',$notificationGroup->getName());} ?>>
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				<button class="btn btn-theme margintop10 pull-left" type="submit">Save</button>
			</div>
		</div>
	</form>
	<!-- End contact form-->
</div>
<!-- end: Right Content -->
