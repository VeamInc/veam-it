[<?php echo link_to('Create new broadcast','broadcast/edit/') ?>]<br />
<br />
[<?php echo link_to('Waiting','broadcast/list?p=1&s=0') ?>]
[<?php echo link_to('Sending','broadcast/list?p=1&s=1') ?>]
[<?php echo link_to('Completed','broadcast/list?p=1&s=2') ?>]
[<?php echo link_to('Error','broadcast/list?p=1&s=3') ?>]
<br />
<br />
<table border="1">
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
			<td><?php echo link_to('Remove','broadcast/confirmdelete?id=' . $broadcastNotification->getId()) ?></td>
		</tr>
	<?php endforeach ?>
</table>
<?php echo link_to('Next page',sprintf('broadcast/list?p=%d&s=%d',($pageNo+1),$status)) ?>
