<b>Are you sure you want to remove this audio?</b><br />
<br />
<?php echo link_to('Cancel','audio/show') ?><br />
<br />
<table border="1" bgcolor="#FF0000">
	<tr><td>Id</td><td>AppId</td><td>Kind</td><td>Author</td><td>Duration</td><td>Title</td><td>Description</td><td>LinkUrl</td><td>LargeImageUrl</td><td>DataUrl</td><td>DataSize</td><td>MixedId</td><td>MixedImageUrl</td><td>CreatedAt</td><td>Actions</td></tr>
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
				<?php $mixedId = $mixed->getId() ; ?>
				<td><?php echo $mixed->getId() ?></td>
				<td><a href="<?php echo $mixed->getThumbnailUrl() ?>" target="_blank"><img src="<?php echo $mixed->getThumbnailUrl() ?>" width="120"></a></td>
			<?php else: ?>
				<?php $mixedId = 0 ; ?>
				<td>no mixed</td>
				<td>no mixed</td>
			<?php endif ?>
			<td><?php echo $audio->getCreatedAt() ?></td>
			<td><?php echo link_to('Remove','audio/delete?id=' . $audio->getId(). '&mid=' . $mixedId) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />

