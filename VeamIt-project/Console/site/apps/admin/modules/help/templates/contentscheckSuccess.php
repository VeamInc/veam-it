<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td>-</td><td>Check the followings</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>4 inch screenshots<br />
					<?php if($app->getScreenShot1()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot1() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot2()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot2() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot3()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot3() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot4()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot4() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot5()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot5() ?>" alt="" width="120" height="213" /></div><?php endif ?>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>3.5 inch screenshots to your mac<br />
					<?php if($app->getScreenShot1()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot1()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot2()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot2()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot3()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot3()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot4()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot4()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot5()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot5()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>icon image<br />
					<div class="thumbnail pull-left"><img src="<?php echo $app->getIconImage() ?>" alt="" width="128" height="128" /></div>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>App Name<br />
					<pre><?php echo $app->getName() ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Store App Name<br />
					<pre><?php echo $app->getStoreAppName() ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>App Store Description<br />
					<pre><?php echo $appDescription ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>App Store Keywords<br />
					<pre><?php echo $app->getKeyword() ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>App Store Category<br />
					<pre><?php echo $app->getCategory() ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Subscription Price<br />
					<pre><?php echo $templateSubscription->getPrice() ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>About Subscription<br />
					<pre><?php echo $aboutSubscription ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Rating questions
					<table class="table">
						<tbody>
							<?php foreach($questions as $question): ?>
								<tr><td><?php echo $question->getQuestion() ?></td>
									<td><?php if($answerMapForQuestion[$question->getId()]): ?>
											<?php echo $answerMapForQuestion[$question->getId()]->getAnswer(); ?>
										<?php else: ?>
											Not answered
										<?php endif ?>
									</td></tr>
							<?php endforeach ?>
							<tr><td>Unrestricted Web Access</td><td>Yes</td></tr>
							<tr><td>Gambling and Contests</td><td>No</td></tr>
						</tbody>
					</table>
				</td></tr>




				<tr><td><?php echo $lineNo++ ?></td><td>Premium Contents ( Payment type : 

						<?php $subscriptionType = $templateSubscription->getKind() ?>
						<?php if($subscriptionType == 4): ?>
						Subscription )<br /><br />
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
						<?php else: ?>
						There are no results.
						<?php endif ?>

						<?php elseif($subscriptionType == 6): /*OneTimePayment*/?>
							One time )<br /><br />
						<?php if(count($sellSectionItems) > 0): ?>
						<?php 
							foreach($sellSectionItems as $sellSectionItem): 

								$kind = $sellSectionItem->getKind() ;
								$contentName = "" ;
								if($kind == 1){
									$video = $videoMap[$sellSectionItem->getContentId()] ;
									$contentName = $video->getTitle() ;
									$thumbnailUrl = $video->getThumbnailUrl() ;
								} else if($kind == 2){
									$pdf = $pdfMap[$sellSectionItem->getContentId()] ;
									$contentName = $pdf->getTitle() ;
									$thumbnailUrl = $pdf->getThumbnailUrl() ;
								} else if($kind == 3){
									$audio = $audioMap[$sellSectionItem->getContentId()] ;
									$contentName = $audio->getTitle() ;
									$thumbnailUrl = $audio->getRectangleImageUrl() ;
								}
								$sellSectionCategory = $sellSectionCategoryMap[$sellSectionItem->getSellSectionCategoryId()] ;
						?>
						<div class="media">
							<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="100" height="100" /></div>
							<div class="media-body">
								<div class="media-content">
									<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
									<div class="bottom-article-no-margin">
										<ul class="meta-post">
											<li><i class="icon-calendar"></i><?php echo $sellSectionItem->getUpdatedAt() ?></li>
											<li>
											<?php if($sellSectionItem->getKind() == 1){ ?>
												<i class="icon-facetime-video"></i>Video
											<?php } else if($sellSectionItem->getKind() == 2){ ?>
												<i class="icon-book"></i>Pdf
											<?php } else if($sellSectionItem->getKind() == 3){ ?>
												<i class="icon-music"></i>Audio
											<?php } ?>
											</li>
											<li><i class="icon-folder-close"></i><?php echo $sellSectionCategory->getName() ?>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<!-- divider -->
						<div class="solidline">
						</div>
						<?php endforeach ?>
						<?php else: ?>
						There are no results.
						<?php endif ?>


						<?php elseif($subscriptionType == 5): ?>
							Pay Per Content )<br /><br />

						<?php if((count($sellVideos) > 0) || (count($sellAudios) > 0) || (count($sellPdfs) > 0)): ?>
						<?php 
							foreach($sellVideos as $sellVideo): 
								$contentName = "" ;
								$video = $videoMap[$sellVideo->getVideoId()] ;
								$contentName = $video->getTitle() ;
								$thumbnailUrl = $video->getThumbnailUrl() ;
								$videoCategory = $videoCategoryMap[$video->getVideoCategoryId()] ;
								$categoryName = "" ;
								if($videoCategory){
									$categoryName = $videoCategory->getName() ;
								}
						?>
						<div class="media">
							<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="100" height="100" /></div>
							<div class="media-body">
								<div class="media-content">
									<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
									<div class="bottom-article-no-margin">
										<ul class="meta-post">
											<li><i class="icon-calendar"></i><?php echo $sellVideo->getUpdatedAt() ?></li>
											<li><i class="icon-folder-close"></i><?php echo $categoryName ?>
											<li><i class="icon-facetime-video"></i>Video</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<?php endforeach ?>
						<?php 
							foreach($sellAudios as $sellAudio): 
								$contentName = "" ;
								$audio = $audioMap[$sellAudio->getAudioId()] ;
								$contentName = $audio->getTitle() ;
								$thumbnailUrl = $audio->getRectangleImageUrl() ;
								$audioCategory = $audioCategoryMap[$audio->getAudioCategoryId()] ;
								$categoryName = "" ;
								if($audioCategory){
									$categoryName = $audioCategory->getName() ;
								}
						?>
						<div class="media">
							<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="100" height="100" /></div>
							<div class="media-body">
								<div class="media-content">
									<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
									<div class="bottom-article-no-margin">
										<ul class="meta-post">
											<li><i class="icon-calendar"></i><?php echo $sellAudio->getUpdatedAt() ?></li>
											<li><i class="icon-folder-close"></i><?php echo $categoryName ?>
											<li><i class="icon-music"></i>Audio</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<?php endforeach ?>
						<?php 
							foreach($sellPdfs as $sellPdf): 
								$contentName = "" ;
								$pdf = $pdfMap[$sellPdf->getPdfId()] ;
								$contentName = $pdf->getTitle() ;
								$thumbnailUrl = $pdf->getThumbnailUrl() ;
								$pdfCategory = $pdfCategoryMap[$pdf->getPdfCategoryId()] ;
								$categoryName = "" ;
								if($pdfCategory){
									$categoryName = $pdfCategory->getName() ;
								}
						?>
						<div class="media">
							<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="100" height="100" /></div>
							<div class="media-body">
								<div class="media-content">
									<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
									<div class="bottom-article-no-margin">
										<ul class="meta-post">
											<li><i class="icon-calendar"></i><?php echo $sellPdf->getUpdatedAt() ?></li>
											<li><i class="icon-folder-close"></i><?php echo $categoryName ?>
											<li><i class="icon-book"></i>Pdf</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
						<?php endforeach ?>
						<!-- divider -->
						<div class="solidline">
						</div>
						<?php else: ?>
						There are no results.
						<?php endif ?>


						<?php endif /*subscriptionType*/?>

				</td></tr>



				<tr><td><?php echo $lineNo++ ?></td><td>Youtube Playlists
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
										<?php echo AdminTools::link_to('<i class="icon-folder-close"></i>', "youtube/listvideos", array("target"=>"_blank","class"=>"contact-more","query_string"=>sprintf("a=%d&c=%d&p=1",$app->getId(),$youtubeCategory->getId()))) ; ?>
									</td>
								</tr>
								<?php } ?>
							</tbody>
						</table>
						<?php else: ?>
						There are no results.
						<?php endif ?>
				</td></tr>


				<tr><td><?php echo $lineNo++ ?></td><td>Forum Themes
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
				</td></tr>


				<tr><td><?php echo $lineNo++ ?></td><td>Links
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
										<?php if(substr($web->getUrl(),0,4) == 'http'): ?>
											<?php echo link_to('<i class="icon-external-link"></i>', $web->getUrl(), array("class"=>"contact-more","target"=>"_blank")) ; ?>
										<?php else : ?>
											<?php echo $web->getUrl() ?>
										<?php endif ?>
									</td>
								</tr>
								<?php } ?>
							</tbody>
						</table>
						<?php else: ?>
						There are no results.
						<?php endif ?>
				</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and approve if there is no issue.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
