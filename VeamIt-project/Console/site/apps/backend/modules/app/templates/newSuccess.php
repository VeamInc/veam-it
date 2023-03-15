Create new app<br />
<br />
<?php if(isset($errorMessage)): ?>
<font color="red"><?php echo $errorMessage ?></font><br />
<br />
<?php endif ?>
<form action="<?php echo url_for('app/create') ?>" method="POST">
App Creator Name:<input type="text" name="app_creator_name" id="app_creator_name" value="" /><br />
App Creator Password:<input type="text" name="app_creator_password" id="app_creator_password" value="" /><br />
<br />
<input type="submit" value="Create" />
</form>

