package co.veam.veam31000287;

import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.google.android.gms.gcm.GoogleCloudMessaging;

public class GCMIntentService extends IntentService {
    public GCMIntentService() {
        //super(VeamUtil.GCM_SENDER_ID) ;
        super("GcmIntentService") ;
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        Bundle extras = intent.getExtras() ;
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this) ;
        String messageType = gcm.getMessageType(intent) ;

        if (!extras.isEmpty()) {
            if (GoogleCloudMessaging.MESSAGE_TYPE_SEND_ERROR.equals(messageType)) {
                //VeamUtil.log("debug", "messageType(error): " + messageType + ",body:" + extras.toString());
            } else if (GoogleCloudMessaging.MESSAGE_TYPE_DELETED.equals(messageType)) {
                //VeamUtil.log("debug","messageType(deleted): " + messageType + ",body:" + extras.toString());
            } else if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType)) {
                //VeamUtil.log("debug","messageType(message): " + messageType + ",body:" + extras.toString());

                String str = intent.getStringExtra("message");
                String kind = intent.getStringExtra("kind");
                String pictureId = intent.getStringExtra("picture_id");
                String socialUserId = intent.getStringExtra("social_user_id");

                Intent activityIntent = new Intent(this,InitialActivity.class) ;
                if(!VeamUtil.isEmpty(kind)){
                    if(kind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_FOLLOW) ||
                        kind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_COMMENT_PICTURE) ||
                        kind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_LIKE_PICTURE)){
                        activityIntent = new Intent(this,ProfileActivity.class) ;
                        activityIntent.putExtra("IS_NOTIFICATION", true) ;
                        activityIntent.putExtra("TAB_INDEX", 2) ;
                        activityIntent.putExtra("NOTIFICATION_KIND", kind) ;
                        activityIntent.putExtra("SOCIAL_USER_ID", socialUserId) ;
                        activityIntent.putExtra("PICTURE_ID", pictureId) ;
                    }
                }

                PendingIntent contentIntent = PendingIntent.getActivity(this, 0, activityIntent, PendingIntent.FLAG_UPDATE_CURRENT) ;

                Notification notification;
                if(!VeamUtil.isEmpty(str)) {
                    String[] lines = str.split("\n");

                    //notification = new Notification(R.drawable.ic_launcher,str, System.currentTimeMillis());
                    notification = new Notification(R.drawable.ic_launcher, str, 0);
                    if (lines.length >= 2) {
                        notification.setLatestEventInfo(this, lines[0], lines[1], contentIntent);
                    } else {
                        notification.setLatestEventInfo(this, this.getString(R.string.app_name), str, contentIntent);
                    }

                    NotificationManager nm = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                    nm.notify(1, notification);
                }

                //VeamUtil.log("debug","notification kind="+kind);
                if(!VeamUtil.isEmpty(kind)){
                    if(kind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_MESSAGE)){
                        VeamUtil.notifyNewMessage(this) ;
                    } else if(kind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_FOLLOW) ||
                            kind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_COMMENT_PICTURE) ||
                            kind.equals(UserNotificationObject.USER_NOTIFICATION_KIND_LIKE_PICTURE)){
                        VeamUtil.notifyNewProfileNotification(this) ;
                    }
                }
            }
        }
        GCMBroadcastReceiver.completeWakefulIntent(intent);
    }

    private void sendNotification(String msg) {
        NotificationManager mNotificationManager = (NotificationManager)this.getSystemService(Context.NOTIFICATION_SERVICE) ;

        // PendingIntent contentIntent = PendingIntent.getActivity(this, 0,new Intent(this, MainActivity.class), 0) ;
        Intent activityIntent = new Intent(this,InitialActivity.class) ;
        PendingIntent contentIntent = PendingIntent.getActivity(this, 0, activityIntent, 0) ;

        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setContentTitle(this.getString(R.string.app_name))
                        .setStyle(new NotificationCompat.BigTextStyle()
                                .bigText(msg))
                        .setContentText(msg) ;

        mBuilder.setContentIntent(contentIntent) ;
        mNotificationManager.notify(1, mBuilder.build()) ;
    }

}
