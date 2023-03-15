<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Messages from youtuber</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),0), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%d&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId()), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endforeach ?>
			</select>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($appCreatorMessageLatests) > 0): ?>
		<?php 
			foreach($appCreatorMessageLatests as $appCreatorMessageLatest): 
				$app = $appMap[$appCreatorMessageLatest->getAppId()] ;
				if($app){
					$appName = $app->getName() ;
				} else {
					$appName = "" ;
				}
				$appCreatorId = $appCreatorMessageLatest->getAppCreatorId() ;
				$appCreator = $appCreatorMap[$appCreatorId] ;
				$appCreatorMessages = $appCreatorMessagesMap[$appCreatorId] ;
		?>
		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo sprintf("%s %s (%s)",$appCreator->getFirstName(),$appCreator->getLastName(),$appCreator->getUsername()) ; ?></h6>

					<div class="accordion stripped" id="accordion-comment<?php echo $appCreatorMessageLatest->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $appCreatorMessageLatest->getId() ?>" href="#collapse-comment<?php echo $appCreatorMessageLatest->getId() ?>"><span class="icon-envelope"></span> Latest <?php echo count($appCreatorMessages) ?> Messages </a>
							</div>
							<div id="collapse-comment<?php echo $appCreatorMessageLatest->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">

									<?php foreach($appCreatorMessages as $appCreatorMessage): ?>
									<h6><span><?php echo $appCreatorMessage->getCreatedAt() ?></span> <?php echo $appCreatorMessage->getDirection()==1?$appCreator->getUsername():$appCreatorMessage->getMcnUserName() ?></h6>
									<pre><?php echo $appCreatorMessage->getMessage() ?></pre>
									<br />
									<?php endforeach ?>

								</div>
							</div>
						</div>
					</div>

					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $appCreatorMessageLatest->getUpdatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ?></li>
							<li><i class="icon-user"></i><?php echo $appCreator->getUsername() ?></li>
							<li><i class="icon-reply"></i><?php echo AdminTools::link_to('Reply','message/reply',array('query_string'=>sprintf('c=%d',$appCreatorId))) ?></li>
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
			<?php echo AdminTools::link_to("<<", "message/listfromcreator", array("class"=>"inactive", "query_string"=>sprintf("a=%d&p=1",$appId))) ; ?>
			<?php echo AdminTools::link_to("<", "message/listfromcreator", array("class"=>"inactive", "query_string"=>sprintf("a=%d&p=%d",$appId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "message/listfromcreator", array("class"=>"inactive", "query_string"=>sprintf("a=%d&p=%d",$appId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "message/listfromcreator", array("class"=>"inactive", "query_string"=>sprintf("a=%d&p=%d",$appId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "message/listfromcreator", array("class"=>"inactive", "query_string"=>sprintf("a=%dp=%d",$appId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
