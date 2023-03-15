<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">All Users</h5></div>

		<span class="pull-left">
			<form action="<?php echo url_for('mi/forumuser') ?>" method="post">
				<input type="text" id="na" name="na" value="<?php echo $userName ?>">
				<input type="hidden" name="so" value="<?php echo $sortKind ?>" />
				<input type="submit" value="Search" />
			</form>
		</span>
		<div class="element-select">
			<span class="pull-right">
				Notification Group :
				<select onchange="selectJump(this)">
					<option value="<?php echo url_for(sprintf('mi/forumuser?p=0&so=%d&ng=0&na=%s',$sortKind,$userName), false) ?>" <?php if(!$notificationGroupId)echo("selected"); ?>>All</option>
					<?php foreach($notificationGroups as $notificationGroup): ?>
					<option value="<?php echo url_for(sprintf('mi/forumuser?p=0&so=%d&ng=%d&na=%s',$sortKind,$notificationGroup->getId(),$userName), false) ?>" <?php if($notificationGroup->getId() == $notificationGroupId)echo("selected"); ?>><?php echo $notificationGroup->getName() ?></option>
					<?php endforeach ?>
				</select>
			</span>
			<p style="clear:both" />

<!--
			<span class="pull-right">
			View :
			<select onChange="selectJump(this)">
				<?php foreach($sortKinds as $workSortKind => $sortName): ?>
				<option value="<?php echo url_for(sprintf('%s/%s?p=1&so=%d&na=%s',$sf_context->getModuleName(),$sf_context->getActionName(),$workSortKind,$userName), false) ?>" <?php if($workSortKind == $sortKind) echo 'selected' ; ?>><?php echo $sortName ?></option>
				<?php endforeach ?>
			</select>
			</span>
			<p style="clear:both" />
-->
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(count($users) > 0): ?>

		<?php 
			$currentIndex = $startIndex ;
			foreach($users as $user):
				$iconUrl = $user->getProfileImage() ;
				if(!$iconUrl){
					$iconUrl = '/images/admin/assets/no_icon.png' ;
				}
				$groups = $userNotificationGroupsMap[$user->getId()] ;
				$socialUserPermission = $socialUserPermissionMap[$user->getId()] ;
				$index = $currentIndex ;
				$currentIndex-- ;
		?>


		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $iconUrl ?>" alt="" width="120" height="120" /></div>
			<div class="media-body">
				<div class="media-content">
					<h6><span>[<?php echo $index ?>]</span> <?php echo $user->getName() ?></h6>
					<div class="accordion stripped" id="accordion-group<?php echo $user->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-group<?php echo $user->getId() ?>" href="#collapse-group<?php echo $user->getId() ?>"><span class="icon-group"></span> Notification Groups(<div style="display:inline;" id="number_of_groups_<?php echo $user->getId() ?>"><?php echo count($groups) ?></div>) </a>
							</div>
							<div id="collapse-group<?php echo $user->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">
									<ul class="folio-detail">
										<div style="display:inline;" id="usr_groups_<?php echo $user->getId() ?>">
											<?php foreach($groups as $group): 
												$notificationGroup = $notificationGroupMap[$group->getId()] ;
												if($notificationGroup){
													$notificationGroupName = $notificationGroup->getName() ;
												} else {
													$notificationGroupName = "" ;
												}
											?>
											<li><label><?php echo $notificationGroupName ?></label>&nbsp;&nbsp;[<i class="icon-trash"></i><?php echo link_to("Remove user from this group", "mi/deleteuserfromnotificationgroupapi", array("onclick"=>"return removeUserFromGroup(this)","query_string"=>sprintf('su=%d&ngid=%d&p=%d&so=%d&ng=%d&na=%s',$user->getId(),$group->getId(),$page,$sortKind,$notificationGroupId,$userName))) ; ?>]</li>
											<?php endforeach ?>
										</div>
										<li>
										Add to notification group : 
										<select onChange="addUserToGroup(this)">
											<option value="" selected>Select</option>
											<?php foreach($notificationGroups as $notificationGroup): ?>
											<option value="<?php echo url_for(sprintf('mi/addusertonotificationgroupapi?su=%d&ngid=%d&p=%d&so=%d&ng=%d&na=%s',$user->getId(),$notificationGroup->getId(),$page,$sortKind,$notificationGroupId,$userName), false) ?>"><?php echo $notificationGroup->getName() ?></option>
											<?php endforeach ?>
										</select>
										</li>

									</ul>

								</div>
							</div>
						</div>
					</div>
					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $user->getCreatedAt() ?></li>
							<li><i class="icon-cog"></i>
							<?php if($socialUserPermission): ?>
								<?php echo link_to("Revoke Post Permission", "mi/revokeuserpermission", array("onclick"=>"return confirm('Revoke Post Permission?')","query_string"=>sprintf('su=%d&p=%d&so=%d&na=%s',$user->getId(),$page,$sortKind,$userName))) ; ?>
							<?php else: ?>
								<?php echo link_to("Grant Post Permission", "mi/grantuserpermission", array("onclick"=>"return confirm('Grant Post Permission?')","query_string"=>sprintf('su=%d&p=%d&so=%d&na=%s',$user->getId(),$page,$sortKind,$userName))) ; ?>
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
			<?php echo link_to("<<", "mi/forumuser", array("class"=>"inactive", "query_string"=>sprintf("p=1&so=%d&na=%s",$sortKind,$userName))) ; ?>
			<?php echo link_to("<", "mi/forumuser", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page-1,$sortKind,$userName))) ; ?>
			<?php endif ?>
			<?php 
				for($workPage = $startPage ; $workPage <= $endPage ; $workPage++){ 
					if($workPage == $page){
						echo sprintf('<span class="current">%d</span>',$workPage) ;
					} else {
						echo link_to($workPage, "mi/forumuser", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$workPage,$sortKind,$userName))) ;
					}
				}
			?>
			<?php if($page != $lastPage): ?>
			<?php echo link_to(">", "mi/forumuser", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$page+1,$sortKind,$userName) )) ; ?>
			<?php echo link_to(">>", "mi/forumuser", array("class"=>"inactive", "query_string"=>sprintf("p=%d&so=%d&na=%s",$lastPage,$sortKind,$userName) )) ; ?>
			<?php endif ?>
		</div>
		<!-- End pagination-->

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->

