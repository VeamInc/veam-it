<b>Are you sure you want to deploy this program?</b><br />
<br />
<?php echo link_to('Cancel','youtube/show') ?><br />
<br />
<table border="1" bgcolor="#AAAAFF">
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
			<td><?php echo link_to('Deploy','youtube/deploy?id=' . $youtube->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />

