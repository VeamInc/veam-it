<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading"><?php echo $appProcess->getName() ?></h5></div>
		<table class="table">
			<tbody>
				<?php $lineNo = 1 ?>
				<tr><td><?php echo $lineNo++ ?></td><td>Download the following 4 inch screenshots to your mac<br />
					<?php if($app->getScreenShot1()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot1() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot2()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot2() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot3()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot3() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot4()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot4() ?>" alt="" width="120" height="213" /></div><?php endif ?>
					<?php if($app->getScreenShot5()): ?><div class="thumbnail pull-left"><img src="<?php echo $app->getScreenShot5() ?>" alt="" width="120" height="213" /></div><?php endif ?>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Download the following 3.5 inch screenshots to your mac<br />
					<?php if($app->getScreenShot1()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot1()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot2()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot2()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot3()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot3()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot4()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot4()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
					<?php if($app->getScreenShot5()): ?><div class="thumbnail pull-left"><img src="<?php echo str_replace('4inch','3inch',$app->getScreenShot5()) ?>" alt="" width="120" height="180" /></div><?php endif ?>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Download the following icon image to your mac<br />
					<div class="thumbnail pull-left"><img src="<?php echo $app->getIconImage() ?>" alt="" width="128" height="128" /></div>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Sign in to the <a href="https://itunesconnect.apple.com/" target="_blank">iTunes Connect</a></td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [My Apps]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [<?php echo $app->getName() ?>]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [4-Inch]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Choose File]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the downloaded 4 inch screenshots</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [3.5-Inch]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Choose File]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the downloaded 3.5 inch screenshots</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter the following text for [Description]<br />
					<pre><?php echo $app->getDescription() ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter the following text for [Keywords]<br />
					<pre><?php echo $app->getKeyword() ?></pre>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>http://help.veam.co/contact/app.php/inquiry?m=<?php echo $mcnId ?>&a=<?php echo $app->getId() ?></strong>" for [Support URL]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Enter "<strong>Copyright 2015 Veam All rights reserved.</strong>" for [Copyright]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Choose File] of [App Icon]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select the downloaded icon file</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Select "<strong><?php echo $app->getCategory() ?></strong>" for [Primary] of [Category]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Edit] of [Rating] and check as follows
					<table class="table">
						<tbody>
							<?php foreach($questions as $question): ?>
								<tr><td><?php echo $question->getQuestion() ?></td>
									<td><?php if($answerMapForQuestion[$question->getId()]): ?>
											<?php echo $answerMapForQuestion[$question->getId()]->getAnswer(); ?>
										<?php else: ?>
											Not answered
										<?php endif ?>
									</td></tr>
							<?php endforeach ?>
							<tr><td>Unrestricted Web Access</td><td>No</td></tr>
							<tr><td>Gambling and Contests</td><td>No</td></tr>
						</tbody>
					</table>
				</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Done]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [+] button of [In-App Purchases]</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Check the [Premium Content] and click on the [Done] button</td></tr>
				<tr><td><?php echo $lineNo++ ?></td><td>Click on the [Save] of the page</td></tr>
				<tr><td>-</td><td>Back to <?php echo AdminTools::link_to("App Status", "app/detailforstatus", array("query_string"=>sprintf("a=%d",$app->getId()))) ; ?> and mark as done.</td></tr>
			</tbody>
		</table>
	</div>
</div>
<!-- end: Right Content -->
