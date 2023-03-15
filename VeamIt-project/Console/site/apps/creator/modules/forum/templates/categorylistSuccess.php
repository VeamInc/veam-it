<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Forum Categories') ?></h5></div>

		<?php if($app): ?>
	<span id="add_button" class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New') ?></span>
	<p style="clear:both">
		<?php if(count($forums) > 0): ?>
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
					foreach($forums as $forum){
						$count++ ;
				?>
				<tr id="category_<?php echo $forum->getId() ?>">
					<td style="width:30px;min-width:30px;">
						<img id="btn_edit_<?php echo $forum->getId() ?>" src="/images/admin/list_edit_on.png" width="24" height="24">
					</td>
					<td><span id="<?php echo $forum->getId() ?>"><?php echo AdminTools::unescapeName($forum->getName()) ?></span></td>
					<?php if($deleteEnabled): ?>
					<td style="width:30px;min-width:30px;">
						<img id="btn_remove_<?php echo $forum->getId() ?>" src="/images/admin/list_delete_on.png" width="24" height="24" class="icon-trash">
					</td>
					<?php endif ?>
				</tr>
				<?php } ?>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
<?php foreach($forums as $forum): ?>
var option = {trigger : $("img#btn_edit_<?php echo $forum->getId() ?>"), action : "click"};
$("span#<?php echo $forum->getId() ?>").editable(option, function(e){changeForumCategoryName('/creator.php/forum/changecategorynameapi/id/<?php echo $forum->getId() ?>',e.value);});
<?php endforeach ?>

function confirmAndRemoveCategory()
{
	if(confirm('<?php echo __('Remove this forum category') ?>?')){
		id = $(this).attr("id") ;
		elements = id.split("_") ;
		forumId = elements[2] ;
		$(this).parent().parent().remove() ;
		//alert(forumId) ;
		removeForumCategory("/creator.php/forum/removecategoryapi/id/"+forumId) ;
	}
}

$('img.icon-trash').click(confirmAndRemoveCategory);

$('span#add_button').click(function(){
	forumId = addForumCategory("/creator.php/forum/addcategoryapi/") ;
	if(forumId > 0){
		<?php if($deleteEnabled): ?>
		$('#list_table').append( '<tr id="category_' + forumId + '"><td style="width:15px"><img id="btn_edit_' + forumId + '" src="/images/admin/list_edit_on.png" width="24" height="24"></td><td><span id="' + forumId + '">New Category</span></td><td style="width:30px"><img id="btn_remove_'+forumId+'" src="/images/admin/list_delete_on.png" width="24" height="24" class="icon-trash"></td></tr>' );
		<?php else: ?>
		$('#list_table').append( '<tr id="category_' + forumId + '"><td style="width:15px"><img id="btn_edit_' + forumId + '" src="/images/admin/list_edit_on.png" width="24" height="24"></td><td><span id="' + forumId + '">New Category</span></td></tr>' );
		<?php endif ?>

		var option = {trigger : $("img#btn_edit_"+forumId), action : "click"};
		$("span#"+forumId).editable(option, function(e){changeForumCategoryName('/creator.php/forum/changecategorynameapi/id/'+forumId,e.value);});

		$('img#btn_remove_'+forumId).click(confirmAndRemoveCategory);
	}
});

/*

$("span#edit").editable(option, function(e){
  alert(e.value);
});
*/
</script>
		<?php else: ?>
		<?php echo __('There are no results.') ?>
		<?php endif ?>
		<!--end: Accordion -->
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
