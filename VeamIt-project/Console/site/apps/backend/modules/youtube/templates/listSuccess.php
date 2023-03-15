<table border="1">
	<tr><td>Id</td><td>AppId</td><td>Kind</td><td>Duration</td><td>Title</td><td>Description</td><td>CategoryId</td><td>SubCategoryId</td><td>YoutubeCode</td><td>DisplayOrder</td><td>CreatedAt</td></tr>
	<?php foreach($youtubes as $youtube): ?>
		<tr>
			<td><?php echo link_to($youtube->getId(),'youtube/show?id='.$youtube->getId()) ?></td>
			<td><?php echo $youtube->getAppId() ?></td>
			<td><?php echo $youtube->getKind() ?></td>
			<td><?php echo $youtube->getDuration() ?></td>
			<td><?php echo $youtube->getTitle() ?></td>
			<td><?php echo $youtube->getDescription() ?></td>
			<td><?php echo $categoryNames[$youtube->getCategoryId()] ?></td>
			<td><?php echo $subCategoryNames[$youtube->getSubCategoryId()] ?></td>
			<td><?php echo $youtube->getYoutubeCode() ?></td>
			<td><?php echo $youtube->getDisplayOrder() ?></td>
			<td><?php echo $youtube->getCreatedAt() ?></td>
		</tr>
	<?php endforeach ?>
</table>
<?php echo link_to('Next page','youtube/list?p='.($pageNo+1).'&a='.$appId) ?>
