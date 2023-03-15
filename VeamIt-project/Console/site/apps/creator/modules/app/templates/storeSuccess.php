<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Preparing for App Submission') ?></h5></div>
		<?php if($app): ?>
		<form id="commentform" action="#" method="post" name="comment-form">
		<h6><?php echo __('App Name') ?></h6>
		<input placeholder="* <?php echo __('Enter App Name') ?>" type="text" id="app_name" value="<?php echo $app->getName() ?>">
									
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<h6><?php echo __('Store App Name') ?></h6>
		<input placeholder="* <?php echo __('Enter Store App Name') ?>" type="text" id="app_store_name" value="<?php echo $app->getStoreAppName() ?>">
									
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<h6><?php echo __('Description') ?></h6>
		<textarea rows="12" class="input-block-level" id="description" placeholder="* <?php echo __('Enter Description') ?>"><?php echo $app->getDescription() ?></textarea>
									
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<h6><?php echo __('Keywords') ?></h6>
		<input placeholder="* <?php echo __('Enter Keywords') ?>" type="text" id="keywords" value="<?php echo $app->getKeyWord() ?>">
									
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->


		<h6><?php echo __('Screenshots') ?></h6>
		<?php if($app->getScreenShot1()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot1() ?>" alt="" width="120" height="213" /></div><?php endif ?>
		<?php if($app->getScreenShot2()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot2() ?>" alt="" width="120" height="213" /></div><?php endif ?>
		<?php if($app->getScreenShot3()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot3() ?>" alt="" width="120" height="213" /></div><?php endif ?>
		<?php if($app->getScreenShot4()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot4() ?>" alt="" width="120" height="213" /></div><?php endif ?>
		<?php if($app->getScreenShot5()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot5() ?>" alt="" width="120" height="213" /></div><?php endif ?>
		<p style="clear:both" />

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php $appCategory = $app->getCategory() ; ?>
		<h6><?php echo __('App Category') ?></h6>
		<select id="category">
			<option value="" <?php echo ($appCategory == "")?"selected":"" ; ?>><?php echo __('select') ?></option>
			<?php foreach($categories as $category): ?>
			<option value="<?php echo $category ?>" <?php echo ($appCategory == $category)?"selected":"" ; ?>><?php echo __($category) ?></option>
			<?php endforeach ?>
		</select>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<h6><?php echo __('App Rating') ?></h6>
		<table id="list_table" class="table table-striped">
			<thread><th><?php echo __('Question') ?></th><th><?php echo __('Answer') ?></th></thread>
			<?php 
				foreach($appRatingQuestions as $appRatingQuestion){ 
					$question = $appRatingQuestion->getQuestion() ;
					$selectionsString = $appRatingQuestion->getSelections() ;
					$selections = explode('|',$selectionsString) ;
					$answer = $appRatingAnswerMap[$appRatingQuestion->getId()] ;
			?>
				<tr>
					<td><?php echo __($question) ?></td>
					<td>
						<select id="answer_<?php echo $appRatingQuestion->getId() ?>">
							<option value="" <?php echo $answer?"":"selected" ; ?>><?php echo __('select') ?></option>
							<?php foreach($selections as $selection): ?>
							<option value="<?php echo $selection ?>" <?php if($answer && ($answer->getAnswer() == $selection)){echo "selected";} ?>><?php echo __($selection) ?></option>
							<?php endforeach ?>
						</select>
					</td>
				</tr>
			<?php } ?>
		</table>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

		<?php if(($app->getStatus() == 1) || ($app->getStatus() == 4)): ?>
		<span id="save_button" class="pull-right btn btn-theme"><i class="icon-save"></i><?php echo __('Save') ?></span>
		<?php endif ?>

<script type="text/javascript">
$('span#save_button').click(function(){

	var url = '/creator.php/app/savestoreinfoapi/' ;

	var appName = $('#app_name').val() ;
	var appStoreName = $('#app_store_name').val() ;
	var description = $('#description').val() ;
	var keywords = $('#keywords').val() ;
	var category = $('#category option:selected').text() ;
	<?php foreach($appRatingQuestions as $appRatingQuestion): ?>
    var answer<?php echo $appRatingQuestion->getId() ?> = $('#answer_<?php echo $appRatingQuestion->getId() ?> option:selected').attr('value') ;
	<?php endforeach ?>

	$.ajax({
		type: "POST",
		url: url,
		data: {
	        'app_name': appName,
	        'store_app_name': appStoreName,
	        'description': description,
	        'keywords': keywords,
	        'category': category,
			<?php foreach($appRatingQuestions as $appRatingQuestion): ?>
	        'answer_<?php echo $appRatingQuestion->getId() ?>': answer<?php echo $appRatingQuestion->getId() ?>,
			<?php endforeach ?>
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
