<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">To app user</h5></div>

		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<form id="contactform" action="<?php echo url_for('inquiry/sendmessage') ?>" method="post" class="validateform" name="send-contact">
						<div class="field">

							<select name="a" id="a">
								<option value="0" <?php if(!$appId){echo 'selected';} ?>>Select app</option>
								<?php 
									foreach($apps as $app): 
								?>
								<option value="<?php echo $app->getId() ?>" <?php if($appId == $app->getId()) echo 'selected' ; ?>><?php echo sprintf("%s",$app->getName()) ; ?></option>
								<?php endforeach ?>
							</select>

							<input name="e" id="e" placeholder="* Enter email address" data-rule="email" data-msg="Please enter a valid email" type="text" <?php if($email){echo sprintf('value="%s"',$email);} ?>>
							<div class="validation"></div>

							<input name="s" id="s" placeholder="* Enter your subject" data-rule="maxlen:4" data-msg="Please enter at least 4 chars" type="text">
							<div class="validation"></div>

							<textarea rows="12" name="m" id="m" class="input-block-level" placeholder="* Your message here..." data-rule="required" data-msg="Please write something"></textarea>
							<div class="validation"></div>

							<p><button class="btn btn-theme margintop10 pull-left" type="submit">Send message</button></p>
						</div>
					</form>

				</div>
			</div>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

	</div>
</div>
<!-- end: Right Content -->
