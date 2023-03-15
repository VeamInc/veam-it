<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo __('Playlists') ?></h5></div>

		<?php if($app): ?>
		<!-- 2.Sorted YouTube List -->
		<?php if(count($youtubeCategories) > 0): ?>
<div style="position: relative;width: 100%;" class="span9 column">
	<div style="position: relative;width: 100%;">
		<table id="list_table" class="table table-striped">
				<thread>
					<th><?php echo __('Disable') ?></th>
					<th><?php echo __('Name') ?></th>
				</thread>
			<tbody id="sortdata">
				<?php 
					$count = 0 ;
					foreach($youtubeCategories as $youtubeCategory){
						$count++ ;
				?>
				<tr id="category_<?php echo $youtubeCategory->getId() ?>">
					<td style="width:50px;min-width:50px;">
						<img id="<?php echo $youtubeCategory->getId() ;?>" src="/images/admin/list_disable_<?php echo ($youtubeCategory->getDisabled() == '1')?'on':'off' ; ?>.png" width="24" height="24" onclick="javascript:activatePlaylist(this);">
					</td>
					<td><?php echo AdminTools::unescapeName($youtubeCategory->getName()) ?></td>
				</tr>
				<?php } ?>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
function activatePlaylist(obj)
{
	var activation = 1 ;

	var src = obj.src ;
	var fileName = src.substring(src.lastIndexOf('/')+1, src.length) ;

	if(fileName == 'list_disable_off.png'){
		activation = 0 ;
		obj.src = "/images/admin/list_disable_on.png" ;
	} else {
		activation = 1 ;
		obj.src = "/images/admin/list_disable_off.png" ;
	}
	activateYoutubeCategory('/creator.php/youtube/changecategoryactivationapi/id/' + obj.id + '/ac/'+activation) ;
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
