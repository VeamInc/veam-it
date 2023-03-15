<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">YouTube Videos</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),0), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId()), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endforeach ?>
			</select>
			Category :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&c=0&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$appId), false) ?>" <?php if(!$categoryId) echo 'selected' ; ?>>All</option>
				<?php foreach($categoriesForList as $category): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&c=%s&p=1',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$category->getId()), false) ?>" <?php if($categoryId == $category->getId()) echo 'selected' ; ?>><?php echo AdminTools::unescapeName($category->getName()) ?></option>
				<?php endforeach ?>
			</select>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($youtubeVideos) > 0): ?>
		<?php 
			foreach($youtubeVideos as $youtubeVideo): 
				$app = $appMap[$youtubeVideo->getAppId()] ;
				if($app){
					$appName = $app->getName() ;
				} else {
					$appName = "" ;
				}
				$category = $categoryMap[$youtubeVideo->getCategoryId()] ;
				if($category){
					$categoryName = $category->getName() ;
				} else {
					$categoryName = "" ;
				}
				$description = AdminTools::unescapeName($youtubeVideo->getDescription()) ;
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo sprintf("http://img.youtube.com/vi/%s/default.jpg",$youtubeVideo->getYoutubeCode()) ?>" alt="" width="120" height="90" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo AdminTools::unescapeName($youtubeVideo->getTitle()) ?></h6>

					<div class="accordion stripped" id="accordion-comment<?php echo $youtubeVideo->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $youtubeVideo->getId() ?>" href="#collapse-comment<?php echo $youtubeVideo->getId() ?>"><span class="icon-pencil"></span> Description</a>
							</div>
							<div id="collapse-comment<?php echo $youtubeVideo->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">

									<pre><?php echo AdminTools::unescapeName($description) ?></pre>

								</div>
							</div>
						</div>
					</div>

					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $youtubeVideo->getCreatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ." > " . AdminTools::unescapeName($categoryName) ?></li>
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
			<?php echo AdminTools::link_to("<<", "youtube/listvideos", array("class"=>"inactive", "query_string"=>sprintf("a=%s&c=%s&p=1",$appId,$categoryId))) ; ?>
			<?php echo AdminTools::link_to("<", "youtube/listvideos", array("class"=>"inactive", "query_string"=>sprintf("a=%s&c=%s&p=%d",$appId,$categoryId,$page-1))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "youtube/listvideos", array("class"=>"inactive", "query_string"=>sprintf("a=%s&c=%s&p=%d",$appId,$categoryId,$workPage))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "youtube/listvideos", array("class"=>"inactive", "query_string"=>sprintf("a=%s&c=%s&p=%d",$appId,$categoryId,$page+1) )) ; ?>
			<?php echo AdminTools::link_to(">>", "youtube/listvideos", array("class"=>"inactive", "query_string"=>sprintf("a=%s&c=%s&p=%d",$appId,$categoryId,$lastPage) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
