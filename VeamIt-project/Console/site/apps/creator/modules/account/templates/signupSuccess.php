	<article class="lower">
		<section id="create">
			<h1><?php echo __('Create a free account to access Veam It! Publisher') ?></h1>
			<?php if(count($errorMessages) > 0): ?>
			<?php foreach($errorMessages as $errorMessage): ?>
				<p class="comment" style="color:red;margin:0px;"><?php echo __($errorMessage) ?></p>
			<?php endforeach ?>
			<br /><br />
			<?php endif ?>
			<form action="/creator.php/account/confirmsignup" method="POST">
				<input type="hidden" name="mcn" id="mcn" value="<?php echo $mcnId ?>">
				<dl>
					<?php if(__('LANGUAGE') == 'ja'): ?>
					<dt><?php echo __('Last Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="text" name="ln" id="ln" value="<?php echo $lastName ?>"></dd>
					<dt><?php echo __('First Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="text" name="fn" id="fn" value="<?php echo $firstName ?>"></dd>
					<?php else: ?>
					<dt><?php echo __('First Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="text" name="fn" id="fn" value="<?php echo $firstName ?>"></dd>
					<dt><?php echo __('Last Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="text" name="ln" id="ln" value="<?php echo $lastName ?>"></dd>
					<?php endif ?>
					<dt><?php echo __('Email Address') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="text" name="m" id="m" value="<?php echo $email ?>"></dd>
					<dt><?php echo __('Confirm<br>Email Address') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="text" name="cm" id="cm" value="<?php echo $confirmEmail ?>"></dd>
					<dt><?php echo __('Password<br>(more than 8 characters)') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="password" name="p" id="p" value="<?php echo $password ?>"></dd>
					<dt><?php echo __('Password<br>(type in again)') ?><span><?php echo __('Required') ?></span></dt>
					<dd><input type="password" name="cp" id="cp" value="<?php echo $confirmPassword ?>"></dd>
					<dt><?php echo __('YouTube Channel ID') ?></dt>
					<dd>
						<table style="width:98%">
							<tr><td style="width:10px;white-space: nowrap;font-weight:bold;">https://www.youtube.com/channel/</td><td><input type="text" name="y" id="y" value="<?php echo $youtubeUserName ?>"></td></tr>
						</table>
						<p class="memo">※<?php echo __('YouTube Playlist will appear on your app and will be synchronized with your Channel') ?></p>
					</dd>
				</dl>
				<?php if(__('LANGUAGE') == 'ja'): ?>
				<p class="comment">登録すると<a href="<?php echo url_for('account/terms') ?>" target="_blank">サービス利用規約</a>および<a href="<?php echo url_for('account/privacy') ?>" target="_blank">個人情報の取扱いについて</a>に同意したことになります。</p>
				<?php else: ?>
				<p class="comment">By clicking the below. I confirm that I have agreed to <a href="<?php echo url_for('account/terms') ?>" target="_blank">Terms of Service</a> and <a href="<?php echo url_for('account/privacy') ?>" target="_blank">Privacy Policy</a>
				<?php endif ?>
				<div class="submit">
					<input type="submit" name="" id="" value="<?php echo __('Next') ?>">
				</div>
			</form>
			<?php if(__('LANGUAGE') == 'ja'): ?>
			<p class="comment">すでにアカウントをお持ちの方は、こちらから<a href="<?php echo url_for('login/index') ;?>">ログイン</a>してください。</p>
			<?php else: ?>
			<p class="comment"><a href="<?php echo url_for('login/index') ;?>">Log in</a> if you have an account</p>
			<?php endif ?>
		</section>
	</article>
