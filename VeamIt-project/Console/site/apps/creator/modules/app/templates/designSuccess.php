<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Customize Your App Design') ?></h5></div>
		<?php if($app): ?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $app->getBackgroundImage() ?>" id="splash_image" alt="" height="100" width="177"></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo __('Splash') ?> &amp; <?php echo __('Background image') ?> (640 x 1136) 
						<span class="portfolio-image">
							<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Splash') ?> &amp; <?php echo __('Background image') ?>" href="/images/admin/help/c_custom_design_1.png"><i class="icon-question-sign"></i></a>
							<img src="/images/admin/help/c_custom_design_1.png" alt="<?php echo __('Size') ?> : 640 x 1136 px (<?php echo __('Portrait') ?>)" style="visibility: hidden;" width="1" height="1">
						</span>
					</h6>
					<ul class="meta-post">
						<?php if(($app->getStatus() == 1) || ($app->getStatus() == 4)): ?>
						<table>
							<tr><td>
								<span class="btn btn-theme fileinput-button">
									<span style="color: white;" ><?php echo __('Select file') ?></span>
									<input id="splashfileupload" type="file" name="upfile">
								</span>
							</td></tr>
							<tr><td>
								<!-- The global progress bar -->
								<div id="progress" class="progress" style="width: 100%;height: 5px;">
									<div  id="splash_progress_bar" class="progress-bar progress-bar-success" style="background-color: red;width: 0px;height: 5px;"></div>
								</div>
							</td></tr>
						</table>
						<?php endif ?>
					</ul>
				</div>
			</div>
		</div>

		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $app->getIconImage() ?>" id="icon_image" alt="" height="177" width="177"></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo __('Icon image') ?> (1024 x 1024)
						<span class="portfolio-image">
							<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Icon image') ?>" href="/images/admin/help/c_custom_design_3.png"><i class="icon-question-sign"></i></a>
							<img src="/images/admin/help/c_custom_design_3.png" alt="<?php echo __('Size') ?> : 1024 x 1024 px" style="visibility: hidden;" width="1" height="1">
						</span>
					</h6>

					<ul class="meta-post">
						<?php if(($app->getStatus() == 1) || ($app->getStatus() == 4)): ?>
						<table>
							<tr><td>
								<span class="btn btn-theme fileinput-button">
									<span style="color: white;" ><?php echo __('Select file') ?></span>
									<input id="iconfileupload" type="file" name="upfile">
								</span>
							</td></tr>
							<tr><td>
								<!-- The global progress bar -->
								<div id="progress" class="progress" style="width: 100%;height: 5px;">
									<div id="icon_progress_bar" class="progress-bar progress-bar-success" style="background-color: red;width: 0px;height: 5px;"></div>
								</div>
							</td></tr>
						</table>
						<?php endif ?>
					</ul>
				</div>
			</div>
		</div>

		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $rightImageUrl ?>" id="right_image" alt="" height="177" width="177"></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo __('Main image') ?> (1024 x 1024)
						<span class="portfolio-image">
							<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Main image') ?>" href="/images/admin/help/c_custom_design_4.png"><i class="icon-question-sign"></i></a>
							<img src="/images/admin/help/c_custom_design_4.png" alt="<?php echo __('Size') ?> : 1024 x 1024 px" style="visibility: hidden;" width="1" height="1">
						</span>
					</h6>

					<ul class="meta-post">
						<?php if(($app->getStatus() == 1) || ($app->getStatus() == 4)): ?>
						<table>
							<tr><td>
								<span class="btn btn-theme fileinput-button">
									<span style="color: white;" ><?php echo __('Select file') ?></span>
									<input id="rightfileupload" type="file" name="upfile">
								</span>
							</td></tr>
							<tr><td>
								<!-- The global progress bar -->
								<div id="progress" class="progress" style="width: 100%;height: 5px;">
									<div id="right_progress_bar" class="progress-bar progress-bar-success" style="background-color: red;width: 0px;height: 5px;"></div>
								</div>
							</td></tr>
						</table>
						<?php endif ?>
					</ul>
				</div>
			</div>
		</div>

		<div class="media">
			<div class="thumbnail pull-left"><img src="/images/admin/spacer.gif" id="concept_color" style="background-color: #<?php echo $appColorCode; ?>" alt="" height="177" width="177"></div>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo __('Color') ?>
						<span class="portfolio-image">
							<a class="hover-wrap fancybox" data-fancybox-group="gallery" title="<?php echo __('Color') ?>" href="/images/admin/help/c_custom_design_2.png"><i class="icon-question-sign"></i></a>
							<img src="/images/admin/help/c_custom_design_2.png" alt="" style="visibility: hidden;" width="1" height="1">
						</span>
					</h6>
					<ul class="meta-post">
						<?php if(($app->getStatus() == 1) || ($app->getStatus() == 4)): ?>
						<table>
							<tr><td>
								<input type="color" id="colorinput" name="colorinput" value="#<?php echo $appColorCode; ?>">
							</td></tr>
							<tr><td>
								<!-- The global progress bar -->
								<div id="progress" class="progress" style="width: 100%;height: 5px;">
									<div id="color_progress_bar" class="progress-bar progress-bar-success" style="background-color: red;width: 0px;height: 5px;"></div>
								</div>
							</td></tr>
						</table>
						<?php endif ?>
					</ul>
				</div>
			</div>
		</div>


<script>
$(function () {
    'use strict';
    var url = '/creator.php/app/uploadsplash';
    $('#splashfileupload').fileupload({
        url: url,
        dataType: 'json',
        done: function (e, data) {
			//alert("done : " + data.result.image_url) ;
            $('#progress #splash_progress_bar').css('width','100%');
			$('#splash_image').attr("src",data.result.image_url) ;
        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 90, 10);
			//alert("progress : " + progress) ;
            $('#progress #splash_progress_bar').css('width',progress + '%');
        }
    }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
});

$(function () {
    'use strict';
    var url = '/creator.php/app/uploadicon';
    $('#iconfileupload').fileupload({
        url: url,
        dataType: 'json',
        done: function (e, data) {
			//alert("done : " + data.result.image_url) ;
            $('#progress #icon_progress_bar').css('width','100%');
			$('#icon_image').attr("src",data.result.image_url) ;
        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 90, 10);
			//alert("progress : " + progress) ;
            $('#progress #icon_progress_bar').css('width',progress + '%');
        }
    }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
});

$(function () {
    'use strict';
    var url = '/creator.php/app/uploadrightimage';
    $('#rightfileupload').fileupload({
        url: url,
        dataType: 'json',
        done: function (e, data) {
			//alert("done : " + data.result.image_url) ;
            $('#progress #right_progress_bar').css('width','100%');
			$('#right_image').attr("src",data.result.image_url) ;
        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 90, 10);
			//alert("progress : " + progress) ;
            $('#progress #right_progress_bar').css('width',progress + '%');
        }
    }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
});

$('#colorinput').on('change',function(){
	var colorValue = $(this).val() ;
	var colorCode = colorValue.substring(1) ;
	changeConceptColor('/creator.php/app/changeconceptcolorapi/cv/' + colorCode) ;
    $('#concept_color').css('background-color',colorValue);
});


</script>

		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
