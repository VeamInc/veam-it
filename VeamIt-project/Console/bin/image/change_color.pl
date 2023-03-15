use Image::Magick;
use File::Basename;
use FindBin;

$appId = $ARGV[0] ;
$conceptColor = $ARGV[1] ;
$textColor = $ARGV[2] ;

chdir($FindBin::Bin) ;

our $sourceImageDir = 'source_images' ;

if(!-e $appId){
	mkdir($appId) ;
}

our $outDir = sprintf("%s/%s",$appId,$conceptColor) ;
if(!-e $outDir){
	mkdir($outDir) ;
}

our $ssOutDir = sprintf("%s",$appId) ;


$veamColor = 'fd71bf' ;


$baseColor = $conceptColor ;
$baseTextColor = $textColor ;
$tabSelectColor = $conceptColor ;


%configList = (
	'add_on.png'=>				sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'answer_button_on.png'=>	sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'answer_video_on.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'answer_audio_on.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'ask_button.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'calendar_dot2.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'camera_button.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'check_box_on.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'expand_comment.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'flame.png'=>				sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'forum_comment.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'forum_like_button_on.png'=>sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'goodjob.png'=>				sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'like.png'=>				sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'list_clip.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'list_following.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'list_my_post.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'program_comment.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'program_like.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'pro_follow.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'pro_person_icon.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'pro_post_icon.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'pro_settings.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'q_answer_icon.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'q_ranking_icon.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'q_video_icon.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'q_vote_icon.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'ranking_button_on.png'=>	sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'report.png'=>				sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'select_back.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	't1_top_left.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	't8_top_left.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'tab_selected_back.png'=>	sprintf("%s:%s:%s",$veamColor,$tabSelectColor,$outDir),
	'tab_selected_back@2x.png'=>sprintf("%s:%s:%s",$veamColor,$tabSelectColor,$outDir),
	'thankyou.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'video_left.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'vote_button_on.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'vote_on.png'=>				sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'grid_audio.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'grid_back.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'grid_back1.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'grid_back2.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'grid_video.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'grid_year.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'default_grid_0.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'audio_thumbnail.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'video_thumbnail.png'=>		sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'share_facebook_off.png'=>	sprintf("%s:%s:%s",$veamColor,$baseTextColor,$outDir),
	'share_facebook_on.png'=>	sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'share_twitter_off.png'=>	sprintf("%s:%s:%s",$veamColor,$baseTextColor,$outDir),
	'share_twitter_on.png'=>	sprintf("%s:%s:%s",$veamColor,$baseColor,$outDir),
	'ss1_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss2_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss3_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss4_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss5_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss1_3i_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss2_3i_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss3_3i_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss4_3i_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
	'ss5_3i_text.png'=>			sprintf("%s:%s:%s",$veamColor,$baseColor,$ssOutDir),
) ;


if(opendir(IMAGEDIR,$sourceImageDir)){
	@list = grep(/.*\.png/i,readdir(IMAGEDIR)) ;
	for(@list){
		$fileName = $_ ;
		$colorConfig = $configList{$fileName} ;
		if($colorConfig){
			@colors = split(/:/,$colorConfig) ;
			changeColor($fileName,$colors[0],$colors[1],$colors[2]) ;
		} else {
			die("++++++++++++++++ not specified : ".$fileName."\n") ;
		}
	}
	closedir(IMAGEDIR) ;
} else {
	die("open failed ".$sourceImageDir) ;
}


exit ;


