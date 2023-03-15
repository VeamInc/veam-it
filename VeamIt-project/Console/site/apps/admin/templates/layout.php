<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <?php include_http_metas() ?>
    <?php include_metas() ?>
    <?php include_title() ?>
    <?php include_stylesheets() ?>
    <?php include_javascripts() ?>
  </head>
  <body onload="initPieChart();">

<?php 
	$values = get_slot('values') ;
	$mcnNames = $values['mcn_names'] ;
	$targetMcnId = $values['target_mcn_id'] ;
	$appProcessCategories = $values['app_process_categories'] ;
	$appProcessesMap = $values['app_processes_map'] ;
	$moduleName = $sf_context->getModuleName() ;
	$actionName = $sf_context->getActionName() ;
?>

<div id="wrapper">
	<!-- start header -->
	<header>
	<div class="container">
		<div class="row bottom2">
		    <!-- Logo -->
			<div class="span3 logo-span">
				<div class="logo">
					<a href="#"><img src="/images/admin/logo.png" width="220" alt="logo" class="logo" /></a>
				</div>
			</div>
			<!-- End Logo -->
			
			<div class="span9 navbar-span">
				<div class="navigation">
					<?php if(($moduleName != 'login') && ($moduleName != 'sfGuardAuth')): ?>
					<a href="/admin.php/logout">Logout</a><br><br>
					<select onChange="selectJump(this)">
						<?php foreach($mcnNames as $mcnId => $mcnName): ?>
						<option value="<?php echo sprintf('/admin.php/app/listall?mcn=%s',$mcnId) ?>" <?php if($mcnId == $targetMcnId) echo 'selected' ; ?>><?php echo $mcnName ?></option>
						<?php endforeach ?>
					</select>
					<?php endif ?>
				</div>
			</div>
		</div>
	</div>
	</header>
	<!-- End header -->
     
	<!-- Start fixed menu -->
	<div class="fixed-menu">
		<header>
			<div class="container">
				<div class="row nomargin">
				</div>
				<div class="row bottom2">
					<!-- Logo -->
					<div class="span3">
					<div class="logo">
					<a href="#"><img src="/images/admin/logo.png" width="220" alt="logo" class="logo" /></a>

					</div>
					</div>
					<!-- End logo -->

					<div class="span9">
						<div class="navigation-fixed">
							<select onChange="selectJump(this)">
								<?php foreach($mcnNames as $mcnId => $mcnName): ?>
								<option value="<?php echo sprintf('/admin.php/app/listall?mcn=%s',$mcnId) ?>" <?php if($mcnId == $targetMcnId) echo 'selected' ; ?>><?php echo $mcnName ?></option>
								<?php endforeach ?>
							</select>
						</div>
					</div>
				</div>
			</div>
		</header>
    </div>
    <!-- End fixed menu -->


	<!-- Start Content -->
	<section id="content">
		<div class="container">
			<div class="row nomargin">
				<div class="span12">
					<!-- divider -->
					<div class="solidline">
					</div>
					<!-- end divider -->
				</div>
			</div>

			<div class="row">
