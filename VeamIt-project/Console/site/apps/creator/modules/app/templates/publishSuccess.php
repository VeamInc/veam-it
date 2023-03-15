<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Publish') ?></h5></div>
		<?php if($app): ?>

		<?php if($isAppReleased): ?>
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->
		<h6><?php echo __('Exclusive Content') ?> ( <?php echo __('Latest') ?> 10 )</h6>
		<?php if(count($mixeds) > 0): ?>
		<?php 
			foreach($mixeds as $mixed): 
				$kind = $mixed->getKind() ;
				$contentName = "" ;
				$hasLink = false ;
				if(($kind == 7) || ($kind == 8)){
					$video = $videoMap[$mixed->getContentId()] ;
					$contentName = $video->getTitle() ;
				} else if(($kind == 9) || ($kind == 10)){
					$audio = $audioMap[$mixed->getContentId()] ;
					$contentName = $audio->getTitle() ;
					$audioLink = $audio->getLinkUrl() ;
					if($audioLink){
						$hasLink = true ;
					}
				}

				$thumbnailUrl = $mixed->getThumbnailUrl() ;
				if(!$thumbnailUrl){
					if(($kind == 7) || ($kind == 8)){
						$thumbnailUrl = "/images/admin/assets/grid_video.png" ;
					} else if(($kind == 9) || ($kind == 10)){
						$thumbnailUrl = "/images/admin/assets/grid_audio.png" ;
					}
				}

				$status = $mixed->getStatus() ;
				if($status == 0){
					$statusText = "Ready" ;
				} else if($status == 2){
					$statusText = "Preparing" ;
				}

		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $thumbnailUrl ?>" alt="" width="120" height="120" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo AdminTools::unescapeName($contentName) ?></h6>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $mixed->getCreatedAt() ?></li>
							<li>
							<?php if($mixed->getKind() == 7){ ?>
								<i class="icon-facetime-video"></i><?php echo __('Bonus Video') ?>
							<?php } else if($mixed->getKind() == 8){ ?>
								<i class="icon-facetime-video"></i><?php echo __('Video') ?>
							<?php } else if($mixed->getKind() == 9){ ?>
								<i class="icon-music"></i><?php echo __('Bonus Audio') ?>
							<?php } else if($mixed->getKind() == 10){ ?>
								<i class="icon-music"></i><?php echo __('Audio') ?>
							<?php } ?>
							</li>
							<li><i class="icon-flag"></i><?php echo __('Status') ?> : <?php echo $statusText ?></li>
							<?php if($hasLink): ?>
							<li><i class="icon-external-link"></i><a href="<?php echo $audioLink ?>" target="_blank"><?php echo $audioLink ?></a></li>
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
		<?php endif ?>


		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->
		<h6><?php echo __('Forum Categories') ?></h6>
		<?php if(count($forums) > 0): ?>
		<table class="table table-striped">
			<thread>
				<th><?php echo __('Name') ?></th>
			</thread>
			<tbody>
				<?php 
					$count = 0 ;
					foreach($forums as $forum){
						$count++ ;
				?>
				<tr>
					<td><span id="<?php echo $forum->getId() ?>"><?php echo AdminTools::unescapeName($forum->getName()) ?></span></td>
				</tr>
				<?php } ?>
			</tbody>
		</table>
		<?php endif ?>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->
		<h6><?php echo __('Links') ?></h6>
		<?php if(count($webs) > 0): ?>
		<table class="table table-striped">
			<thread>
				<th><?php echo __('Name') ?></th>
				<th>URL</th>
			</thread>
			<tbody>
				<?php 
					$count = 0 ;
					foreach($webs as $web){
						$count++ ;
				?>
				<tr>
					<td><span id="<?php echo $web->getId() ?>"><?php echo AdminTools::unescapeName($web->getTitle()) ?></span></td>
					<td><span id="url_<?php echo $web->getId() ?>"><?php echo AdminTools::unescapeName($web->getUrl()) ?></span></td>
				</tr>
				<?php } ?>
			</tbody>
		</table>
		<?php endif ?>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->
		<span id="save_button" class="pull-right btn btn-theme"><i class="icon-upload-alt"></i><?php echo __('Publish') ?></span>

<script type="text/javascript">
$('span#save_button').click(function(){

	var url = '/creator.php/app/publishappapi/' ;

	if(confirm('<?php echo __('Publish contents?') ?>')){
		$.ajax({
			type: "POST",
			url: url,
			data: {
		        'accept': 1,
		    },
			dataType: "json",
			cache: false,
			success: function(data, textStatus){
				/*
				$(data.number_of_groups_target).html(data.number_of_groups);
				$(data.html_target).html(data.html);
				*/
				if(data.message){
					alert(data.message) ;
				} else {
					alert("<?php echo __('Published') ?>") ;
				}
			},
			error: function(xhr, textStatus, errorThrown){
				//alert('Error! ' + textStatus + ' ' + errorThrown);
				location.href = '/creator.php/login' ;
			}
		});
	}
});

</script>

		<?php else: ?>
		<?php echo __('The app is not released yet.') ?>
		<?php endif ?>
		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
