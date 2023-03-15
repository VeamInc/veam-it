<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Access Count</h5></div>
		<span class="pull-left">
			<table border="1">
				<tr><td></td><td></td><td></td><td></td><td colspan="<?php echo count($dates) ?>"><b># Updates per Month(Veam updated at <?php echo date('Y-m-d') ?>)</b></td></tr>
				<tr><td>No.</td><td>Name</td><td><b>Channel URL</b></td><td><b>Category</b></td><td><b>Payment Type</b></td>
					<?php foreach($dates as $date): ?>
						<td><?php echo $date ?></td>
					<?php endforeach ?>
					<?php foreach($forumCounts['dates'] as $date): ?>
						<td><?php echo $date ?></td>
					<?php endforeach ?>
				</tr>
				<?php $count = 0 ; $rawNames = $sf_data->getRaw('appNames');?>
				<?php foreach($appNames as $appName): ?>
				<?php if($appName): ?>
					<?php $count++ ?>
					<?php 
						$category = $categories[$rawNames[$count-1]] ;
						$channelUrl = $channelUrls[$rawNames[$count-1]] ;
						$kind = $kinds[$rawNames[$count-1]] ;
						$kindName = '' ;
						if($kind == 5){
							$style = 'style="background-color:#DDFFDD"' ;
							$kindName = 'Pay Per Content' ;
						} else if($kind == 4){
							$style = 'style="background-color:#FFFFFF"' ;
							$kindName = 'Subscription' ;
						} else if($kind == 6){
							$style = 'style="background-color:#FFFFFF"' ;
							$kindName = 'One Time Payment' ;
						}
					 ?>

					<tr><td><?php echo $count ?></td><td <?php echo $style ?>><?php echo $appName ?></td><td><?php echo $channelUrl ?></td><td><?php echo $category ?></td><td><?php echo $kindName ?></td>
						<?php if(!$messages[$rawNames[$count-1]]): ?>

						<?php foreach($dates as $date){
							$premiumCount = $counts[$rawNames[$count-1]][$date] ;
							if($premiumCount){
								$style = 'style="background-color:#DDDDFF"' ;
							} else {
								$style = 'style="background-color:#FFDDDD"' ;
							}

						 ?>
							<td <?php echo $style ?>><?php echo sprintf("%d",$premiumCount) ?></td>
						<?php } ?>

						<?php for($index = 0 ; $index < count($forumCounts['dates']) ; $index++){
							$forumCount = $forumCounts[$rawNames[$count-1]][$index] ;
							if($forumCount){
								$style = 'style="background-color:#DDDDFF"' ;
							} else {
								$style = 'style="background-color:#FFDDDD"' ;
							}

						 ?>
							<td <?php echo $style ?>><?php echo sprintf("%d",$forumCount) ?></td>
						<?php } ?>

						<?php else: ?>
						<td colspan="6"><?php echo $messages[$rawNames[$count-1]] ?></td>
						<?php endif ?>
					</tr>
				<?php endif ?>
				<?php endforeach ?>
			</table>
		</span>
	</div>
</div>
<!-- end: Right Content -->
