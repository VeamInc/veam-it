package co.veam.veam31000287;

import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import java.io.IOException;

/**
 * Created by veam on 11/13/15.
 */
public class BackgroundSoundService extends Service implements MediaPlayer.OnCompletionListener {
    private final IBinder mBinder = new LocalBinder();
    private static final String TAG = null;
    private String dataPath ;
    MediaPlayer mediaPlayer ;
    private boolean isCompleted = false ;

    public class LocalBinder extends Binder {
        BackgroundSoundService getService() {
            return BackgroundSoundService.this;
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        dataPath = intent.getStringExtra("DATA_PATH") ;
        //VeamUtil.log("debug", "BackgroundSoundService::onBind " + dataPath) ;
        if(!VeamUtil.isEmpty(dataPath)) {
            mediaPlayer = new MediaPlayer();
            try {
                mediaPlayer.setDataSource(dataPath);
                mediaPlayer.setOnCompletionListener(this) ;
                mediaPlayer.prepare();
                //duration = mediaPlayer.getDuration() / 1000 ;
                mediaPlayer.start();
                isCompleted = false ;
                //isPlaying = true ;
                //this.startProgressCheck() ;
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (SecurityException e) {
                e.printStackTrace();
            } catch (IllegalStateException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return mBinder;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        //VeamUtil.log("debug", "BackgroundSoundService::onCreate " + dataPath) ;
    }


    public int onStartCommand(Intent intent, int flags, int startId) {
        //VeamUtil.log("debug", "BackgroundSoundService::onStartCommand " + dataPath) ;
        return 1;
    }

    public void onStop() {

    }
    public void onPause() {

    }
    @Override
    public void onDestroy() {
        //VeamUtil.log("debug", "BackgroundSoundService::onDestroy") ;
        if(mediaPlayer != null) {
            mediaPlayer.stop();
            mediaPlayer.release();
            mediaPlayer = null ;
        }
    }

    @Override
    public void onLowMemory() {

    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        //VeamUtil.log("debug", "BackgroundSoundService::onCompletion") ;
        isCompleted = true ;
        //this.stopSelf();
    }

    public boolean isCompleted() {
        return isCompleted ;
    }






    //// player command
    public boolean isPlaying() {
        boolean retValue = false ;
        if(mediaPlayer != null){
            retValue = mediaPlayer.isPlaying() ;
        }
        return retValue ;
    }

    public void stop() {
        if(mediaPlayer != null){
            mediaPlayer.stop() ;
        }
    }

    public void pause() {
        if(mediaPlayer != null){
            mediaPlayer.pause() ;
        }
    }

    public void start() {
        //VeamUtil.log("debug", "BackgroundSoundService::start") ;
        if(mediaPlayer != null){
            //VeamUtil.log("debug", "call mediaPlayer.start") ;
            mediaPlayer.start() ;
        }
    }


    public int getCurrentPosition() {
        int retValue = 0 ;
        if(mediaPlayer != null){
            retValue = mediaPlayer.getCurrentPosition() ;
        }
        return retValue ;
    }

    public int getDuration() {
        int retValue = 0 ;
        if(mediaPlayer != null){
            retValue = mediaPlayer.getDuration();
        }
        return retValue ;
    }

    public void seekTo(int msec) {
        if(mediaPlayer != null){
            mediaPlayer.seekTo(msec);
        }
    }

}
