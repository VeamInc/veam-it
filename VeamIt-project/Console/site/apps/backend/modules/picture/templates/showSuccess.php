<table border="1">
	<tr><td>ID</td><td>Forum</td><td>User</td><td>Likes</td><td>Image</td><td>Comments</td><td>CreatedAt</td><td>Actions</td></tr>
	<?php foreach($pictures as $picture): ?>
		<tr>
			<td><?php echo $picture->getId() ?></td>
			<td><?php echo $picture->getForumId() ?></td>
			<td><?php echo $picture->getSocialUserId() ?></td>
			<td><?php echo $picture->getNumberOfLikes() ?></td>
			<td>
				<?php if($picture->getUrl() == 'SWATCH'): ?>
					<?php $swatch = $swatchesForPictureId[$picture->getId()] ?>
					<?php if($swatch->getImage1()): ?><img src="<?php echo $swatch->getBaseUrl().$swatch->getImage1() ?>" width="150"><br /><?php endif ?>
					<?php if($swatch->getImage2()): ?><img src="<?php echo $swatch->getBaseUrl().$swatch->getImage2() ?>" width="150"><br /><?php endif ?>
					<?php if($swatch->getImage3()): ?><img src="<?php echo $swatch->getBaseUrl().$swatch->getImage3() ?>" width="150"><br /><?php endif ?>
					<?php if($swatch->getImage4()): ?><img src="<?php echo $swatch->getBaseUrl().$swatch->getImage4() ?>" width="150"><br /><?php endif ?>
					<?php if($swatch->getImage5()): ?><img src="<?php echo $swatch->getBaseUrl().$swatch->getImage5() ?>" width="150"><br /><?php endif ?>
				<?php else: ?>
					<a href="<?php echo $picture->getUrl() ?>" target="_blank"><img src="<?php echo $picture->getUrl() ?>" width="150"></a>
				<?php endif ?>
			</td>
			<td><?php echo str_replace("\n","<br />",$commentsForPictureId[$picture->getId()]) ?></td>
			<td><?php echo $picture->getCreatedAt() ?></td>
			<td><?php echo link_to('Remove','picture/confirmdelete?id=' . $picture->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />
<form action="<?php echo url_for('picture/show') ?>" method="POST">
ID:<input type="text" name="id" id="id" /><input type="submit" value="Show" />
</form>

