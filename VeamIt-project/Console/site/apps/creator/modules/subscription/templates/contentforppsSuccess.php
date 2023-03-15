<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Contents') ?></h5></div>
		<a href="/creator.php/subscription/addnewvideoforpps"><span class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New Video') ?></span></a><br /><br />
		<a href="/creator.php/subscription/addnewaudioforpps"><span class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New Audio') ?></span></a>
		<div class="element-select">
			<?php echo __('View') ?> :
			<select onChange="selectJump(this)">
				<?php foreach($sortKinds as $workSortKind => $sortName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$workSortKind), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo __($sortName) ?></option>
				<?php endforeach ?>
			</select>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($sellSectionItems) > 0): ?>
		<?php 
			foreach($sellSectionItems as $sellSectionItem): 
				$appName = $app->getName() ;

				$kind = $sellSectionItem->getKind() ;
				$contentName = "" ;
				$thumbnailUrl = "" ;
				$hasLink = false ;
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
					$audioLink = $audio->getLinkUrl() ;
					if($audioLink){
						$hasLink = true ;
					}
					$thumbnailUrl = $audio->getRectangleImageUrl() ;
				}

				/*
				$thumbnailUrl = $sellSectionItem->getThumbnailUrl() ;
				if(!$thumbnailUrl){
					if(($kind == 7) || ($kind == 8)){
						$thumbnailUrl = "/images/admin/assets/grid_video.png" ;
					} else if(($kind == 9) || ($kind == 10)){
						$thumbnailUrl = "/images/admin/assets/grid_audio.png" ;
					}
				}
				*/

				$status = $sellSectionItem->getStatus() ;
				if($status == 0){
					$statusText = "Ready" ;
				} else if($status == 2){
					$statusText = "Preparing" ;
				}

		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="120" height="120" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $sellSectionItem->getCreatedAt() ?></li>
							<li>
							<?php if($sellSectionItem->getKind() == 1){ ?>
								<i class="icon-facetime-video"></i><?php echo __('Video') ?>
							<?php } else if($sellSectionItem->getKind() == 2){ ?>
								<i class="icon-book"></i>PDF
							<?php } else if($sellSectionItem->getKind() == 3){ ?>
								<i class="icon-music"></i><?php echo __('Audio') ?>
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

		<!-- Start pagination-->
		<div id="pagination">
			<span class="all"><?php echo __('Page') ?> <?php echo $page ?> <?php echo __('of') ?> <?php echo $lastPage ?></span>
			<?php if($page != 1): ?>
			<?php echo link_to("<<", "subscription/content", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1&so=%d",$appId,$sortKind))) ; ?>
			<?php echo link_to("<", "subscription/content", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$page-1,$sortKind))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo link_to($workPage, "subscription/content", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$workPage,$sortKind))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo link_to(">", "subscription/content", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$page+1,$sortKind) )) ; ?>
			<?php echo link_to(">>", "subscription/content", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$lastPage,$sortKind) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->




		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
