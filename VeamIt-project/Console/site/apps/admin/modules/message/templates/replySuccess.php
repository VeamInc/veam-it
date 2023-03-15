<!-- start: Right Content -->
<?php 
	$appCreatorMessages = $appCreatorMessagesMap[$appCreatorId] ; 
	$appCreator = $appCreatorMap[$appCreatorId] ;
?>
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Reply</h5></div>
		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<div class="accordion stripped" id="accordion-comment<?php echo $appCreatorId ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $appCreatorId ?>" href="#collapse-comment<?php echo $appCreatorId ?>"><span class="icon-envelope"></span> Latest <?php echo count($appCreatorMessages) ?> Messages </a>
							</div>
							<div id="collapse-comment<?php echo $appCreatorId ?>" class="accordion-body collapse">
								<div class="accordion-inner">
									<?php foreach($appCreatorMessages as $appCreatorMessage): ?>
									<h6><span><?php echo $appCreatorMessage->getCreatedAt() ?></span> <?php echo ($appCreatorMessage->getDirection()==1)?$appCreator->getUsername():$appCreatorMessage->getMcnUserName() ?></h6>
									<pre><?php echo $appCreatorMessage->getMessage() ?></pre>
									<br />
									<?php endforeach ?>

								</div>
							</div>
						</div>
					</div>

					<form id="contactform" action="<?php echo url_for('message/sendreply') ?>" method="post" class="validateform" name="send-contact">
						<div class="field">
							<textarea rows="12" name="r" id="r" class="input-block-level" placeholder="* Your message here..." data-rule="required" data-msg="Please write something"></textarea>
							<div class="validation"></div>
							<input type="hidden" name="c" id="c" value="<?php echo $appCreatorId ?>" >
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
