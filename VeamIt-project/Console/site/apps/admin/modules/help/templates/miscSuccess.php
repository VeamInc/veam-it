<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td>-</td><td>Check the followings</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>4 inch screenshots [EXCLUSIVE -> PREMIUM] <a href="/admin.php/app/updatescreenshot/?a=<?php echo $app->getId() ?>" target="_blank">update</a> if needed<br />
					<?php if($app->getScreenShot1()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot1() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot2()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot2() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot3()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot3() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot4()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot4() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot5()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot5() ?>" alt="" width="120" height="213" /></div><?php endif ?>
				</td></tr>
				<?php if(preg_match('/exclusive/i',$app->getDescription())): ?>
				<?php $styledDescription = str_replace('exclusive','<font color="red">exclusive</font>',$appDescription) ?>
				<?php $styledDescription = str_replace('Exclusive','<font color="red">Exclusive</font>',$styledDescription) ?>
				<tr><td><?php echo $lineNo++ ?></td><td>App Store Description [EXCLUSIVE -> PREMIUM]<br />
					<pre><?php echo str_replace('exclusive','<font color="red">exclusive</font>',$styledDescription) ?></pre>
				</td></tr>
				<?php endif ?>
				<tr><td><?php echo $lineNo++ ?></td><td>About Subscription<br />
					<pre><?php echo $aboutSubscription ?></pre>
				</td></tr>


				<?php $subscriptionType = $templateSubscription->getKind() ?>
				<?php if($subscriptionType == 5): ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Exclusive Contents ( Payment type : Pay Per Content ) Please update the status <br /><br />
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

						<?php if($sellVideo->getStatus() == 3): ?>
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
						<?php endif ?>
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

						<?php if($sellAudio->getStatus() == 3): ?>
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
						<?php endif ?>
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

						<?php if($sellPdf->getStatus() == 3): ?>
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
						<?php endif ?>
						<?php endforeach ?>
						<!-- divider -->
						<div class="solidline">
						</div>
						<?php else: ?>
						There are no results.
						<?php endif ?>
				</td></tr>
				<?php endif /*subscriptionType*/?>



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


				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and approve if there is no issue.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
