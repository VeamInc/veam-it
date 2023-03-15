<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Edit Account</h5></div>

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('creator/save') ?>" method="post" class="validateform" name="send-contact">
		<input name="c" type="hidden" value="<?php echo $appCreatorId ?>">
		<div id="sendmessage">
			 Your message has been sent. Thank you!
		</div>
		<div class="row">
			<div class="span9 field">
				<input name="fname" placeholder="* Enter your first name" data-rule="maxlen:1" data-msg="Please enter at least 1 chars" type="text" <?php if($firstName){echo sprintf('value="%s"',$firstName);} ?>>
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				<input name="lname" placeholder="* Enter your last name" data-rule="maxlen:1" data-msg="Please enter at least 1 chars" type="text" <?php if($lastName){echo sprintf('value="%s"',$lastName);} ?>>
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				<input name="email" placeholder="* Enter email address" data-rule="email" data-msg="Please enter a valid email" type="text" <?php if($email){echo sprintf('value="%s"',$email);} ?>>
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				<input name="pass" placeholder="* Enter new password (leave blank if no change)" type="text" <?php if($password){echo sprintf('value="%s"',$password);} ?>>
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
