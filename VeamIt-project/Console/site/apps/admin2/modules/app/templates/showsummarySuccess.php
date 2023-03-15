<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">App Summary</h5></div>

		<?php if($app): ?>

		<?php 
			$iconUrl = $app->getIconImage() ;
			if(!$iconUrl){
				$iconUrl = '/images/admin/assets/no_icon.png' ;
			}
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $iconUrl ?>" alt="" width="100" height="100" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo $app->getName() ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i>Created at <?php echo $app->getCreatedAt() ?></li>
							<li><i class="icon-tags"></i>Status : <?php echo AdminTools::getAppStatusName($app->getStatus()) ?></li>
						</ul>
					</div>
				</div>
			</div>
		</div>








		<!-- start: Accordion -->
		<div class="accordion faq" id="accordion-app-summary">


			<!-- 1.Subscription -->
			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-app-summary" href="#collapse-as-1">
					<i class="icon-plus"></i> 1.Subscription </a>
				</div>
				<div id="collapse-as-1" class="accordion-body collapse">
					<div class="accordion-inner">

						<?php if(count($mixeds) > 0): ?>
						<?php 
							foreach($mixeds as $mixed): 

								$kind = $mixed->getKind() ;
								$contentName = "" ;
								if(($kind == 7) || ($kind == 8)){
									$video = $videoMap[$mixed->getContentId()] ;
									$contentName = $video->getTitle() ;
								} else if(($kind == 9) || ($kind == 10)){
									$audio = $audioMap[$mixed->getContentId()] ;
									$contentName = $audio->getTitle() ;
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
							<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="100" height="100" /></div>
							<div class="media-body">
								<div class="media-content">
									<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
									<div class="bottom-article-no-margin">
										<ul class="meta-post">
											<li><i class="icon-calendar"></i><?php echo $mixed->getUpdatedAt() ?></li>
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
										</ul>
									</div>
								</div>
							</div>
						</div>
						<!-- divider -->
						<div class="solidline">
						</div>
						<?php endforeach ?>
						<?php echo AdminTools::link_to("+ALL", "subscription/listcontents", array("class"=>"pull-right", "query_string"=>sprintf("a=%d&p=1",$app->getId()))) ; ?>
						<p style="clear:both" />
						<?php else: ?>
						There are no results.
						<?php endif ?>

					</div>
				</div>
			</div>



			<!-- 2.Sorted YouTube List -->
			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-app-summary" href="#collapse-as-2">
					<i class="icon-plus"></i> 2.Sorted YouTube List </a>
				</div>
				<div id="collapse-as-2" class="accordion-body collapse">
					<div class="accordion-inner">

						<?php if(count($youtubeCategories) > 0): ?>
						<table class="table table-striped">
							<tbody>
								<?php 
									$count = 0 ;
									foreach($youtubeCategories as $youtubeCategory){
										$count++ ;
								?>
								<tr>
									<td><?php echo $count ?></td>
									<td><?php echo AdminTools::unescapeName($youtubeCategory->getName()) ?></td>
									<td><?php echo $youtubeCategory->getCreatedAt() ?></td>
									<td style="width:15px">
										<?php echo AdminTools::link_to('<i class="icon-folder-close"></i>', "youtube/listvideos", array("class"=>"contact-more","query_string"=>sprintf("a=%d&c=%d&p=1",$app->getId(),$youtubeCategory->getId()))) ; ?>
									</td>
								</tr>
								<?php } ?>
							</tbody>
						</table>
						<?php else: ?>
						There are no results.
						<?php endif ?>

					</div>
				</div>
			</div>


			<!-- 3.Forum -->
			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-app-summary" href="#collapse-as-3">
					<i class="icon-plus"></i> 3.Forum </a>
				</div>
				<div id="collapse-as-3" class="accordion-body collapse">
					<div class="accordion-inner">

						<?php if(count($forums) > 0): ?>
						<table class="table table-striped">
							<tbody>
								<?php 
									$count = 0 ;
									foreach($forums as $forum){
										$count++ ;
								?>
								<tr>
									<td><?php echo $count ?></td>
									<td><?php echo AdminTools::unescapeName($forum->getName()) ?></td>
									<td><?php echo $forum->getCreatedAt() ?></td>
									<td style="width:15px">
										<?php echo AdminTools::link_to('<i class="icon-folder-close"></i>', "forum/posts", array("class"=>"contact-more","query_string"=>sprintf("a=%d&f=%d&p=1",$app->getId(),$forum->getId()))) ; ?>
									</td>
								</tr>
								<?php } ?>
							</tbody>
						</table>
						<?php else: ?>
						There are no results.
						<?php endif ?>

					</div>
				</div>
			</div>


			<!-- 4.Report from Users -->
			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-app-summary" href="#collapse-as-4">
					<i class="icon-plus"></i> 4.Report from Users </a>
				</div>
				<div id="collapse-as-4" class="accordion-body collapse">
					<div class="accordion-inner">

						<?php if(count($reportSets) > 0): ?>

						<?php 
							foreach($reportSets as $reportSet): 
								$picture = $pictureMap[$reportSet->getContent()] ;
								if($picture):
									$reports = $reportsForReportSetId[$reportSet->getId()] ;
									$forum = $forumMap[$picture->getForumId()] ;
									if($forum){
										$forumName = AdminTools::unescapeName($forum->getName()) ;
									} else {
										$forumName = "" ;
									}
									$removed = $reportSet->getRemoved() ;
									if($removed){
										$opacityClass = "media-opacity40" ;
									} else {
										$opacityClass = "" ;
									}
						?>
						<div class="media <?php echo $opacityClass ?>">
							<div class="thumbnail pull-left"><img src="<?php echo $picture->getUrl() ?>" alt="" width="150" height="150" /></div>
							<div class="media-body">
								<div class="media-content">

									<div class="accordion faq" id="accordion-comment<?php echo $picture->getId() ?>">
										<div class="accordion-group">
											<div class="accordion-heading">
												<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $picture->getId() ?>" href="#collapse-comment<?php echo $picture->getId() ?>"><span class="icon-thumbs-down"></span> Reports(<?php echo count($reports) ?>) </a>
											</div>
											<div id="collapse-comment<?php echo $picture->getId() ?>" class="accordion-body collapse">
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

									<div class="bottom-article-no-margin">
										<ul class="meta-post">
											<li><i class="icon-calendar"></i>Posted at <?php echo $picture->getCreatedAt() ?></li>
											<li><i class="icon-calendar"></i>Reported at <?php echo $reportSet->getLastReportedAt() ?></li>
											<?php if($removed): ?>
											<li><i class="icon-calendar"></i>Removed at <?php echo $reportSet->getUpdatedAt() ?></li>
											<?php endif ?>
											<li><i class="icon-folder-open"></i><?php echo $forumName ?></li>
											<?php if(!$removed): ?>
											<li><i class="icon-trash"></i><?php echo AdminTools::link_to("Remove this post", "forum/deletepost", array("onclick"=>'return confirm("Remove this post?")',"query_string"=>sprintf("pid=%d&a=%s&p=%s",$picture->getId(),$app->getId(),$page))) ; ?></li>
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

						<?php echo AdminTools::link_to("+ALL", "forum/reports", array("class"=>"pull-right", "query_string"=>sprintf("a=%d&p=1",$app->getId()))) ; ?>
						<p style="clear:both" />


						<?php else: ?>
						There are no results.
						<?php endif ?>

					</div>
				</div>
			</div>


			<!-- 5.Link -->
			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-app-summary" href="#collapse-as-5">
					<i class="icon-plus"></i> 5.Link </a>
				</div>
				<div id="collapse-as-5" class="accordion-body collapse">
					<div class="accordion-inner">

						<?php if(count($webs) > 0): ?>
						<table class="table table-striped">
							<tbody>
								<?php 
									$count = 0 ;
									foreach($webs as $web){
										$count++ ;
								?>
								<tr>
									<td><?php echo $count ?></td>
									<td><?php echo $web->getTitle() ?></td>
									<td><?php echo $web->getCreatedAt() ?></td>
									<td style="width:15px">
										<?php echo AdminTools::link_to('<i class="icon-external-link"></i>', $web->getUrl(), array("class"=>"contact-more","target"=>"_blank")) ; ?>
									</td>
								</tr>
								<?php } ?>
							</tbody>
						</table>
						<?php else: ?>
						There are no results.
						<?php endif ?>

					</div>
				</div>
			</div>


			<!-- 6.Store Information -->
			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-app-summary" href="#collapse-as-6">
					<i class="icon-plus"></i> 6.Store Information </a>
				</div>
				<div id="collapse-as-6" class="accordion-body collapse">
					<div class="accordion-inner">

						<h6>Screen Shots</h6>
						<div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot1() ?>" alt="" width="123" height="220" /></div>
						<div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot2() ?>" alt="" width="123" height="220" /></div>
						<div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot3() ?>" alt="" width="123" height="220" /></div>
						<div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot4() ?>" alt="" width="123" height="220" /></div>
						<div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot5() ?>" alt="" width="123" height="220" /></div>
						<p style="clear:both" />
						<!-- divider -->
						<div class="solidline">
						</div>
						<!-- end divider -->

						<h6>Description</h6>
						<pre><?php echo $app->getDescription() ?></pre>
						<!-- divider -->
						<div class="solidline">
						</div>
						<!-- end divider -->

						<h6>Keywords</h6>
						<pre><?php echo $app->getKeyWord() ?></pre>
						<!-- divider -->
						<div class="solidline">
						</div>
						<!-- end divider -->

					</div>
				</div>
			</div>


		</div>
		<!--end: Accordion -->
		<?php endif ?>




















	</div>
</div>
<!-- end: Right Content -->
