<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Removed Posts</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),0), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId()), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endforeach ?>
			</select>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($pictures) > 0): ?>

		<?php 
			foreach($pictures as $picture): 
				$comments = $commentsForPictureId[$picture->getId()] ;
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
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $picture->getUrl() ?>" alt="" width="150" height="150" /></div>
			<div class="media-body">
				<div class="media-content">

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
											} else {
												$socialUserName = "" ;
											}
										?>
										<li><label><?php echo $socialUserName ?> :</label> <?php echo AdminTools::unescapeName(AdminTools::unescapeName($comment->getComment())) ?></li>
										<?php endforeach ?>
									</ul>

								</div>
							</div>
						</div>
					</div>

					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i>Posted at <?php echo $picture->getCreatedAt() ?></li>
							<li><i class="icon-calendar"></i>Removed at <?php echo $picture->getUpdatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ." > " . $forumName ?></li>
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
			<?php echo AdminTools::link_to("<<", "forum/removedposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1",$appId))) ; ?>
			<?php echo AdminTools::link_to("<", "forum/removedposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "forum/removedposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "forum/removedposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "forum/removedposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
