Create TextContent<br />
<br />
<form action="<?php echo url_for('textline/save') ?>" method="POST">
<input type="hidden" name="app_id" id="app_id" value="<?php echo $appId ?>" />
App ID:<?php echo $appId ?><br />
Title:<input type="text" name="title" id="title" value="" /><br />
Text:<textarea name="text" cols=40 rows=4></textarea><br />
<input type="submit" value="Save" />
</form>
