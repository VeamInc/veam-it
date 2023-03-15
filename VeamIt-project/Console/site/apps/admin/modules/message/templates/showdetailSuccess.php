<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Message</h5></div>
		<?php foreach($appCreatorMessages as $appCreatorMessage): ?>
		<h6><span><?php echo $appCreatorMessage->getCreatedAt() ?></span> <?php echo ($appCreatorMessage->getDirection()==1)?$appCreator->getUsername():$appCreatorMessage->getMcnUserName() ?></h6>
		<pre><?php echo $appCreatorMessage->getMessage() ?></pre>
		<br />
		<?php endforeach ?>

		<!-- Start pagination-->
		<div id="pagination">
			<span class="all">Page <?php echo $page ?> of <?php echo $lastPage ?></span>
			<?php if($page != 1): ?>
			<?php echo AdminTools::link_to("<<", "message/showdetail", array("class"=>"inactive", "query_string"=>sprintf("c=%d&&p=1",$appCreatorId))) ; ?>
			<?php echo AdminTools::link_to("<", "message/showdetail", array("class"=>"inactive", "query_string"=>sprintf("c=%d&p=%d",$appCreatorId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "message/showdetail", array("class"=>"inactive", "query_string"=>sprintf("c=%d&p=%d",$appCreatorId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "message/showdetail", array("class"=>"inactive", "query_string"=>sprintf("c=%d&p=%d",$appCreatorId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "message/showdetail", array("class"=>"inactive", "query_string"=>sprintf("c=%d&p=%d",$appCreatorId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->
	</div>
</div>
<!-- end: Right Content -->
