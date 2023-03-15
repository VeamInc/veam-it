	<article class="lower">
		<section id="inquiry">
			<h1><?php echo __('Inquiry') ?></h1>
			<p class="comment mb60"><?php echo __("Click “Send” when you're ready.") ?></p>
			<form action="<?php echo url_for('account/registerinquiry') ?>" method="POST">

				<input type="hidden" name="cn" id="cn" value="<?php echo $companyName ?>">
				<input type="hidden" name="ln" id="ln" value="<?php echo $lastName ?>">
				<input type="hidden" name="fn" id="fn" value="<?php echo $firstName ?>">
				<input type="hidden" name="m" id="m" value="<?php echo $email ?>">
				<input type="hidden" name="t" id="t" value="<?php echo $tel ?>">
				<input type="hidden" name="sns" id="sns" value="<?php echo $snsUserName ?>">
				<input type="hidden" name="q" id="q" value="<?php echo $query ?>">
				<input type="hidden" name="kind" id="kind" value="<?php echo $kind ?>">
				<input type="hidden" name="os" id="os" value="<?php echo $os ?>">
				<input type="hidden" name="app" id="app" value="<?php echo $app ?>">

				<dl>
					<dt><?php echo __('Company Name') ?></dt>
					<dd><?php echo $companyName ?></dd>
					<?php if(__('LANGUAGE') == 'ja'): ?>
					<dt><?php echo __('Last Name') ?></dt>
					<dd><?php echo $lastName ?></dd>
					<dt><?php echo __('First Name') ?></dt>
					<dd><?php echo $firstName ?></dd>
					<?php else: ?>
					<dt><?php echo __('First Name') ?></dt>
					<dd><?php echo $firstName ?></dd>
					<dt><?php echo __('Last Name') ?></dt>
					<dd><?php echo $lastName ?></dd>
					<?php endif ?>
					<dt><?php echo __('Email Address') ?></dt>
					<dd><?php echo $email ?></dd>
					<dt><?php echo __('YouTube Channel link') ?></dt>
					<dd><?php echo $snsUserName ?></dd>
					<dt><?php echo __('Inquiry') ?></dt>
					<dd><?php echo $query ?></dd>
				</dl>
				<div class="submit">
					<input type="submit" name="" id="" value="<?php echo __('Send') ?>">
				</div>
			</form>
		</section>
	</article>



