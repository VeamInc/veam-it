<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <?php include_http_metas() ?>
    <?php include_metas() ?>
    <?php include_title() ?>
    <?php include_stylesheets() ?>
    <?php include_javascripts() ?>
  </head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>
<script src="/js/admin/jquery.editable.min.js"></script>

  <body onload="initPieChart();">

<?php 
	$values = get_slot('values') ;
	$targetAppId = $values['target_app_id'] ;
	$targetApp = $values['target_app'] ;
	$userId = $values['user_name'] ;
	if($targetApp){
		$targetAppName = $targetApp->getName() ;
		$targetAppIcon = $targetApp->getIconImage() ;
	} else {
		$targetAppName = '' ;
		$targetAppIcon = '' ;
	}
/*
	$mcnNames = $values['mcn_names'] ;
	$targetMcnId = $values['target_mcn_id'] ;
	$appProcessCategories = $values['app_process_categories'] ;
	$appProcessesMap = $values['app_processes_map'] ;
*/
	$moduleName = $sf_context->getModuleName() ;
	$actionName = $sf_context->getActionName() ;
	if($sf_user->hasCredential('musicians_institute')){
		$logoName = 'mi_logo.png' ;
	} else {
		$logoName = 'veamitweblogo.png' ;
	}

	$env = ConsoleTools::getEnvString() ;
	if($env == 'work'){
		$domainPrefix = "work." ;
	} else if($env == 'preview'){
		$domainPrefix = "preview." ;
	} else {
		$domainPrefix = "" ;
	}

?>

<div id="wrapper">
	<!-- start header -->
	<header>
	<div class="container">
		<div class="row bottom2">
			<img src="/images/admin/<?php echo $logoName ?>" width="220" alt="logo" class="logo" />
			<div class="pull-right" style="margin-top:5px;margin-bottom:5px;">
				<ul class="meta-post">
					<?php if($targetAppIcon): ?>
					<li><img src="<?php echo $targetAppIcon ?>" width="32px" height="32px" /></li>
					<?php endif ?>
					<?php if($targetAppName): ?>
					<li><?php echo $targetAppName ?></li>
					<?php endif ?>
					<?php if($userId): ?>
					<li><?php echo $userId ?></li>
					<?php endif ?>
					<li><a href="/creator.php/login/logout/" class="bcontinue"><?php echo __('Logout') ?></a></li>
				</ul>
			</div>
		</div>
	</div>
	</header>
	<!-- End header -->
     
	<!-- Start fixed menu -->
	<div class="fixed-menu">
		<header>
	<div class="container">
		<div class="row bottom2">
			<img src="/images/admin/<?php echo $logoName ?>" width="220" alt="logo" class="logo" />
			<div class="pull-right" style="margin-top:5px;margin-bottom:5px;">
				<ul class="meta-post">
					<?php if($targetAppIcon): ?>
					<li><img src="<?php echo $targetAppIcon ?>" width="32px" height="32px" /></li>
					<?php endif ?>
					<?php if($targetAppName): ?>
					<li><?php echo $targetAppName ?></li>
					<?php endif ?>
					<?php if($userId): ?>
					<li><?php echo $userId ?></li>
					<?php endif ?>
					<li><a href="/creator.php/login/logout/" class="bcontinue"><?php echo __('Logout') ?></a></li>
				</ul>
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
				<div class="span3 navbar-span">
					<div class="navbar navbar-static-top">
						<a class="btn btn-navbar collapsed" data-toggle="collapse" data-target=".nav-collapse">
		                    <span class="icon-bar"></span>
		                    <span class="icon-bar"></span>
		                    <span class="icon-bar"></span>
		                </a><!-- /nav-collapse --> 
						<div class="nav-collapse collapse" style="height: 0px;">



<?php if($targetAppId): ?>
<?php if($sf_user->hasCredential('musicians_institute')): ?>
					<div class="widget-title"><h5 class="widgetheading">APP DASHBOARD</h5></div>
					<!-- start: Accordion -->
					<div class="accordion" id="accordion2">

						<?php $accordionTarget = ACCORDION_TOGGLE_TARGET_DASHBOARD_MI ; ?>
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="<?php echo AdminTools::getAccordionToggleClass($accordionTarget,$moduleName,$actionName) ?>" data-toggle="collapse" data-parent="#accordion2" href="#collapse2-1">
								<i class="<?php echo AdminTools::getAccordionToggleIconClass($accordionTarget,$moduleName,$actionName) ?>"></i> Musicians Institute </a>
							</div>
							<div id="collapse2-1" class="<?php echo AdminTools::getAccordionToggleCollapseClass($accordionTarget,$moduleName,$actionName) ?>">
								<div class="accordion-inner">
									<ul class="cat">
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_MI_FORUMUSER,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_public('Users', 'mi/forumuser') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_MI_NOTIFICATION,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_public('Notifications', 'mi/notification') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_MI_NOTIFICATIONGROUP,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_public('Notification Groups', 'mi/notificationgroup') ?></li>
										<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_MI_FORUMPOST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_public('Posts', 'mi/forumposts') ?></li>
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
<?php else: ?>
<?php 
	$completeRatio = ConsoleTools::getSettingCompletionRatio($targetAppId); 
	if($completeRatio == 100){
		if($targetApp->getStatus() == 1){
			$barText = __('Required app submit') ;
		} else if($targetApp->getStatus() == 2){
			$barText = __('Data Checking') ;
		}
	} else {
			$barText = sprintf('%d%% %s',$completeRatio,__('Complete')) ;
	}