<?php if ($sf_user->isAuthenticated()): ?>
				<!-- start: Left Menu -->
				<div class="span3">
					<div class="widget-title"><h5 class="widgetheading">APP DASHBOARD</h5></div>
					<!-- start: Accordion -->
					<div class="accordion" id="accordion1">

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_DASHBOARD_APP ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion1" href="#collapse1-1">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Apps </a>
							</div>
							<div id="collapse1-1" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTALL,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('All', 'app/listall') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTRELEASED,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('Released', 'app/listreleased') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_APP_LISTUNRELEASED,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('Unreleased', 'app/listunreleased') ?></li>
									</ul>
								</div>
							</div>
						</div>
						
						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_DASHBOARD_SUBSCRIPTION ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion1" href="#collapse1-2">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Subscription </a>
							</div>
							<div id="collapse1-2" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTCONTENT,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Contents', 'subscription/listcontents') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTDELAYED,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Delayed', 'subscription/listdelayed') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_SUBSCRIPTION_LISTLONGDELAYED,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Long Delayed', 'subscription/listlongdelayed') ?></li>
									</ul>
								</div>
							</div>
						</div>
						
						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_DASHBOARD_YOUTUBE ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion1" href="#collapse1-3">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Sorted YouTube Lists </a>
							</div>
							<div id="collapse1-3" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_YOUTUBE_LISTVIDEO,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Videos', 'youtube/listvideos') ?></li>
									</ul>
								</div>
							</div>
						</div>
						
						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_DASHBOARD_FORUM ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion1" href="#collapse1-4">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Forum </a>
							</div>
							<div id="collapse1-4" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_FORUM_POST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Posts', 'forum/posts') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REPORT,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Report from User', 'forum/reports') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REMOVEDPOST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Removed Posts', 'forum/removedposts') ?></li>
									</ul>
								</div>
							</div>
						</div>

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_DASHBOARD_LINK ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion1" href="#collapse1-5">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Link </a>
							</div>
							<div id="collapse1-5" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_LINK_LISTLINK,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Links', 'link/listlinks') ?></li>
									</ul>
								</div>
							</div>
						</div>

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_DASHBOARD_OTHER ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion1" href="#collapse1-6">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Others </a>
							</div>
							<div id="collapse1-6" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_OTHER_LISTUSERGUIDE,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('User Guide', 'userguide/listuserguide') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_OTHER_LISTTERMS,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Terms of Service', 'terms/listterms') ?></li>
									</ul>
								</div>
							</div>
						</div>

					</div>
					<!--end: Accordion -->

					<?php if(count($appProcessCategories) > 0): ?>

					<!-- divider -->
					<div class="solidline">
					</div>
					<!-- end divider -->

					<div class="widget-title"><h5 class="widgetheading">APP STATUS</h5></div>
					<!-- start: Accordion -->
					<div class="accordion" id="accordion2">

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_STATUS_STATUS ?>

						<?php 
							$categoryCount = 0 ; 
							foreach($appProcessCategories as $appProcessCategory):
								$categoryCount++ ;
						?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion2" href="#collapse2-<?php echo $appProcessCategory->getId() ?>">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> <?php echo $categoryCount . "." . $appProcessCategory->getName() ?> </a>
							</div>
							<div id="collapse2-<?php echo $appProcessCategory->getId() ?>" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('All', 'app/listforstatus',array("query_string"=>sprintf("pc=%s&p=1",$appProcessCategory->getId()))) ?></li>
									</ul>
								</div>
							</div>
						</div>
						<?php endforeach ?>

					</div>
					<!--end: Accordion -->
					<?php endif ?>


					<!-- divider -->
					<div class="solidline">
					</div>
					<!-- end divider -->

					<div class="widget-title"><h5 class="widgetheading">YOUTUBER SUPPORT</h5></div>
					<!-- start: Accordion -->
					<div class="accordion" id="accordion3">
						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_CREATOR_REVENUE ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion3" href="#collapse3-1">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Revenue Share </a>
							</div>
							<div id="collapse3-1" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('All', 'revenue/listrevenue',array("query_string"=>sprintf("p=1"))) ?></li>
										<li><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('Upload', 'revenue/input') ?></li>
									</ul>
								</div>
							</div>
						</div>

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_CREATOR_ANALYTICS ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion3" href="#collapse3-2">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Analytics </a>
							</div>
							<div id="collapse3-2" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('All', 'analytics/listall',array("query_string"=>sprintf("p=1"))) ?></li>
									</ul>
								</div>
							</div>
						</div>

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_CREATOR_ACCOUNT ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion3" href="#collapse3-3">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Account </a>
							</div>
							<div id="collapse3-3" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_ACCOUNT_LISTALL,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('All', 'creator/listall') ?></li>
									</ul>
								</div>
							</div>
						</div>

					</div>
					<!--end: Accordion -->			


					<!-- divider -->
					<div class="solidline">
					</div>
					<!-- end divider -->

					<div class="widget-title"><h5 class="widgetheading">MESSAGE BOARD</h5></div>
					<!-- start: Accordion -->
					<div class="accordion" id="accordion4">

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_MESSAGE_COMPOSE ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion4" href="#collapse4-1">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Compose </a>
							</div>
							<div id="collapse4-1" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_MESSAGE_COMPOSE_CREATOR,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('To youtuber', 'message/composetocreator') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_MESSAGE_COMPOSE_APPUSER,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('To app user', 'inquiry/composetoappuser') ?></li>
									</ul>
								</div>
							</div>
						</div>

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_MESSAGE_INBOX ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion4" href="#collapse4-2">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Inbox </a>
							</div>
							<div id="collapse4-2" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_MESSAGE_INBOX_LISTFROMCREATOR,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('From youtuber', 'message/listfromcreator') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_MESSAGE_INBOX_LISTFROMAPPUSER,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('From app user', 'inquiry/listfromappuser') ?></li>
									</ul>
								</div>
							</div>
						</div>

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_MESSAGE_OUTBOX ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion4" href="#collapse4-3">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Outbox </a>
							</div>
							<div id="collapse4-3" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_MESSAGE_OUTBOX_LISTTOCREATOR,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('To youtuber', 'message/listtocreator') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_MESSAGE_OUTBOX_LISTTOAPPUSER,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_public('To app user', 'inquiry/listtoappuser') ?></li>
									</ul>
								</div>
							</div>
						</div>

					</div>
					<!--end: Accordion -->			


					<?php if($sf_user->hasCredential(array('admin', 'financial_manager'), false)): ?>
					<div class="widget-title"><h5 class="widgetheading">PAYMENT</h5></div>
					<!-- start: Accordion -->
					<div class="accordion" id="accordion5">

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_PAYMENT_ACCOUNT ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion5" href="#collapse5-1">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Account </a>
							</div>
							<div id="collapse5-1" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_PAYMENT_COMPOSE_CREATOR,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('All', 'payment/listaccount') ?></li>
									</ul>
								</div>
							</div>
						</div>

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_PAYMENT_TRANSACTION ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion5" href="#collapse5-2">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Revenue </a>
							</div>
							<div id="collapse5-2" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_PAYMENT_TRANSACTION_LIST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('Revenue', 'payment/listrevenue') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_PAYMENT_TRANSACTION_LIST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('Balance', 'payment/listbalance') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_PAYMENT_TRANSACTION_LIST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('Payment', 'payment/listpayment') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_PAYMENT_TRANSACTION_LIST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_admin_preview('Mail', 'payment/listmail') ?></li>
									</ul>
								</div>
							</div>
						</div>

					</div>
					<!--end: Accordion -->			
					<?php endif ?>



				</div>
				<!-- end: Left Menu -->
