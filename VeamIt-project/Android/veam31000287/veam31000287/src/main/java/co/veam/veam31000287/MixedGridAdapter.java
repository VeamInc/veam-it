package co.veam.veam31000287;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by veam on 2015/06/03.
 */
public class MixedGridAdapter extends BaseAdapter {

    public static final int TYPE_SPACER 		= 0 ;
    public static final int TYPE_MIXED 		= 1;
    private static final int TYPE_COUNT 		= 2 ;

    private VeamActivity context ;

    private int listWidth ;
    private int topMargin ;
    private float scaledDensity ;
    private MixedObject[] mixeds ;
    private int mixedCount = 0 ;
    private static int VIEWID_TITLE			= 0x50001 ;
    private static int VIEWID_IMAGE			= 0x50002 ;
    private static int VIEWID_DURATION		= 0x50003 ;
    private static int VIEWID_YEAR			= 0x50003 ;

    private Typeface typeface ;


    public MixedGridAdapter(VeamActivity activity,MixedObject[] mixeds,int width,int topMargin,float scaledDensity)
    {
        this.context = activity ;
        this.listWidth = width ;
        this.topMargin = topMargin ;
        this.scaledDensity = scaledDensity ;
        this.setMixeds(mixeds) ;
        typeface = Typeface.SERIF ;
        //typeface = Typeface.createFromAsset(this.context.getAssets(), "Roboto-Light.ttf") ;
    }

    public void setMixeds(MixedObject[] mixeds){
        this.mixeds = mixeds ;
        if(mixeds == null){
            mixedCount = 0 ;
        } else {
            mixedCount = mixeds.length ;
        }
    }

    @Override
    public int getCount() {
        int retValue = 0 ;
        if(mixeds != null){
            retValue = mixeds.length ;
        }
        if(retValue < 24){
            retValue = 24 ;
        }
        //VeamUtil.log("debug","AudioAdapter::getCount for:"+audioKind+" "+retValue) ;
        return retValue ;
    }

    @Override
    public Object getItem(int position) {
        //VeamUtil.log("debug","ExclusiveGridAdapter::getItem "+position) ;
        MixedObject retValue = null ;
        if((mixeds != null) && (mixeds.length > position)){
            retValue = mixeds[position] ;
        }
        return retValue ;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public int getItemViewType(int position) {
        int itemViewType = TYPE_MIXED ;
        //AudioObject audio = (AudioObject)this.getItem(position) ;
        return itemViewType ;
    }

    @Override
    public int getViewTypeCount() {
        return TYPE_COUNT ;
    }

    public View getSpacerView(){
        LinearLayout view = new LinearLayout(context) ;
        view.setTag(Integer.valueOf(0)) ;
        view.setOrientation(LinearLayout.VERTICAL) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;
        view.setPadding(0, topMargin, 0, 0) ;
        return view ;
    }




    public View getMixedView(int position){
        //VeamUtil.log("debug","getAudioView:"+position) ;
        RelativeLayout.LayoutParams relativeLayoutParams ;

        LinearLayout view = new LinearLayout(context) ;
        view.setTag(Integer.valueOf(0)) ;
        view.setOrientation(LinearLayout.VERTICAL) ;
        //view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
        view.setBackgroundColor(Color.TRANSPARENT) ;

        LinearLayout.LayoutParams layoutParams ;

        int cellWidth = this.listWidth*235/1000 ;
        int cellHeight = this.listWidth*275/1000 ;

        RelativeLayout contentLayout = new RelativeLayout(context) ;
        contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
        layoutParams = new LinearLayout.LayoutParams(cellWidth, cellHeight) ;
        view.addView(contentLayout,layoutParams) ;

        int imageTop = listWidth*375/10000 ;
        int imageLeft = listWidth*2375/100000 ;
        int imageSize = listWidth*1875/10000 ;

        ImageView imageView ;
        imageView = new ImageView(context) ;
        imageView.setId(VIEWID_IMAGE) ;
        imageView.setTag(Integer.valueOf(position)) ;
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP) ;
        relativeLayoutParams = new RelativeLayout.LayoutParams(imageSize,imageSize) ;
        relativeLayoutParams.setMargins(imageLeft,imageTop, 0, 0) ;
        contentLayout.addView(imageView,relativeLayoutParams) ;

        int yearHeight = cellHeight*30/100 ;
        int titleOffset = cellHeight*1/100 ;
        int titleHeight = cellHeight-imageTop-imageSize+titleOffset ;

        //////////// title
        TextView textView = new TextView(context) ;
        textView.setId(VIEWID_TITLE) ;
        textView.setBackgroundColor(Color.TRANSPARENT) ;
        textView.setGravity(Gravity.TOP|Gravity.CENTER_HORIZONTAL) ;
        textView.setPadding(0, 0, 0, 0) ;
        textView.setTextSize((float)listWidth * 4.0f / 100 / scaledDensity) ;
        textView.setTextColor(Color.BLACK) ;
        textView.setTypeface(typeface) ;
        textView.setMaxLines(1) ;
        relativeLayoutParams = new RelativeLayout.LayoutParams(cellWidth,titleHeight) ;
        relativeLayoutParams.setMargins(0,imageTop+imageSize-titleOffset, 0, 0) ;
        contentLayout.addView(textView,relativeLayoutParams) ;

        //////////// year

        int yearTop = imageTop + (imageSize-yearHeight) / 2 ;
        textView = new TextView(context) ;
        textView.setId(VIEWID_YEAR) ;
        textView.setBackgroundColor(Color.TRANSPARENT) ;
        textView.setGravity(Gravity.CENTER_VERTICAL|Gravity.CENTER_HORIZONTAL) ;
        textView.setPadding(0, 0, 0, 0) ;
        textView.setTextSize((float)listWidth * 4.0f / 100 / scaledDensity) ;
        textView.setTypeface(typeface) ;
        textView.setMaxLines(1) ;
        textView.setTextColor(Color.WHITE) ;
        relativeLayoutParams = new RelativeLayout.LayoutParams(cellWidth,yearHeight) ;
        relativeLayoutParams.setMargins(0,yearTop, 0, 0) ;
        contentLayout.addView(textView,relativeLayoutParams) ;

        return view ;
    }

