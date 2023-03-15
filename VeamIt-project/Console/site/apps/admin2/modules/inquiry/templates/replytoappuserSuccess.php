<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Reply</h5></div>

		<?php if(count($inquirySets) > 0): ?>
		<?php 
			foreach($inquirySets as $inquirySet): 
				$inquiries = $inquiriesForInquirySetId[$inquirySet->getId()] ;
				$app = $appMap[$inquirySet->getAppId()] ;
				if($app){
					$appName = $app->getName() ;
				} else {
					$appName = "" ;
				}
		?>
		<div class="media">
			<div class="media-body">
				<div class="media-content">

					<h6><?php echo $inquirySet->getSubject() ?></h6>

					<div class="accordion stripped" id="accordion-comment<?php echo $inquirySet->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $inquirySet->getId() ?>" href="#collapse-comment<?php echo $inquirySet->getId() ?>"><span class="icon-envelope"></span> Messages(<?php echo count($inquiries) ?>) </a>
							</div>
							<div id="collapse-comment<?php echo $inquirySet->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">

									<?php foreach($inquiries as $inquiry): ?>
									<h6><span><?php echo $inquiry->getCreatedAt() ?></span> <?php echo (($inquiry->getKind()==1)||($inquiry->getKind()==2))?$inquirySet->getEmail():$inquiry->getUserName() ?></h6>
									<pre><?php echo $inquiry->getMessage() ?></pre>
									<br />
									<?php endforeach ?>

								</div>
							</div>
						</div>
					</div>

					<form id="contactform" action="<?php echo url_for('inquiry/sendreply') ?>" method="post" class="validateform" name="send-contact">
						<div class="field">
							<textarea rows="12" name="r" id="r" class="input-block-level" placeholder="* Your message here..." data-rule="required" data-msg="Please write something"></textarea>
							<div class="validation"></div>
							<input type="hidden" name="i" id="i" value="<?php echo $inquirySetId ?>" >
							<input type="hidden" name="t" id="t" value="<?php echo $inquirySetToken ?>" >
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
		<?php endforeach ?>

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
