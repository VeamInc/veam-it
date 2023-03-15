package co.veam.veam31000287;

import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;

import java.util.ArrayList;

public class ForumAdapter extends BaseAdapter {

	private ForumActivity forumActivity ;
	
	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private ForumObject[] forumObjects ;
	private ArrayList<ForumGroupObject> forumGroupObjects ;

	private AdSize adSize ;
	private String adUnitId ;

	public static final int TYPE_SPACER 		= 0 ;
	public static final int TYPE_FORUM	 		= 1 ;
	public static final int TYPE_GROUP	 		= 2 ;
	public static final int TYPE_ADD_GROUP	 	= 3 ;
	public static final int TYPE_AD		 		= 4 ;

    private static final int TYPE_MAX_COUNT 	= 5 ;

    public static final int PRE_LINE_COUNT		= 5 ; // spacer + Ad + My Posts + favorites + following
    public static final int POST_LINE_COUNT	= 0 ; // add group(removed)

	public ForumAdapter(ForumActivity activity,ForumObject[] forumObjects,ArrayList<ForumGroupObject> forumGroupObjects,int width,int topMargin,float scaledDensity,String adUnitId,AdSize adSize)
	{
		this.forumActivity = activity ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.forumObjects = forumObjects ;
		this.forumGroupObjects = forumGroupObjects ;

		this.adUnitId = adUnitId ;
		this.adSize = adSize ;

	}
	
	public void setForumGroupObjects(ArrayList<ForumGroupObject> forumGroupObjects){
		this.forumGroupObjects = forumGroupObjects ;
	}

