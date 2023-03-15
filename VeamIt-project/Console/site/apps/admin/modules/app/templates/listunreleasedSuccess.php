<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Unreleased Apps</h5></div>

		<div class="element-select">
			<span class="pull-right">
			View :
			<select onChange="selectJump(this)">
				<?php foreach($sortKinds as $workSortKind => $sortName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?p=1&so=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$workSortKind), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
				<?php endforeach ?>
			</select>
			</span>
			<p style="clear:both" />
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($apps) > 0): ?>

		<?php 
			foreach($apps as $app):
				$iconUrl = $app->getIconImage() ;
				if(!$iconUrl){
					$iconUrl = '/images/admin/assets/no_icon.png' ;
				}
				$appCreators = $appCreatorsMapForAppId[$app->getId()] ;
				$templateSubscription = $templateSubscriptionMapForAppId[$app->getId()] ;
				$paymentType = "" ;
				if($templateSubscription){
					$kind = $templateSubscription->getKind() ;
					if($kind == 4){
						$paymentType = "Subscription" ;
					} else if($kind == 6) {
						$paymentType = "One time" ;
					} else if($kind == 5) {
						$paymentType = "Pay Per Content" ;
					}
				}
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $iconUrl ?>" alt="" width="100" height="100" /></div>
			<div class="media-body">
				<div class="media-content">
					<?php echo AdminTools::link_to("<h6>".$app->getName()."</h6>", "app/showsummary", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i>Created at <?php echo $app->getCreatedAt() ?></li>
							<li><i class="icon-tags"></i>Status : <?php echo AdminTools::getAppStatusName($app->getStatus()) ?></li>
							<li><i class="icon-tags"></i>Payment Type : <?php echo $paymentType ?></li>
							<?php foreach($appCreators as $appCreator): ?>
							<li><i class="icon-user"></i><?php echo $appCreator->getUsername() ?></li>
							<?php endforeach ?>
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
			<?php echo AdminTools::link_to("<<", "app/listunreleased", array("class"=>"inactive", "query_string"=>sprintf("p=1&so=%d",$sortKind))) ; ?>
			<?php echo AdminTools::link_to("<", "app/listunreleased", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$page-1,$sortKind))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "app/listunreleased", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$workPage,$sortKind))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "app/listunreleased", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$page+1,$sortKind) )) ; ?>
			<?php echo AdminTools::link_to(">>", "app/listunreleased", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d",$lastPage,$sortKind) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
