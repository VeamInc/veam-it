<table border="1">
	<tr><td>Id</td><td>AppId</td><td>Title</td><td>Text</td><td>CreatedAt</td></tr>
	<?php foreach($textlines as $textline): ?>
		<tr>
			<td><?php echo link_to($textline->getId(),'textline/show?id='.$textline->getId()) ?></td>
			<td><?php echo $textline->getAppId() ?></td>
			<td><?php echo $textline->getTitle() ?></td>
			<td><?php echo $textline->getText() ?></td>
			<td><?php echo $textline->getCreatedAt() ?></td>
		</tr>
	<?php endforeach ?>
</table>
<?php echo link_to('Next page','textline/list?p='.($pageNo+1).'&a='.$appId) ?>
