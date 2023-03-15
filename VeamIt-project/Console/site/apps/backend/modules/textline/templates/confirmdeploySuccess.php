<b>Are you sure you want to deploy this program?</b><br />
<br />
<?php echo link_to('Cancel','textline/show') ?><br />
<br />
<table border="1" bgcolor="#AAAAFF">
	<tr><td>Id</td><td>AppId</td><td>Title</td><td>Text</td><td>CreatedAt</td><td>Actions</td></tr>
	<?php foreach($textlines as $textline): ?>
		<tr>
			<td><?php echo $textline->getId() ?></td>
			<td><?php echo $textline->getAppId() ?></td>
			<td><?php echo $textline->getTitle() ?></td>
			<td><?php echo $textline->getText() ?></td>
			<td><?php echo $textline->getCreatedAt() ?></td>
			<td><?php echo link_to('Deploy','textline/deploy?id=' . $textline->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />

