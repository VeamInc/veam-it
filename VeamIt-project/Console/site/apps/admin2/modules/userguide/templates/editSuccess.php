<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Edit User Guide</h5></div>

		<div class="media">
			<div class="media-body">
				<div class="media-content">

					<h6><?php echo $app->getName() ?></h6>

					<form id="contactform" action="<?php echo url_for('userguide/save') ?>" method="post" class="validateform" name="send-contact">
						<div class="field">
							<textarea rows="12" name="d" id="d" class="input-block-level" placeholder="* User Guide" data-rule="required" data-msg="Please write something"><?php echo $userGuide->getDescription() ?></textarea>
							<div class="validation"></div>
							<input type="hidden" name="a" id="a" value="<?php echo $app->getId() ?>" >
							<p><button class="btn btn-theme margintop10 pull-left" type="submit">Save</button></p>
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
