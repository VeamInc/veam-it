package co.veam.veam31000287;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.Tracker;

//import me.kiip.sdk.Kiip;

/**
 * Created by veam on 6/25/15.
 */
public class AnalyticsApplication extends Application {

    private static final String PROPERTY_ID = "__GA_PROPERTY_ID__";

    Tracker mTracker;
    ConsoleContents mConsoleContents ;

    private static Context sContext;

    public static Context getContext() {
        return sContext;
    }

    public AnalyticsApplication() {
        super();
    }

    @Override
    public void onCreate() {
        super.onCreate();
        //VeamUtil.log("debug", "Application::onCreate") ;
        sContext = this;
        //Kiip kiip = Kiip.init(this, "280452e24dbf3395d2682cf20d86335b", "6aba2208cd691d183dc711d69c644ff9");
        //Kiip.setInstance(kiip);
    }

    synchronized Tracker getTracker() {
        if (mTracker == null) {
            GoogleAnalytics analytics = GoogleAnalytics.getInstance(this);
            mTracker = analytics.newTracker(PROPERTY_ID);
        }
        return mTracker;
    }

    synchronized ConsoleContents getConsoleContents() {
        if (mConsoleContents == null) {
            mConsoleContents = new ConsoleContents() ;
        }
        return mConsoleContents;
    }

    synchronized void setConsoleContents(ConsoleContents consoleContents) {
        mConsoleContents = consoleContents ;
    }
}