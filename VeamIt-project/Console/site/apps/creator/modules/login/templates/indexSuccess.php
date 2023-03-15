	<article class="lower">
		<section id="app_edit" style="margin-bottom:0px">
			<h1>
				<?php echo __('Click the App Store link below and download the Veam It! Publisher app from iTunes to create an app featuring your original content') ?>
			</h1>
			<div class="link">
				<a href="https://itunes.apple.com/us/app/veam-it!-publisher-app/id953709465?l=ja&ls=1&mt=8" target="_blank" onclick="ga('send', 'event', 'AppStoreButton', 'Click', 'AppStore', 0, {'nonInteraction': 1});"><img src="/images/lp/btn_appstore_l.png" alt="" width="300"></a>
			</div>
		</section>

		<section id="login">
			<h1 style="padding-top:0px"><?php echo __('Android users, log in to Veam It! Publisher web site') ?></h1>
			<?php if($errorMessage): ?>
			<font color="red"><?php echo __($errorMessage) ?></font><br /><br />
			<?php endif ?>
			<form action="/creator.php/" method="POST">
				<dl>
					<dt><?php echo __('Email Address') ?></dt>
					<dd><input type="text" name="login[username]" id="login_username"></dd>
					<dt><?php echo __('Password') ?></dt>
					<dd><input type="password" name="login[password]" id="login_password"></dd>
				</dl>
				<div class="submit">
					<input type="submit" name="" id="" value="<?php echo __('Login') ?>">
				</div>
				<p class="comment"><a href="<?php echo url_for('account/resetpassword') ;?>"><?php echo __('forgot password?') ?></a></p>
			</form>
			<p class="comment"><?php echo link_to(__('create another account'),'account/signup'); ?></p>
		</section>

	</article>
