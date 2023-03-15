<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Categories') ?></h5></div>

		<?php if($app): ?>
	<span id="add_category_button" class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New Category') ?></span><br /><br />
	<p style="clear:both">
		<?php if(count($sellSectionCategories) > 0): ?>
<div style="position: relative;width: 100%;" class="span9 column">
	<div style="position: relative;width: 100%;">
		<table id="list_table" class="table table-striped">
				<thread>
					<th> </th>
					<th><?php echo __('Name') ?></th>
					<?php if($deleteEnabled): ?>
					<th> </th>
					<?php endif ?>
				</thread>
			<tbody id="sortdata">
				<?php 
					$count = 0 ;
					foreach($sellSectionCategories as $sellSectionCategory){
						$kind = $sellSectionCategory->getKind() ;
						$name = $sellSectionCategory->getName() ;
						$count++ ;
				?>
				<tr id="category_<?php echo $sellSectionCategory->getId() ?>">
					<td style="width:15px">
						<i id="btn_edit_<?php echo $sellSectionCategory->getId() ?>" class="icon-edit"></i>
					</td>
					<td><span id="<?php echo $sellSectionCategory->getId() ?>"><?php echo AdminTools::unescapeName($name) ?></span></td>
					<?php if($deleteEnabled): ?>
					<td style="width:30px;min-width:30px;">
						<i id="btn_remove_<?php echo $sellSectionCategory->getId() ?>" class="icon-trash"></i>
					</td>
					<?php endif ?>
				</tr>
				<?php } ?>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
<?php foreach($sellSectionCategories as $sellSectionCategory): ?>
var option = {trigger : $("i#btn_edit_<?php echo $sellSectionCategory->getId() ?>"), action : "click"};
$("span#<?php echo $sellSectionCategory->getId() ?>").editable(option, function(e){changeSellSectionCategoryName('/creator.php/subscription/changesellsectioncategorynameapi/id/<?php echo $sellSectionCategory->getId() ?>',e.value);});
<?php endforeach ?>

function confirmAndRemoveCategory()
{
	if(confirm('<?php echo __('Remove this category') ?>?')){
		id = $(this).attr("id") ;
		elements = id.split("_") ;
		sellSectionCategoryId = elements[2] ;
		$(this).parent().parent().remove() ;
		//alert(sellSectionCategoryId) ;
		removeSellSectionCategory("/creator.php/subscription/removesellsectioncategoryapi/id/"+sellSectionCategoryId) ;
	}
}

$('i.icon-trash').click(confirmAndRemoveCategory);

$('span#add_category_button').click(function(){
	sellSectionCategoryId = addSellSectionCategory("/creator.php/subscription/addsellsectioncategoryapi/k/1") ;
	categoryAdded(sellSectionCategoryId,'<?php echo __('Video') ?>') ;
});

function categoryAdded(addedId,kindName)
{
	if(addedId > 0){
		<?php if($deleteEnabled): ?>
		$('#list_table').append( '<tr id="category_' + addedId + '"><td style="width:15px"><i id="btn_edit_' + addedId + '" class="icon-edit"></i></td><td><span id="' + addedId + '">New Category</span></td><td style="width:30px"><i id="btn_remove_'+addedId+'" class="icon-trash"></i></td></tr>' );
		<?php else: ?>
		$('#list_table').append( '<tr id="category_' + addedId + '"><td style="width:15px"><i id="btn_edit_' + addedId + '" class="icon-edit"></i></td><td><span id="' + addedId + '">New Category</span></td></tr>' );
		<?php endif ?>

		var option = {trigger : $("i#btn_edit_"+addedId), action : "click"};
		$("span#"+addedId).editable(option, function(e){changeSellSectionCategoryName('/creator.php/subscription/changesellsectioncategorynameapi/id/'+addedId,e.value);});

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
