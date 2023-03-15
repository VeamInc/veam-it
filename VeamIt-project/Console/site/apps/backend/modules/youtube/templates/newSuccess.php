Create YoutubeVideo<br />
<br />
<form action="<?php echo url_for('youtube/save') ?>" method="POST">
<input type="hidden" name="app_id" id="app_id" value="<?php echo $appId ?>" />
App ID:<?php echo $appId ?><br />
Sub Category:<select name="sub_category">
<?php foreach($subCategoryNames as $subCategoryId=>$subCategoryName): ?>
<option value="<?php echo $subCategoryId ?>"><?php echo $subCategoryName ?></option>
<?php endforeach ?>
</select><br />
Duration:<input type="text" name="duration" id="duration" value="" /><br />
Title:<input type="text" name="title" id="title" value="" /><br />
Description:<textarea name="description" cols=40 rows=4></textarea><br />
Youtube Code:<input type="text" name="youtube_code" id="youtube_code" value="" /><br />
<input type="submit" value="Save" />
</form>

