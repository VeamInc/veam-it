<table border="1">
	<tr><td>Id</td><td>AppId</td><td>Kind</td><td>Author</td><td>Duration</td><td>Title</td><td>Description</td><td>LinkUrl</td><td>ImageUrl</td><td>DataUrl</td><td>DataSize</td><td>MixedId</td><td>MixedImageUrl</td><td>CreatedAt</td><td>Actions</td></tr>
	<?php foreach($audios as $audio): ?>
		<?php $mixed = $mixedMap[$audio->getId()] ; ?>
		<tr>
			<td><?php echo $audio->getId() ?></td>
			<td><?php echo $audio->getAppId() ?></td>
			<td><?php echo $audio->getKind() ?></td>
			<td><?php echo $audio->getAuthor() ?></td>
			<td><?php echo $audio->getDuration() ?></td>
			<td><?php echo $audio->getTitle() ?></td>
			<td><?php echo $audio->getDescription() ?></td>
			<td><?php echo $audio->getLinkUrl() ?></td>
			<td><a href="<?php echo $audio->getImageUrl() ?>" target="_blank"><img src="<?php echo $audio->getImageUrl() ?>" width="120"></a></td>
			<td><?php echo $audio->getDataUrl() ?></td>
			<td><?php echo $audio->getDataSize() ?></td>
			<?php if($mixed): ?>
				<td><?php echo $mixed->getId() ?></td>
				<td><a href="<?php echo $mixed->getThumbnailUrl() ?>" target="_blank"><img src="<?php echo $mixed->getThumbnailUrl() ?>" width="120"></a></td>
			<?php else: ?>
				<td>no mixed</td>
				<td>no mixed</td>
			<?php endif ?>
			<td><?php echo $audio->getCreatedAt() ?></td>
			<td><?php echo link_to('Remove','audio/confirmdelete?id=' . $audio->getId()) ?><br /><br /><?php echo link_to('Deploy','audio/confirmdeploy?id=' . $audio->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />
<form action="<?php echo url_for('audio/show') ?>" method="POST">
ID:<input type="text" name="id" id="id" /><input type="submit" value="Show" />
</form>

