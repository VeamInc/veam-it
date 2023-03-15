<b>Are you sure you want to initialize this app?</b><br />
<br />
<?php echo link_to('Cancel','app/list') ?><br />
<br />
<table border="1" bgcolor="#FF0000">
	<tr><td>ID</td><td>Name</td><td>Store App Name</td><td>Status</td><td>CreatedAt</td><td>Actions</td></tr>
	<?php foreach($apps as $app): ?>
		<tr>
			<td><?php echo $app->getId() ?></td>
			<td><?php echo $app->getName() ?></td>
			<td><?php echo $app->getStoreAppName() ?></td>
			<td><?php echo $app->getStatus() ?></td>
			<td><?php echo $app->getCreatedAt() ?></td>
			<td><?php echo link_to('Initialize','app/initialize?id=' . $app->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />

