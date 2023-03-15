<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Links') ?></h5></div>

		<?php if($app): ?>
	<span id="add_button" class="pull-right btn btn-theme"><i class="icon-plus-sign"></i><?php echo __('Add New') ?></span>
	<p style="clear:both">
		<?php if(count($webs) > 0): ?>
<div style="position: relative;width: 100%;" class="span9 column">
	<div style="position: relative;width: 100%;">
		<table id="list_table" class="table table-striped">
				<thread>
					<th colspan="2"><?php echo __('Name') ?></th>
					<th colspan="2">URL</th>
					<th> </th>
				</thread>
			<tbody id="sortdata">
				<?php 
					$count = 0 ;
					foreach($webs as $web){
						$count++ ;
				?>
				<tr id="link_<?php echo $web->getId() ?>">
					<td style="width:30px;min-width:30px;">
						<img id="btn_edit_<?php echo $web->getId() ?>" src="/images/admin/list_edit_on.png" width="24" height="24">
					</td>
					<td><span id="<?php echo $web->getId() ?>"><?php echo AdminTools::unescapeName($web->getTitle()) ?></span></td>

					<td style="width:30px;min-width:30px;">
						<img id="btn_edit_url_<?php echo $web->getId() ?>" src="/images/admin/list_edit_on.png" width="24" height="24">
					</td>
					<td><span id="url_<?php echo $web->getId() ?>"><?php echo AdminTools::unescapeName($web->getUrl()) ?></span></td>

					<td style="width:30px;min-width:30px;">
						<img id="btn_remove_<?php echo $web->getId() ?>" src="/images/admin/list_delete_on.png" width="24" height="24" class="icon-trash">
					</td>
				</tr>
				<?php } ?>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
<?php foreach($webs as $web): ?>

var option = {trigger : $("img#btn_edit_<?php echo $web->getId() ?>"), action : "click"};
$("span#<?php echo $web->getId() ?>").editable(option, function(e){changeLinkName('/creator.php/link/changelinknameapi/id/<?php echo $web->getId() ?>',e.value);});

var option = {trigger : $("img#btn_edit_url_<?php echo $web->getId() ?>"), action : "click"};
$("span#url_<?php echo $web->getId() ?>").editable(option, function(e){changeLinkUrl('/creator.php/link/changelinkurlapi/id/<?php echo $web->getId() ?>',e.value);});

<?php endforeach ?>

function confirmAndRemoveLink()
{
	if(confirm('<?php echo __('Remove this link') ?>?')){
		id = $(this).attr("id") ;
		elements = id.split("_") ;
		webId = elements[2] ;
		$(this).parent().parent().remove() ;
		//alert(forumId) ;
		removeLink("/creator.php/link/removelinkapi/id/"+webId) ;
	}
}

$('img.icon-trash').click(confirmAndRemoveLink);

$('span#add_button').click(function(){
	webId = addLink("/creator.php/link/addlinkapi/") ;
	if(webId > 0){
		$('#list_table').append( '<tr id="link_' + webId + '"><td style="width:15px"><img id="btn_edit_' + webId + '" src="/images/admin/list_edit_on.png" width="24" height="24"></td><td><span id="' + webId + '">New Link</span></td><td style="width:15px"><img id="btn_edit_url_' + webId + '" src="/images/admin/list_edit_on.png" width="24" height="24"></td><td><span id="url_' + webId + '">http://veam.co/</span></td><td style="width:30px"><img id="btn_remove_'+webId+'" src="/images/admin/list_delete_on.png" width="24" height="24"></td></tr>' );

		var option = {trigger : $("img#btn_edit_"+webId), action : "click"};
		$("span#"+webId).editable(option, function(e){changeLinkName('/creator.php/link/changelinknameapi/id/'+webId,e.value);});

		var option = {trigger : $("img#btn_edit_url_"+webId), action : "click"};
		$("span#url_"+webId).editable(option, function(e){changeLinkUrl('/creator.php/link/changelinkurlapi/id/'+webId,e.value);});

		$('img#btn_remove_'+webId).click(confirmAndRemoveLink);
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
