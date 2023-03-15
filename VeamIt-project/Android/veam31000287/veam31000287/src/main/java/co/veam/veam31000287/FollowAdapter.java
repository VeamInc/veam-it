package co.veam.veam31000287;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class FollowAdapter extends LoadMoreAdapter {

	private FollowAdapterActivityInterface followActivity ;
	private Context context ;
	
	ArrayList<FollowObject> follows ;
	
	private int listWidth ;
	private int topMargin ;
	private float scaledDensity ;
	private String socialUserId ;
	private TextView topTextView = null ;
	private RelativeLayout topContentView = null ;
	private boolean updating = false ;
	private boolean loadingMore = false ;
	
	public static int VIEWID_USER_ICON			= 0x50001 ;
	public static int VIEWID_USER_NAME			= 0x50002 ;
	
	public FollowAdapter(FollowAdapterActivityInterface activity,Context context,FollowXml followXml,int width,int topMargin,float scaledDensity)
	{
		this.followActivity = activity ;
		this.context = context ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.setFollows(followXml) ;
		this.setSocialUserId() ;
	}
	
	public void setSocialUserId(){
		this.socialUserId = VeamUtil.getSocialUserId(context) ; 
	}
	
	public void setFollows(FollowXml followXml){
		if(followXml != null){
			this.follows = followXml.getFollows() ;
		}
		updating = false ;
	}
	
	public boolean hasFollow(String socialUserId){
		boolean retBool = false ;
		if(follows != null){
			int count = follows.size() ;
			for(int index = 0 ; index < count ; index++){
				FollowObject follow = follows.get(index) ;
				if(socialUserId.equals(follow.getSocialUserId())){
					retBool = true ;
					break ;
				}
			}
		}
		return retBool ;
	}
	
	public void addFollows(FollowXml followXml){
		loadingMore = false ;
		if(follows == null){
			follows = new ArrayList<FollowObject>() ;
		}
		ArrayList<FollowObject> workFollows = followXml.getFollows() ;
		int count = workFollows.size() ;
		for(int index = 0 ; index < count ; index++){
			FollowObject follow = workFollows.get(index) ;
			if(!this.hasFollow(follow.getSocialUserId())){
				follows.add(follow) ;
			}
		}
	}
	
	public void deleteFollowObject(FollowObject followObject){
		follows.remove(followObject) ;
	}
	


	@Override
	public int getCount() {
		int retValue = 0 ; 
		if(follows != null){
			retValue = follows.size()+1 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		FollowObject retValue = null ;
		if(position > 0){
			retValue = follows.get(position-1) ;
		}
		return retValue ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}
	
	public void setTopText(String text){
		if(topTextView != null){
			topTextView.setText(text) ;
		}
	}
	
	public void setUpdating(){
		updating = true ;
		this.notifyDataSetChanged() ;
		followActivity.reloadFollow() ;
	}

	@Override
	public void setLoadingMore(){
		if(!loadingMore){
			loadingMore = true ;
			this.notifyDataSetChanged() ;
			followActivity.loadMoreFollow() ;
		}
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//VeamUtil.log("debug","getView:"+position) ;
		
		FollowObject followObject = (FollowObject)this.getItem(position) ;
		String userName = "" ;
		
		if(position > 0){
			if(followObject != null){
				userName = followObject.getSocialUserName() ;
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
		if(tag != 0){
			view = (LinearLayout)convertView ;
		}
		
		LinearLayout.LayoutParams linearLayoutParams ;
		RelativeLayout.LayoutParams relativeLayoutParams ;
		Typeface typefaceRobotoLight= Typeface.createFromAsset(context.getAssets(), "Roboto-Light.ttf");

		if(position == 0){
			view = new LinearLayout(context) ;
			view.setTag(Integer.valueOf(position)) ;
			//view.setOnClickListener(context) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.TRANSPARENT) ;
			
			topContentView = new RelativeLayout(context) ;
			topContentView.setBackgroundColor(Color.TRANSPARENT) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, topMargin) ;
			view.addView(topContentView,linearLayoutParams) ;

			topTextView = new TextView(context) ;
			if(updating){
				view.setPadding(0, topMargin, 0, 0) ;
				topTextView.setText(context.getString(R.string.updating)) ;
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
		
		int userIconSize = listWidth * 10 / 100 ;
		int cellHeight = listWidth * 14 / 100 ;
		
		if(view == null){
			view = new LinearLayout(context) ;
			view.setTag(Integer.valueOf(0)) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
			int margin = listWidth*3/100 ;
			view.setPadding(margin, 0, 0, 0) ;
			
			
			RelativeLayout contentLayout = new RelativeLayout(context) ;
			contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
			view.addView(contentLayout,linearLayoutParams) ;
			
			CircleImageView userIconImageView = new CircleImageView(context) ;
			userIconImageView.setId(VIEWID_USER_ICON) ;
			userIconImageView.setScaleType(ScaleType.CENTER_CROP) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(userIconSize,userIconSize) ;
			relativeLayoutParams.setMargins(0,(cellHeight-userIconSize)/2,0,0) ;
			contentLayout.addView(userIconImageView,relativeLayoutParams) ;
			
			TextView userNameTextView = new TextView(context) ;
			userNameTextView.setId(VIEWID_USER_NAME) ;
			userNameTextView.setBackgroundColor(Color.TRANSPARENT) ;
			userNameTextView.setTextColor(Color.rgb(0x00, 0x00, 0x00)) ;
			userNameTextView.setGravity(Gravity.CENTER_VERTICAL) ;
			userNameTextView.setPadding(0, 0, 0, 0) ;
			userNameTextView.setTextSize((float)listWidth * 4.3f / 100 / scaledDensity) ;
			userNameTextView.setTypeface(typefaceRobotoLight) ;
			userNameTextView.setMaxLines(1) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*75/100, cellHeight) ;
			relativeLayoutParams.setMargins(this.listWidth*15/100,listWidth*1/100, 0, 0) ;
			contentLayout.addView(userNameTextView,relativeLayoutParams) ;
			
			int arrowHeight = cellHeight * 30 / 100 ;
			int arrowWidth = arrowHeight * 16 / 26  ;

			ImageView arrowImageView = new ImageView(context) ;
			arrowImageView.setImageResource(R.drawable.setting_arrow) ;
			arrowImageView.setScaleType(ScaleType.FIT_XY) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(arrowWidth,arrowHeight) ;
			relativeLayoutParams.setMargins(listWidth-margin*2-arrowWidth,(cellHeight-arrowHeight)/2, 0, 0) ;
			contentLayout.addView(arrowImageView,relativeLayoutParams) ;
			
			View lineView = new View(context) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-margin,1) ;
			relativeLayoutParams.setMargins(0,cellHeight-1, 0, 0) ;
			contentLayout.addView(lineView,relativeLayoutParams) ;


		}
		
		//if(position != (Integer)view.getTag()){
			TextView userNameTextView = (TextView)view.findViewById(VIEWID_USER_NAME) ;
			userNameTextView.setText(userName);

			CircleImageView userIconImageView = (CircleImageView)view.findViewById(VIEWID_USER_ICON) ;
			userIconImageView.setTag(Integer.valueOf(position)) ;
			Bitmap icomBitmap = VeamUtil.getCachedFileBitmapWithWidth(context, followObject.getImageUrl(), userIconSize,1, false) ;
			if(icomBitmap == null){
				userIconImageView.setImageDrawable(new ColorDrawable(Color.argb(0,0,0,0))) ;
				LoadImageTask loadImageTask = new LoadImageTask(context,followObject.getImageUrl(),userIconImageView,userIconSize,position,null) ;
				loadImageTask.execute("") ;
			} else {
				userIconImageView.setImageBitmap(icomBitmap) ;
				icomBitmap = null ;
			}

		//}
	
		view.setTag(Integer.valueOf(position)) ;
		
		return view ;	
	}
	
	public interface  FollowAdapterActivityInterface {
		public void reloadFollow() ;
		public void loadMoreFollow() ;
		public void onFollowLoadFailed() ;
		public void updateFollow(FollowXml followXml,int pageNo) ;
	}


}
