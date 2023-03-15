<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">To Youtuber</h5></div>

		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<form id="contactform" action="<?php echo url_for('inquiry/sendmessage') ?>" method="post" class="validateform" name="send-contact">
						<div class="field">

							To :
							<select name="c" id="c">
								<option value="0" <?php if(!$appCreatorId){echo 'selected';} ?>>Select youtuber</option>
								<?php 
									foreach($appCreators as $appCreator): 
										$app = $appMap[$appCreator->getAppId()] ;
										if($app){
											$appName = $app->getName() ;
										} else {
											$appName = "" ;
										}
								?>
								<option value="<?php echo $appCreator->getId() ?>" <?php if($appCreatorId == $appCreator->getId()) echo 'selected' ; ?>><?php echo sprintf("%s (%s)",$appCreator->getUsername(),$appName) ; ?></option>
								<?php endforeach ?>
							</select>

							<input name="s" id="s" placeholder="Enter your subject" data-rule="maxlen:4" data-msg="Please enter at least 4 chars" type="text">
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
