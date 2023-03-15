<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Section Information') ?></h5></div>
		<?php if($app): ?>
		<form id="commentform" action="#" method="post" name="comment-form">

		<h6><?php echo __('Description of this section') ?></h6>
		<textarea rows="6" class="input-block-level" id="description" placeholder="*<?php echo __('Description here') ?>"><?php echo str_replace('&amp;#xA;',"\n",$subscriptionDescription) ?></textarea>
									
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<h6><?php echo __('Description before purchasing') ?></h6>
		<textarea rows="6" class="input-block-level" id="purchase_description" placeholder="*<?php echo __('Description here') ?>"><?php echo str_replace('&amp;#xA;',"\n",$subscriptionPaymentDescription) ?></textarea>
									
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<h6><?php echo __('Price') ?></h6>
		<select id="price">
			<?php foreach($prices as $price): ?>
			<option value="<?php echo $price ?>" <?php echo ($subscriptionPrice == $price)?"selected":"" ; ?>><?php echo $price ?></option>
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

	var url = '/creator.php/subscription/savesectioninfoforppsapi/' ;

	var description = $('#description').val() ;
	var purchaseDescription = $('#purchase_description').val() ;
	var price = $('#price option:selected').text() ;

	$.ajax({
		type: "POST",
		url: url,
		data: {
	        'description': description,
	        'purchase_description': purchaseDescription,
	        'price': price,
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
		<?php echo __('There are no results.') ?>
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
