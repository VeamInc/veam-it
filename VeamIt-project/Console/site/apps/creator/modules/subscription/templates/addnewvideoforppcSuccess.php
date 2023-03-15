<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Video') ?></h5></div>
		<?php if($app): ?>
		<?php if(count($videoCategories) > 0): ?>
		<form id="content_form" action="/creator.php/subscription/registervideoforppc" method="post">
			<h6><?php echo __('Category') ?></h6>
			<select id="category" name="category">
				<?php foreach($videoCategories as $videoCategory): ?>
				<option value="<?php echo $videoCategory->getId() ?>"><?php echo $videoCategory->getName() ?></option>
				<?php endforeach ?>
			</select>
										
			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->

			<h6><?php echo __('Title') ?></h6>
			<input placeholder="* <?php echo __('Title') ?>" type="text" id="title" name="title" value="">
										
			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->

			<h6><?php echo __('Dropbox Video URL') ?></h6>
			<input placeholder="https://www.dropbox.com/..." type="text" id="video_url" name="video_url" value="">
										
			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->

			<h6><?php echo __('Dropbox Thumbnail URL') ?></h6>
			<input placeholder="https://www.dropbox.com/..." type="text" id="thumbnail_url" name="thumbnail_url" value="">
										
			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->

			<h6><?php echo __('Price') ?></h6>
			<select id="price" name="price">
				<?php foreach($prices as $price): ?>
				<option value="<?php echo $price ?>"><?php echo $price ?></option>
				<?php endforeach ?>
			</select>
										
			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->

			<h6><?php echo __('Description') ?></h6>
			<textarea rows="12" class="input-block-level" id="description" name="description" placeholder="*<?php echo __('Video description here') ?>"></textarea>

			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->


			<span id="save_button" class="pull-right btn btn-theme"><i class="icon-save"></i><?php echo __('Save') ?></span>
		</form>

<script type="text/javascript">
$('span#save_button').click(function(){
	//alert("submit") ;

	var title = $('#title').val() ;
	var videoUrl = $('#video_url').val() ;
	var thumbnailUrl = $('#thumbnail_url').val() ;
	var description = $('#description').val() ;

	if((title == "") || (videoUrl == "") || (thumbnailUrl == "") || (description == "")){
		alert("<?php echo __('Please enter the values') ?>") ;
	} else {
		if(videoUrl.substring(0,26) != 'https://www.dropbox.com/s/'){
			alert("<?php echo __('Please enter the shared Dropbox URL for video data.') ?>\n<?php echo __('Like https://www.dropbox.com/s/...') ?>") ;
		} else if(!videoUrl.match(/(\.mov)|(\.mp4)|(\.mpg)|(\.m4v)|(\.mts)|(\.wmv)/)){
			alert("<?php echo __('Please select the file with following extensions for video data.') ?>\n.mov .mp4 .mpg .m4v .mts .wmv") ;

		} else if(thumbnailUrl.substring(0,26) != 'https://www.dropbox.com/s/'){
			alert("<?php echo __('Please enter the shared Dropbox URL for thumbnail data.') ?>\n<?php echo __('Like https://www.dropbox.com/s/...') ?>") ;
		} else if(!thumbnailUrl.match(/(\.jpg)|(\.png)/)){
			alert("<?php echo __('Please select the file with following extensions for thumbnail data.') ?>\n.jpg .png") ;

		} else {
			$('#content_form').submit();
		}
	}
});

</script>

		<?php else: /* categories */ ?>
		<a href="/creator.php/subscription/category"><?php echo __('Please add a video category.') ?></a>
		<?php endif ?>

		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
