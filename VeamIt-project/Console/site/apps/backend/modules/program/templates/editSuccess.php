
<?php if($programId): ?>
Edit program for id <?php echo $programId ?><br />
<?php else: ?>
Create program<br />
<?php endif ?>
<br />
<form action="<?php echo url_for('program/save') ?>" method="POST">
<input type="hidden" name="id" id="id" value="<?php echo $programId ?>" /><br />
App ID:<input type="text" name="app_id" id="app_id" value="<?php echo $appId ?>" /><br />
Kind(1:message 2:music):<input type="text" name="kind" id="kind" value="<?php echo $kind ?>" /><br />
Author:<input type="text" name="author" id="author" value="<?php echo $author ?>" /><br />
Duration:<input type="text" name="duration" id="duration" value="<?php echo $duration ?>" /><br />
Title:<input type="text" name="title" id="title" value="<?php echo $title ?>" /><br />
Description:<input type="text" name="description" id="description" value="<?php echo $description ?>" /><br />
Image Dropbox URL:<input type="text" name="image_url" id="image_url" value="" /><br />
Data Dropbox URL:<input type="text" name="data_url" id="data_url" value="" /><br />
<input type="submit" value="Save" />
</form>

