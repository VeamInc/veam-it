<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Contents</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),0,$sortKind), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId(),$sortKind), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endforeach ?>
			</select>

			<span class="pull-right">
			View :
			<select onChange="selectJump(this)">
				<?php foreach($sortKinds as $workSortKind => $sortName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$workSortKind), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
				<?php endforeach ?>
			</select>
			</span>
			<p style="clear:both" />
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($mixeds) > 0): ?>
		<?php 
			foreach($mixeds as $mixed): 
				$app = $appMap[$mixed->getAppId()] ;
				if($app){
					$appName = $app->getName() ;
				} else {
					$appName = "" ;
				}

				$kind = $mixed->getKind() ;
				$contentName = "" ;
				if(($kind == 7) || ($kind == 8)){
					$video = $videoMap[$mixed->getContentId()] ;
					$contentName = $video->getTitle() ;
					$numberOfLikes = $numberOfVideoLikes[$mixed->getContentId()] ;
					$comments = $videoCommentsMap[$mixed->getContentId()] ;
				} else if(($kind == 9) || ($kind == 10)){
					$audio = $audioMap[$mixed->getContentId()] ;
					$contentName = $audio->getTitle() ;
					$numberOfLikes = $numberOfAudioLikes[$mixed->getContentId()] ;
					$comments = $audioCommentsMap[$mixed->getContentId()] ;
				}

				$thumbnailUrl = $mixed->getThumbnailUrl() ;
				if(!$thumbnailUrl){
					if(($kind == 7) || ($kind == 8)){
						$thumbnailUrl = "/images/admin/assets/grid_video.png" ;
					} else if(($kind == 9) || ($kind == 10)){
						$thumbnailUrl = "/images/admin/assets/grid_audio.png" ;
					}
				}

		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="120" height="120" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $mixed->getCreatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ?></li>
							<li>
							<?php if($mixed->getKind() == 7){ ?>
								<i class="icon-facetime-video"></i>Bonus Video
							<?php } else if($mixed->getKind() == 8){ ?>
								<i class="icon-facetime-video"></i>Video
							<?php } else if($mixed->getKind() == 9){ ?>
								<i class="icon-music"></i>Bonus Audio
							<?php } else if($mixed->getKind() == 10){ ?>
								<i class="icon-music"></i>Audio
							<?php } ?>
							</li>
							<li><i class="icon-heart"></i><?php echo sprintf("%d",$numberOfLikes) ?></li>
						</ul>
					</div>

					<div class="accordion stripped" id="accordion-comment<?php echo $mixed->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $mixed->getId() ?>" href="#collapse-comment<?php echo $mixed->getId() ?>"><span class="icon-comment"></span> Comments(<?php echo count($comments) ?>) </a>
							</div>
							<div id="collapse-comment<?php echo $mixed->getId() ?>" class="accordion-body collapse">
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
			<?php echo AdminTools::link_to("<<", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1&so=%d",$appId,$sortKind))) ; ?>
			<?php echo AdminTools::link_to("<", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$page-1,$sortKind))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$workPage,$sortKind))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$page+1,$sortKind) )) ; ?>
			<?php echo AdminTools::link_to(">>", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$lastPage,$sortKind) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
