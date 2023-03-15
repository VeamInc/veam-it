<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Notifications</h5></div>

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
			<a href="/creator2.php/mi/editnotification" class="btn btn-mini"><i class="icon-plus-sign"></i>Send New Notification</a>	</span>
		<p style="clear:both" />

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

		<?php if(count($notifications) > 0): ?>

		<?php 
			$currentIndex = $startIndex ;
			foreach($notifications as $notification):
				$index = $currentIndex ;
				$currentIndex-- ;
				$notificationGroupId = $notification->getNotificationGroupId() ;
				if($notificationGroupId){
					$notificationGroup = $notificationGroupMap[$notificationGroupId] ;
					if($notificationGroup){
						$notificationGroupName = $notificationGroup->getName() ;
					} else {
						$notificationGroupName = 'Unknown' ;
					}
				} else {
					$notificationGroupName = 'All Users' ;
				}
		?>
		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<h6><span>[<?php echo $index ?>]</span> <?php echo $notification->getMessage() ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $notification->getCreatedAt() ?></li>
							<li><i class="icon-group"></i><?php echo $notificationGroupName ?></li>
							<li><i class="icon-tags"></i>Status : <?php echo $statuses[$notification->getStatus()] ?></a></li>
							<li><i class="icon-trash"></i><?php echo link_to("Remove", "mi/deletenotification", array("onclick"=>"return confirm('Remove this notification?')","query_string"=>sprintf("i=%d",$notification->getId()))) ; ?></li>
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
			<?php echo link_to("<<", "mi/notification", array("class"=>"inactive", "query_string"=>sprintf("p=1&so=%d&na=%s",$sortKind,$userName))) ; ?>
			<?php echo link_to("<", "mi/notification", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page-1,$sortKind,$userName))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo link_to($workPage, "mi/notification", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$workPage,$sortKind,$userName))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo link_to(">", "mi/notification", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page+1,$sortKind,$userName) )) ; ?>
			<?php echo link_to(">>", "mi/notification", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$lastPage,$sortKind,$userName) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->

