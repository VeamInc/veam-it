<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <title>Veam</title>
    <link rel="shortcut icon" href="/favicon.ico" />
    <?php use_stylesheet('admin.css') ?>
    <?php include_javascripts() ?>
    <?php include_stylesheets() ?>
  </head>
  <body>
    <div id="container">
      <div id="header">
        <h1>
			<img src="/legacy/images/logo.jpg" alt="Veam" />
        </h1>
      </div>

<?php if ($sf_user->isAuthenticated()): ?>
<div id="menu">
	<ul>
		<li>[<?php echo link_to('Logout', '@sf_guard_signout') ?>]</li>

		<?php if ($sf_user->isSuperAdmin() || $sf_user->hasPermission('ReadUser')): ?>
		<li>[<?php echo link_to('Users', '@sf_guard_user') ?>]</li>
		<?php endif ?>

		<?php if ($sf_user->isSuperAdmin() || $sf_user->hasPermission('ReadGroup')): ?>
		<li>[<?php echo link_to('Groups', '@sf_guard_group') ?>]</li>
		<?php endif ?>

		<?php if ($sf_user->isSuperAdmin() || $sf_user->hasPermission('ReadPermission')): ?>
		<li>[<?php echo link_to('Permissions', '@sf_guard_permission') ?>]</li>
		<?php endif ?>

		<?php if ($sf_user->isSuperAdmin() || $sf_user->hasPermission('c_text')): ?>
		<li>[<?php echo link_to('Text', 'textline_c_text') ?>]</li>
		<?php endif ?>
	</ul>
</div>
<?php endif ?>


      <div id="content">
        <?php echo $sf_content ?>
      </div>
 
      <div id="footer">
      </div>
    </div>
  </body>
</html>
