<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">All Apps</h5></div>

			<span class="pull-left">
				<form action="<?php echo url_for('app/listall') ?>" method="post">
					<input type="text" id="na" name="na" value="<?php echo $appName ?>">
					<input type="hidden" name="so" value="<?php echo $sortKind ?>" />
					<input type="submit" value="Search" />
				</form>
			</span>

		<div class="element-select">
			<span class="pull-right">
			View :
			<select onChange="selectJump(this)">
				<?php foreach($sortKinds as $workSortKind => $sortName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?p=1&so=%d&na=%s',$sf_context->getModuleName(),$sf_context->getActionName(),$workSortKind,$appName), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
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
				$youtubeAdditionalChannels = $youtubeAdditionalChannelMapForAppId[$app->getId()] ;
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
				$lastUpdate = $lastUpdatedAt[$app->getId()] ;

		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $iconUrl ?>" alt="" width="100" height="100" /></div>
			<div class="media-body">
				<div class="media-content">
					<?php echo AdminTools::link_to("<h6>".$app->getName()."</h6>", "app/showsummary", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i>Created at <?php echo $app->getCreatedAt() ?></li>
							<?php if($app->getReleasedAt()): ?><li><i class="icon-calendar"></i>Released at <?php echo $app->getReleasedAt() ?></li><?php endif ?>
							<?php if($lastUpdate): ?><li><i class="icon-calendar"></i>Premium Updated at <?php echo $lastUpdate ?></li><?php endif ?>
							<li><i class="icon-tags"></i><?php echo AdminTools::link_to("Status : ".AdminTools::getAppStatusName($app->getStatus()), "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></li>
							<li><i class="icon-tags"></i>Payment Type : <?php echo $paymentType ?></li>
							<?php foreach($appCreators as $appCreator): ?>
							<li><i class="icon-user"></i><?php echo AdminTools::link_to($appCreator->getUsername(), "creator/listall", array("query_string"=>sprintf("c=%d",$appCreator->getId()))) ; ?></li>
							<?php endforeach ?>
							<li><i class="icon-plus-sign"></i><?php echo AdminTools::link_to("Add channel", "app/inputnewadditionalchannel", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></li>
							<div id="playlist_button_<?php echo $app->getId() ?>" style="display:block">
								<li><i class="icon-refresh"></i><?php echo AdminTools::link_to("Update playlists", "#", array("onclick"=>sprintf("updatePlaylists('%d')",$app->getId()))) ; ?></li>
							</div>
							<div id="playlist_indicator_<?php echo $app->getId() ?>" style="display:none">
								<li><img src="/images/admin/ajax-loader.gif">Updating</li>
							</div>

							<?php if($app->getStatus() == 0): ?>
							<div id="publish_button_<?php echo $app->getId() ?>" style="display:block">
								<li><i class="icon-cloud-upload"></i><?php echo AdminTools::link_to("Publish contents", "#", array("onclick"=>sprintf("publishContents('%d')",$app->getId()))) ; ?></li>
							</div>
							<div id="publish_indicator_<?php echo $app->getId() ?>" style="display:none">
								<li><img src="/images/admin/ajax-loader.gif">Publishing</li>
							</div>
							<?php endif ?>
						</ul>
					</div>
					<?php if(count($youtubeAdditionalChannels) > 0): ?>
					<table class="table table-striped">
					<thead>	<tr><th>#</th><th>Addisional Youtube Channel ID</th><th>Added at</th><th>Link</th></tr></thead>
					<tbody>
						<?php 
							$count = 0 ;
							foreach($youtubeAdditionalChannels as $youtubeAdditionalChannel){
							$count++ ;
						 ?>
							<tr><td><?php echo $count ?></td><td><?php echo $youtubeAdditionalChannel->getYoutubeChannelId() ?></td><td><?php echo $youtubeAdditionalChannel->getCreatedAt() ?></td><td style="width:15px"><a href="https://www.youtube.com/channel/<?php echo $youtubeAdditionalChannel->getYoutubeChannelId() ?>" target="_blank"><i class="icon-external-link"></i></a></td></tr>
						<?php } ?>
					</tbody>
					</table>
					<?php endif ?>
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
			<?php echo AdminTools::link_to("<<", "app/listall", array("class"=>"inactive", "query_string"=>sprintf("p=1&so=%d&na=%s",$sortKind,$appName))) ; ?>
			<?php echo AdminTools::link_to("<", "app/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page-1,$sortKind,$appName))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo AdminTools::link_to($workPage, "app/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$workPage,$sortKind,$appName))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo AdminTools::link_to(">", "app/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page+1,$sortKind,$appName) )) ; ?>
			<?php echo AdminTools::link_to(">>", "app/listall", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$lastPage,$sortKind,$appName) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->

<script type="text/javascript">

function updatePlaylists(appId)
{
	//alert(appId) ;
	document.getElementById("playlist_indicator_"+appId).style.display="block" ;
	document.getElementById("playlist_button_"+appId).style.display="none" ;

	$.ajax({
	    url:"/admin.php/app/updateplaylist?a="+appId,
	    type:"get",
	    dataType:"text",
		success: function(data, textStatus){
	      // 成功したとき
	      // data にサーバーから返された html が入る
			document.getElementById("playlist_indicator_"+appId).style.display="none" ;
			document.getElementById("playlist_button_"+appId).style.display="block" ;
			if(data == 'OK'){
				alert("Playlist updated") ;
			} else {
				alert("Failed to update : " + data) ;
			}
	    },
	    error: function(xhr, textStatus, errorThrown){
	      // エラー処理
			document.getElementById("playlist_indicator_"+appId).style.display="none" ;
			document.getElementById("playlist_button_"+appId).style.display="block" ;
			alert("Failed to update") ;
	    }
	}) ;
}

function publishContents(appId)
{
	//alert(appId) ;
	document.getElementById("publish_indicator_"+appId).style.display="block" ;
	document.getElementById("publish_button_"+appId).style.display="none" ;

	$.ajax({
	    url:"/admin.php/app/publishcontent?a="+appId,
	    type:"get",
	    dataType:"text",
		success: function(data, textStatus){
	      // 成功したとき
	      // data にサーバーから返された html が入る
			document.getElementById("publish_indicator_"+appId).style.display="none" ;
			document.getElementById("publish_button_"+appId).style.display="block" ;
			if(data == 'OK'){
				alert("Published") ;
			} else {
				alert("Failed to publish : " + data) ;
			}
	    },
	    error: function(xhr, textStatus, errorThrown){
	      // エラー処理
			document.getElementById("publish_indicator_"+appId).style.display="none" ;
			document.getElementById("publish_button_"+appId).style.display="block" ;
			alert("Failed to publish") ;
	    }
	}) ;
}

</script>