?>
					<div class="widget-title">
						<h5 class="widgetheading"><?php echo __('APP SETTINGS') ?>
							<span class="portfolio-image">
								<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="Veam" href="/images/admin/help/template_help<?php echo __('LANGUAGE') == 'ja'?'_ja':'_en' ?>.jpg"><i class="icon-question-sign"></i></a>
								<img src="/images/admin/help/template_help.jpg" alt=" " style="visibility: hidden;" width="1" height="1">
							</span>
						</h5></div>

					<div class="widget">
						<div class="widget-title"><h5 class="widgetheading">1. <?php echo __('Start Editing Your App') ?></h5></div>
						<ul class="cat">
							<li>
								<div class="progress-bar">
									<div class="progress" style="height: 40px;">
										<!-- <div style="width: <?php echo $completeRatio ?>%;font-size: 14px; height: 30px; padding-top: 4px;" class="bar bar-color" data-percentage="<?php echo $completeRatio ?>"><?php echo $barText ?></div> -->
										<div style="width: <?php echo $completeRatio ?>%;font-size: 13px; height: 40px; padding-top: 9px;white-space:nowrap;color:black;" class="bar bar-color" data-percentage="<?php echo $completeRatio ?>"><?php echo $barText ?></div>
										<!-- <div style="width: 30%;font-size: 14px; height: 30px; padding-top: 4px;white-space:nowrap;color:black;" class="bar bar-color" data-percentage="30">30% Complete</div> -->
									</div>
								</div>
							</li>
							<?php if(($targetApp->getStatus() == 1) || ($targetApp->getStatus() == 4)): ?>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_APP_DESIGN,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Customize Your App Design'), 'app/design') ?></li>
							<?php endif ?>
						</ul>
					</div>
					<br />

					<div class="widget">
						<div class="widget-title">
							<h5 class="widgetheading">2. <?php echo __('Upload Exclusive Content') ?>
								<span class="portfolio-image">
									<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Exclusive Section') ?>" href="/images/admin/help/exclusive_tutorial.png"><i class="icon-question-sign"></i></a>
									<img src="/images/admin/help/exclusive_tutorial.png" alt="<?php echo __('Users will pay monthly subscription fee to access.') ?><br /><?php echo __('Post your exclusive content to your devoted fans!') ?>" style="visibility: hidden;" width="1" height="1">
								</span>
							</h5>
						</div>
						<ul class="cat">
							<?php if(($targetApp->getStatus() == 1) || ($targetApp->getStatus() == 4)): ?>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_APP_PAYMENTTYPE,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Change Payment Type'), 'app/paymenttype') ?></li>
							<?php endif ?>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_SUBSCRIPTION_CONTENT,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Content'), 'subscription/content') ?></li>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_SUBSCRIPTION_CATEGORY,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Category'), 'subscription/category') ?></li>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_SUBSCRIPTION_INFO,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Section Info'), 'subscription/sectioninfo') ?></li>
						</ul>
					</div>
					<br />

					<div class="widget">
						<div class="widget-title">
							<h5 class="widgetheading">3. <?php echo __('Edit your YouTube Playlist') ?>
								<span class="portfolio-image">
									<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Automatically Synced Playlist') ?>" href="/images/admin/help/youtube_tutorial.png"><i class="icon-question-sign"></i></a>
									<img src="/images/admin/help/youtube_tutorial.png" alt="<?php echo __('YouTube playlists will be automatically sorted and synced in the app.') ?><br /><?php echo __('Add views to your YouTube videos.') ?>" style="visibility: hidden;" width="1" height="1">
								</span>
							</h5>
						</div>
						<ul class="cat">
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_YOUTUBE_PLAYLIST_ACTIVATION,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Playlist'), 'youtube/playlistactivation') ?></li>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_YOUTUBE_PLAYLIST_ORDER,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Playlist order'), 'youtube/playlistorder') ?></li>
						</ul>
					</div>
					<br />

					<div class="widget">
						<div class="widget-title">
							<h5 class="widgetheading">4. <?php echo __('Add Topics to Forum') ?>
								<span class="portfolio-image">
									<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Interact with your Fans') ?>" href="/images/admin/help/forum_tutorial.png"><i class="icon-question-sign"></i></a>
									<img src="/images/admin/help/forum_tutorial.png" alt="<?php echo __('Instagram-like picture Forum dedicated to the app.') ?><br /><?php echo __('Users log in with Facebook or Twitter account.') ?><br /><?php echo __('Add topics you want the fans to post about.') ?><br />" style="visibility: hidden;" width="1" height="1">
								</span>
							</h5>
						</div>
						<ul class="cat">
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_FORUM_CATEGORY_LIST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Forum Topic'), 'forum/categorylist') ?></li>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_FORUM_CATEGORY_ORDER,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Forum Topic Order'), 'forum/categoryorder') ?></li>
						</ul>
					</div>
					<br />

					<div class="widget">
						<div class="widget-title">
							<h5 class="widgetheading">5. <?php echo __('Edit the Link Section') ?>
								<span class="portfolio-image">
									<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Edit Social Media Links') ?>" href="/images/admin/help/link_tutorial.png"><i class="icon-question-sign"></i></a>
									<img src="/images/admin/help/link_tutorial.png" alt="<?php echo __('Edit the URLs to forward app traffic to your social media, merch stores and blogs.') ?><br />" style="visibility: hidden;" width="1" height="1">
								</span>
							</h5>
						</div>
						<ul class="cat">
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_LINK_LIST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Link'), 'link/linklist') ?></li>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_LINK_ORDER,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Edit Link order'), 'link/linkorder') ?></li>
						</ul>
					</div>
					<br />


					<div class="widget">
						<div class="widget-title"><h5 class="widgetheading">6. <?php echo __('Get Ready For Submission') ?></h5></div>
						<ul class="cat">
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_APP_TERMS,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Accept the terms'), 'app/terms') ?></li>

							<?php if(($targetApp->getStatus() == 1) || ($targetApp->getStatus() == 4)): ?>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_APP_STORE,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Preparing for App Submission'), 'app/store') ?></li>
							<?php endif ?>

							<?php if(($targetApp->getStatus() == 1) || ($targetApp->getStatus() == 4)): ?>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_APP_SUBMIT,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('App Submit'), 'app/submit') ?></li>
							<?php endif ?>

							<?php if($targetApp->getStatus() == 0): ?>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_APP_PUBLISH,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview(__('Publish'), 'app/publish') ?></li>
							<?php endif ?>

						</ul>
					</div>
					<br />



					<div class="widget-title"><h5 class="widgetheading"><?php echo __('APP PREVIEW') ?></h5></div>

					<div class="widget">
						<div class="widget-title"><h5 class="widgetheading"><?php echo __('Preview') ?></h5></div>
						<ul class="cat">
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_CREATOR_PREVIEW_ANDROID,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_preview('Android', 'app/androidpreview') ?></li>
						</ul>
					</div>
					<br />



					<br />
