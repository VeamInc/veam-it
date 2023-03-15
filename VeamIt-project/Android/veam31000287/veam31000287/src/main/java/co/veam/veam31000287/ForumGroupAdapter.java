package co.veam.veam31000287;

import java.util.ArrayList;
import java.util.HashMap;

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

public class ForumGroupAdapter extends LoadMoreAdapter {

	private ForumGroupAdapterActivityInterface forumGroupActivity ;
	private Context context ;
	
	ArrayList<ForumGroupObject> forumGroups ;
	HashMap<String,String> entryMap ;
	
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
	
	public ForumGroupAdapter(ForumGroupAdapterActivityInterface activity,Context context,ForumGroupXml forumGroupXml,int width,int topMargin,float scaledDensity)
	{
		this.forumGroupActivity = activity ;
		this.context = context ;
		this.listWidth = width ;
		this.topMargin = topMargin ;
		this.scaledDensity = scaledDensity ;
		this.setForumGroups(forumGroupXml) ;
		this.setSocialUserId() ;
	}
	
	public void setSocialUserId(){
		this.socialUserId = VeamUtil.getSocialUserId(context) ; 
	}
	
	public void setForumGroups(ForumGroupXml forumGroupXml){
		if(forumGroupXml != null){
			this.forumGroups = forumGroupXml.getForumGroups() ;
			this.entryMap = forumGroupXml.getEntryMap() ;
		}
		updating = false ;
	}
	
	public boolean hasForumGroup(String forumGroupId){
		boolean retBool = false ;
		if(forumGroups != null){
			int count = forumGroups.size() ;
			for(int index = 0 ; index < count ; index++){
				ForumGroupObject forumGroup = forumGroups.get(index) ;
				if(forumGroupId.equals(forumGroup.getId())){
					retBool = true ;
					break ;
				}
			}
		}
		return retBool ;
	}
	
	public void addForumGroups(ForumGroupXml forumGroupXml){
		loadingMore = false ;
		if(forumGroups == null){
			forumGroups = new ArrayList<ForumGroupObject>() ;
		}
		ArrayList<ForumGroupObject> workForumGroups = forumGroupXml.getForumGroups() ;
		int count = workForumGroups.size() ;
		for(int index = 0 ; index < count ; index++){
			ForumGroupObject forumGroup = workForumGroups.get(index) ;
			if(!this.hasForumGroup(forumGroup.getId())){
				forumGroups.add(forumGroup) ;
			}
		}
		this.entryMap = forumGroupXml.getEntryMap() ;
	}
	
	public void deleteForumGroupObject(ForumGroupObject forumGroupObject){
		forumGroups.remove(forumGroupObject) ;
	}
	


	@Override
	public int getCount() {
		int retValue = 0 ; 
		if(forumGroups != null){
			retValue = forumGroups.size()+1 ;
		}
		return retValue ;
	}

