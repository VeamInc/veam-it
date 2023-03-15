<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Long Delayed</h5></div>

		<?php if(count($delays) > 0): ?>
		<?php 
			foreach($delays as $delay): 
				$app = $appMap[$delay->getAppId()] ;
				if($app){
					$appName = $app->getName() ;
				} else {
					$appName = "" ;
				}
		?>
		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo $appName ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i>Due at <?php echo $delay->getDueAt() ?> (<?php echo AdminTools::getAgoString($delay->getDueAt()) ?>)</li>
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
			<?php echo AdminTools::link_to("<<", "subscription/listlongdelayed", array("class"=>"inactive", "query_string"=>sprintf("p=1"))) ; ?>
			<?php echo AdminTools::link_to("<", "subscription/listlongdelayed", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "subscription/listlongdelayed", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "subscription/listlongdelayed", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "subscription/listlongdelayed", array("class"=>"inactive", "query_string"=>sprintf("p=%d",$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
