<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">PDF</h5></div>

		<div class="element-select">
			App :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d&s=%d',$sf_context->getModuleName(),$sf_context->getActionName(),0,$sortKind,$status), false) ?>" <?php if(!$appId) echo 'selected' ; ?>>All</option>
				<?php foreach($allApps as $workApp): ?>
				<?php if($workApp->getStatus() != 1): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d&s=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$workApp->getId(),$sortKind,$status), false) ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
				<?php endif ?>
				<?php endforeach ?>
			</select>

			Status :
			<select onChange="selectJump(this)">
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d&s=-1',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$sortKind), false) ?>" <?php if($status === null) echo 'selected' ; ?>>All</option>
				<?php foreach($statuses as $workStatus => $statusName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d&s=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$sortKind,$workStatus), false) ?>" <?php if($status == $workStatus) echo 'selected' ; ?>><?php echo $statusName ?></option>
				<?php endforeach ?>
			</select>

			<span class="pull-right">
			View :
			<select onChange="selectJump(this)">
				<?php foreach($sortKinds as $workSortKind => $sortName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?a=%s&p=1&so=%d&s=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$appId,$workSortKind,$status), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
				<?php endforeach ?>
			</select>
			</span>
			<p style="clear:both" />
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($sellPdfs) > 0): ?>
		<?php 
			foreach($sellPdfs as $sellPdf): 
				$app = $appMap[$sellPdf->getAppId()] ;
				if($app){
					$appName = $app->getName() ;
				} else {
					$appName = "" ;
				}

				$pdf = $pdfMap[$sellPdf->getPdfId()] ;
				$contentName = $pdf->getTitle() ;
				$thumbnailUrl = $pdf->getThumbnailUrl() ;
				$currentStatus = $sellPdf->getStatus() ;
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="120" height="120" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $sellPdf->getCreatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ?></li>
							<li>Status : <?php echo $statuses[$currentStatus] ?></li>
							<?php if($currentStatus == 3): ?>
							<li><i class="icon-info-sign"></i><a href="/admin.php/help/registerppc?k=3&i=<?php echo $sellPdf->getId() ?>" >Register to app store</a></li>
							<?php endif ?>
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
			<?php echo AdminTools::link_to("<<", "paypercontent/listpdf", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=1&so=%d&s=%d",$appId,$sortKind,$status))) ; ?>
			<?php echo AdminTools::link_to("<", "paypercontent/listpdf", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d&s=%d",$appId,$page-1,$sortKind,$status))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "paypercontent/listpdf", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d&s=%d",$appId,$workPage,$sortKind,$status))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "paypercontent/listpdf", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d&s=%d",$appId,$page+1,$sortKind,$status) )) ; ?>
			<?php echo AdminTools::link_to(">>", "paypercontent/listpdf", array("class"=>"inactive", "query_string"=>sprintf("a=%s&p=%d&so=%d&s=%d",$appId,$lastPage,$sortKind,$status) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
