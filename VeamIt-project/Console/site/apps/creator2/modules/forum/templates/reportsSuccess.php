<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Reports') ?></h5></div>

		<div class="element-select">
			<?php echo __('App') ?> :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&f=0&p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$sortKind), false) ?>" selected><?php echo $appNames[$appId] ?></option>
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
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-report<?php echo $picture->getId() ?>" href="#collapse-report<?php echo $picture->getId() ?>"><span class="icon-thumbs-down"></span> <?php echo __('Reports') ?>(<?php echo count($reports) ?>) </a>
							</div>
							<div id="collapse-report<?php echo $picture->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">

									<ul class="folio-detail">
										<?php foreach($reports as $report): 
											$socialUser = $socialUserMap[$report->getSocialUserId()] ;
											if($socialUser){
												$socialUserName = $socialUser->getName() ;
											} else {
												$socialUserName = "<?php echo __('Unknown') ?>" ;
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
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $picture->getId() ?>" href="#collapse-comment<?php echo $picture->getId() ?>"><span class="icon-comment"></span> <?php echo __('Comments') ?>(<?php echo count($comments) ?>) </a>
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
											<label><?php echo AdminTools::link_to_creator($socialUserName, "forum/user", array("query_string"=>sprintf("i=%d",$socialUserId))) ; ?> :</label> 
											<?php echo AdminTools::unescapeName(AdminTools::unescapeName($comment->getComment())) ?>&nbsp;
											<?php if($comment->getDelFlag() == 0): ?>
											<?php echo AdminTools::link_to_creator('<i class="icon-trash"></i>', "forum/deletecomment", array("onclick"=>"return confirm('".__('Remove this comment')."?')","query_string"=>sprintf("cid=%d&pid=%d&a=%s&p=%s",$comment->getId(),$picture->getId(),$appId,$page))) ; ?>
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
							<li><i class="icon-calendar"></i><?php echo __('Posted at') ?> <?php echo $picture->getCreatedAt() ?></li>
							<li><i class="icon-calendar"></i><?php echo __('Reported at') ?> <?php echo $reportSet->getLastReportedAt() ?></li>
							<?php if($removed): ?>
							<li><i class="icon-calendar"></i><?php echo __('Removed at') ?> <?php echo $reportSet->getUpdatedAt() ?></li>
							<?php endif ?>
							<li><i class="icon-folder-open"></i><?php echo $appName ." > " . $forumName ?></li>
							<?php if(!$removed): ?>
							<li><i class="icon-trash"></i><?php echo AdminTools::link_to_creator(__("Remove"), "forum/deletepost", array("onclick"=>"return confirm('".__('Remove this post')."?')","query_string"=>sprintf("pid=%d&a=%s&p=%s",$picture->getId(),$appId,$page))) ; ?></li>
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
			<span class="all"><?php echo __('Page') ?> <?php echo $page ?> <?php echo __('of') ?> <?php echo $lastPage ?></span>
			<?php if($page != 1): ?>
			<?php echo AdminTools::link_to_creator("<<", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1",$appId))) ; ?>
			<?php echo AdminTools::link_to_creator("<", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to_creator($workPage, "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to_creator(">", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to_creator(">>", "forum/reports", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
