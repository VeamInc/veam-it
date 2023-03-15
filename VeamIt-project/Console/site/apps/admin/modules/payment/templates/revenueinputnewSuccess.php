<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Add New Revenue</h5></div>

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('payment/addnewrevenue') ?>" method="post" class="validateform" name="send-contact">
		<div class="row">
			<div class="span9 field">
				<textarea rows="12" name="data" id="data" class="input-block-level" placeholder="* Revenue data" data-rule="required" data-msg="Please write something"><?php echo $data ?></textarea>
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				<button class="btn btn-theme margintop10 pull-left" type="submit">Add</button>
			</div>
		</div>
	</form>
	<!-- End contact form-->
</div>
<!-- end: Right Content -->
