<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Links</h5></div>

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
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$workSortKind), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
				<?php endforeach ?>
			</select>
			</span>
			<p style="clear:both" />
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($webs) > 0): ?>
		<?php 
			foreach($webs as $web): 
				$app = $appMap[$web->getAppId()] ;
				if($app){
					$appName = $app->getName() ;
				} else {
					$appName = "" ;
				}
		?>
		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo $web->getTitle() ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $web->getCreatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ?></li>
							<li><i class="icon-external-link"></i><a href="<?php echo $web->getUrl() ?>" target="_blank"><?php echo $web->getUrl() ?></a></li>
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
			<?php echo AdminTools::link_to("<<", "link/listlinks", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1&so=%d",$appId,$sortKind))) ; ?>
			<?php echo AdminTools::link_to("<", "link/listlinks", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$page-1,$sortKind))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "link/listlinks", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$workPage,$sortKind))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "link/listlinks", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$page+1,$sortKind) )) ; ?>
			<?php echo AdminTools::link_to(">>", "link/listlinks", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d",$appId,$lastPage,$sortKind) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
