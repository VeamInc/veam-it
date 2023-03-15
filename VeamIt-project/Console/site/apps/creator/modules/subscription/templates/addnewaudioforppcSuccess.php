<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Audio') ?></h5></div>
		<?php if($app): ?>
		<?php if(count($audioCategories) > 0): ?>
		<form id="content_form" action="/creator.php/subscription/registeraudioforppc" method="post">
			<h6><?php echo __('Category') ?></h6>
			<select id="category" name="category">
				<?php foreach($audioCategories as $audioCategory): ?>
				<option value="<?php echo $audioCategory->getId() ?>"><?php echo $audioCategory->getName() ?></option>
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

			<h6><?php echo __('Dropbox Audio URL') ?></h6>
			<input placeholder="https://www.dropbox.com/s/..." type="text" id="audio_url" name="audio_url" value="">
										
			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->

			<h6><?php echo __('Dropbox Thumbnail URL') ?></h6>
			<input placeholder="https://www.dropbox.com/s/..." type="text" id="thumbnail_url" name="thumbnail_url" value="">
										
			<!-- divider -->
			<div class="solidline">
			</div>
			<!-- end divider -->

			<h6><?php echo __('Dropbox PDF URL (optional)') ?></h6>
			<input placeholder="https://www.dropbox.com/s/..." type="text" id="pdf_url" name="pdf_url" value="">
										
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
			<textarea rows="12" class="input-block-level" id="description" name="description" placeholder="*<?php echo __('Audio description here') ?>"></textarea>

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
	var audioUrl = $('#audio_url').val() ;
	var thumbnailUrl = $('#thumbnail_url').val() ;
	var description = $('#description').val() ;
	var pdfUrl = $('#pdf_url').val() ;


	if((title == "") || (audioUrl == "") || (thumbnailUrl == "") || (description == "")){
		alert("<?php echo __('Please enter the values') ?>") ;
	} else {
		if(audioUrl.substring(0,26) != 'https://www.dropbox.com/s/'){
			alert("<?php echo __('Please enter the shared Dropbox URL for audio data.') ?>\n<?php echo __('Like https://www.dropbox.com/s/...') ?>") ;
		} else if(!audioUrl.match(/(\.aac)|(\.mp3)|(\.m4a)/)){
			alert("<?php echo __('Please select the file with following extensions for audio data.') ?>\n.aac .mp3 .m4a") ;

		} else if(thumbnailUrl.substring(0,26) != 'https://www.dropbox.com/s/'){
			alert("<?php echo __('Please enter the shared Dropbox URL for thumbnail data.') ?>\n<?php echo __('Like https://www.dropbox.com/s/...') ?>") ;
		} else if(!thumbnailUrl.match(/(\.jpg)|(\.png)/)){
			alert("<?php echo __('Please select the file with following extensions for thumbnail data.') ?>\n.jpg .png") ;

		} else if(pdfUrl && (pdfUrl.substring(0,26) != 'https://www.dropbox.com/s/')){
			alert("<?php echo __('Please enter the shared Dropbox URL for pdf data.') ?>\n<?php echo __('Like https://www.dropbox.com/s/...') ?>") ;
		} else if(pdfUrl && !pdfUrl.match(/(\.pdf)/)){
			alert("<?php echo __('Please select the file with following extensions for PDF data.') ?>\n.pdf") ;

		} else {
			$('#content_form').submit();
		}
	}
});

</script>
		<?php else: /* categories */ ?>
		<a href="/creator.php/subscription/category"><?php echo __('Please add a audio category.') ?></a>
		<?php endif ?>
		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
