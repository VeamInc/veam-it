	<article class="lower">
		<section id="reminder">
			<h1><?php echo __('Reset your password') ?></h1>
			<?php if(count($errorMessages) > 0): ?>
			<?php foreach($errorMessages as $errorMessage): ?>
				<p class="comment" style="color:red;margin:0px;"><?php echo __($errorMessage) ?></p>
			<?php endforeach ?>
			<br /><br />
			<?php endif ?>
			<form action="<?php echo url_for('account/sendpassword') ?>" method="POST">
				<dl>
					<dt><?php echo __('Email Address') ?></dt>
					<dd><input type="text" name="email" id="email"></dd>
				</dl>
				<div class="submit">
					<input type="submit" name="" id="" value="<?php echo __('Reset') ?>">
				</div>
			</form>
		</section>
	</article>
