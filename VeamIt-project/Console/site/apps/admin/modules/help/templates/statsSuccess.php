<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Register app to the Stats DB</h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<?php $appName = str_replace("'","''",$app->getName()) ?>
				<?php $storeAppName = str_replace("'","''",$app->getStoreAppName()) ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Execute the following SQL on the Stats DB<br />
					<pre>
INSERT INTO `veam_apps_tbl` (`VeamId`, `SKU`, `Title`, `Platform`, `ProductType`) VALUES
('<?php echo $app->getId() ?>', '<?php echo $app->getId() ?>', '<?php echo $storeAppName() ?>', 'iOS', 'App'),
('<?php echo $app->getId() ?>', 'co.veam.veam<?php echo $app->getId() ?>.subscription0.1m', 'Exclusive Content_200_30', 'iOS', 'In-App'),
('<?php echo $app->getId() ?>', '', '<?php echo $appName ?>', 'GA', 'SV'),
('<?php echo $app->getId() ?>', '', '<?php echo $appName ?>', 'GA', 'USR'),
('<?php echo $app->getId() ?>', '', '<?php echo $appName ?>', 'GA', 'RS'),
('<?php echo $app->getId() ?>', '', '<?php echo $app->getId() ?>', 'VEAM', 'Posts');
					</pre>
				</td></tr>

			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
