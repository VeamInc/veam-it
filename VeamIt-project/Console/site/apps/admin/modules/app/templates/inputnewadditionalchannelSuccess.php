<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Add Youtube Channel</h5></div>

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('app/addnewadditionalchannel') ?>" method="post" class="validateform" name="send-contact">
		<div id="sendmessage">
			 Your message has been sent. Thank you!
		</div>
		<div class="row">
			<div class="span9 field">
				<input name="c" placeholder="* Enter Youtube Channel ID" data-rule="maxlen:1" data-msg="Please enter at least 1 chars" type="text" <?php if($youtubeChannelId){echo sprintf('value="%s"',$youtubeChannelId);} ?>>
				<div class="validation"></div>
			</div>

			<div class="span9 field">
				<button class="btn btn-theme margintop10 pull-left" type="submit">Add</button>
			</div>
		</div>
		<input type="hidden" name="a" id="a" value="<?php echo $appId ?>" />
	</form>
	<!-- End contact form-->
</div>
<!-- end: Right Content -->