    public void setAudioValues(int position,View convertView){

        //VeamUtil.log("debug", "setAudioValues " + position) ;
        MixedObject mixed = (MixedObject)this.getItem(position) ;

        ImageView imageView ;
        imageView = (ImageView)convertView.findViewById(VIEWID_IMAGE) ;
        imageView.setTag(Integer.valueOf(position)) ;
        TextView titleTextView = (TextView)convertView.findViewById(VIEWID_TITLE) ;
        TextView yearTextView = (TextView)convertView.findViewById(VIEWID_YEAR) ;

        if(mixedCount == 0){
            if(position == 0){
                imageView.setImageBitmap(VeamUtil.getThemeImage(context,"grid_year",1)) ;
                titleTextView.setText("") ;
                yearTextView.setText("2017") ;
            } else {
                imageView.setImageBitmap(VeamUtil.getThemeImage(context,String.format("default_grid_%d",position),1)) ;
                titleTextView.setText("----") ;
                yearTextView.setText("") ;
            }
        } else {
            if(mixed == null){
                imageView.setImageResource(R.drawable.grid_back1) ;
                titleTextView.setText("") ;
                yearTextView.setText("") ;
            } else {
                String imageUrl = mixed.getThumbnailUrl() ;
                if(mixed.getKind().equals(MixedObject.KIND_YEAR)){
                    //imageView.setImageResource(R.drawable.grid_year) ;
                    imageView.setImageBitmap(VeamUtil.getThemeImage(context, "grid_year", 1)) ;
                    yearTextView.setText(String.format("%d",VeamUtil.getYearFromIntString(mixed.getCreatedAt()))) ;
                    titleTextView.setText("") ;
                } else {
                    yearTextView.setText("") ;
                    if(mixed.getDisplayType().equals(MixedObject.DISPLAY_TYPE_TITLE)) {
                        titleTextView.setText(mixed.getDisplayName());
                    } else {
                        titleTextView.setText(this.getContentName(mixed));
                    }
                    if(VeamUtil.isEmpty(imageUrl)){
                        if(mixed.getKind().equals(MixedObject.KIND_FIXED_AUDIO)){
                            imageView.setImageResource(R.drawable.grid_audio) ;
                        } else if(mixed.getKind().equals(MixedObject.KIND_PERIODICAL_AUDIO)){
                            imageView.setImageResource(R.drawable.grid_audio) ;
                        } else if(mixed.getKind().equals(MixedObject.KIND_FIXED_VIDEO)){
                            imageView.setImageResource(R.drawable.grid_video) ;
                        } else if(mixed.getKind().equals(MixedObject.KIND_PERIODICAL_VIDEO)){
                            imageView.setImageResource(R.drawable.grid_video) ;
                        }
                    } else {
                        Bitmap bitmap = VeamUtil.getCachedFileBitmapWithWidth(context, imageUrl, this.listWidth/4,1, false) ;
                        if(bitmap == null){
                            imageView.setImageResource(R.drawable.message_back) ;
                            LoadImageTask loadImageTask = new LoadImageTask(context,imageUrl,imageView,this.listWidth/4,position,null) ;
                            loadImageTask.execute("") ;
                        } else {
                            imageView.setImageBitmap(bitmap) ;
                            bitmap = null ;
                        }
                    }
                }
            }
        }
    }



    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        //VeamUtil.log("debug","getView:"+position) ;

        int itemViewType = getItemViewType(position) ;
        //VeamUtil.log("debug","itemViewType:"+itemViewType) ;

        if(convertView == null){
            if(itemViewType == TYPE_MIXED){
                convertView = this.getMixedView(position) ;
            }
        }

        if(itemViewType == TYPE_MIXED){
            setAudioValues(position,convertView) ;
        }

        convertView.setTag(Integer.valueOf(position)) ;

        return convertView ;
    }

    public String getContentName(MixedObject mixedObject){
        String kind = mixedObject.getKind() ;
        String name = "" ;
        if (kind.equals(MixedObject.KIND_FIXED_VIDEO) || kind.equals(MixedObject.KIND_PERIODICAL_VIDEO)) {
            VideoObject videoObject = VeamUtil.getVideoObject(context.getDb(), mixedObject.getContentId());
            if (videoObject != null) {
                //VeamUtil.log("debug", "Video Found");
                name = videoObject.getTitle() ;
            }
        } else if (kind.equals(MixedObject.KIND_FIXED_AUDIO) || kind.equals(MixedObject.KIND_PERIODICAL_AUDIO)) {
            AudioObject audioObject = VeamUtil.getAudioObject(context.getDb(), mixedObject.getContentId());
            if(audioObject != null) {
                name = audioObject.getTitle() ;
            }
        }
        return name ;
    }

}
