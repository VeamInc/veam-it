<table border="1">
	<tr><td>Id</td><td>AppId</td><td>Kind</td><td>Author</td><td>Duration</td><td>Title</td><td>Description</td><td>SmallImageUrl</td><td>LargeImageUrl</td><td>DataUrl</td><td>DataSize</td><td>CreatedAt</td><td>Actions</td></tr>
	<?php foreach($programs as $program): ?>
		<tr>
			<td><?php echo $program->getId() ?></td>
			<td><?php echo $program->getAppId() ?></td>
			<td><?php echo $program->getKind() ?></td>
			<td><?php echo $program->getAuthor() ?></td>
			<td><?php echo $program->getDuration() ?></td>
			<td><?php echo $program->getTitle() ?></td>
			<td><?php echo $program->getDescription() ?></td>
			<td><a href="<?php echo $program->getSmallImageUrl() ?>" target="_blank"><img src="<?php echo $program->getSmallImageUrl() ?>" width="120"></a></td>
			<td><a href="<?php echo $program->getLargeImageUrl() ?>" target="_blank"><img src="<?php echo $program->getLargeImageUrl() ?>" width="120"></a></td>
			<td><?php echo $program->getDataUrl() ?></td>
			<td><?php echo $program->getDataSize() ?></td>
			<td><?php echo $program->getCreatedAt() ?></td>
			<td><?php echo link_to('Remove','program/confirmdelete?id=' . $program->getId()) ?><br /><br /><?php echo link_to('Deploy','program/confirmdeploy?id=' . $program->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />
<form action="<?php echo url_for('program/show') ?>" method="POST">
ID:<input type="text" name="id" id="id" /><input type="submit" value="Show" />
</form>

