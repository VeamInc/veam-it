<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('App Submit') ?></h5></div>
		<?php if($app): ?>

		<!-- divider -->
		<div class="solidline">
		</div>

		<?php if(!$app->getBackgroundImage() || !$app->getIconImage()): ?>

		<!-- end divider -->
		<h6><?php echo __('Design') ?></h6>
		<table class="table table-striped">
			<tbody>
				<?php if(!$app->getBackgroundImage()): ?>
				<tr>
					<td><?php echo __('Splash') ?> &amp; <?php echo __('Background image') ?></td>
					<td>
						<a href="/creator.php/app/design"><?php echo __('Please upload a background image.') ?></a>
					</td>
				</tr>
				<?php endif ?>
				<?php if(!$app->getIconImage()): ?>
				<tr>
					<td><?php echo __('Icon image') ?></td>
					<td>
						<a href="/creator.php/app/design"><?php echo __('Please upload an icon image.') ?></a>
					</td>
				</tr>
				<?php endif ?>
			</tbody>
		</table>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php endif ?>




		<?php if(!$app->getDescription() || !$app->getKeyWord() || !$app->getCategory() || !$allQuestionsAnswered): ?>

		<!-- end divider -->
		<h6><?php echo __('App Store Info') ?></h6>
		<table class="table table-striped">
			<tbody>
				<?php if(!$app->getDescription()): ?>
				<tr>
					<td><?php echo __('Description') ?></td>
					<td>
						<a href="/creator.php/app/store"><?php echo __('Please enter a description.') ?></a>
					</td>
				</tr>
				<?php endif ?>
				<?php if(!$app->getKeyWord()): ?>
				<tr>
					<td><?php echo __('Keywords') ?></td>
					<td>
						<a href="/creator.php/app/store"><?php echo __('Please enter keywords.') ?></a>
					</td>
				</tr>
				<?php endif ?>
				<?php if(!$app->getCategory()): ?>
				<tr>
					<td><?php echo __('Category') ?></td>
					<td>
						<a href="/creator.php/app/store"><?php echo __('Please select a category.') ?></a>
					</td>
				</tr>
				<?php endif ?>
				<?php if(!$allQuestionsAnswered): ?>
				<tr>
					<td><?php echo __('Rating') ?></td>
					<td>
						<a href="/creator.php/app/store"><?php echo __('Please answer the rating questions.') ?></a>
					</td>
				</tr>
				<?php endif ?>
			</tbody>
		</table>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php endif ?>




		<?php 
			$needExclusiveContent = false ;
			if($subscriptionKind == 4){
				if(count($mixeds) <= 0){
					$needExclusiveContent = true ;
				}
			} else if($subscriptionKind == 5){ /*subscriptionKind*/
				if(count($sellItems) <= 0){
					$needExclusiveContent = true ;
				}
			} else if($subscriptionKind == 6){ /*subscriptionKind*/
				if(count($sellSectionItems) <= 0){
					$needExclusiveContent = true ;
				}
			}
		?>


		<?php if($needExclusiveContent): ?>
		<?php $isSubmittable = false ; ?>
		<h6><?php echo __('Exclusive Content') ?></h6>
		<a href="/creator.php/subscription/content" ?><?php echo __('Please add a exclusive content.') ?></a>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php endif ?>























		<?php if(count($forums) == 0): ?>
		<h6><?php echo __('Forum Categories') ?></h6>
		<a href="/creator.php/forum/categorylist" ?><?php echo __('Please add a forum category before submission.') ?></a>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php endif ?>


		<?php if(count($webs) == 0): ?>
		<h6><?php echo __('Links') ?></h6>
		<a href="/creator.php/link/linklist" ?><?php echo __('Please add a link before submission.') ?></a>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php endif ?>


		<?php if(!$app->getTermsAcceptedAt()): ?>
		<h6><?php echo __('Terms of Service') ?></h6>
		<a href="/creator.php/app/terms" ?><?php echo __('Please accept the terms before submission.') ?></a>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php endif ?>


		<?php if($isSubmittable): ?>
			<div id="submit_area">
			<?php if($submittedAt): ?>
				<i class="icon-check"></i><?php echo __('App submitted at') ?> <?php echo $submittedAt ?>
			<?php else: ?>
				<span id="save_button" class="pull-right btn btn-theme"><i class="icon-save"></i><?php echo __('Submit') ?></span>
			<?php endif ?>
			</div>
		<?php endif ?>

<script type="text/javascript">
$('span#save_button').click(function(){

	var url = '/creator.php/app/submitappapi/' ;

	if(confirm('Submit this app?')){
		$.ajax({
			type: "POST",
			url: url,
			data: {
		        'accept': 1,
		    },
			dataType: "json",
			cache: false,
			success: function(data, textStatus){
				/*
				$(data.number_of_groups_target).html(data.number_of_groups);
				$(data.html_target).html(data.html);
				*/
				$("#submit_area").text('App submitted');
				alert("<?php echo __('Submitted') ?>") ;
			},
			error: function(xhr, textStatus, errorThrown){
				//alert('Error! ' + textStatus + ' ' + errorThrown);
				location.href = '/creator.php/login' ;
			}
		});
	}
});

</script>


		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
