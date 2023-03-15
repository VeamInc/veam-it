<table border="1">
	<tr><td>Id</td><td>AppId</td><td>Kind</td><td>Duration</td><td>Title</td><td>Description</td><td>CategoryId</td><td>SubCategoryId</td><td>YoutubeCode</td><td>DisplayOrder</td><td>CreatedAt</td><td>Actions</td></tr>
	<?php foreach($youtubes as $youtube): ?>
		<tr>
			<td><?php echo $youtube->getId() ?></td>
			<td><?php echo $youtube->getAppId() ?></td>
			<td><?php echo $youtube->getKind() ?></td>
			<td><?php echo $youtube->getDuration() ?></td>
			<td><?php echo $youtube->getTitle() ?></td>
			<td><?php echo $youtube->getDescription() ?></td>
			<td><?php echo $youtube->getCategoryId() ?></td>
			<td><?php echo $youtube->getSubCategoryId() ?></td>
			<td><?php echo $youtube->getYoutubeCode() ?></td>
			<td><?php echo $youtube->getDisplayOrder() ?></td>
			<td><?php echo $youtube->getCreatedAt() ?></td>
			<td><?php echo link_to('Remove','youtube/confirmdelete?id=' . $youtube->getId()) ?><br /><br /><?php echo link_to('Deploy','youtube/confirmdeploy?id=' . $youtube->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />
<form action="<?php echo url_for('youtube/show') ?>" method="POST">
ID:<input type="text" name="id" id="id" /><input type="submit" value="Show" />
</form>

