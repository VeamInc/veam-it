<?php 
	$env = ConsoleTools::getEnvString() ;
	if($env == 'work'){
		$domain = 'work.' ;
	} else if($env == 'preview'){
		$domain = 'preview.' ;
	} else {
		$domain = '' ;
	}

	if(__('LANGUAGE') == 'ja'){
		$topUrl = sprintf("http://%sveam.com/",$domain) ;
		$downloadUrl = sprintf("%slp/jadownload",$topUrl) ;
	} else {
		$topUrl = sprintf("http://%sveam.co/",$domain) ;
		$downloadUrl = sprintf("%slp/endownload",$topUrl) ;
	}
?>
<!doctype html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>VEAM</title>
<meta name="keywords" content="VEAM">
<meta name="description" content="VEAM">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<meta name="robots" content="noindex">
<!--[if lt IE 9]>
<script src="js/html5shiv.js"></script>
<![endif]-->
<link rel="stylesheet" href="/css/lp/style.css">
<link rel="stylesheet" href="/css/lp/drawer.css">
<script src="/js/lp/jquery-1.8.3.min.js"></script>
<script src="/js/lp/jquery.original.js"></script>
<script src="/js/lp/drawer.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/iScroll/5.1.3/iscroll.min.js"></script>
<script src="https://use.typekit.net/gcw7xfc.js"></script>
<script>try{Typekit.load({ async: true });}catch(e){}</script>
</head>
<body class="drawer drawer--right">
	<header id="pagetop" class="lower">
		<div class="header_inner">
			<h1><a href="<?php echo $topUrl ?>"><img src="/images/lp/logo.png" alt="VEAM"></a></h1>
			<button type="button" class="drawer-toggle drawer-hamburger">
			  <span class="sr-only">toggle navigation</span>
			  <span class="drawer-hamburger-icon"></span>
			</button>
			<nav class="drawer-nav" role="navigation">
		      <ul class="drawer-menu">
		        <li><a href="<?php echo $topUrl ?>#feature"><?php echo __('Why Veam?') ?></a></li>
		        <li><a href="<?php echo $topUrl ?>#function"><?php echo __('Features') ?></a></li>
				<?php if(__('LANGUAGE') == 'ja'): ?>
		        <li><a href="<?php echo $topUrl ?>#case">事 例</a></li>
				<?php endif ?>
		        <li><a href="<?php echo $topUrl ?>#tutorial"><?php echo __('Help Materials') ?></a></li>
		        <li><a href="<?php echo $downloadUrl ;?>"><?php echo __('Veam It! Publisher') ?></a></li>
		      </ul>
		      <p>Copyright &copy; VEAM 2016</p>
	    	</nav>
			<nav class="nav_pc">
		      <ul class="drawer-menu">
		        <li><a href="<?php echo $topUrl ?>#feature"><?php echo __('Why Veam?') ?></a></li>
		        <li><a href="<?php echo $topUrl ?>#function"><?php echo __('Features') ?></a></li>
				<?php if(__('LANGUAGE') == 'ja'): ?>
		        <li><a href="<?php echo $topUrl ?>#case">事 例</a></li>
				<?php endif ?>
		        <li><a href="<?php echo $topUrl ?>#tutorial"><?php echo __('Help Materials') ?></a></li>
		        <li><a href="<?php echo $downloadUrl ;?>"><?php echo __('Veam It! Publisher') ?></a></li>
		      </ul>
	    	</nav>
	    </div>
	</header>

<?php echo $sf_content ?>

	<footer>
		<div class="sec_inner">
			<p class="footer_logo"><a href="<?php echo $topUrl ?>"><img src="/images/lp/logo_footer.png" alt="VEAM"></a></p>
			<ul class="footer_menu">
		        <li><a href="<?php echo $topUrl ?>#feature"><?php echo __('Why Veam?') ?></a></li>
		        <li><a href="<?php echo $topUrl ?>#function"><?php echo __('Features') ?></a></li>
				<?php if(__('LANGUAGE') == 'ja'): ?>
		        <li><a href="<?php echo $topUrl ?>#case">事 例</a></li>
				<?php endif ?>
		        <li><a href="<?php echo $topUrl ?>#tutorial"><?php echo __('Help Materials') ?></a></li>
		        <li><a href="<?php echo $downloadUrl ;?>"><?php echo __('Veam It! Publisher') ?></a></li>
			</ul>
			<ul class="social">
		        <li><a href="https://twitter.com/VeamApp" target="_blank"><img src="/images/lp/ico_tw.png" alt="Twitter"></a></li>
		        <li><a href="https://www.facebook.com/VeamApp/" target="_blank"><img src="/images/lp/ico_fb.png" alt="Facebook"></a></li>
			</ul>
		</div>

		<p class="copyright">Copyright &copy; VEAM 2016</p>
	</footer>
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
