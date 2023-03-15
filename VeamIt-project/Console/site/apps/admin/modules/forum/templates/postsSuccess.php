<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Posts</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&f=0&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),0), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&f=0&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId()), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endforeach ?>
			</select>
			Forum :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&f=0&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$appId), false) ?>" <?php if(!$forumId) echo 'selected' ; ?>>All</option>
				<?php if($appId): ?>
				<?php foreach($forums as $forum): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&f=%d&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$forum->getId()), false) ?>" <?php if($forumId == $forum->getId()) echo 'selected' ; ?>><?php echo AdminTools::unescapeName($forum->getName()) ?></option>
				<?php endforeach ?>
				<?php endif ?>
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
							<li><i class="icon-calendar"></i><?php echo $picture->getCreatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ." > " . $forumName ?></li>
							<li><i class="icon-heart"></i><?php echo $picture->getNumberOfLikes() ?></li>
							<li><i class="icon-trash"></i><?php echo AdminTools::link_to("Remove", "forum/deletepost", array("onclick"=>'return confirm("Remove this post?")',"query_string"=>sprintf("pid=%d&a=%s&p=%s",$picture->getId(),$appId,$page))) ; ?></li>
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
			<?php echo AdminTools::link_to("<<", "forum/posts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=1",$appId,$forumId))) ; ?>
			<?php echo AdminTools::link_to("<", "forum/posts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d",$appId,$forumId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "forum/posts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d",$appId,$forumId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "forum/posts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d",$appId,$forumId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "forum/posts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d",$appId,$forumId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
