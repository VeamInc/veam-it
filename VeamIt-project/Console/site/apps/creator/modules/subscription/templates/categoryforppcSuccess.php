<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Categories') ?></h5></div>

		<?php if($app): ?>
	<span id="add_video_button" class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New Video Category') ?></span><br /><br />
	<span id="add_audio_button" class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New Audio Category') ?></span><br /><br />
	<span id="add_pdf_button" class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New PDF Category') ?></span><br /><br />
	<p style="clear:both">
		<?php if(count($sellItemCategories) > 0): ?>
<div style="position: relative;width: 100%;" class="span9 column">
	<div style="position: relative;width: 100%;">
		<table id="list_table" class="table table-striped">
				<thread>
					<th> </th>
					<th><?php echo __('Name') ?></th>
					<th><?php echo __('Kind') ?></th>
					<?php if($deleteEnabled): ?>
					<th> </th>
					<?php endif ?>
				</thread>
			<tbody id="sortdata">
				<?php 
					$count = 0 ;
					foreach($sellItemCategories as $sellItemCategory){
						$kind = $sellItemCategory->getKind() ;
						if($kind == 1){ // video
							$kindName = 'Video' ;
							$name = $videoCategoryMap[$sellItemCategory->getTargetCategoryId()]->getName() ;
						} else if($kind == 2){ // pdf
							$kindName = 'PDF' ;
							$name = $pdfCategoryMap[$sellItemCategory->getTargetCategoryId()]->getName() ;
						} else if($kind == 3){ // audio
							$kindName = 'Audio' ;
							$name = $audioCategoryMap[$sellItemCategory->getTargetCategoryId()]->getName() ;
						}
						$count++ ;
				?>
				<tr id="category_<?php echo $sellItemCategory->getId() ?>">
					<td style="width:15px">
						<i id="btn_edit_<?php echo $sellItemCategory->getId() ?>" class="icon-edit"></i>
					</td>
					<td><span id="<?php echo $sellItemCategory->getId() ?>"><?php echo AdminTools::unescapeName($name) ?></span></td>
					<td><?php echo __($kindName) ?></td>
					<?php if($deleteEnabled): ?>
					<td style="width:30px;min-width:30px;">
						<i id="btn_remove_<?php echo $sellItemCategory->getId() ?>" class="icon-trash"></i>
					</td>
					<?php endif ?>
				</tr>
				<?php } ?>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
<?php foreach($sellItemCategories as $sellItemCategory): ?>
var option = {trigger : $("i#btn_edit_<?php echo $sellItemCategory->getId() ?>"), action : "click"};
$("span#<?php echo $sellItemCategory->getId() ?>").editable(option, function(e){changeSellItemCategoryName('/creator.php/subscription/changesellitemcategorynameapi/id/<?php echo $sellItemCategory->getId() ?>',e.value);});
<?php endforeach ?>

function confirmAndRemoveCategory()
{
	if(confirm('<?php echo __('Remove this category') ?>?')){
		id = $(this).attr("id") ;
		elements = id.split("_") ;
		sellItemCategoryId = elements[2] ;
		$(this).parent().parent().remove() ;
		//alert(sellItemCategoryId) ;
		removeSellItemCategory("/creator.php/subscription/removesellitemcategoryapi/id/"+sellItemCategoryId) ;
	}
}

$('i.icon-trash').click(confirmAndRemoveCategory);

$('span#add_video_button').click(function(){
	sellItemCategoryId = addSellItemCategory("/creator.php/subscription/addsellitemcategoryapi/k/1") ;
	categoryAdded(sellItemCategoryId,'<?php echo __('Video') ?>') ;
});

$('span#add_audio_button').click(function(){
	sellItemCategoryId = addSellItemCategory("/creator.php/subscription/addsellitemcategoryapi/k/3") ;
	categoryAdded(sellItemCategoryId,'<?php echo __('Audio') ?>') ;
});

$('span#add_pdf_button').click(function(){
	sellItemCategoryId = addSellItemCategory("/creator.php/subscription/addsellitemcategoryapi/k/2") ;
	categoryAdded(sellItemCategoryId,'PDF') ;
});

function categoryAdded(addedId,kindName)
{
	if(addedId > 0){
		<?php if($deleteEnabled): ?>
		$('#list_table').append( '<tr id="category_' + addedId + '"><td style="width:15px"><i id="btn_edit_' + addedId + '" class="icon-edit"></i></td><td><span id="' + addedId + '">New Category</span></td><td>'+kindName+'</td><td style="width:30px"><i id="btn_remove_'+addedId+'" class="icon-trash"></i></td></tr>' );
		<?php else: ?>
		$('#list_table').append( '<tr id="category_' + addedId + '"><td style="width:15px"><i id="btn_edit_' + addedId + '" class="icon-edit"></i></td><td><span id="' + addedId + '">New Category</span></td><td>'+kindName+'</td></tr>' );
		<?php endif ?>

		var option = {trigger : $("i#btn_edit_"+addedId), action : "click"};
		$("span#"+addedId).editable(option, function(e){changeSellItemCategoryName('/creator.php/subscription/changesellitemcategorynameapi/id/'+addedId,e.value);});

		$('i#btn_remove_'+addedId).click(confirmAndRemoveCategory);
	}
}

</script>
		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>
		<!--end: Accordion -->
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