	@Override
	public int getCount() {
		int retValue = 0 ; 
		if(forumObjects != null){
			retValue = PRE_LINE_COUNT + forumObjects.length + forumGroupObjects.size() + POST_LINE_COUNT ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		int forumStartPosition = PRE_LINE_COUNT ;
		int groupStartPosition = PRE_LINE_COUNT + forumObjects.length ;
		int lastPosition = PRE_LINE_COUNT + forumObjects.length + forumGroupObjects.size() ;
		
		Object retValue = null ;
		if(position == PRE_LINE_COUNT-1){
			retValue = new ForumObject(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS,forumActivity.getString(R.string.following),"0","0","0",false,0) ;
		} else if(position == PRE_LINE_COUNT-2){
            retValue = new ForumObject(VeamUtil.SPECIAL_FORUM_ID_FAVORITES,forumActivity.getString(R.string.my_favorites),"0","0","0",false,0) ;
        } else if(position == PRE_LINE_COUNT-3){
            retValue = new ForumObject(VeamUtil.SPECIAL_FORUM_ID_MY_POSTS,forumActivity.getString(R.string.my_posts),"0","0","0",false,0) ;
		} else if((forumStartPosition <= position) && (position < groupStartPosition)){
			retValue = forumObjects[position-forumStartPosition] ;
		} else if((groupStartPosition <= position) && (position < lastPosition)){
			retValue = forumGroupObjects.get(position-groupStartPosition) ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}
	
	@Override
    public int getItemViewType(int position) {
        int itemViewType = 0 ;
		int forumStartPosition = PRE_LINE_COUNT ;
		int groupStartPosition = PRE_LINE_COUNT + forumObjects.length ;
		int lastPosition = PRE_LINE_COUNT + forumObjects.length + forumGroupObjects.size() ;

		if(position == 0) {
			itemViewType = TYPE_SPACER;
		} else if(position == 1){
			itemViewType = TYPE_AD;
		} else if(position < PRE_LINE_COUNT){
			itemViewType = TYPE_FORUM ;
		} else if((forumStartPosition <= position) && (position < groupStartPosition)){
			itemViewType = TYPE_FORUM ;
		} else if((groupStartPosition <= position) && (position < lastPosition)){
			itemViewType = TYPE_GROUP ;
		} else if(position == lastPosition){
			itemViewType = TYPE_ADD_GROUP ;
		}
		
		//VeamUtil.log("debug","itemViewType="+itemViewType+" lastPosition="+lastPosition+" forumStartPosition="+forumStartPosition+" groupStartPosition="+groupStartPosition) ;

        return itemViewType ;
    }

	@Override
    public int getViewTypeCount() {
        return TYPE_MAX_COUNT ;
    }

	
	public View getSpacerView(int position){
		LinearLayout view = new LinearLayout(forumActivity) ;
		view.setTag(Integer.valueOf(position)) ;
		view.setOrientation(LinearLayout.VERTICAL) ;
		view.setBackgroundColor(Color.TRANSPARENT) ;
		view.setPadding(0, topMargin, 0, 0) ;
		return view ;
	}

	public View getAdView(int position,View convertView){

		if(VeamUtil.isActiveAdmob) {
			if (convertView instanceof AdView) {
				// Don’t instantiate new AdView, reuse old one
				return convertView;
			} else {
				// Create a new AdView
				AdView adView = new AdView(forumActivity);
				adView.setAdSize(adSize);
				adView.setAdUnitId(adUnitId);
				//int height = Math.round(adSize.getHeight() * listWidth / adSize.getWidth());
				android.widget.AbsListView.LayoutParams params = new android.widget.AbsListView.LayoutParams(listWidth, AbsListView.LayoutParams.WRAP_CONTENT);
				adView.setLayoutParams(params);
				adView.loadAd(VeamUtil.getAdRequest());
				adView.setTag(Integer.valueOf(position));
				return adView;
			}
		} else {
			LinearLayout view = new LinearLayout(forumActivity) ;
			view.setTag(position) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			view.setPadding(0, 1, 0, 0) ;
			return view ;
		}
	}

	public View getForumView(int position){
		ForumObject forumObject = (ForumObject)this.getItem(position) ;
		String forumName = "" ;
		if(forumObject != null){
            if(forumObject.getKind().equals("2")) {
                forumName = forumActivity.getString(R.string.forum_name_hot_topics) ;
            } else {
                forumName = forumObject.getName();
            }

		}
		
		LinearLayout view = new LinearLayout(forumActivity) ;
		view.setTag(Integer.valueOf(position)) ;
		view.setOrientation(LinearLayout.VERTICAL) ;
		
		view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
		
		LinearLayout.LayoutParams layoutParams ;
		
		int cellHeight = this.listWidth*14/100 ;
		
		RelativeLayout contentLayout = new RelativeLayout(forumActivity) ;
		contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
		layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
		view.addView(contentLayout,layoutParams) ;

		LinearLayout nameView = new LinearLayout(forumActivity) ;
		nameView.setOrientation(LinearLayout.HORIZONTAL) ;
		nameView.setPadding(0, 0, 0, 0) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*84/100, cellHeight) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,0, 0, 0) ;
		contentLayout.addView(nameView,relativeLayoutParams) ;

		Typeface typeface = Typeface.createFromAsset(this.forumActivity.getAssets(), "Roboto-Light.ttf");

		TextView textView = new TextView(forumActivity) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText(forumName);
		if( forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_MY_POSTS) ||
				forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_MY_PROFILE) ||
				forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FAVORITES) ||
			forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS)){
            //textView.setTextColor(Color.rgb(0xFF, 0x80, 0xBD)) ;
            textView.setTextColor(VeamUtil.getLinkTextColor(forumActivity)) ;
		}
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)listWidth * 5.2f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, cellHeight) ;
		nameView.addView(textView,linearLayoutParams) ;
		
		if(forumObject.getKind().equals("2")){
			ImageView imageView ;
			imageView = new ImageView(forumActivity) ;
            //imageView.setImageResource(R.drawable.flame) ; // 36x50
            imageView.setImageBitmap(VeamUtil.getThemeImage(forumActivity,"flame",1));
			imageView.setScaleType(ScaleType.FIT_XY) ;
			linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*288/1000,cellHeight*40/100) ;
			linearLayoutParams.setMargins(listWidth*2/100, cellHeight*30/100, 0, 0) ;
			nameView.addView(imageView,linearLayoutParams) ;
		} else if(forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_MY_POSTS)){
			ImageView imageView ;
			imageView = new ImageView(forumActivity) ;
            //imageView.setImageResource(R.drawable.list_my_post) ; // 42x50
            imageView.setImageBitmap(VeamUtil.getThemeImage(forumActivity,"list_my_post",1));
			imageView.setScaleType(ScaleType.FIT_XY) ;
			linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*42/100,cellHeight*50/100) ;
			linearLayoutParams.setMargins(listWidth*2/100, cellHeight*25/100, 0, 0) ;
			nameView.addView(imageView,linearLayoutParams) ;
		} else if(forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FAVORITES)){
			ImageView imageView ;
			imageView = new ImageView(forumActivity) ;
			//imageView.setImageResource(R.drawable.list_clip) ; // 36x50
            imageView.setImageBitmap(VeamUtil.getThemeImage(forumActivity,"list_clip",1));
			imageView.setScaleType(ScaleType.FIT_XY) ;
			linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*36/100,cellHeight*50/100) ;
			linearLayoutParams.setMargins(listWidth*1/100, cellHeight*25/100, 0, 0) ;
			nameView.addView(imageView,linearLayoutParams) ;
		} else if(forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_MY_PROFILE)){
			ImageView imageView ;
			imageView = new ImageView(forumActivity) ;
			imageView.setImageResource(R.drawable.list_earth) ; // 50x80
			imageView.setScaleType(ScaleType.FIT_XY) ;
			linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*562/1000,cellHeight*90/100) ;
			linearLayoutParams.setMargins(listWidth*5/1000, cellHeight*5/100, 0, 0) ;
			nameView.addView(imageView,linearLayoutParams) ;
		} else if(forumObject.getId().equals(VeamUtil.SPECIAL_FORUM_ID_FOLLOWINGS)){
			ImageView imageView ;
			imageView = new ImageView(forumActivity) ;
			//imageView.setImageResource(R.drawable.list_following) ; // 46x50
            imageView.setImageBitmap(VeamUtil.getThemeImage(forumActivity,"list_following",1));
			imageView.setScaleType(ScaleType.FIT_XY) ;
			linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*46/100,cellHeight*50/100) ;
			linearLayoutParams.setMargins(listWidth*2/100, cellHeight*25/100, 0, 0) ;
			nameView.addView(imageView,linearLayoutParams) ;
		}
		

		ImageView imageView ;
		imageView = new ImageView(forumActivity) ;
		imageView.setImageResource(R.drawable.setting_arrow) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
		relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*4/100, 0, 0) ;
		contentLayout.addView(imageView, relativeLayoutParams) ;
		
		View lineView = new View(forumActivity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight - 1, 0, 0);
		contentLayout.addView(lineView,relativeLayoutParams) ;

		lineView = new View(forumActivity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,0, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		return view ;
	}


	public View getGroupView(int position){
		ForumGroupObject forumGroupObject = (ForumGroupObject)this.getItem(position) ;
		String forumName = "" ;
		if(forumGroupObject != null){
			forumName = String.format("%s (%s)",forumGroupObject.getForumName(),forumGroupObject.getNumberOfMembers()) ;
		}
		
		LinearLayout view = new LinearLayout(forumActivity) ;
		view.setTag(Integer.valueOf(position)) ;
		view.setOrientation(LinearLayout.VERTICAL) ;
		
		view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
		
		LinearLayout.LayoutParams layoutParams ;
		
		int cellHeight = this.listWidth*14/100 ;
		
		RelativeLayout contentLayout = new RelativeLayout(forumActivity) ;
		contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
		layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
		view.addView(contentLayout,layoutParams) ;

		LinearLayout nameView = new LinearLayout(forumActivity) ;
		nameView.setOrientation(LinearLayout.HORIZONTAL) ;
		nameView.setPadding(0, 0, 0, 0) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*84/100, cellHeight) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,0, 0, 0) ;
		contentLayout.addView(nameView,relativeLayoutParams) ;

		Typeface typeface = Typeface.createFromAsset(this.forumActivity.getAssets(), "Roboto-Light.ttf");
		
		int iconSize = cellHeight * 35 / 100 ;
		ImageView groupImageView = new ImageView(forumActivity) ;
		groupImageView.setImageResource(R.drawable.pro_person_icon) ;
		groupImageView.setScaleType(ScaleType.FIT_XY) ;
		//groupImageView.setGravity(Gravity.CENTER_VERTICAL) ;
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(iconSize,iconSize) ;
		linearLayoutParams.setMargins(0, (cellHeight-iconSize)/2, cellHeight*10/100, 0) ;
		nameView.addView(groupImageView,linearLayoutParams) ;

		TextView textView = new TextView(forumActivity) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText(forumName);
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)listWidth * 5.2f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, cellHeight) ;
		nameView.addView(textView,linearLayoutParams) ;
		

		ImageView imageView ;
		imageView = new ImageView(forumActivity) ;
		imageView.setImageResource(R.drawable.setting_arrow) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
		relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*4/100, 0, 0) ;
		contentLayout.addView(imageView,relativeLayoutParams) ;
		
		View lineView = new View(forumActivity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;

		return view ;	
	}
	
	public View getAddGroupView(int position){
		LinearLayout view = new LinearLayout(forumActivity) ;
		view.setTag(Integer.valueOf(position)) ;
		view.setOrientation(LinearLayout.VERTICAL) ;
		
		view.setBackgroundColor(Color.argb(0xff, 0xff, 0x62, 0xBD)) ;
		
		LinearLayout.LayoutParams layoutParams ;
		
		int cellHeight = this.listWidth*14/100 ;
		
		RelativeLayout contentLayout = new RelativeLayout(forumActivity) ;
		contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
		layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
		view.addView(contentLayout,layoutParams) ;

		LinearLayout nameView = new LinearLayout(forumActivity) ;
		nameView.setOrientation(LinearLayout.HORIZONTAL) ;
		nameView.setPadding(0, 0, 0, 0) ;
		RelativeLayout.LayoutParams relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*84/100, cellHeight) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,0, 0, 0) ;
		contentLayout.addView(nameView,relativeLayoutParams) ;

		Typeface typeface = Typeface.createFromAsset(this.forumActivity.getAssets(), "Roboto-Light.ttf");

		ImageView imageView ;
		imageView = new ImageView(forumActivity) ;
		imageView.setImageResource(R.drawable.add_forum_group) ; // 40x40
		imageView.setScaleType(ScaleType.FIT_XY) ;
		LinearLayout.LayoutParams linearLayoutParams = new LinearLayout.LayoutParams(cellHeight*50/100,cellHeight*50/100) ;
		linearLayoutParams.setMargins(0, cellHeight*25/100, 0, 0) ;
		nameView.addView(imageView,linearLayoutParams) ;
		
		TextView textView = new TextView(forumActivity) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText("Join other Groups");
		textView.setTextColor(Color.rgb(0xFF, 0xFF, 0xFF)) ;
		textView.setGravity(Gravity.CENTER_VERTICAL) ;
		textView.setPadding(0, 0, 0, 0) ;
		textView.setTextSize((float)listWidth * 5.2f / 100 / scaledDensity) ;
		textView.setTypeface(typeface) ;
		linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, cellHeight) ;
		linearLayoutParams.setMargins(listWidth*2/100, 0, 0, 0) ;
		nameView.addView(textView,linearLayoutParams) ;
		
		imageView = new ImageView(forumActivity) ;
		imageView.setImageResource(R.drawable.settings_arrow_white) ;
		imageView.setScaleType(ScaleType.FIT_START) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*3/100,listWidth*5/100) ;
		relativeLayoutParams.setMargins(this.listWidth*90/100,this.listWidth*4/100, 0, 0) ;
		contentLayout.addView(imageView,relativeLayoutParams) ;
		
		View lineView = new View(forumActivity) ;
		lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
		relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth*95/100,1) ;
		relativeLayoutParams.setMargins(this.listWidth*5/100,cellHeight-1, 0, 0) ;
		contentLayout.addView(lineView,relativeLayoutParams) ;
		
		return view ;	
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		
		int itemViewType = getItemViewType(position) ;
		
		View view = null ;
		if(itemViewType == TYPE_SPACER) {
			view = this.getSpacerView(position);
		} else if(itemViewType == TYPE_AD){
			view = this.getAdView(position,convertView);
		} else if(itemViewType == TYPE_FORUM){
			view = this.getForumView(position) ;
		} else if(itemViewType == TYPE_GROUP){
			view = this.getGroupView(position) ;
		} else if(itemViewType == TYPE_ADD_GROUP){
			view = this.getAddGroupView(position) ;
		}

		return view ;	
	}

}
