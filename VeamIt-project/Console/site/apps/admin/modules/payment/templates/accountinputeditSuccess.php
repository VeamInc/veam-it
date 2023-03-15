<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Edit Account</h5></div>

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('payment/saveaccount') ?>" method="post" class="validateform" name="send-contact">
		<div id="sendmessage">
			 Your message has been sent. Thank you!
		</div>
		<div class="row">

			<input type="hidden" name="c" value="<?php echo $paymentAccountId ?>">
			<div class="span9 field">
				App Name : <?php echo $app->getName() ?><br/><br/>
			</div>

			<div class="span9 field">
				<input name="name" placeholder="* Enter account name" data-rule="maxlen:1" data-msg="Please enter at least 1 chars" type="text" <?php if($name){echo sprintf('value="%s"',$name);} ?>>
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				<input name="email" placeholder="* Enter email address" data-rule="email" data-msg="Please enter a valid email" type="text" <?php if($email){echo sprintf('value="%s"',$email);} ?>>
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				<input name="share" placeholder="* Enter share value[%]" data-rule="maxlen:1" data-msg="Please enter a share value[%]" type="text" <?php if($share){echo sprintf('value="%s"',$share);} ?>>
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
