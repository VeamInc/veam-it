<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Confirm Mail</h5></div>

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('payment/sendmail') ?>" method="post" class="validateform" name="send-contact">
		<input type="hidden" name="sym" value="<?php echo $startYearMonth ?>">
		<input type="hidden" name="eym" value="<?php echo $endYearMonth ?>">
		<input type="hidden" name="a" value="<?php echo $appId ?>">
		<input type="hidden" name="r" value="<?php echo $paymentAccount->getEmail() ?>">
		<div class="row">
			<div class="span9 field">
			<table class="table table-bordered">
			<tbody>
				<tr><td>App Name</td><td><?php echo $app->getName() ?></td></tr>
				<tr><td>Start Year/Month</td><td><?php echo $startYearMonth ?></td></tr>
				<tr><td>End Year/Month</td><td><?php echo $startYearMonth ?></td></tr>
				<tr><td>Receiver</td><td><?php echo $paymentAccount->getEmail() ?><?php echo preg_match("/@veam.co/",$paymentAccount->getEmail())?' <font color="red">(Is this email correct?)</font>':"" ; ?></td></tr>
				<tr><td>Subject</td><td><input type="text" name="subject" placeholder="* Subject" value="<?php echo $subject ?>"></td></tr>
				<tr>
					<td>Message</td>
					<td><textarea rows="12" name="body" id="data" class="input-block-level" placeholder="* Message" data-rule="required" data-msg="Please write something"><?php echo $body ?></textarea></td>
				</tr>
			</tbody>
			</table>
			</div>
			<div class="span9 field">
				<button class="btn btn-theme margintop10 pull-left" type="submit">Send Mail</button>
			</div>
		</div>
	</form>
	<!-- End contact form-->
</div>
<!-- end: Right Content -->
