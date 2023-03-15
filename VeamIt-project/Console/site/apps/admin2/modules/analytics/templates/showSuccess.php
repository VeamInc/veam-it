<?php $count = 0 ?>
<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Analytics</h5></div>
		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo $app->getName() ?></h6>
					<?php if($elements): ?>
					<?php foreach($elements as $key=>$element): ?>
					<?php if($element->show): $count++ ; ?>
					<div class="accordion stripped" id="accordion-comment<?php echo $key ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $key ?>" href="#collapse-comment<?php echo $key ?>"> <?php echo $element->ProductType ?> </a>
							</div>
							<div id="collapse-comment<?php echo $key ?>" class="accordion-body collapse">
								<div class="accordion-inner">



<?php foreach(array('Daily','Weekly','Monthly') as $member){ ?>

					<div class="accordion stripped" id="accordion-comment<?php echo $key.$member ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $key.$member ?>" href="#collapse-comment<?php echo $key.$member ?>"> <?php echo $member ?> </a>
							</div>
							<div id="collapse-comment<?php echo $key.$member ?>" class="accordion-body collapse">
								<div class="accordion-inner">
									<table class="table">
										<thead><tr><th>Date</th><th>Count</th><th></th></tr></thead>
										<tbody>
											<?php 
												$daily = $element->$member ;
												$max = 0 ;
												foreach($daily as $day){
													if($max < $day->count){
														$max = $day->count ;
													}
												}

												for($index = count($daily) - 1 ; $index >= 0 ; $index--){
													$day = $daily[$index] ;
											?>
											<tr>
												<td style="width:150px"><?php echo $day->beginDate.'-'.$day->endDate ?></td>
												<td style="width:70px"><?php echo floor($day->count) ?></td>
												<td style="width:440px"><div class="progress"><div style="width: <?php echo round($day->count*100 / $max) ?>%;" class="bar bar-color" data-percentage="<?php echo round($day->count*100 / $max) ?>"></div></div></td>
											</tr>
											<?php } ?>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
<?php } ?>









								</div>
							</div>
						</div>
					</div>
					<?php endif ?>
					<?php endforeach ?>

					<?php if($count == 0): ?>
						No Analytics
					<?php endif ?>

					<?php else: ?>
						No Analytics
					<?php endif ?>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- end: Right Content -->
