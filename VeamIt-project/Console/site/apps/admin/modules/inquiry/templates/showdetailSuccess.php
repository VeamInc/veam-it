<?php 
	$inquirySetStatuses = AdminTools::getInquirySetStatuses() ;
?>
<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Message</h5></div>

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
				$kind = $inquirySet->getKind() ;
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

					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $inquirySet->getUpdatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ?></li>
							<li><i class="icon-user"></i><?php echo $inquirySet->getEmail() ?></li>
							<li><i class="icon-tag"></i>Status : <?php echo $inquirySetStatuses[$inquirySet->getStatus()] ?></li>
							<?php if($status != 3): ?>
							<?php if(($kind == 1) || ($kind == 3)): ?>
								<li><i class="icon-reply"></i><?php echo AdminTools::link_to('Reply','inquiry/replytoappuser',array('query_string'=>sprintf('i=%d&t=%s',$inquirySet->getId(),$inquirySet->getToken()))) ?></li>
							<?php else: ?>
								<li><i class="icon-reply"></i><?php echo AdminTools::link_to('Reply','inquiry/reply',array('query_string'=>sprintf('i=%d&t=%s',$inquirySet->getId(),$inquirySet->getToken()))) ?></li>
							<?php endif ?>
							<li><i class="icon-ok"></i><?php echo AdminTools::link_to("Mark as solved", "inquiry/setstatus", array("onclick"=>'return confirm("Mark this inquiry as solved?")',"query_string"=>sprintf("i=%d&t=%s&s=3",$inquirySet->getId(),$inquirySet->getToken()))) ; ?></li>
							<?php endif ?>

						</ul>
					</div>

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
