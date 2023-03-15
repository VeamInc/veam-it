package co.veam.veam31000287;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.text.Html;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TextView;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.NativeExpressAdView ;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class PictureAdapter extends LoadMoreAdapter {

	private VeamActivity veamActivity ;
	
	ArrayList<PictureObject> pictures ;
	HashMap<String,String> likeMap ;

	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private String socialUserId ;
	private TextView topTextView = null ;
	private RelativeLayout topContentView = null ;
	private boolean updating = false ;
	private boolean loadingMore = false ;
	private boolean shouldShowForumName = false ;
	private boolean forumUserPermission = false ;

	private AdSize adSize ;
	private String adUnitId ;

	Map<String,NativeExpressAdView> pictureNativeAdViews ;
	ArrayList<String> pictureNativeAdLoadRows ;


	//private static int VIEWID_TITLE				= 0x50001 ;
	public static int VIEWID_IMAGE				= 0x50002 ;
	public static int VIEWID_USER_ICON			= 0x50003 ;
	public static int VIEWID_USER_NAME			= 0x50004 ;
	public static int VIEWID_TIME				= 0x50005 ;
	public static int VIEWID_LIKE_MARK			= 0x50006 ;
	public static int VIEWID_LIKE_COUNT			= 0x50007 ;
	public static int VIEWID_LIKE_BUTTON		= 0x50008 ;
	public static int VIEWID_COMMENT_BUTTON		= 0x50009 ;
	public static int VIEWID_COMMENT_AREA		= 0x5000a ;
	public static int VIEWID_DELETE_BUTTON		= 0x5000b ;
	public static int VIEWID_FOLD_COMMENT		= 0x5000c ;
	public static int VIEWID_PROGRESS			= 0x5000d ;
	public static int VIEWID_FAVORITE_BUTTON	= 0x5000e ;
	public static int VIEWID_REPORT_BUTTON		= 0x5000f ;
	public static int VIEWID_COMMENT			= 0x50010 ;
	public static int VIEWID_LIKE_COUNT_VIEW	= 0x50011 ;
	public static int VIEWID_NATIVE_AD			= 0x50012 ;
	public static int VIEWID_CONTENT			= 0x50013 ;



	////////////////
	private static final int ITEM_VIEW_TYPE_SPACER = 0 ;
	private static final int ITEM_VIEW_TYPE_BANNER_AD = 1 ;
	private static final int ITEM_VIEW_TYPE_PICTURE = 2 ;
	private static final int ITEM_VIEW_TYPE_NATIVE_AD = 3 ;
	////
	private static final int TYPE_MAX_COUNT = 4 ;
	////////////////

	private int nativeAdWidth ;
	private int nativeAdHeight ;
	private int numberOfPicturesBetweenAds ;
	private int numberOfPictures ;

	public PictureAdapter(VeamActivity activity,PictureXml pictureXml,int width,int topMargin,float scaledDensity,boolean shouldShowForumName,String adUnitId,AdSize adSize)
	{
		this.pictureNativeAdViews = new HashMap<String,NativeExpressAdView>() ;
		this.pictureNativeAdLoadRows = new ArrayList<String>() ;

		this.veamActivity = activity ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.setPictures(pictureXml) ;
		this.setSocialUserId() ;
		this.shouldShowForumName = shouldShowForumName ;

		this.adUnitId = adUnitId ;
		this.adSize = adSize ;

		String nativeAdHeightString = VeamUtil.getPreferenceString(veamActivity, "picture_ad_height") ;
		int workHeight = 280 ;
		if(!VeamUtil.isEmpty(nativeAdHeightString)){
			workHeight = VeamUtil.parseInt(nativeAdHeightString) ;
		}

		this.nativeAdWidth = listWidth * 94 / 100 ;
		this.nativeAdHeight = nativeAdWidth * workHeight / 300 ;

		VeamUtil.log("debug","native ad width="+nativeAdWidth+" height="+nativeAdHeight) ;


	}
	
	public void setSocialUserId(){
		this.socialUserId = VeamUtil.getSocialUserId(veamActivity) ; 
	}
	
	public void setPictures(PictureXml pictureXml){
		if(pictureXml != null){
			this.pictures = pictureXml.getPictures() ;
			this.likeMap = pictureXml.getLikeMap() ;
			this.forumUserPermission = pictureXml.getForumUserPermission() ;

			// initial preload ad
			numberOfPicturesBetweenAds = pictureXml.getNumberOfPicturesBetweenAds() ;
			if(numberOfPicturesBetweenAds > 0) {
				if (pictures != null) {
					numberOfPictures = pictures.size();
					if (numberOfPictures >= numberOfPicturesBetweenAds) {
						this.getNativeAdView(numberOfPicturesBetweenAds + 2);
					}
				}
			}
		}
		updating = false ;
	}
	
	public boolean hasPicture(String id){
		boolean retBool = false ;
		if(!id.equals("AD")) {
			if (pictures != null) {
				int count = pictures.size();
				for (int index = 0; index < count; index++) {
					PictureObject picture = pictures.get(index);
					if (id.equals(picture.getId())) {
						retBool = true;
						break;
					}
				}
			}
		}
		return retBool ;
	}
	
	public void setLike(String pictureId,boolean isLike){
		//VeamUtil.log("debug","setLike:"+pictureId + " isLike:" + isLike) ;
		if(likeMap == null){
			likeMap = new HashMap<String,String>() ;
		}
		if(likeMap != null){
			if(isLike){
				//VeamUtil.log("debug","setLike 'y'") ;
				likeMap.put(pictureId, "y") ;
			} else {
				//VeamUtil.log("debug","setLike 'n'") ;
				likeMap.put(pictureId, "n") ;
			}
		}
	}
	
	public boolean isLike(String pictureId){
		boolean isLike = false ;
		//VeamUtil.log("debug","isLike:"+pictureId) ;
		if(likeMap != null){
			//VeamUtil.log("debug","likeMap not null") ;
			String like = likeMap.get(pictureId) ;
			if(!VeamUtil.isEmpty(like) && like.equals("y")){
				//VeamUtil.log("debug","I like this"+pictureId) ;
				isLike = true ;
			}
		}
		return isLike ;
	}
	
	public void addPictures(PictureXml pictureXml){
		loadingMore = false ;
		if(pictures == null){
			pictures = new ArrayList<PictureObject>() ;
		}
		ArrayList<PictureObject> workPictures = pictureXml.getPictures() ;
		int count = workPictures.size() ;
		for(int index = 0 ; index < count ; index++){
			PictureObject picture = workPictures.get(index) ;
			if(!picture.getId().equals("AD")) {
				if (!this.hasPicture(picture.getId())) {
					pictures.add(picture);
				}
			}
		}
		numberOfPictures = pictures.size() ;
		likeMap = pictureXml.getLikeMap() ;
	}
	
	public void deletePictureObject(PictureObject pictureObject){
		pictures.remove(pictureObject) ;
	}
	
	public boolean getForumUserPermission(){
		return forumUserPermission ;
	}

	@Override
	public int getCount() {
		VeamUtil.log("debug","PictureAdapter::getCount") ;
		int retValue = 0 ; 
		if(pictures != null){
			retValue = pictures.size()+2 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		PictureObject retValue = null ;
		if(position > 1){
			retValue = pictures.get(position-2) ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public void setTopText(String text){
		if(topTextView != null){
			topTextView.setText(text) ;
		}
	}


	@Override
	public int getItemViewType(int position) {
		int itemViewType = 0 ;

		if(position == 0) {
			itemViewType = ITEM_VIEW_TYPE_SPACER;
		} else if(position == 1){
			itemViewType = ITEM_VIEW_TYPE_BANNER_AD;
		} else {
			PictureObject pictureObject = (PictureObject)this.getItem(position) ;
			VeamUtil.log("debug","PictureAdapter::getItemViewType position="+position+" id="+pictureObject.getId()) ;
			if(pictureObject.getId().equals("AD")) {
				itemViewType = ITEM_VIEW_TYPE_NATIVE_AD;
			} else {
				itemViewType = ITEM_VIEW_TYPE_PICTURE;
			}
		}

		return itemViewType ;
	}

	@Override
	public int getViewTypeCount() {
		return TYPE_MAX_COUNT ;
	}


	public void setUpdating(){
		updating = true ;
		this.notifyDataSetChanged() ;
		veamActivity.reloadPicture() ;
	}

	@Override
	public void setLoadingMore(){
		if(!loadingMore){
			loadingMore = true ;
			this.notifyDataSetChanged() ;
			veamActivity.loadMorePicture() ;
		}
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//VeamUtil.log("debug","getView:"+position) ;
		
		PictureObject pictureObject = (PictureObject)this.getItem(position) ;
		String userName = "" ;
		boolean isAd = false ;


		if(position == 1){
			if(VeamUtil.isActiveAdmob) {
				if (convertView instanceof AdView) {
					// Don’t instantiate new AdView, reuse old one
					return convertView;
				} else {
					// Create a new AdView
					AdView adView = new AdView(veamActivity);
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
				LinearLayout view = new LinearLayout(veamActivity) ;
				view.setTag(position) ;
				view.setOrientation(LinearLayout.VERTICAL) ;
				view.setBackgroundColor(Color.TRANSPARENT) ;
				view.setPadding(0, 1, 0, 0) ;
				return view ;
			}
		}



		if(position > 1){
			if(pictureObject != null){
				userName = pictureObject.getUserName() ;
				isAd = pictureObject.getId().equals("AD") ;
			}
		}
		Integer tag = 0 ;
		if(convertView != null){
			tag = (Integer)convertView.getTag() ;
			//VeamUtil.log("debug","convertView tag:"+tag) ;
			if((tag == 0) && (position == 0)){
				return convertView ;
			}
		}
		//LinearLayout view = (LinearLayout)convertView ;
		LinearLayout view = null ;
		if((tag != 0) && (tag != 1)){
			view = (LinearLayout)convertView ;
		}
		
		LinearLayout.LayoutParams linearLayoutParams ;
		RelativeLayout.LayoutParams relativeLayoutParams ;
		Typeface typefaceRobotoLight= Typeface.createFromAsset(veamActivity.getAssets(), "Roboto-Light.ttf");

		if(position == 0){
			view = new LinearLayout(veamActivity) ;
			view.setTag(Integer.valueOf(position)) ;
			//view.setOnClickListener(veamActivity) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			
			topContentView = new RelativeLayout(veamActivity) ;
			topContentView.setBackgroundColor(Color.TRANSPARENT) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, topMargin) ;
			view.addView(topContentView,linearLayoutParams) ;

			topTextView = new TextView(veamActivity) ;
			if(updating){
				view.setPadding(0, topMargin, 0, 0) ;
				topTextView.setText(veamActivity.getString(R.string.updating)) ;
			} else {
				view.setPadding(0, 0, 0, 0) ;
			}
			topTextView.setGravity(Gravity.CENTER) ;
			topTextView.setTextSize((float)listWidth * 5.8f / 100 / scaledDensity) ;
			topTextView.setTypeface(typefaceRobotoLight) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,topMargin) ;
			relativeLayoutParams.setMargins(0,0,0,0) ;
			topContentView.addView(topTextView,relativeLayoutParams) ;

			return view ;
		}
		
		int userIconSize = listWidth * 12 / 100 ;
		int pictureSize = listWidth * 94 / 100 ;

		if(view == null){
			view = new LinearLayout(veamActivity);
			view.setTag(Integer.valueOf(0));
			view.setOrientation(LinearLayout.VERTICAL);
			view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff));
			int margin = listWidth * 3 / 100;
			view.setPadding(margin, margin, margin, 0);

			RelativeLayout contentLayout = new RelativeLayout(veamActivity);
			contentLayout.setId(VIEWID_CONTENT) ;
			contentLayout.setBackgroundColor(Color.TRANSPARENT);
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
			view.addView(contentLayout, linearLayoutParams);
			if(isAd){
				int progressSize = listWidth * 10 / 100;
				ProgressBar progress = new ProgressBar(veamActivity);
				progress.setIndeterminate(true);
				progress.setId(VIEWID_PROGRESS);
				relativeLayoutParams = new RelativeLayout.LayoutParams(progressSize, progressSize);
				relativeLayoutParams.setMargins((pictureSize - progressSize) / 2, (nativeAdHeight - progressSize) / 2 + 10, 0, 0);
				contentLayout.addView(progress, relativeLayoutParams);

				View lineView = new View(veamActivity);
				lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00));

				relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth * 95 / 100, 1);
				relativeLayoutParams.setMargins(0, nativeAdHeight+30, 0, 0);
				contentLayout.addView(lineView, relativeLayoutParams);


			} else {

				ImageView userIconImageView = new ImageView(veamActivity);
				userIconImageView.setId(VIEWID_USER_ICON);
				userIconImageView.setOnClickListener(veamActivity);
				userIconImageView.setScaleType(ScaleType.CENTER_CROP);
				relativeLayoutParams = new RelativeLayout.LayoutParams(userIconSize, userIconSize);
				relativeLayoutParams.setMargins(0, 0, 0, 0);
				contentLayout.addView(userIconImageView, relativeLayoutParams);

				TextView userNameTextView = new TextView(veamActivity);
				userNameTextView.setId(VIEWID_USER_NAME);
				userNameTextView.setOnClickListener(veamActivity);
				userNameTextView.setBackgroundColor(Color.TRANSPARENT);
				userNameTextView.setTextColor(VeamUtil.getLinkTextColor(veamActivity));
				userNameTextView.setGravity(Gravity.CENTER_VERTICAL);
				userNameTextView.setPadding(0, 0, 0, 0);
				userNameTextView.setTextSize((float) listWidth * 4.3f / 100 / scaledDensity);
				userNameTextView.setTypeface(typefaceRobotoLight);
				userNameTextView.setMaxLines(1);
				relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth * 50 / 100, listWidth * 6 / 100);
				relativeLayoutParams.setMargins(this.listWidth * 15 / 100, listWidth * 1 / 100, 0, 0);
				contentLayout.addView(userNameTextView, relativeLayoutParams);

				TextView timeTextView = new TextView(veamActivity);
				timeTextView.setId(VIEWID_TIME);
				timeTextView.setBackgroundColor(Color.TRANSPARENT);
				timeTextView.setGravity(Gravity.CENTER_VERTICAL);
				timeTextView.setPadding(0, 0, 0, 0);
				timeTextView.setTextSize((float) listWidth * 3.2f / 100 / scaledDensity);
				timeTextView.setTypeface(typefaceRobotoLight);
				timeTextView.setMaxLines(1);
				relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth * 50 / 100, listWidth * 5 / 100);
				relativeLayoutParams.setMargins(this.listWidth * 15 / 100, listWidth * 6 / 100, 0, 0);
				contentLayout.addView(timeTextView, relativeLayoutParams);

				LinearLayout likeCountView = new LinearLayout(veamActivity);
				likeCountView.setId(VIEWID_LIKE_COUNT_VIEW);
				likeCountView.setOnClickListener(veamActivity);
				likeCountView.setOrientation(LinearLayout.HORIZONTAL);
				likeCountView.setGravity(Gravity.RIGHT | Gravity.CENTER_VERTICAL);
				likeCountView.setBackgroundColor(Color.TRANSPARENT);
				relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth * 50 / 100, userIconSize);
				relativeLayoutParams.setMargins(this.listWidth * 43 / 100, 0, 0, 0);
				contentLayout.addView(likeCountView, relativeLayoutParams);

				int likeMarkHeight = listWidth * 6 / 100;
				int likeMarkWidth = likeMarkHeight * 44 / 36;

				ImageView likeMarkImageView = new ImageView(veamActivity);
				likeMarkImageView.setId(VIEWID_LIKE_MARK);
				likeMarkImageView.setScaleType(ScaleType.FIT_END);
				likeMarkImageView.setImageBitmap(VeamUtil.getThemeImage(veamActivity, "like", 1));
				linearLayoutParams = new LinearLayout.LayoutParams(likeMarkWidth, likeMarkHeight);
				likeCountView.addView(likeMarkImageView, linearLayoutParams);

				TextView likeCountTextView = new TextView(veamActivity);
				likeCountTextView.setId(VIEWID_LIKE_COUNT);
				likeCountTextView.setBackgroundColor(Color.TRANSPARENT);
				likeCountTextView.setTextColor(VeamUtil.getLinkTextColor(veamActivity));
				likeCountTextView.setGravity(Gravity.CENTER_VERTICAL);
				likeCountTextView.setPadding(listWidth * 2 / 100, 0, 0, 0);
				likeCountTextView.setTextSize((float) listWidth * 6.0f / 100 / scaledDensity);
				likeCountTextView.setTypeface(Typeface.SANS_SERIF);
				likeCountTextView.setMaxLines(1);
				linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
				likeCountView.addView(likeCountTextView, linearLayoutParams);

				int progressSize = listWidth * 10 / 100;
				ProgressBar progress = new ProgressBar(veamActivity);
				progress.setIndeterminate(true);
				progress.setId(VIEWID_PROGRESS);
				relativeLayoutParams = new RelativeLayout.LayoutParams(progressSize, progressSize);
				relativeLayoutParams.setMargins((pictureSize - progressSize) / 2, userIconSize + margin + (pictureSize - progressSize) / 2, 0, 0);
				contentLayout.addView(progress, relativeLayoutParams);

				ImageView pictureImageView = new ImageView(veamActivity);
				pictureImageView.setId(VIEWID_IMAGE);
				pictureImageView.setScaleType(ScaleType.CENTER_CROP);
				relativeLayoutParams = new RelativeLayout.LayoutParams(pictureSize, pictureSize);
				relativeLayoutParams.setMargins(0, userIconSize + margin, 0, 0);
				contentLayout.addView(pictureImageView, relativeLayoutParams);

				int buttonMargin = listWidth * 2 / 100;
				int bottomY = pictureSize + margin - buttonMargin;
				ImageView likeButtonImageView = new ImageView(veamActivity);
				likeButtonImageView.setId(VIEWID_LIKE_BUTTON);
				likeButtonImageView.setOnClickListener(veamActivity);
				likeButtonImageView.setScaleType(ScaleType.CENTER_CROP);
				relativeLayoutParams = new RelativeLayout.LayoutParams(userIconSize, userIconSize);
				relativeLayoutParams.setMargins(buttonMargin, bottomY, 0, 0);
				contentLayout.addView(likeButtonImageView, relativeLayoutParams);

				ImageView commentButtonImageView = new ImageView(veamActivity);
				commentButtonImageView.setId(VIEWID_COMMENT_BUTTON);
				commentButtonImageView.setOnClickListener(veamActivity);
				commentButtonImageView.setScaleType(ScaleType.CENTER_CROP);
				commentButtonImageView.setImageResource(R.drawable.forum_comment_button);
				relativeLayoutParams = new RelativeLayout.LayoutParams(userIconSize, userIconSize);
				relativeLayoutParams.setMargins(buttonMargin * 2 + userIconSize, bottomY, 0, 0);
				contentLayout.addView(commentButtonImageView, relativeLayoutParams);

				ImageView favoriteButtonImageView = new ImageView(veamActivity);
				favoriteButtonImageView.setId(VIEWID_FAVORITE_BUTTON);
				favoriteButtonImageView.setOnClickListener(veamActivity);
				favoriteButtonImageView.setScaleType(ScaleType.CENTER_CROP);
				relativeLayoutParams = new RelativeLayout.LayoutParams(userIconSize, userIconSize);
				relativeLayoutParams.setMargins(pictureSize - userIconSize - buttonMargin, bottomY, 0, 0);
				contentLayout.addView(favoriteButtonImageView, relativeLayoutParams);

				ImageView deleteButtonImageView = new ImageView(veamActivity);
				deleteButtonImageView.setId(VIEWID_DELETE_BUTTON);
				deleteButtonImageView.setOnClickListener(veamActivity);
				deleteButtonImageView.setScaleType(ScaleType.CENTER_CROP);
				deleteButtonImageView.setImageResource(R.drawable.forum_delete_button);
				relativeLayoutParams = new RelativeLayout.LayoutParams(userIconSize, userIconSize);
				relativeLayoutParams.setMargins(pictureSize - userIconSize - buttonMargin, userIconSize + margin + buttonMargin, 0, 0);
				contentLayout.addView(deleteButtonImageView, relativeLayoutParams);


				LinearLayout bottomView = new LinearLayout(veamActivity);
				bottomView.setOrientation(LinearLayout.VERTICAL);
				bottomView.setBackgroundColor(Color.TRANSPARENT);
				relativeLayoutParams = new RelativeLayout.LayoutParams(pictureSize, RelativeLayout.LayoutParams.WRAP_CONTENT);
				relativeLayoutParams.setMargins(0, userIconSize + margin + pictureSize + margin, 0, 0);
				contentLayout.addView(bottomView, relativeLayoutParams);

				LinearLayout commentView = new LinearLayout(veamActivity);
				commentView.setOrientation(LinearLayout.HORIZONTAL);
				commentView.setBackgroundColor(Color.TRANSPARENT);
				linearLayoutParams = new LinearLayout.LayoutParams(pictureSize, RelativeLayout.LayoutParams.WRAP_CONTENT);
				bottomView.addView(commentView, linearLayoutParams);


				int commentMarkWidth = listWidth * 6 / 100;
				int commentMarkHeight = commentMarkWidth * 32 / 36;
				int commentMarkPadding = listWidth * 1 / 100;
				ImageView commentMarkImageView = new ImageView(veamActivity);
				//likeMarkImageView.setId(VIEWID_LIKE_MARK) ;
				commentMarkImageView.setScaleType(ScaleType.FIT_XY);
				//commentMarkImageView.setImageResource(R.drawable.forum_comment) ;
				commentMarkImageView.setImageBitmap(VeamUtil.getThemeImage(veamActivity, "forum_comment", 1));
				commentMarkImageView.setPadding(0, commentMarkPadding, 0, 0);
				linearLayoutParams = new LinearLayout.LayoutParams(commentMarkWidth, commentMarkHeight + commentMarkPadding);
				commentView.addView(commentMarkImageView, linearLayoutParams);

				LinearLayout commentAreaView = new LinearLayout(veamActivity);
				commentAreaView.setId(VIEWID_COMMENT_AREA);
				commentAreaView.setOrientation(LinearLayout.VERTICAL);
				//commentView.setGravity(Gravity.LEFT | Gravity.CENTER_VERTICAL) ;
				commentAreaView.setBackgroundColor(Color.TRANSPARENT);
				commentAreaView.setPadding(listWidth * 3 / 100, 0, 0, 0);
				linearLayoutParams = new LinearLayout.LayoutParams(listWidth * 88 / 100, LinearLayout.LayoutParams.WRAP_CONTENT);
				commentView.addView(commentAreaView, linearLayoutParams);

				View lineView = new View(veamActivity);
				lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00));
				linearLayoutParams = new LinearLayout.LayoutParams(listWidth * 95 / 100, 1);
				linearLayoutParams.setMargins(0, margin, 0, 0);
				bottomView.addView(lineView, linearLayoutParams);

				/*
				lineView = new View(veamActivity);
				lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00));
				relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth * 95 / 100, 1);
				relativeLayoutParams.setMargins(this.listWidth * 5 / 100, 0, 0, 0);
				contentLayout.addView(lineView, relativeLayoutParams);
				*/
			}

		}
		
		if(isAd){
			RelativeLayout contentView = (RelativeLayout) view.findViewById(VIEWID_CONTENT);
			NativeExpressAdView adView = (NativeExpressAdView)contentView.findViewById(VIEWID_NATIVE_AD) ;
			if(adView != null){
				contentView.removeView(adView);
			}

			adView = this.getNativeAdView(position) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(nativeAdWidth, nativeAdHeight);
			relativeLayoutParams.setMargins(0, 10, 0, 0);
			contentView.addView(adView, relativeLayoutParams);

			if(numberOfPicturesBetweenAds > 0){
				if((position + numberOfPicturesBetweenAds + 1) < numberOfPictures + 2){
					// load next ad
					this.getNativeAdView(position+numberOfPicturesBetweenAds+1) ;
				}
			}

		} else {
			TextView userNameTextView = (TextView) view.findViewById(VIEWID_USER_NAME);
			userNameTextView.setText(userName);
			userNameTextView.setTag(Integer.valueOf(position));

			long currentTime = System.currentTimeMillis() / 1000L;
			String createdAt = pictureObject.getCreatedAt();
			long diff = currentTime - Long.parseLong(createdAt);
			if (diff < 0) {
				diff = 0;
			}
			String timeString = "";
			if (diff < 60) {
				if (diff == 1) {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.second_ago));
				} else {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.seconds_ago));
				}
			} else if (diff < 3600) {
				diff = (int) (diff / 60);
				if (diff == 1) {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.minute_ago));
				} else {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.minutes_ago));
				}
			} else if (diff < 86400) {
				diff = (int) (diff / 3600);
				if (diff == 1) {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.hour_ago));
				} else {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.hours_ago));
				}
			} else {
				diff = (int) (diff / 86400);
				if (diff == 1) {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.day_ago));
				} else {
					timeString = String.format("%d %s", diff, veamActivity.getString(R.string.days_ago));
				}
			}
			//VeamUtil.log("debug","createdAt:"+createdAt + "  current:"+currentTime + " diff:"+diff + " timeString:"+timeString) ;

			if (shouldShowForumName) {
				timeString = String.format("%s - %s", timeString, pictureObject.getForumName());
			}
			TextView timeTextView = (TextView) view.findViewById(VIEWID_TIME);
			timeTextView.setText(timeString);

			View likeCountView = (View) view.findViewById(VIEWID_LIKE_COUNT_VIEW);
			likeCountView.setTag(Integer.valueOf(position));

			TextView likeCountTextView = (TextView) view.findViewById(VIEWID_LIKE_COUNT);
			likeCountTextView.setText(pictureObject.getLikes());


			ImageView userIconImageView = (ImageView) view.findViewById(VIEWID_USER_ICON);
			userIconImageView.setTag(Integer.valueOf(position));
			Bitmap icomBitmap = VeamUtil.getCachedFileBitmapWithWidth(veamActivity, pictureObject.getUserIconUrl(), userIconSize, 1, false);
			if (icomBitmap == null) {
				userIconImageView.setImageDrawable(new ColorDrawable(Color.argb(0, 0, 0, 0)));
				LoadImageTask loadImageTask = new LoadImageTask(veamActivity, pictureObject.getUserIconUrl(), userIconImageView, userIconSize, position, null);
				loadImageTask.execute("");
			} else {
				userIconImageView.setImageBitmap(icomBitmap);
				icomBitmap = null;
			}


			ProgressBar progress = (ProgressBar) view.findViewById(VIEWID_PROGRESS);
			progress.setTag(Integer.valueOf(position));

			ImageView pictureImageView = (ImageView) view.findViewById(VIEWID_IMAGE);
			pictureImageView.setTag(Integer.valueOf(position));
			Bitmap bitmap = VeamUtil.getCachedFileBitmapWithWidth(veamActivity, pictureObject.getImageUrl(), pictureSize, 1, false);

			if (bitmap == null) {
				progress.setVisibility(View.VISIBLE);
				pictureImageView.setImageDrawable(new ColorDrawable(Color.argb(0, 0, 0, 0)));
				LoadImageTask loadImageTask = new LoadImageTask(veamActivity, pictureObject.getImageUrl(), pictureImageView, pictureSize, position, progress);
				loadImageTask.execute("");
			} else {
				progress.setVisibility(View.GONE);
				pictureImageView.setImageBitmap(bitmap);
				bitmap = null;
			}


			ImageView likeButtonImageView = (ImageView) view.findViewById(VIEWID_LIKE_BUTTON);
			likeButtonImageView.setTag(Integer.valueOf(position));
			if (this.isLike(pictureObject.getId())) {
				likeButtonImageView.setImageBitmap(VeamUtil.getThemeImage(veamActivity, "forum_like_button_on", 1));
			} else {
				likeButtonImageView.setImageResource(R.drawable.forum_like_button_off);
			}

			ImageView commentButtonImageView = (ImageView) view.findViewById(VIEWID_COMMENT_BUTTON);
			commentButtonImageView.setTag(Integer.valueOf(position));

			ImageView favoriteButtonImageView = (ImageView) view.findViewById(VIEWID_FAVORITE_BUTTON);
			favoriteButtonImageView.setTag(Integer.valueOf(position));
			if (VeamUtil.isFavoritePicture(veamActivity, pictureObject.getId())) {
				favoriteButtonImageView.setImageBitmap(VeamUtil.getThemeImage(veamActivity, "add_on", 1));
			} else {
				favoriteButtonImageView.setImageBitmap(VeamUtil.getThemeImage(veamActivity, "add_off", 1));
			}

			ImageView deleteButtonImageView = (ImageView) view.findViewById(VIEWID_DELETE_BUTTON);
			deleteButtonImageView.setTag(Integer.valueOf(position));
			if ((socialUserId != null) && !socialUserId.equals("") && socialUserId.equals(pictureObject.getSocialUserId())) {
				//VeamUtil.log("debug","my picture , show delete button ") ;
				deleteButtonImageView.setVisibility(View.VISIBLE);
			} else {
				//VeamUtil.log("debug","not my picture , hide delete button " + socialUserId + "!="+pictureObject.getSocialUserId()) ;
				deleteButtonImageView.setVisibility(View.GONE);
			}

			int reportWidth = listWidth * 20 / 100;
			int reportHeight = reportWidth * 42 / 118;

			LinearLayout commentAreaView = (LinearLayout) view.findViewById(VIEWID_COMMENT_AREA);
			commentAreaView.removeAllViews();
			ArrayList<PictureCommentObject> comments = pictureObject.getComments();
			int count = comments.size();
			int showCount = count;
			if ((count > 3) && !pictureObject.isShowAllComments()) {
				showCount = 3;
			}

			linearLayoutParams = new LinearLayout.LayoutParams(this.listWidth * 85 / 100, LinearLayout.LayoutParams.WRAP_CONTENT);


			for (int index = 0; index < showCount; index++) {
				PictureCommentObject comment = comments.get(index);
				TextView commentTextView = new TextView(veamActivity);
				commentTextView.setTextSize((float) listWidth * 3.9f / 100 / scaledDensity);
				String htmlString = String.format("<font color=\"#%s\"><b>%s</b></font> <font color=\"#333333\">%s</font>",
						VeamUtil.getColorString(VeamUtil.getLinkTextColor(veamActivity)), comment.getUserName(), comment.getText());
				commentTextView.setText(Html.fromHtml(htmlString));
				commentTextView.setTypeface(typefaceRobotoLight);
				commentTextView.setId(VIEWID_COMMENT);
				commentTextView.setTag(comment);
				commentTextView.setOnClickListener(veamActivity);
				commentAreaView.addView(commentTextView, linearLayoutParams);
			}

			if (count <= 3) {
				TextView textView = new TextView(veamActivity);
				textView.setTextSize((float) listWidth * 3.9f / 100 / scaledDensity);
				textView.setText(" ");
				textView.setGravity(Gravity.CENTER_VERTICAL);
				textView.setTextColor(Color.TRANSPARENT);
				textView.setTypeface(typefaceRobotoLight);

				LinearLayout countAndReport = new LinearLayout(this.veamActivity);
				countAndReport.setOrientation(LinearLayout.HORIZONTAL);
				linearLayoutParams = new LinearLayout.LayoutParams(listWidth * 85 / 100, reportHeight);
				commentAreaView.addView(countAndReport, linearLayoutParams);

				linearLayoutParams = new TableLayout.LayoutParams(listWidth * 65 / 100, listWidth * 15 / 100, 1f);
				countAndReport.addView(textView, linearLayoutParams);

				ImageView reportImageView = new ImageView(this.veamActivity);
				reportImageView.setImageBitmap(VeamUtil.getThemeImage(veamActivity, "report", 1));
				//reportImageView.setScaleType(ScaleType.CENTER_INSIDE) ;
				reportImageView.setScaleType(ScaleType.FIT_END);
				reportImageView.setTag(Integer.valueOf(position));
				reportImageView.setId(VIEWID_REPORT_BUTTON);
				reportImageView.setOnClickListener(veamActivity);
				linearLayoutParams = new TableLayout.LayoutParams(reportWidth, reportHeight, 2f);

				//VeamUtil.log("debug", "listWidth=" + listWidth + " reportWidth=" + reportWidth) ;
				linearLayoutParams.gravity = Gravity.CENTER_VERTICAL;
				countAndReport.addView(reportImageView, linearLayoutParams);
			} else {
				TextView textView = new TextView(veamActivity);
				textView.setTextSize((float) listWidth * 3.9f / 100 / scaledDensity);
				if (!pictureObject.isShowAllComments()) {
					textView.setText(String.format(veamActivity.getString(R.string.view_all_comments), count));
				} else {
					textView.setText(veamActivity.getString(R.string.close_all_comments));
				}
				textView.setGravity(Gravity.CENTER_VERTICAL);
				textView.setTextColor(VeamUtil.getColorFromArgbString("CC000000"));
				textView.setTypeface(typefaceRobotoLight);
				textView.setId(VIEWID_FOLD_COMMENT);
				textView.setTag(pictureObject);
				textView.setOnClickListener(veamActivity);

				LinearLayout countAndReport = new LinearLayout(veamActivity);
				countAndReport.setOrientation(LinearLayout.HORIZONTAL);
				linearLayoutParams = new LinearLayout.LayoutParams(listWidth * 85 / 100, listWidth * 15 / 100);
				commentAreaView.addView(countAndReport, linearLayoutParams);

				linearLayoutParams = new TableLayout.LayoutParams(listWidth * 65 / 100, listWidth * 15 / 100, 1f);
				countAndReport.addView(textView, linearLayoutParams);

				ImageView reportImageView = new ImageView(veamActivity);
				reportImageView.setImageBitmap(VeamUtil.getThemeImage(veamActivity, "report", 1));
				reportImageView.setScaleType(ScaleType.FIT_END);
				reportImageView.setTag(Integer.valueOf(position));
				reportImageView.setId(VIEWID_REPORT_BUTTON);
				reportImageView.setOnClickListener(veamActivity);
				linearLayoutParams = new TableLayout.LayoutParams(reportWidth, reportHeight, 2f);
				linearLayoutParams.gravity = Gravity.CENTER_VERTICAL;
				countAndReport.addView(reportImageView, linearLayoutParams);

			}
		}

		view.setTag(Integer.valueOf(position)) ;
	
		return view ;	
	}

	private NativeExpressAdView getNativeAdView(int position){
		VeamUtil.log("debug","getNativeAdView "+position + " scaledDensity="+scaledDensity + " listWidth="+listWidth + " nativeAdWidth="+nativeAdWidth) ;
		String positionString = String.format("%d",position) ;
		NativeExpressAdView adView = pictureNativeAdViews.get(positionString) ;
		if(adView == null){
			adView = new NativeExpressAdView(veamActivity);
			adView.setId(VIEWID_NATIVE_AD);
			adView.setAdSize(new AdSize((int)(nativeAdWidth/scaledDensity), (int)(nativeAdHeight/scaledDensity)));
			//adView.setAdSize(new AdSize(300, 280));
			VeamUtil.log("debug", "setAdUnit " + adUnitId) ;
			adView.setAdUnitId(adUnitId);
			adView.loadAd(VeamUtil.getAdRequest());
			pictureNativeAdViews.put(positionString,adView);
		} else {
			ViewGroup parent = (ViewGroup)adView.getParent() ;
			if(parent != null) {
				parent.removeView(adView);
			}
		}

		pictureNativeAdLoadRows.remove(positionString) ;
		pictureNativeAdLoadRows.add(0, positionString);

		this.clearPictureNativeAdCache();

		return adView ;
	}


	private void clearPictureNativeAdCache()
	{
		int maxCache = 5 ;
		Set<String> keys = pictureNativeAdViews.keySet() ;
		int stackCount = pictureNativeAdLoadRows.size() ;
		int keysCount = keys.size() ;
		VeamUtil.log("debug","pictureNativeAdViews count="+keysCount) ;
		if(keysCount > maxCache){
			int removeCount = keysCount - maxCache ;
			for (String positionString : keys) {
				boolean shouldBeRemain = false ;
				int checkCount = maxCache ;
				if(checkCount > stackCount){
					checkCount = stackCount ;
				}
				for(int stackIndex = 0 ; stackIndex < checkCount ; stackIndex++){
					if(positionString.equals(pictureNativeAdLoadRows.get(stackIndex))){
						shouldBeRemain = true ;
						break ;
					}
				}
				if(!shouldBeRemain){
					VeamUtil.log("debug","clear pictureNativeAd for "+positionString) ;
					pictureNativeAdViews.remove(positionString) ;
					removeCount-- ;
					if(removeCount == 0){
						break ;
					}
				}
			}
		}
	}


}
