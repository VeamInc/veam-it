<table border="1">
	<tr><td>ID</td><td>Name</td><td>Store App Name</td><td>Status</td><td>CreatedAt</td><td>Actions</td></tr>
	<?php foreach($apps as $app): ?>
		<tr>
			<td><?php echo $app->getId() ?></td>
			<td><?php echo $app->getName() ?></td>
			<td><?php echo $app->getStoreAppName() ?></td>
			<td><?php echo $app->getStatus() ?></td>
			<td><?php echo $app->getCreatedAt() ?></td>
			<td><?php echo link_to('Initialize','app/confirminitialize?id=' . $app->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />
<form action="<?php echo url_for('app/show') ?>" method="POST">
ID:<input type="text" name="id" id="id" /><input type="submit" value="Show" />
</form>
