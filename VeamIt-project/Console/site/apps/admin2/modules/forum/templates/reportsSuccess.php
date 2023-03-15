<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Reports</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),0), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<?php if($workApp->getStatus() == 0):?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId()), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endif ?>
				<?php endforeach ?>
			</select>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($reportSets) > 0): ?>
		<?php 
			foreach($reportSets as $reportSet): 
				$picture = $pictureMap[$reportSet->getContent()] ;
				if($picture):
					$reports = $reportsForReportSetId[$reportSet->getId()] ;
					$forum = $forumMap[$picture->getForumId()] ;
					if($forum){
						$forumName = AdminTools::unescapeName($forum->getName()) ;
						$app = $appMap[$forum->getAppId()] ;
						if($app){
							$appName = $app->getName() ;
						} else {
							$appName = "" ;
						}
					} else {
						$forumName = "" ;
						$appName = "" ;
					}
					$removed = $reportSet->getRemoved() ;
					if($removed){
						$opacityClass = "media-opacity40" ;
					} else {
						$opacityClass = "" ;
					}

					$comments = $commentsForPictureId[$picture->getId()] ;

		?>
		<div class="media <?php echo $opacityClass ?>">
			<div class="thumbnail pull-left"><img src="<?php echo $picture->getUrl() ?>" alt="" width="150" height="150" /></div>
			<div class="media-body">
				<div class="media-content">

					<div class="accordion stripped" id="accordion-report<?php echo $picture->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-report<?php echo $picture->getId() ?>" href="#collapse-report<?php echo $picture->getId() ?>"><span class="icon-thumbs-down"></span> Reports(<?php echo count($reports) ?>) </a>
							</div>
							<div id="collapse-report<?php echo $picture->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">

									<ul class="folio-detail">
										<?php foreach($reports as $report): 
											$socialUser = $socialUserMap[$report->getSocialUserId()] ;
											if($socialUser){
												$socialUserName = $socialUser->getName() ;
											} else {
												$socialUserName = "Unknown" ;
											}
										?>
										<li><label><?php echo $socialUserName ?> :</label> <?php echo $report->getMessage() ?></li>
										<?php endforeach ?>
									</ul>

								</div>
							</div>
						</div>
					</div>

					<div class="accordion stripped" id="accordion-comment<?php echo $picture->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $picture->getId() ?>" href="#collapse-comment<?php echo $picture->getId() ?>"><span class="icon-comment"></span> Comments(<?php echo count($comments) ?>) </a>
							</div>
							<div id="collapse-comment<?php echo $picture->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">

									<ul class="folio-detail">
										<?php foreach($comments as $comment): 
											$socialUser = $socialUserMap[$comment->getSocialUserId()] ;
											if($socialUser){
												$socialUserName = $socialUser->getName() ;
												$socialUserId = $socialUser->getId() ;
											} else {
												$socialUserName = "" ;
												$socialUserId = 0 ;
											}
										?>
										<li class="<?php echo ($comment->getDelFlag() == 0) ? "":"media-opacity40"?>">
											<label><?php echo AdminTools::link_to($socialUserName, "forum/user", array("query_string"=>sprintf("i=%d",$socialUserId))) ; ?> :</label> 
											<?php echo AdminTools::unescapeName(AdminTools::unescapeName($comment->getComment())) ?>&nbsp;
											<?php if($comment->getDelFlag() == 0): ?>
											<?php echo AdminTools::link_to('<i class="icon-trash"></i>', "forum/deletecomment", array("onclick"=>"return confirm('Remove this comment?')","query_string"=>sprintf("cid=%d&pid=%d&a=%s&p=%s",$comment->getId(),$picture->getId(),$appId,$page))) ; ?>
											<?php endif ?>
										</li>
										<?php endforeach ?>
									</ul>

								</div>
							</div>
						</div>
					</div>

					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i>Posted at <?php echo $picture->getCreatedAt() ?></li>
							<li><i class="icon-calendar"></i>Reported at <?php echo $reportSet->getLastReportedAt() ?></li>
							<?php if($removed): ?>
							<li><i class="icon-calendar"></i>Removed at <?php echo $reportSet->getUpdatedAt() ?></li>
							<?php endif ?>
							<li><i class="icon-folder-open"></i><?php echo $appName ." > " . $forumName ?></li>
							<?php if(!$removed): ?>
							<li><i class="icon-trash"></i><?php echo AdminTools::link_to("Remove this post", "forum/deletepost", array("onclick"=>"return confirm('Remove this post?')","query_string"=>sprintf("pid=%d&a=%s&p=%s",$picture->getId(),$appId,$page))) ; ?></li>
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
		<?php endif ?>
		<?php endforeach ?>

		<!-- Start pagination-->
		<div id="pagination">
			<span class="all">Page <?php echo $page ?> of <?php echo $lastPage ?></span>
			<?php if($page != 1): ?>
			<?php echo AdminTools::link_to("<<", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1",$appId))) ; ?>
			<?php echo AdminTools::link_to("<", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
