<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Launch the Create_Android_Project.command in your Mac</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong><?php echo $app->getId() ?></strong>" for App ID</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Confirm no error found and Android Studio project launched</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Build] - [Clean Project]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Build] - [Generate Signed APK...]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Next]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Next]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Remember [APK Destination Folder] and Click on the [Finish]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Upload the generated file "<strong>veam<?php echo $app->getId() ?>-release.apk</strong>" to the <?php echo AdminTools::link_to("upload page", "app/enterapk", array("target"=>"_blank","query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?></td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
