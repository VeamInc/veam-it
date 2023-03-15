<b>Are you sure you want to remove this broadcast?</b><br />
<br />
<?php echo link_to('Cancel','broadcast/list') ?><br />
<br />
<table border="1" bgcolor="#FF0000">
	<tr><td>Id</td><td>App</td><td>Message</td><td>Badge</td><td>Stasus</td><td>Result</td><td>StartAt</td><td>CreatedAt</td><td>UpdatedAt</td><td>Actions</td></tr>
	<?php foreach($broadcastNotifications as $broadcastNotification): ?>
		<tr>
			<td><?php echo link_to($broadcastNotification->getId(),sprintf('broadcast/edit?id=%s',$broadcastNotification->getId())) ?></td>
			<td><?php echo sprintf("%s:%s",$broadcastNotification->getAppId(),$appMap[$broadcastNotification->getAppId()]->getName()) ?></td>
			<td><?php echo $broadcastNotification->getMessage() ?></td>
			<td><?php echo $broadcastNotification->getBadge() ?></td>
			<td><?php echo $broadcastNotification->getStatus() ?></td>
			<td><?php echo $broadcastNotification->getResult() ?></td>
			<td><?php echo $broadcastNotification->getStartAt()." (".$diffs[$broadcastNotification->getId()].")" ?></td>
			<td><?php echo $broadcastNotification->getCreatedAt() ?></td>
			<td><?php echo $broadcastNotification->getUpdatedAt() ?></td>
			<td><?php echo link_to('Remove','broadcast/delete?id=' . $broadcastNotification->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<br />
<br />

