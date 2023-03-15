<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Change Payment Type') ?></h5></div>
		<?php if($app): ?>
		<h6><?php echo __('Payment type') ?></h6>
		<select id="payment_type">
			<option value="" <?php echo ($currentType == 0)?"selected":"" ; ?>>select</option>
			<?php foreach($selection as $kind=>$text): ?>
			<option value="<?php echo $kind ?>" <?php echo ($kind == $currentType)?"selected":"" ; ?>><?php echo __($text) ?></option>
			<?php endforeach ?>
		</select>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(($app->getStatus() == 1) || ($app->getStatus() == 4)): ?>
		<span id="save_button" class="pull-right btn btn-theme"><i class="icon-save"></i><?php echo __('Save') ?></span>
		<?php endif ?>

<script type="text/javascript">
$('span#save_button').click(function(){

	var url = '/creator.php/app/savepaymenttypeapi/' ;

	var paymentType = $('#payment_type option:selected').attr('value') ;

	$.ajax({
		type: "POST",
		url: url,
		data: {
	        'payment_type': paymentType,
	    },
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
			alert("<?php echo __('Saved') ?>") ;
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
});

</script>

		<?php else: ?>
		There are no results.
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
