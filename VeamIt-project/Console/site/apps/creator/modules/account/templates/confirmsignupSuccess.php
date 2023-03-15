	<article class="lower">
		<section id="create">
			<h1><?php echo __('Create a free account to access Veam It! Publisher') ?></h1>
			<p class="comment mb60"><?php echo __("Click“Register” when you're ready.") ?></p>
			<form action="/creator.php/account/registersignup" method="POST">

				<input type="hidden" name="mcn" id="mcn" value="<?php echo $mcnId ?>">
				<input type="hidden" name="ln" id="ln" value="<?php echo $lastName ?>">
				<input type="hidden" name="fn" id="fn" value="<?php echo $firstName ?>">
				<input type="hidden" name="m" id="m" value="<?php echo $email ?>">
				<input type="hidden" name="p" id="p" value="<?php echo $password ?>">
				<input type="hidden" name="y" id="y" value="<?php echo $youtubeUserName ?>">

				<dl>
					<?php if(__('LANGUAGE') == 'ja'): ?>
					<dt><?php echo __('Last Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><?php echo $lastName ?></dd>
					<dt><?php echo __('First Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><?php echo $firstName ?></dd>
					<?php else: ?>
					<dt><?php echo __('First Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><?php echo $firstName ?></dd>
					<dt><?php echo __('Last Name') ?><span><?php echo __('Required') ?></span></dt>
					<dd><?php echo $lastName ?></dd>
					<?php endif ?>
					<dt><?php echo __('Email Address') ?><span><?php echo __('Required') ?></span></dt>
					<dd><?php echo $email ?></dd>
					<dt><?php echo __('Password') ?><span><?php echo __('Required') ?></span></dt>
					<dd><?php echo str_repeat('*',strlen($password)) ?></dd>
					<dt><?php echo __('YouTube Channel ID') ?></dt>
					<dd><?php echo $youtubeUserName ?></dd>
				</dl>
				<div class="submit">
					<input type="submit" name="" id="" value="<?php echo __('Register') ?>">
				</div>
			</form>
		</section>
	</article>
