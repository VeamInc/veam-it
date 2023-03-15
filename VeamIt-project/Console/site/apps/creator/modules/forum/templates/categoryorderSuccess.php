<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Forum Categories') ?></h5></div>

		<?php if($app): ?>
		<?php if(count($forums) > 0): ?>
<div style="position: relative;width: 100%;" class="span9 column">
	<div style="position: relative;width: 100%;">
		<table id="list_table" class="table table-striped">
				<thread>
					<th><?php echo __('Name') ?></th>
					<th><?php echo __('Order') ?></th>
				</thread>
			<tbody id="sortdata">
				<?php 
					$count = 0 ;
					foreach($forums as $forum){
						$count++ ;
				?>
				<tr id="category_<?php echo $forum->getId() ?>">
					<td><?php echo AdminTools::unescapeName($forum->getName()) ?></td>
					<td style="width:30px;min-width:30px;"><img src="/images/admin/list_move_on.png" width="24" height="24"></td>
				</tr>
				<?php } ?>
			</tbody>
		</table>
		<div style="position: absolute;margin-right: 30px;top: 0;left: 0;bottom: 0;right: 30px;"></div>
	</div>
</div>
<script type="text/javascript">
jQuery(function($) {
    $('#sortdata').sortable();
});

$('#sortdata').bind('sortstop',function(){
	var table = document.getElementById("list_table") ;
	var length = table.rows.length ;
	var ids = "" ;
	for(count = 0 ; count < length ; count++){
		if(ids != ""){
			ids += "," ;
		}
		id = table.rows[count].id ;
		elements = id.split("_") ;
		ids += elements[1] ;
	}
	changeForumCategoryOrder('/creator.php/forum/changecategoryorderapi/ids/' + ids) ;

});
</script>
		<?php else: ?>
		There are no results.
		<?php endif ?>
		<!--end: Accordion -->
		<?php endif ?>
	</div>
</div>
<!-- end: Right Content -->
