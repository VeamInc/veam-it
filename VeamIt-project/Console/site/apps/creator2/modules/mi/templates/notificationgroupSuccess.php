<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Notification groups</h5></div>

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

		<span class="pull-right">
			<a href="/creator2.php/mi/editnotificationgroup" class="btn btn-mini"><i class="icon-plus-sign"></i>Add New</a>	</span>
		<p style="clear:both" />

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

		<?php if(count($notificationGroups) > 0): ?>

		<?php 
			$currentIndex = $startIndex ;
			foreach($notificationGroups as $notificationGroup):
				$index = $currentIndex ;
				$currentIndex-- ;
		?>
		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<h6><span>[<?php echo $index ?>]</span> <?php echo $notificationGroup->getName() ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $notificationGroup->getCreatedAt() ?></li>
							<li><i class="icon-trash"></i><?php echo link_to("Remove", "mi/deletenotificationgroup", array("onclick"=>"return confirm('Remove this notification group?')","query_string"=>sprintf("i=%d",$notificationGroup->getId()))) ; ?></li>
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
			<?php echo link_to("<<", "mi/notificationGroup", array("class"=>"inactive", "query_string"=>sprintf("p=1&so=%d&na=%s",$sortKind,$userName))) ; ?>
			<?php echo link_to("<", "mi/notificationGroup", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page-1,$sortKind,$userName))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo link_to($workPage, "mi/notificationGroup", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$workPage,$sortKind,$userName))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo link_to(">", "mi/notificationGroup", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page+1,$sortKind,$userName) )) ; ?>
			<?php echo link_to(">>", "mi/notificationGroup", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$lastPage,$sortKind,$userName) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->

