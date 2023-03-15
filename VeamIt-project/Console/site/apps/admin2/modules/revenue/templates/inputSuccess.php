<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Upload Revenue Info</h5></div>

		<?php if($errorMessage): ?>
		<p class="main"><span style="padding: 0 5px; background-color:#fff59f; color:#bf7500;"><?php echo $errorMessage ?></span></p>
		<?php endif ?>

		<div class="media">
			<div class="media-body">
				<div class="media-content">
					<form enctype="multipart/form-data" id="contactform" action="<?php echo url_for('revenue/upload') ?>" method="post" class="validateform" name="send-contact">
						<div class="field">

							Year : 
							<select name="year" id="year">
								<option value="2014" 			>2014</option>
								<option value="2015" selected	>2015</option>
								<option value="2016"			>2016</option>
								<option value="2017"			>2017</option>
								<option value="2018"			>2018</option>
								<option value="2019"			>2019</option>
							</select>

							&nbsp;&nbsp;&nbsp;&nbsp;Month : 
							<select name="month" id="month">
								<option value="1" selected	>1</option>
								<option value="2" 			>2</option>
								<option value="3" 			>3</option>
								<option value="4" 			>4</option>
								<option value="5" 			>5</option>
								<option value="6" 			>6</option>
								<option value="7" 			>7</option>
								<option value="8" 			>8</option>
								<option value="9" 			>9</option>
								<option value="10" 			>10</option>
								<option value="11" 			>11</option>
								<option value="12" 			>12</option>
							</select>
							<br />
							<br />
							<br />
							<div class="field">
								<input name="ios_payment" placeholder="* Enter the amount of payment from Apple" data-rule="number" data-msg="Please enter a valid amount" type="text">
								<div class="validation"></div>
								<br />
								<input name="iad_payment" placeholder="* Enter the amount of payment from iAd" data-rule="number" data-msg="Please enter a valid amount" type="text">
								<div class="validation"></div>
								<br />
								Select all files downloaded from iTunes Connect : <br /><input name="iosfiles[]" type="file" multiple><br />
								<br />
								<br />
								<textarea rows="12" name="ios_payment_list" id="ios_payment_list" class="input-block-level" placeholder="* iOS Payment List here..." data-rule="required" data-msg="Please paste payment list"></textarea>
								<div class="validation"></div>
								<br />
								<br />
								<input name="android_payment" placeholder="* Enter the amount of payment from Google" data-rule="number" data-msg="Please enter a valid amount" type="text">
								<div class="validation"></div>
								Select a file downloaded from Google Wallet Marchant Center : <br /><input name="androidfiles[]" type="file" multiple><br />
								<br />
								<br />
							</div>
							<p><button class="btn btn-theme margintop10 pull-left" type="submit">Upload</button></p>
						</div>
					</form>

				</div>
			</div>
		</div>

		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->

	</div>
</div>
<!-- end: Right Content -->
