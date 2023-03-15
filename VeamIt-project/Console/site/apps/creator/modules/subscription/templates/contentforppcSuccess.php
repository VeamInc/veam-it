<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Contents') ?></h5></div>
		<a href="/creator.php/subscription/addnewvideoforppc"><span class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New Video') ?></span></a><br /><br />
		<a href="/creator.php/subscription/addnewaudioforppc"><span class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New Audio') ?></span></a><br /><br />
		<a href="/creator.php/subscription/addnewpdfforppc"><span class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New PDF') ?></span></a><br /><br />
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($sellItems) > 0): ?>
		<?php 
			foreach($sellItems as $id=>$sellItem): 
				$elements = explode('_',$id) ;
				$kind = $elements[0] ;
				$contentName = "" ;
				$thumbnailUrl = "" ;
				$price = "" ;
				$description = "" ;
				$hasLink = false ;
				$audioLink = "" ;

				$price = $sellItem->getPriceText() ;
				$description = $sellItem->getDescription() ;
				$status = $sellItem->getStatus() ;

				if($kind == 'video'){
					$sellVideo = $sellItem ;
					$video = $videoMap[$sellVideo->getVideoId()] ;
					$contentName = $video->getTitle() ;
					$thumbnailUrl = $video->getThumbnailUrl() ;
				} else if($kind == 'audio'){
					$sellAudio = $sellItem ;
					$audio = $audioMap[$sellAudio->getAudioId()] ;
					$contentName = $audio->getTitle() ;
					$thumbnailUrl = $audio->getRectangleImageUrl() ;
					$audioLink = $audio->getLinkUrl() ;
					if($audioLink){
						$hasLink = true ;
					}
				} else if($kind == 'pdf'){
					$sellPdf = $sellItem ;
					$pdf = $pdfMap[$sellPdf->getPdfId()] ;
					$contentName = $pdf->getTitle() ;
					$thumbnailUrl = $pdf->getThumbnailUrl() ;
				}

				$description = str_replace('&amp;#xA;','<br />',$description) ;

				if($status == 0){
					$statusText = 'Ready' ;
				} else if($status == 2){
					$statusText = 'Preparing' ;
				} else if($status == 3){
					$statusText = 'Waiting for approval' ;
				}
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="120" height="120" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $sellItem->getCreatedAt() ?></li>
							<li><i class="icon-money"></i><?php echo $price ?></li>
							<li>
							<?php if($kind == 'video'){ ?>
								<i class="icon-facetime-video"></i><?php echo __('Video') ?>
							<?php } else if($kind == 'audio'){ ?>
								<i class="icon-music"></i><?php echo __('Audio') ?>
							<?php } else if($kind == 'pdf'){ ?>
								<i class="icon-book"></i>PDF
							<?php } ?>
							</li>
							<li><i class="icon-flag"></i><?php echo __('Status') ?> : <?php echo __($statusText) ?></li>
							<?php if($hasLink): ?>
							<li><i class="icon-external-link"></i><a href="<?php echo $audioLink ?>" target="_blank"><?php echo $audioLink ?></a></li>
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

		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
