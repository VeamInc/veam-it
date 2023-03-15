<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Input names</h5></div>
		<span class="pull-left">
			<table border="1">
				<tr><td>No.</td><td>Name</td><td>Login Count</td></tr>
				<?php $count = 0 ; ?>
				<?php foreach($appNames as $appName): ?>
				<?php if($appName): ?>
					<?php $count++ ?>
					<tr><td><?php echo $count ?></td><td><?php echo $appName ?></td><td><?php echo $counts[$appName] ?></td></tr>
				<?php endif ?>
				<?php endforeach ?>
			</table>
		</span>
	</div>
</div>
<!-- end: Right Content -->
