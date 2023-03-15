package co.veam.veam31000287;

import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.List;

/**
 * Created by veam on 11/18/16.
 */
public class ConsoleScreenShotAdapter extends RecyclerView.Adapter<ConsoleScreenShotAdapter.MyViewHolder> {

    private static final int VIEWID_IMAGE_VIEW = 0x80001 ;

    private int listWidth ;
    private List<String> horizontalList;

    public class MyViewHolder extends RecyclerView.ViewHolder {
        //public TextView txtView;
        public ImageView imageView ;

        public MyViewHolder(View view) {
            super(view);
            imageView = (ImageView) view.findViewById(VIEWID_IMAGE_VIEW);
        }
    }


    public ConsoleScreenShotAdapter(List<String> horizontalList,int listWidth) {
        this.horizontalList = horizontalList;
        this.listWidth = listWidth ;
    }

    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        RelativeLayout itemView = new RelativeLayout(parent.getContext()) ;
        ImageView workImageView = new ImageView(parent.getContext()) ;
        workImageView.setScaleType(ImageView.ScaleType.FIT_XY);
        workImageView.setId(VIEWID_IMAGE_VIEW);
        itemView.addView(workImageView,ConsoleUtil.getRelativeLayoutPrams(0,0,listWidth/2,listWidth*1136/640/2));

        return new MyViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(final MyViewHolder holder, final int position) {
        VeamUtil.log("debug", "onBindViewHolder " + position + "=" + horizontalList.get(position)) ;
        holder.imageView.setImageBitmap(VeamUtil.getCachedFileBitmapWithWidth(AnalyticsApplication.getContext(),horizontalList.get(position),listWidth/2,2,false));
    }

    @Override
    public int getItemCount() {
        VeamUtil.log("debug", "getItemCount " + horizontalList.size()) ;
        return horizontalList.size();
    }
}