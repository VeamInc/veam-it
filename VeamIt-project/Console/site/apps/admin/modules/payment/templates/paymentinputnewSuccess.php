<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Add New Payment</h5></div>

	<span class="pull-right">
		<?php echo AdminTools::link_to('<i class="icon-download-alt"></i>Download Evidence File', "payment/downloadevidence", array("class"=>"btn btn-mini","query_string"=>sprintf("a=%d&ym=%s",$appId,$yearMonth) ) ) ; ?>
	</span>
	<p style="clear:both" />

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('payment/addnewpayment') ?>" method="post" class="validateform" name="send-contact">
		<input type="hidden" name="ym" value="<?php echo $yearMonth ?>">
		<input type="hidden" name="a" value="<?php echo $appId ?>">
		<div class="row">
			<div class="span9 field">
			<table class="table table-bordered">
			<tbody>
				<tr><td>App Name</td><td><?php echo $app->getName() ?></td></tr>
				<tr><td>Payment Receiver</td><td><?php echo $paymentAccount->getEmail() ?><?php echo preg_match("/@veam.co/",$paymentAccount->getEmail())?' <font color="red">(Is this email correct?)</font>':"" ; ?></td></tr>
				<tr><td>Year/Month</td><td><?php echo substr($yearMonth,0,4) . " / " . substr($yearMonth,4,2) ?></td></tr>
				<tr>
					<td>Amount</td>
					<td><input name="amount" placeholder="* Enter a paid amount" data-rule="maxlen:1" data-msg="Please enter a paid amount" type="text" <?php if($amount){echo sprintf('value="%s"',$amount);} ?>></td>
				</tr>
				<tr>
					<td>Payment ID</td>
					<td><input name="payment_id" placeholder="* Enter a payment ID" data-rule="maxlen:1" data-msg="Please enter a payment ID" type="text" <?php if($paymentId){echo sprintf('value="%s"',$paymentId);} ?>></td>
				</tr>
			</tbody>
			</table>
			</div>
			<div class="span9 field">
				<button class="btn btn-theme margintop10 pull-left" type="submit">I have paid this</button>
			</div>
		</div>
	</form>
	<!-- End contact form-->
</div>
<!-- end: Right Content -->
