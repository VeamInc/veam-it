package co.veam.veam31000287;


import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class PlaceAdapter extends BaseAdapter {
	private Context context ;
	private PlaceXml locations ;
	private float textSize ;
	Typeface typefaceRobotoLight ;
	
	public PlaceAdapter(Context activity,PlaceXml locations,float textSize)
	{
		this.context = activity ;
		this.locations = locations ;
		this.textSize = textSize ;
		typefaceRobotoLight = Typeface.createFromAsset(context.getAssets(), "Roboto-Light.ttf");
	}

	@Override
	public int getCount() {
		return locations.getNumberOfLocations() ;
	}

	@Override
	public Object getItem(int position) {
		return null ;
	}

	@Override
	public long getItemId(int position) {
		return 0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		TextView textView = new TextView(context) ;
		textView.setBackgroundColor(Color.TRANSPARENT) ;
		textView.setText(locations.getLocationNameAt(position)) ;
		textView.setTextSize(textSize) ;
		textView.setPadding((int)(textSize*2.5), (int)(textSize*1.5), 0, (int)(textSize*1.5)) ;
		textView.setTypeface(typefaceRobotoLight) ;

		
		return textView ;	
	}

}
