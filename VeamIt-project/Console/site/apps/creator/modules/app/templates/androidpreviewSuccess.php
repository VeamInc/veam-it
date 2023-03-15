<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Android preview') ?></h5></div>
		<?php if($app): ?>

		<h6>QR</h6>
		<div class="thumbnail pull-left"><img src="/images/admin/veamit_android_qr.gif" alt="" width="135" height="135" /></div>
		<p style="clear:both" />

		<!-- divider -->
		<div class="solidline">
		</div>

		<h6>URL</h6>
		<a href="/apk/veamit/veamit.apk">http://veam.co/apk/veamit/veamit.apk</a>
									
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<h6><?php echo __('Send URL') ?></h6>
		<input placeholder="* <?php echo __('Enter Your Email Address') ?>" type="text" id="email" value="">
		<span id="send_button" class="pull-right btn btn-theme"><i class="icon-envelope"></i><?php echo __('Send') ?></span>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->


<script type="text/javascript">
$('span#send_button').click(function(){

	var url = '/creator.php/app/sendandroidpreviewurl/' ;

	var email = $('#email').val() ;

	$.ajax({
		type: "POST",
		url: url,
		data: {
	        'email': email,
	    },
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
			alert("Sent") ;
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