sub changeColor
{
	my($fileName,$from,$to,$saveDir) = @_ ;

	my $image = Image::Magick->new();

	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;

print(	$image->ReadImage($filePath));
	print($image->get('width')) ;
	$image->Set(depth=>24) ;

	print(sprintf("%s %dx%d\n",$filePath,$image->Get('width'),$image->Get('height'))) ;


	#$image->Opaque(color=>'#FD71BF',fill=>'#ff0000',fuzz=>'30%');
	#$image->Transparent(color=>'#FFFFFF') ;
	#$image->Colorize(fill=>'#0000FF',blend=>'') ; # no effect
	#$image->ColorMatrix([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0.5, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);


	# tr = r * m0 + g * m1 + b * m2 ;
	# tg = r * m3 + g * m4 + b * m5 ;
	# tb = r * m6 + g * m7 + b * m8 ;

	# f = f * m0 + f * m1 + f * m2 ;
	# f = f * m3 + f * m4 + f * m5 ;
	# f = f * m6 + f * m7 + f * m8 ;

	# tr = r * m0 + g * m1 + b * m2 ;
	# f = f * m0 + f * m1 + f * m2 ;
	# 1 - m1 - m2 = m0  ;
	# g / b = m2 / m1
	# m2 = g * m1 / b ;
	# tr = r * (1 - m1 - g * m1 / b) + g * m1 + b * g * m1 / b ;
	# tr* = b*r - b*r*m1 - g*r*m1 + b*g*m1 + b*g*m1
	# tr*b = b*r + (2*b*g - b*r - g*r) * m1

	## m1 = (tr*b - b*r) / (2*b*g - b*r - g*r)
	## m2 = g * m1 / b ;
	## m0 = 1 - m1 - m2

	# tg = r * m3 + g * m4 + b * m5 ;
	# f = f * m3 + f * m4 + f * m5 ;
	# r/b = m5/m3 ;
	# tg*b - b*g = (b*r - b*g - g*r + b*r)*m3 ;

	## m3 = (tg*b - b*g) / (2*b*r - b*g - g*r) ;
	## m5 = r*m3/b
	## m4 = 1 - m3 - m5

	# tb = r * m6 + g * m7 + b * m8 ;
	# f = f * m6 + f * m7 + f * m8 ;
	# m7 = m6*r/g

	## m6 = (tb*g - g*b) / (2*g*r - g*b - b*r)
	## m7 = m6*r/g
	## m8 = 1 - m6 - m7

	#############################################
	## m1 = (tr*b - b*r) / (2*b*g - b*r - g*r)
	## m2 = g * m1 / b ;
	## m0 = 1 - m1 - m2
	## m3 = (tg*b - b*g) / (2*b*r - b*g - g*r) ;
	## m5 = r*m3/b
	## m4 = 1 - m3 - m5
	## m6 = (tb*g - g*b) / (2*g*r - g*b - b*r)
	## m7 = m6*r/g
	## m8 = 1 - m6 - m7
	#############################################


	$r = hex(substr($from,0,2));
	$g = hex(substr($from,2,2));
	$b = hex(substr($from,4,2));
	$tr = hex(substr($to,0,2));
	$tg = hex(substr($to,2,2));
	$tb = hex(substr($to,4,2));

	$param = (2*$b*$g - $b*$r - $g*$r) ;
	if($param){
		$m1 = ($tr*$b - $b*$r) / $param ;
		$m2 = $g * $m1 / $b ;
	} else {
		$m1 = 0.5 ;
		$m1 = 0.5 ;
	}
	$m0 = 1 - $m1 - $m2 ;

	$param = (2*$b*$r - $b*$g - $g*$r) ;
	if($param){
		$m3 = ($tg*$b - $b*$g) / $param ;
		$m5 = $r*$m3/$b ;
	} else {
		$m3 = 0.5 ; 
		$m5 = 0.5 ;
	}
	$m4 = 1 - $m3 - $m5 ;

	$param = (2*$g*$r - $g*$b - $b*$r) ;
	if($param){
		$m6 = ($tb*$g - $g*$b) / $param ;
		$m7 = $m6*$r/$g ;
	} else {
		$m6 = 0.5 ;
		$m7 = 0.5 ;
	}
	$m8 = 1 - $m6 - $m7 ;

	$image->ColorMatrix([
		$m0,$m1,$m2,
		$m3,$m4,$m5,
		$m6,$m7,$m8
		]);
		


#	$image->ColorMatrix([
#		$m0,$m1,$m2,0,
#		$m3,$m4,$m5,0,
#		$m6,$m7,$m8,0,
#		0,0,0,1
#		]);

	$image->Set(depth=>24) ;
	$image->Write(sprintf('%s/%s',$saveDir,$fileName)) ;
}

