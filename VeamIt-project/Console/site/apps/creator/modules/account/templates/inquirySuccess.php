	<article class="lower">
		<section id="inquiry">
			<h1><?php echo __('Inquiry') ?></h1>
			<p class="comment mb60">
				<?php if(__('LANGUAGE') == 'ja'): ?>
				個人情報の取り扱いに関しては「<a href="<?php echo url_for('account/privacy') ?>" target="_blank">個人情報の取扱いについて</a>」をお読みいただき、同意のうえお問い合わせください。
				<?php else: ?>
				Please read our <a href="<?php echo url_for('account/privacy') ?>" target="_blank">Privacy Policy</a> before sending your inquiries.
				<?php endif ?>
			</p>
			<?php if(count($errorMessages) > 0): ?>
			<?php foreach($errorMessages as $errorMessage): ?>
				<p class="comment" style="color:red;margin:0px;"><?php echo __($errorMessage) ?></p>
			<?php endforeach ?>
			<br /><br />
			<?php endif ?>
			<form action="<?php echo url_for('account/confirminquiry') ?>" method="POST">
				<input type="hidden" name="kind" id="kind" value="<?php echo $kind ?>">
				<input type="hidden" name="os" id="os" value="<?php echo $os ?>">
				<input type="hidden" name="app" id="app" value="<?php echo $app ?>">
				<dl>
					<dt><?php echo __('Company Name') ?></dt>
					<dd><input type="text" name="cn" id="cn" value="<?php echo $companyName ?>"></dd>
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
					<dt><?php echo __('YouTube Channel link') ?></dt>
					<dd><textarea name="sns" id="sns" rows="5"><?php echo $snsUserName ?></textarea></dd>
					<dt><?php echo __('Inquiry') ?><span><?php echo __('Required') ?></span></dt>
					<dd><textarea name="q" id="q" rows="10"><?php echo $query ?></textarea></dd>
				</dl>
				<div class="submit">
					<input type="submit" name="" id="" value="<?php echo __('Next') ?>">
				</div>
			</form>
		</section>
	</article>
