<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Send New Mail</h5></div>

	<?php if($errorMessage): ?>
	<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
	<?php endif ?>

	<!-- Contact Form-->
	<form id="contactform" action="<?php echo url_for('payment/confirmmail') ?>" method="post" class="validateform" name="send-contact">
		<input type="hidden" name="a" value="<?php echo $appId ?>">
		<div class="row">
			<div class="span9 field">
			<table class="table table-bordered">
			<tbody>
				<tr><td>App Name</td><td>
		<select name="a">
			<option value="0" <?php if(!$appId) echo 'selected' ; ?>>Select</option>
			<?php foreach($allApps as $workApp): ?>
			<option value="<?php echo $workApp->getId() ?>" <?php if($appId == $workApp->getId()) echo 'selected' ; ?>><?php echo $workApp->getName() ?></option>
			<?php endforeach ?>
		</select>

</td></tr>
				<tr><td>Start Year/Month</td><td>
		<select name="sym">
			<option value="0" <?php if(!$startYearMonth) echo 'selected' ; ?>>Select</option>
			<?php foreach($yearMonths as $workYearMonth => $yearMonthName): ?>
			<option value="<?php echo $workYearMonth ?>" <?php if($startYearMonth == $workYearMonth) echo 'selected' ; ?>><?php echo AdminTools::unescapeName($yearMonthName) ?></option>
			<?php endforeach ?>
		</select>

</td></tr>
				<tr><td>End Year/Month</td><td>
		<select name="eym">
			<option value="0" <?php if(!$endYearMonth) echo 'selected' ; ?>>Select</option>
			<?php foreach($yearMonths as $workYearMonth => $yearMonthName): ?>
			<option value="<?php echo $workYearMonth ?>" <?php if($endYearMonth == $workYearMonth) echo 'selected' ; ?>><?php echo AdminTools::unescapeName($yearMonthName) ?></option>
			<?php endforeach ?>
		</select>

</td></tr>
			</tbody>
			</table>
			</div>
			<div class="span9 field">
				<button class="btn btn-theme margintop10 pull-left" type="submit">Confirm message</button>
			</div>
		</div>
	</form>
	<!-- End contact form-->
</div>
<!-- end: Right Content -->