<?php endif ?>

			    <?php echo str_replace('http://__CLOUD_FRONT_HOST__','https://__CLOUD_FRONT_HOST__',$sf_content) ?>

			</div>
		</div>
	</section>
	<!-- End Content -->


	<!-- Start Footer-->
	<footer>
	
	<!-- Start Sub-Footer-->
	<div id="sub-footer">
		<div class="container">
			<div class="row bottom3">
				<div class="span7">
					<div class="copyright">
						<p><span class="first">Copyright (c) 2015 Veam.inc </span>|<span><a href="">Support/Help</a></span></p>
					</div>
				</div>
				
				<div class="span5">
					<a href="#" class="logof"><img src="/images/admin/logof.png" alt="logo" width="103" class="logo" /></a>
				</div>
			</div>
		</div>
	</div>
	<!-- End Sub-Footer-->
	</footer>
	<!-- End Footer-->
</div>

             <!-- Start Search form-->
             <div class="header-search-form" ><form method="get" action="http://themes.devatic.com/daisho/">
		         <textarea name="s" cols="15" rows="2" class="s SearchInput header-search-input"></textarea></form>
			     <div class="search-message">Press Enter to Search</div>
		     </div>
			 <!-- End Search form-->


            <!-- Scrollup -->
            <a href="#" class="scrollup"><i class="icon-chevron-up icon-square icon-32 active"></i></a>

<!-- javascript
    ================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="/js/admin/jquery.min.1.8.js"></script>
<script src="/js/admin/jquery.easing.1.3.js"></script>
<script src="/js/admin/bootstrap.js"></script>
<script src="/js/admin/jquery.fancybox.pack.js"></script>
<script src="/js/admin/jquery.fancybox-media.js"></script>
<script src="/js/admin/google-code-prettify/prettify.js"></script>

<script src="/js/admin/jquery.flexslider.js"></script>
<script src="/js/admin/jquery.nivo.slider.js"></script>
<script src="/js/admin/modernizr.custom.79639.js"></script>
<script src="/js/admin/jquery.ba-cond.min.js"></script>
<script src="/js/admin/animate.js"></script>
<script src="/js/admin/waypoints.js"></script>
<script src="/js/admin/waypoints-sticky.js"></script>
<script src="/js/admin/jQuery.appear.js"></script>
<script src="/js/admin/custom.js"></script>
<script type="text/javascript" src="/js/admin/jquery.flexisel.js"></script>
<script src="/js/admin/validate.js"></script>

<script src="/js/admin/jquery.cookie.js"></script>
<script src="/js/colorpicker/colorpicker.js"></script>
<script src="/js/admin/optionspanel.js"></script>

<script src="/js/admin/confirm.script.js"></script>

<script src="/js/admin/excanvas.js"></script>
<script src="/js/admin/jquery.easy-pie-chart.js"></script>
<script type="text/javascript">
            var initPieChart = function() {
                $('.percentage').easyPieChart({
                    animate: 1000,
					size: 200,
					lineWidth: 20,
					barColor: '#fe4236'
                });
                $('.percentage-light').easyPieChart({
                    barColor: function(percent) {
                        percent /= 100;
                        return "rgb(" + Math.round(255 * (1-percent)) + ", " + Math.round(255 * percent) + ", 0)";
                    },
                    trackColor: '#eee',
					barColor: '#fe4236',
                    scaleColor: false,
                    lineCap: 'butt',
                    lineWidth: 30,
                    animate: 1000,
					size: 200,
                });

                $('.updateEasyPieChart').on('click', function(e) {
                  e.preventDefault();
                  $('.percentage, .percentage-light').each(function() {
                    var newValue = Math.round(100*Math.random());
                    $(this).data('easyPieChart').update(newValue);
                    $('span', this).text(newValue);
                  });
                });
            };
</script>

  </body>
</html>
