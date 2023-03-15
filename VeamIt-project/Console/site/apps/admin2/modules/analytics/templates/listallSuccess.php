<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Analytics</h5></div>

		<?php if(count($apps) > 0): ?>

		<?php 
			foreach($apps as $app):
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
					<?php echo AdminTools::link_to_admin_public("Analytics", "analytics/show", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?>
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
			<?php echo AdminTools::link_to_admin_public("<<", "analytics/listall", array("class"=>"inactive", "query_string"=>sprintf("p=1&so=%d",$sortKind))) ; ?>
			<?php echo AdminTools::link_to_admin_public("<", "analytics/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$page-1,$sortKind))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to_admin_public($workPage, "analytics/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$workPage,$sortKind))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to_admin_public(">", "analytics/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$page+1,$sortKind) )) ; ?>
			<?php echo AdminTools::link_to_admin_public(">>", "analytics/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$lastPage,$sortKind) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
