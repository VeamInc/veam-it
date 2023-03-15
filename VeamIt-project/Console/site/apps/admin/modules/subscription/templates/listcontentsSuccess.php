<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Contents</h5></div>

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
			<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="120" height="120" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $mixed->getUpdatedAt() ?></li>
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
			<?php echo AdminTools::link_to("<<", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1",$appId))) ; ?>
			<?php echo AdminTools::link_to("<", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "subscription/listcontents", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d",$appId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
