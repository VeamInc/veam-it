<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Posts</h5></div>

		<div class="element-select">
			<span class="pull-right">
			View :
			<select onChange="selectJump(this)">
				<?php foreach($sortKinds as $workSortKind => $sortName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&f=%d&p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$forumId,$workSortKind), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
				<?php endforeach ?>
			</select>
			</span>
			<p style="clear:both" />
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($pictures) > 0): ?>
		<?php 
			$currentIndex = $startIndex ;
			foreach($pictures as $picture): 
				$index = $currentIndex ;
				$currentIndex-- ;
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

				$socialUser = $socialUserMap[$picture->getSocialUserId()] ;
				if($socialUser){
					$profileImageUrl = $socialUser->getProfileImage() ;
				} else {
					$profileImageUrl = "" ;
				}
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $profileImageUrl ?>" alt="" width="60" height="60" /></div>
			<div class="media-body">
				<div class="media-content">
					<ul class="folio-detail">
						<?php foreach($comments as $comment): 
							$socialUser = $socialUserMap[$comment->getSocialUserId()] ;
							if($socialUser){
								$socialUserName = $socialUser->getName() ;
							} else {
								$socialUserName = "Unknown" ;
								$socialUserId = 0 ;
							}
						?>
						<li>
							<span>[<?php echo $index ?>]</span> <label><?php echo $socialUserName ?> :</label> 
							<?php echo AdminTools::unescapeName(AdminTools::unescapeName($comment->getComment())) ?>
						</li>
						<?php endforeach ?>
					</ul>

					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $picture->getCreatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ." > " . $forumName ?></li>
							<li><i class="icon-trash"></i><?php echo AdminTools::link_to_creator("Remove", "mi/deleteforumpost", array("onclick"=>"return confirm('Remove this post?')","query_string"=>sprintf("pid=%d&a=%s&p=%s",$picture->getId(),$appId,$page))) ; ?></li>
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
			<?php echo AdminTools::link_to_creator("<<", "mi/forumposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=1&so=%d",$appId,$forumId,$sortKind))) ; ?>
			<?php echo AdminTools::link_to_creator("<", "mi/forumposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d&so=%d",$appId,$forumId,$page-1,$sortKind))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to_creator($workPage, "mi/forumposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d&so=%d",$appId,$forumId,$workPage,$sortKind))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to_creator(">", "mi/forumposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d&so=%d",$appId,$forumId,$page+1,$sortKind) )) ; ?>
			<?php echo AdminTools::link_to_creator(">>", "mi/forumposts", array("class"=>"inactive", "query_string"=>sprintf("a=%s&f=%d&p=%d&so=%d",$appId,$forumId,$lastPage,$sortKind) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