<?php if($targetApp->getStatus() == 0): ?>
					<div class="widget-title"><h5 class="widgetheading"><?php echo __('APP DASHBOARD') ?></h5></div>

					<div class="widget">
						<div class="widget-title"><h5 class="widgetheading"><?php echo __('Forum') ?></h5></div>
						<ul class="cat">
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_FORUM_POST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_public(__('Posts'), 'forum/posts') ?></li>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REPORT,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_public(__('Report from User'), 'forum/reports') ?></li>
							<li class="<?php echo AdminTools::getAccordionInnerListClass(ACCORDION_INNER_TARGET_DASHBOARD_FORUM_REMOVEDPOST,$moduleName,$actionName) ?>"><i class="icon-angle-right"></i><?php echo AdminTools::link_to_creator_public(__('Removed Posts'), 'forum/removedposts') ?></li>
						</ul>
					</div>
					<br />
<?php endif ?>
					<!-- divider -->
					<div class="solidline">
					</div>
					<!-- end divider -->

<?php endif ?>
<?php endif /*targetAppId*/ ?>

						</div>
					</div>
				</div>
				<!-- end: Left Menu -->


<?php endif ?>

			    <?php echo $sf_content ?>

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
						<p><span class="first">Copyright (c) 2016 Veam.inc </span>&nbsp;&nbsp;&nbsp;&nbsp;
<?php if(__('LANGUAGE') == 'ja'): ?>
<a href="http://<?php echo $domainPrefix ?>veam.com/#tutorial">Tutorials</a>
<?php else: ?>
<a href="http://<?php echo $domainPrefix ?>veam.co/#tutorial">Tutorials</a>
<?php endif ?>
</p>
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
<!--  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script> -->
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

<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="/js/admin/fileupload/jquery.ui.widget.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="/js/admin/fileupload/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="/js/admin/fileupload/jquery.fileupload.js"></script>


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

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', '__GA_PROPERTY_ID__', 'auto');
  ga('send', 'pageview');

</script>
  </body>
</html>
