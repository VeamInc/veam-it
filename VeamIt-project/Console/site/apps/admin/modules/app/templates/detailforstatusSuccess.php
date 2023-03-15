<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">App Status</h5></div>

		<?php 
			$iconUrl = $app->getIconImage() ;
			if(!$iconUrl){
				$iconUrl = '/images/admin/assets/no_icon.png' ;
			}
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $iconUrl ?>" alt="" width="100" height="100" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo $app->getName() ?></h6>
				</div>
			</div>
		</div>





		<?php if(count($appProcessCategories) > 0): ?>

		<!-- start: Accordion -->
		<div class="accordion faq" id="accordion-app-status">

			<?php 
				$categoryCount = 0 ;
				foreach($appProcessCategories as $appProcessCategory){
					$categoryCount++ ;
					$isActive = ($currentProcess->getAppProcessCategoryId() == $appProcessCategory->getId()) ;
					$appProcesses = $appProcessesMap[$appProcessCategory->getId()] ;
			?>
			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="<?php echo $isActive?"accordion-toggle active":"accordion-toggle" ?>" data-toggle="collapse" data-parent="#accordion-app-status" href="#collapse-as-<?php echo $appProcessCategory->getId() ?>">
					<i class="<?php echo $isActive?"icon-minus":"icon-plus" ?>"></i> <?php echo $categoryCount . "." .$appProcessCategory->getName() ?> </a>
				</div>
				<div id="collapse-as-<?php echo $appProcessCategory->getId() ?>" class="<?php echo $isActive?"accordion-body collapse in":"accordion-body collapse" ?>">
					<div class="accordion-inner">

						<table class="table">
							<tbody>
								<?php 
									$count = 0 ;
									foreach($appProcesses as $appProcess){
										$count++ ;
										$helpUrl = $appProcess->getHelpUrl() ;
										$infoAction = $appProcess->getInfoAction() ;
										$appProcessLog = $appProcessLogMapForProcess[$appProcess->getId()] ;
										$appProcessKind = $appProcess->getKind() ;
										$nextText1 = $appProcess->getNextText1() ;
										$nextText2 = $appProcess->getNextText2() ;
										$nextText3 = $appProcess->getNextText3() ;
										$dependency = $appProcess->getDependsOn() ;
										$doneAllDependency = true ;
										if($dependency){
											$dependencies = explode(",",$dependency) ;
											foreach($dependencies as $dependedProcessId){
												if(!$appProcessLogMapForProcess[$dependedProcessId]){
													$doneAllDependency = false ;
												}
											}
										}


								?>
								<tr <?php if($currentProcess->getId() == $appProcess->getId()){echo 'style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"' ;} ?>>
									<td><?php echo $count ?></td>
									<td><?php echo $appProcess->getName() ?></td>
									<td style="width:10px"><?php if($infoAction){echo AdminTools::link_to('<i class="icon-info-sign"></i>',$infoAction,array("query_string"=>sprintf("a=%s&p=%s",$app->getId(),$appProcess->getId())));} ?></td>
									<td style="width:10px"><?php if($helpUrl){echo sprintf('<a href="%s" target="_blank"><i class="icon-question-sign"></i></a>',$helpUrl);} ?></td>
									<td style="width:100px">
										<?php if($appProcessLog): ?>
											<?php echo AdminTools::getDateString($appProcessLog->getCreatedAt(),ADMIN_DATE_FORMAT_1) ?> <i class="icon-ok"></i>
										<?php else: ?>
											<?php if($doneAllDependency): ?>
												<?php 
													if($appProcessKind == 1){
														if($nextText1){
															echo AdminTools::link_to($nextText1, "app/completeprocess", array("style"=>"width:90px","class"=>"btn btn-mini btn-theme", "query_string"=>sprintf("a=%s&p=%s&r=1",$app->getId(),$appProcess->getId()))) ;
														}
														if($nextText2){
															echo "<br />" ;
															echo "<br />" ;
															echo AdminTools::link_to($nextText2, "app/completeprocess", array("style"=>"width:90px","class"=>"btn btn-mini btn-theme", "query_string"=>sprintf("a=%s&p=%s&r=2",$app->getId(),$appProcess->getId()))) ;
														}
														if($nextText3){
															echo "<br />" ;
															echo "<br />" ;
															echo AdminTools::link_to($nextText3, "app/completeprocess", array("style"=>"width:90px","class"=>"btn btn-mini btn-theme", "query_string"=>sprintf("a=%s&p=%s&r=3",$app->getId(),$appProcess->getId()))) ;
														}
													} else {
														echo "Waiting..." ;
													}
												?>
											<?php endif ?>

										<?php endif ?>
									</td>
								</tr>
								<?php } ?>
							</tbody>
						</table>

					</div>
				</div>
			</div>
			<?php } ?>

		</div>
		<!--end: Accordion -->
		<?php endif ?>












	</div>
</div>
<!-- end: Right Content -->
