<?php 
	$inquirySetStatuses = AdminTools::getInquirySetStatuses() ;
?>
<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Messages to app user</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&s=%d&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),0,$status), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&s=%d&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId(),$status), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endforeach ?>
			</select>

			Status :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&s=%d&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,0), false) ?>" <?php if($status == 0) echo 'selected' ; ?>>All</option>
				<?php foreach($inquirySetStatuses as $statusId => $statusText): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&s=%d&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$statusId), false) ?>" <?php if($status == $statusId) echo 'selected' ; ?>><?php echo $statusText ?></option>
				<?php endforeach ?>
			</select>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

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
				$inquirySetStatus = $inquirySet->getStatus() ;
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
									<h6><span><?php echo $inquiry->getCreatedAt() ?></span> <?php echo $inquiry->getKind()==1?$inquirySet->getEmail():$inquiry->getUserName() ?></h6>
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
							<li><i class="icon-tag"></i>Status : <?php echo $inquirySetStatuses[$inquirySetStatus] ?></li>
							<?php if($inquirySetStatus != 3): ?>
							<li><i class="icon-reply"></i><?php echo AdminTools::link_to('Reply','inquiry/replytoappuser',array('query_string'=>sprintf('i=%d&t=%s',$inquirySet->getId(),$inquirySet->getToken()))) ?></li>
							<li><i class="icon-ok"></i><?php echo AdminTools::link_to_admin_public("Mark as solved", "inquiry/setstatus", array("onclick"=>'return confirm("Mark this inquiry as solved?")',"query_string"=>sprintf("i=%d&t=%s&s=3",$inquirySet->getId(),$inquirySet->getToken()))) ; ?></li>
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

		<!-- Start pagination-->
		<div id="pagination">
			<span class="all">Page <?php echo $page ?> of <?php echo $lastPage ?></span>
			<?php if($page != 1): ?>
			<?php echo AdminTools::link_to("<<", "inquiry/listfromappuser", array("class"=>"inactive", "query_string"=>sprintf("a=%d&s=%d&p=1",$appId,$status))) ; ?>
			<?php echo AdminTools::link_to("<", "inquiry/listfromappuser", array("class"=>"inactive", "query_string"=>sprintf("a=%d&s=%d&p=%d",$appId,$status,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "inquiry/listfromappuser", array("class"=>"inactive", "query_string"=>sprintf("a=%d&s=%d&p=%d",$appId,$status,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "inquiry/listfromappuser", array("class"=>"inactive", "query_string"=>sprintf("a=%d&s=%d&p=%d",$appId,$status,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "inquiry/listfromappuser", array("class"=>"inactive", "query_string"=>sprintf("a=%d&s=%d&p=%d",$appId,$status,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
