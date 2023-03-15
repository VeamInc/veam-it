
<?php if($broadcastNotificationId): ?>
Edit broadcast for id <?php echo $broadcastNotificationId ?><br />
<?php else: ?>
Create broadcast<br />
<?php endif ?>
<br />
<form action="<?php echo url_for('broadcast/save') ?>" method="POST">
<input type="hidden" name="id" id="id" value="<?php echo $broadcastNotificationId ?>" /><br />

App<select name="app_id" id="app_id">
<?php foreach($apps as $app): ?>
<?php if($appId == $app->getId()){$selected = 'selected';}else{$selected = '' ;} ?>
<option value="<?php echo $app->getId()?>" <?php echo ($appId == $app->getId())?'selected':'' ; ?>><?php echo sprintf("%s:%s",$app->getId(),$app->getName()) ?></option>
<?php endforeach ?>
</select><br />

Message:<input type="text" name="message" id="message" value="<?php echo $message ?>" /><br />
Badge:<input type="text" name="badge" id="badge" value="<?php echo $badge ?>" /><br />
Status:<input type="text" name="status" id="status" value="<?php echo $status ?>" /><br />
StartAt:<input type="text" name="start_at" id="start_at" value="<?php echo $startAt ?>" /><br />

<input type="submit" value="Save" />
</form>

