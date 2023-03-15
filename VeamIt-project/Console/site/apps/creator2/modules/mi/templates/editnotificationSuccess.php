<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Edit Notification</h5></div>
	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('mi/savenotification') ?>" method="post" class="validateform" name="send-contact">
		<div class="row">
			<div class="span9 field">
				<input name="m" placeholder="* Enter message" maxlength="50" data-rule="maxlen:1" data-msg="Please enter at least 1 chars" type="text" >
				<div class="validation"></div>
			</div>
			<div class="span9 field">
				Notification Group :
				<select name="ng">
					<option value="0" selected>All Users</option>
					<?php foreach($notificationGroups as $notificationGroup): ?>
					<option value="<?php echo $notificationGroup->getId() ?>"><?php echo $notificationGroup->getName() ?></option>
					<?php endforeach ?>
				</select>
			</div>
			<div class="span9 field">
				<button class="btn btn-theme margintop10 pull-left" type="submit">Send Notification</button>
			</div>
		</div>
	</form>
	<!-- End contact form-->
</div>
<!-- end: Right Content -->