	@Override
	public Object getItem(int position) {
		ForumGroupObject retValue = null ;
		if(position > 0){
			retValue = forumGroups.get(position-1) ;
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
		forumGroupActivity.reloadForumGroup() ;
	}

	@Override
	public void setLoadingMore(){
		if(!loadingMore){
			loadingMore = true ;
			this.notifyDataSetChanged() ;
			forumGroupActivity.loadMoreForumGroup() ;
		}
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		//VeamUtil.log("debug","getView:"+position) ;
		
		ForumGroupObject forumGroupObject = (ForumGroupObject)this.getItem(position) ;
		String userName = "" ;
		
		if(position > 0){
			if(forumGroupObject != null){
				userName = String.format("%s (%s)",forumGroupObject.getForumName(),forumGroupObject.getNumberOfMembers()) ;
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
		int plusIconSize = listWidth * 55 / 1000 ;
		
		if(view == null){
			view = new LinearLayout(context) ;
			view.setTag(Integer.valueOf(0)) ;
			view.setOrientation(LinearLayout.VERTICAL) ;
			view.setBackgroundColor(Color.argb(0x20, 0xff, 0xff, 0xff)) ;
			int margin = listWidth*4/100 ;
			view.setPadding(margin, 0, 0, 0) ;
			
			
			RelativeLayout contentLayout = new RelativeLayout(context) ;
			contentLayout.setBackgroundColor(Color.TRANSPARENT) ;
			linearLayoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, cellHeight) ;
			view.addView(contentLayout,linearLayoutParams) ;
			
			int iconSize = listWidth * 6 / 100 ;
			ImageView groupImageView = new ImageView(context) ;
			groupImageView.setImageResource(R.drawable.pro_person_icon) ;
			groupImageView.setScaleType(ScaleType.CENTER_CROP) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(iconSize,iconSize) ;
			relativeLayoutParams.setMargins(0,(cellHeight-iconSize)/2,0,0) ;
			contentLayout.addView(groupImageView,relativeLayoutParams) ;

			
			TextView userNameTextView = new TextView(context) ;
			userNameTextView.setId(VIEWID_USER_NAME) ;
			userNameTextView.setBackgroundColor(Color.TRANSPARENT) ;
			userNameTextView.setTextColor(Color.rgb(0x00, 0x00, 0x00)) ;
			userNameTextView.setGravity(Gravity.CENTER_VERTICAL) ;
			userNameTextView.setPadding(0, 0, 0, 0) ;
			userNameTextView.setTextSize((float)listWidth * 5.7f / 100 / scaledDensity) ;
			userNameTextView.setTypeface(typefaceRobotoLight) ;
			userNameTextView.setMaxLines(1) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(this.listWidth*75/100, cellHeight) ;
			relativeLayoutParams.setMargins(this.listWidth*9/100,listWidth*1/100, 0, 0) ;
			contentLayout.addView(userNameTextView,relativeLayoutParams) ;
			
			ImageView plusImageView = new ImageView(context) ;
			plusImageView.setImageResource(R.drawable.forum_group_plus_off) ;
			plusImageView.setScaleType(ScaleType.FIT_XY) ;
			plusImageView.setId(VIEWID_USER_ICON) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(plusIconSize,plusIconSize) ;
			relativeLayoutParams.setMargins(listWidth-margin*2-plusIconSize,(cellHeight-plusIconSize)/2, 0, 0) ;
			contentLayout.addView(plusImageView,relativeLayoutParams) ;

			View lineView = new View(context) ;
			lineView.setBackgroundColor(Color.argb(0x20, 0x00, 0x00, 0x00)) ;
			relativeLayoutParams = new RelativeLayout.LayoutParams(listWidth-margin,1) ;
			relativeLayoutParams.setMargins(0,cellHeight-1, 0, 0) ;
			contentLayout.addView(lineView,relativeLayoutParams) ;


		}
		
		//if(position != (Integer)view.getTag()){
			TextView userNameTextView = (TextView)view.findViewById(VIEWID_USER_NAME) ;
			userNameTextView.setText(userName);

			ImageView userIconImageView = (ImageView)view.findViewById(VIEWID_USER_ICON) ;
			if(userIconImageView != null){
				userIconImageView.setTag(Integer.valueOf(position)) ;
		        if(this.hasGroupEntry(forumGroupObject.getId())){
		            userIconImageView.setImageResource(R.drawable.forum_group_plus_on) ;
		        } else {
		            userIconImageView.setImageResource(R.drawable.forum_group_plus_off) ;
		        }
			}
		//}
	
		view.setTag(Integer.valueOf(position)) ;
		
		return view ;	
	}
	
	public interface  ForumGroupAdapterActivityInterface {
		public void reloadForumGroup() ;
		public void loadMoreForumGroup() ;
		public void onForumGroupLoadFailed() ;
		public void updateForumGroup(ForumGroupXml forumGroupXml,int pageNo) ;
	}
	
	public boolean hasGroupEntry(String forumGroupId){
		boolean retValue = false ;
		if(entryMap != null){
			String entry = entryMap.get(forumGroupId) ;
			if(entry != null){
				if(entry.equals("y")){
					retValue = true ;
				}
			}
		}
		return retValue ;
	}

	public void setGroupEntry(String forumGroupId,boolean hasEntry){
		//VeamUtil.log("debug","setLike:"+pictureId + " isLike:" + isLike) ;
		if(entryMap == null){
			entryMap = new HashMap<String,String>() ;
		}
		if(entryMap != null){
			if(hasEntry){
				//VeamUtil.log("debug","setLike 'y'") ;
				entryMap.put(forumGroupId, "y") ;
			} else {
				//VeamUtil.log("debug","setLike 'n'") ;
				entryMap.put(forumGroupId, "n") ;
			}
		}
	}


}
