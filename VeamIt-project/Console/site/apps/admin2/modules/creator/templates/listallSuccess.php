<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">All Creators</h5></div>

	<span class="pull-right">
		<?php echo AdminTools::link_to('<i class="icon-plus-sign"></i>Add New', "creator/inputnew", array("class"=>"btn btn-mini")) ; ?>
	</span>
	<p style="clear:both" />

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

	<?php if(count($creators) > 0): ?>

	<?php 
		foreach($creators as $creator):
			$userName = $creator->getUsername() ;
			$app = $appMap[$creator->getAppId()] ;
			if($app){
				$appName = $app->getName() ;
			} else {
				$appName = "Unknown" ;
			}
	?>
	<div class="media">
		<div class="media-body">
			<div class="media-content">
				<h6><?php echo $userName ?></h6>
				<div class="bottom-article-no-margin">
					<ul class="meta-post">
						<li><i class="icon-calendar"></i>Registered at <?php echo $creator->getCreatedAt() ?></li>
						<li><i class="icon-folder-open"></i><?php echo $appName ?></li>
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
		<?php echo AdminTools::link_to("<<", "creator/listall", array("class"=>"inactive", "query_string"=>sprintf("p=1"))) ; ?>
		<?php echo AdminTools::link_to("<", "creator/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page-1))) ; ?>
		<?php endif ?>
		<?php 
			for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
				if($workPage == $page){
					echo sprintf('<span class="current">%d</span>',$workPage) ;
				} else {
					echo AdminTools::link_to($workPage, "creator/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$workPage))) ;
				}
			}
		?>
		<?php if($page != $lastPage): ?>
		<?php echo AdminTools::link_to(">", "creator/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page+1) )) ; ?>
		<?php echo AdminTools::link_to(">>", "creator/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$lastPage) )) ; ?>
		<?php endif ?>
	</div>
	<!-- End pagination-->

	<?php else: ?>
	There are no results.
	<?php endif ?>

</div>
<!-- end: Right Content -->
