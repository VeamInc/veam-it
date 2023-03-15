use Image::Magick;
use File::Basename;
use FindBin;
use LWP::Simple;

$appId = $ARGV[0] ;
$color = $ARGV[1] ;
$colorString = sprintf("#%s",$color) ;
$outputName = $ARGV[2] ;


chdir($FindBin::Bin) ;

our $sourceImageDir = 'ss_images' ;
our $appImageDir = sprintf("%s",$appId) ;
our $colorImageDir = sprintf("%s/%s",$appId,$color) ;
our $ssOutDir = sprintf("%s/%s",$appId,$outputName) ;

if(!-e $ssOutDir){
	mkdir($ssOutDir) ;
}


$shineFileName = 'shine.png' ;
$shine3iFileName = 'shine_3i.png' ;

%parts = () ;

if(open(CONFIGFILE,"<$appImageDir/ss_config.txt")){
	while(<CONFIGFILE>){
		if(/.+=.+/){
			chomp ;
			($name,$url) = split(/=/) ;
			$outFilePath = sprintf("%s/%s.png",$appImageDir,$name) ;
			print("$url\n") ;
			if($name eq 'FORUMS'){
				@forums = split(/\|/,$url) ;
			} elsif($name eq 'YOUTUBES'){
				@youtubes = split(/\|/,$url) ;
			} else {
				if(0){ # test
					$parts{$name} = $outFilePath ;
				} else {
					my $imageData = get($url) ;
					if(open(OUTFILE, ">$outFilePath")){
						binmode(OUTFILE) ;
						print(OUTFILE $imageData) ;
						close(OUTFILE) ;
						$parts{$name} = $outFilePath ;
					}
				}
			}
		}
	}
	close(CONFIGFILE) ;


	######### Screen Shot 1 ############	
	$fileName = 'ss1_base.png' ;
	$textFileName = 'ss1_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$outFileName = sprintf('%s_4inch_1.png',$outputName) ;
	if($parts{'SPLASH'}){
		my $image = Image::Magick->new();
		$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
		$image->ReadImage($filePath) ;
		$image->Set(depth=>24) ;

		my $textImage = Image::Magick->new() ;
		$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
		$textImage->ReadImage($textFilePath) ;
		$textImage->Set(depth=>24) ;
		
		my $splashImage = Image::Magick->new() ;
		$splashFilePath = sprintf("%s/SPLASH.png",$appImageDir) ;
		$splashImage->ReadImage($splashFilePath) ;
		$splashImage->Set(depth=>24) ;
		$splashImage->Resize(width=>353,height=>626) ;

		my $shineImage = Image::Magick->new() ;
		$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shineFileName) ;
		$shineImage->ReadImage($shineFilePath) ;
		$shineImage->Set(depth=>24) ;

		$image->Composite(image=>$textImage,compose=>'over');
		$image->Composite(image=>$splashImage,x=>144,y=>284,compose=>'over'); # 144,284
		$image->Composite(image=>$shineImage,compose=>'over');

		$image->Set(depth=>24) ;
		$image->Set(alpha=>'Off') ;
		$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;
	}
	
	## for 3.5 inch
	$fileName = 'ss1_3i_base.png' ;
	$textFileName = 'ss1_3i_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$outFileName = sprintf('%s_3inch_1.png',$outputName) ;
	if($parts{'SPLASH'}){
		my $image = Image::Magick->new();
		$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
		$image->ReadImage($filePath) ;
		$image->Set(depth=>24) ;

		my $textImage = Image::Magick->new() ;
		$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
		$textImage->ReadImage($textFilePath) ;
		$textImage->Set(depth=>24) ;
		
		my $splashImage = Image::Magick->new() ;
		$splashFilePath = sprintf("%s/SPLASH.png",$appImageDir) ;
		$splashImage->ReadImage($splashFilePath) ;
		$splashImage->Set(depth=>24) ;
		$splashImage->Resize(width=>304,height=>540) ;

		my $shineImage = Image::Magick->new() ;
		$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shine3iFileName) ;
		$shineImage->ReadImage($shineFilePath) ;
		$shineImage->Set(depth=>24) ;

		$image->Composite(image=>$textImage,compose=>'over');
		$image->Composite(image=>$splashImage,x=>165,y=>227,compose=>'over'); # 165,227
		$image->Composite(image=>$shineImage,compose=>'over');

		$image->Set(depth=>24) ;
		$image->Set(alpha=>'Off') ;
		$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;
	}
	
	
	
	
	######### Screen Shot 2 ############
	$fileName = 'ss2_base.png' ;
	$textFileName = 'ss2_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss2_screen.png' ;
	$outFileName = sprintf('%s_4inch_2.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	my $backgroundImage = Image::Magick->new() ;
	if($parts{'BACKGROUND'}){
		$backgroundFilePath = sprintf("%s/BACKGROUND.png",$appImageDir) ;
		$backgroundImage->ReadImage($backgroundFilePath) ;
	} else {
		$backgroundImage->Set(size=>'640x1136');
		$backgroundImage->ReadImage('xc:white'); # 白地キャンパスの読込み
	}
	$backgroundImage->Set(depth=>24) ;
	
	$yearImage = Image::Magick->new() ;
	$yearImage->ReadImage(sprintf("%s/ss2_part_year.png",$sourceImageDir)) ;
	$yearImage->Set(depth=>24) ;

	$titleImage = Image::Magick->new() ;
	$titleImage->ReadImage(sprintf("%s/ss2_part_title.png",$sourceImageDir)) ;
	$titleImage->Set(depth=>24) ;

	if($parts{'GRID1'}){
		$gridAudio1Image = Image::Magick->new() ;
		$gridAudio1Image->ReadImage(sprintf("%s/GRID1.png",$appImageDir)) ;
		$gridAudio1Image->Set(depth=>24) ;
	} else {
		$gridAudio1Image = Image::Magick->new() ;
		$gridAudio1Image->ReadImage(sprintf("%s/grid_audio.png",$sourceImageDir)) ;
		$gridAudio1Image->Set(depth=>24) ;
	}

	if($parts{'GRID2'}){
		$gridAudio2Image = Image::Magick->new() ;
		$gridAudio2Image->ReadImage(sprintf("%s/GRID2.png",$appImageDir)) ;
		$gridAudio2Image->Set(depth=>24) ;
	} else {
		$gridAudio2Image = Image::Magick->new() ;
		$gridAudio2Image->ReadImage(sprintf("%s/grid_audio.png",$sourceImageDir)) ;
		$gridAudio2Image->Set(depth=>24) ;
	}

	$gridBackImage = Image::Magick->new() ;
	$gridBackImage->ReadImage(sprintf("%s/grid_back.png",$sourceImageDir)) ;
	$gridBackImage->Set(depth=>24) ;

	my $screenImage = Image::Magick->new() ;
	$screenFilePath = sprintf("%s/%s",$sourceImageDir,$screenFileName) ;
	$screenImage->ReadImage($screenFilePath) ;
	$screenImage->Set(depth=>24) ;
	$x = 33 ;
	$y = 1037 ;
	$w = 94 ;
	$h = 15 ;
	$screenImage->Draw(primitive=>'rectangle', points=>sprintf('%d,%d %d,%d',$x,$y,$x+$w,$y+$h), fill=>$colorString) ;
	$screenImage->Draw(primitive=>'circle', points=>'98,216 38,216', fill=>$colorString, stroke=>$colorString, strokewidth=>0) ;
	$screenImage->Composite(image=>$yearImage,x=>48,y=>202,compose=>'over') ;
	$screenImage->Composite(image=>$titleImage,x=>212,y=>282,compose=>'over') ;
	$screenImage->Composite(image=>$gridAudio2Image,x=>190,y=>157,compose=>'over') ;
	$screenImage->Composite(image=>$gridAudio1Image,x=>338,y=>157,compose=>'over') ;
	$screenImage->Composite(image=>$gridBackImage,x=>486,y=>157,compose=>'over') ;
	for($x = 0 ; $x <= 3 ; $x++){
		$x0 = 38 + $x * 148 ;
		for($y = 0 ; $y <= 3 ; $y++){
			$y0 = 326 + $y * 175 ;
			$screenImage->Composite(image=>$gridBackImage,x=>$x0,y=>$y0,compose=>'over') ;
		}
	}
	
	#$screenImage->Annotate( text=>'Bonus Welcome', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>'black', pointsize=>'24', geometry=>'+0+14' );

	$backgroundImage->Composite(image=>$screenImage,compose=>'over');
	$backgroundImage->Resize(width=>353,height=>626) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shineFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$backgroundImage,x=>144,y=>284,compose=>'over'); # 144,284
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;


	## for 3.5 inch
	$fileName = 'ss2_3i_base.png' ;
	$textFileName = 'ss2_3i_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss2_screen.png' ;
	$outFileName = sprintf('%s_3inch_2.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	$backgroundImage->Resize(width=>304,height=>540) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shine3iFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$backgroundImage,x=>165,y=>227,compose=>'over'); # 165,227
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;






	######### Screen Shot 3 ############
	$fileName = 'ss3_base.png' ;
	$textFileName = 'ss3_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss3_screen.png' ;
	$outFileName = sprintf('%s_4inch_3.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	my $backgroundImage = Image::Magick->new() ;
	if($parts{'BACKGROUND'}){
		$backgroundFilePath = sprintf("%s/BACKGROUND.png",$appImageDir) ;
		$backgroundImage->ReadImage($backgroundFilePath) ;
	} else {
		$backgroundImage->Set(size=>'640x1136');
		$backgroundImage->ReadImage('xc:white'); # 白地キャンパスの読込み
	}
	$backgroundImage->Set(depth=>24) ;
	
	$sliderImage = Image::Magick->new() ;
	$sliderImage->ReadImage(sprintf("%s/ss3_part_slider.png",$sourceImageDir)) ;
	$sliderImage->Set(depth=>24) ;

	$pauseImage = Image::Magick->new() ;
	$pauseImage->ReadImage(sprintf("%s/p_pause.png",$sourceImageDir)) ;
	$pauseImage->Set(depth=>24) ;

	if($parts{'AUDIO1'}){
		$audioImage = Image::Magick->new() ;
		$audioImage->ReadImage(sprintf("%s/AUDIO1.png",$appImageDir)) ;
		$audioImage->Set(depth=>24) ;
	} else {
		$audioImage = Image::Magick->new() ;
		$audioImage->ReadImage(sprintf("%s/audio_thumbnail.png",$sourceImageDir)) ;
		$audioImage->Set(depth=>24) ;
	}

	$commentImage = Image::Magick->new() ;
	$commentImage->ReadImage(sprintf("%s/forum_comment_button.png",$sourceImageDir)) ;
	$commentImage->Set(depth=>24) ;

	$likeImage = Image::Magick->new() ;
	$likeImage->ReadImage(sprintf("%s/forum_like_button_on.png",$colorImageDir)) ;
	$likeImage->Set(depth=>24) ;

	$programLikeImage = Image::Magick->new() ;
	$programLikeImage->ReadImage(sprintf("%s/program_like.png",$colorImageDir)) ;
	$programLikeImage->Set(depth=>24) ;

	$programCommentImage = Image::Magick->new() ;
	$programCommentImage->ReadImage(sprintf("%s/program_comment.png",$colorImageDir)) ;
	$programCommentImage->Set(depth=>24) ;

	$expandCommentImage = Image::Magick->new() ;
	$expandCommentImage->ReadImage(sprintf("%s/expand_comment.png",$colorImageDir)) ;
	$expandCommentImage->Set(depth=>24) ;

	my $screenImage = Image::Magick->new() ;
	$screenFilePath = sprintf("%s/%s",$sourceImageDir,$screenFileName) ;
	$screenImage->ReadImage($screenFilePath) ;
	$screenImage->Set(depth=>24) ;

	$screenImage->Composite(image=>$sliderImage,x=>0,y=>879,compose=>'over') ;
	$screenImage->Composite(image=>$pauseImage,x=>282,y=>795,compose=>'over') ;
	$screenImage->Composite(image=>$audioImage,x=>158,y=>374,compose=>'over') ;
	$screenImage->Composite(image=>$likeImage,x=>20,y=>1035,compose=>'over') ;
	$screenImage->Composite(image=>$commentImage,x=>120,y=>1035,compose=>'over') ;
	$screenImage->Composite(image=>$programLikeImage,x=>437,y=>1076,compose=>'over') ;
	$screenImage->Composite(image=>$programCommentImage,x=>518,y=>1076,compose=>'over') ;
	$screenImage->Composite(image=>$expandCommentImage,x=>596,y=>1076,compose=>'over') ;

	$screenImage->Annotate( text=>'Message', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>'#333333', pointsize=>'36', geometry=>'+250+750' );
	$screenImage->Annotate( text=>'69', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>$colorString, pointsize=>'26', geometry=>'+477+1104' );
	$screenImage->Annotate( text=>'11', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>$colorString, pointsize=>'26', geometry=>'+558+1104' );

	$backgroundImage->Composite(image=>$screenImage,compose=>'over');
	$backgroundImage->Resize(width=>353,height=>626) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shineFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$backgroundImage,x=>144,y=>284,compose=>'over'); # 144,284
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;


	## for 3.5 inch
	$fileName = 'ss3_3i_base.png' ;
	$textFileName = 'ss3_3i_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss3_screen.png' ;
	$outFileName = sprintf('%s_3inch_3.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	$backgroundImage->Resize(width=>304,height=>540) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shine3iFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$backgroundImage,x=>165,y=>227,compose=>'over'); # 165,227
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;





	######### Screen Shot 4 ############
	$fileName = 'ss4_base.png' ;
	$textFileName = 'ss4_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss4_screen.png' ;
	$outFileName = sprintf('%s_4inch_4.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	my $backgroundImage = Image::Magick->new() ;
	if($parts{'BACKGROUND'}){
		$backgroundFilePath = sprintf("%s/BACKGROUND.png",$appImageDir) ;
		$backgroundImage->ReadImage($backgroundFilePath) ;
	} else {
		$backgroundImage->Set(size=>'640x1136');
		$backgroundImage->ReadImage('xc:white'); # 白地キャンパスの読込み
	}
	$backgroundImage->Set(depth=>24) ;
	
	$arrowImage = Image::Magick->new() ;
	$arrowImage->ReadImage(sprintf("%s/setting_arrow.png",$sourceImageDir)) ;
	$arrowImage->Set(depth=>24) ;

	$postsImage = Image::Magick->new() ;
	$postsImage->ReadImage(sprintf("%s/list_my_post.png",$colorImageDir)) ;
	$postsImage->Set(depth=>24) ;

	$favoritesImage = Image::Magick->new() ;
	$favoritesImage->ReadImage(sprintf("%s/list_clip.png",$colorImageDir)) ;
	$favoritesImage->Set(depth=>24) ;

	$followingImage = Image::Magick->new() ;
	$followingImage->ReadImage(sprintf("%s/list_following.png",$colorImageDir)) ;
	$followingImage->Set(depth=>24) ;

	$hotImage = Image::Magick->new() ;
	$hotImage->ReadImage(sprintf("%s/flame.png",$colorImageDir)) ;
	$hotImage->Set(depth=>24) ;


	my $screenImage = Image::Magick->new() ;
	$screenFilePath = sprintf("%s/%s",$sourceImageDir,$screenFileName) ;
	$screenImage->ReadImage($screenFilePath) ;
	$screenImage->Set(depth=>24) ;
	
	
	
#	$titleX = 32 ;
#	$point = 32 ;
#	
#	$index = 0 ; 
#	$titleY = 154 + $index * 88 ;
#	$lineY = 218 + $index * 88 ;
#	$screenImage->Annotate( text=>'My Posts', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>$colorString, pointsize=>$point, geometry=>sprintf('+%d+%d',$titleX,$titleY+$point) );
#	$screenImage->Composite(image=>$postsImage,x=>179,y=>$titleY-4,compose=>'over') ;
#	$screenImage->Composite(image=>$arrowImage,x=>597,y=>$titleY+8,compose=>'over') ;
#	$screenImage->Draw(primitive=>'line', points=>sprintf('20,%d 640,%d',$lineY,$lineY), stroke=>'#C5C5C5', strokewidth=>2) ;
#	
#	$index++ ;
#	$titleY = 154 + $index * 88 ;
#	$lineY = 218 + $index * 88 ;
#	$screenImage->Annotate( text=>'My Favorites', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>$colorString, pointsize=>$point, geometry=>sprintf('+%d+%d',$titleX,$titleY+$point) );
#	$screenImage->Composite(image=>$favoritesImage,x=>232,y=>$titleY-4,compose=>'over') ;
#	$screenImage->Composite(image=>$arrowImage,x=>597,y=>$titleY+8,compose=>'over') ;
#	$screenImage->Draw(primitive=>'line', points=>sprintf('20,%d 640,%d',$lineY,$lineY), stroke=>'#C5C5C5', strokewidth=>2) ;
#	
#	$index++ ;
#	$titleY = 154 + $index * 88 ;
#	$lineY = 218 + $index * 88 ;
#	$screenImage->Annotate( text=>'Following', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>$colorString, pointsize=>$point, geometry=>sprintf('+%d+%d',$titleX,$titleY+$point) );
#	$screenImage->Composite(image=>$followingImage,x=>183,y=>$titleY-4,compose=>'over') ;
#	$screenImage->Composite(image=>$arrowImage,x=>597,y=>$titleY+8,compose=>'over') ;
#	$screenImage->Draw(primitive=>'line', points=>sprintf('20,%d 640,%d',$lineY,$lineY), stroke=>'#C5C5C5', strokewidth=>2) ;
#	
#	$index++ ;
#	$titleY = 154 + $index * 88 ;
#	$lineY = 218 + $index * 88 ;
#	$screenImage->Annotate( text=>'Hot Topics', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>'#000000', pointsize=>$point, geometry=>sprintf('+%d+%d',$titleX,$titleY+$point) );
#	$screenImage->Composite(image=>$hotImage,x=>200,y=>$titleY-4,compose=>'over') ;
#	$screenImage->Composite(image=>$arrowImage,x=>597,y=>$titleY+8,compose=>'over') ;
#	$screenImage->Draw(primitive=>'line', points=>sprintf('20,%d 640,%d',$lineY,$lineY), stroke=>'#C5C5C5', strokewidth=>2) ;
#	
#	for(@forums){
#		$forumName = $_ ;
#		$index++ ;
#		$titleY = 154 + $index * 88 ;
#		$lineY = 218 + $index * 88 ;
#		$screenImage->Composite(image=>$arrowImage,x=>597,y=>$titleY+8,compose=>'over') ;
#		$screenImage->Annotate( text=>$forumName, font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>'#000000', pointsize=>$point, geometry=>sprintf('+%d+%d',$titleX,$titleY+$point) );
#		$screenImage->Draw(primitive=>'line', points=>sprintf('20,%d 640,%d',$lineY,$lineY), stroke=>'#C5C5C5', strokewidth=>2) ;
#		if($index >= 9){
#			goto OOL ;
#		}
#	}
OOL:

	$x = 353 ;
	$y = 1037 ;
	$w = 94 ;
	$h = 15 ;
	$screenImage->Draw(primitive=>'rectangle', points=>sprintf('%d,%d %d,%d',$x,$y,$x+$w,$y+$h), fill=>$colorString) ;


	$backgroundImage->Composite(image=>$screenImage,compose=>'over');
	$backgroundImage->Resize(width=>353,height=>626) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shineFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$backgroundImage,x=>144,y=>284,compose=>'over'); # 144,284
	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;


	## for 3.5 inch
	$fileName = 'ss4_3i_base.png' ;
	$textFileName = 'ss4_3i_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss4_screen.png' ;
	$outFileName = sprintf('%s_3inch_4.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	$backgroundImage->Resize(width=>304,height=>540) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shineFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$backgroundImage,x=>165,y=>227,compose=>'over'); # 165,227
	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;



	######### Screen Shot 5 ############
	$fileName = 'ss5_base.png' ;
	$textFileName = 'ss5_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss5_screen.png' ;
	$outFileName = sprintf('%s_4inch_5.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	my $backgroundImage = Image::Magick->new() ;
	if($parts{'BACKGROUND'}){
		$backgroundFilePath = sprintf("%s/BACKGROUND.png",$appImageDir) ;
		$backgroundImage->ReadImage($backgroundFilePath) ;
	} else {
		$backgroundImage->Set(size=>'640x1136');
		$backgroundImage->ReadImage('xc:white'); # 白地キャンパスの読込み
	}
	$backgroundImage->Set(depth=>24) ;
	
	$arrowImage = Image::Magick->new() ;
	$arrowImage->ReadImage(sprintf("%s/setting_arrow.png",$sourceImageDir)) ;
	$arrowImage->Set(depth=>24) ;

	$leftImage = Image::Magick->new() ;
	$leftImage->ReadImage(sprintf("%s/t1_top_left.png",$colorImageDir)) ;
	$leftImage->Set(depth=>24) ;

	$rightImage = Image::Magick->new() ;
	$rightImage->ReadImage(sprintf("%s/YOUTUBE_RIGHT.png",$appImageDir)) ;
	$rightImage->Set(depth=>24) ;
	$rightImage->Resize(width=>320,height=>320) ;



	$favoritesImage = Image::Magick->new() ;
	$favoritesImage->ReadImage(sprintf("%s/list_clip.png",$colorImageDir)) ;
	$favoritesImage->Set(depth=>24) ;

	my $screenImage = Image::Magick->new() ;
	$screenFilePath = sprintf("%s/%s",$sourceImageDir,$screenFileName) ;
	$screenImage->ReadImage($screenFilePath) ;
	$screenImage->Set(depth=>24) ;
	


	$screenImage->Composite(image=>$leftImage,x=>0,y=>131,compose=>'over') ;
	$screenImage->Composite(image=>$rightImage,x=>320,y=>131,compose=>'over') ;
	
	
	$titleX = 32 ;
	$point = 32 ;
	
#	$index = 0 ; 
#	$titleY = 480 + $index * 88 ;
#	$lineY = 551 + $index * 88 ;
#	$screenImage->Annotate( text=>'My Favorites', font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>$colorString, pointsize=>$point, geometry=>sprintf('+%d+%d',$titleX,$titleY+$point) );
#	$screenImage->Composite(image=>$favoritesImage,x=>232,y=>$titleY-4,compose=>'over') ;
#	$screenImage->Composite(image=>$arrowImage,x=>597,y=>$titleY+8,compose=>'over') ;
#	$screenImage->Draw(primitive=>'line', points=>sprintf('20,%d 640,%d',$lineY,$lineY), stroke=>'#C5C5C5', strokewidth=>2) ;
#
#	for(@youtubes){
#		$youtubeName = $_ ;
#		$index++ ;
#		$titleY = 480 + $index * 88 ;
#		$lineY = 551 + $index * 88 ;
#		$screenImage->Composite(image=>$arrowImage,x=>597,y=>$titleY+8,compose=>'over') ;
#		$screenImage->Annotate( text=>$youtubeName, font=>'/usr/share/doc/ImageMagick-perl-6.5.4.7/demo/Generic.ttf', fill=>'#000000', pointsize=>$point, geometry=>sprintf('+%d+%d',$titleX,$titleY+$point) );
#		$screenImage->Draw(primitive=>'line', points=>sprintf('20,%d 640,%d',$lineY,$lineY), stroke=>'#C5C5C5', strokewidth=>2) ;
#		if($index >= 5){
#			goto OOL2 ;
#		}
#	}
OOL2:

	$x = 193 ;
	$y = 1037 ;
	$w = 94 ;
	$h = 15 ;
	$screenImage->Draw(primitive=>'rectangle', points=>sprintf('%d,%d %d,%d',$x,$y,$x+$w,$y+$h), fill=>$colorString) ;


	$backgroundImage->Composite(image=>$screenImage,compose=>'over');
	$backgroundImage->Resize(width=>353,height=>626) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shineFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$backgroundImage,x=>144,y=>284,compose=>'over'); # 144,284
	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;


	# for 3.5 inch
	$fileName = 'ss5_3i_base.png' ;
	$textFileName = 'ss5_3i_text.png' ;
	if(!(-e sprintf("%s/%s",$appImageDir,$textFileName))){
		$textFileName = sprintf('../SSBASE_3DBCFF/%s',$textFileName) ;
	}
	$screenFileName = 'ss5_screen.png' ;
	$outFileName = sprintf('%s_3inch_5.png',$outputName) ;

	my $image = Image::Magick->new();
	$filePath = sprintf("%s/%s",$sourceImageDir,$fileName) ;
	$image->ReadImage($filePath) ;
	$image->Set(depth=>24) ;

	my $textImage = Image::Magick->new() ;
	$textFilePath = sprintf("%s/%s",$appImageDir,$textFileName) ;
	$textImage->ReadImage($textFilePath) ;
	$textImage->Set(depth=>24) ;
	
	$backgroundImage->Resize(width=>304,height=>540) ;

	my $shineImage = Image::Magick->new() ;
	$shineFilePath = sprintf("%s/%s",$sourceImageDir,$shineFileName) ;
	$shineImage->ReadImage($shineFilePath) ;
	$shineImage->Set(d2epth=>24) ;

	$image->Composite(image=>$backgroundImage,x=>165,y=>227,compose=>'over'); # 165,227
	$image->Composite(image=>$textImage,compose=>'over');
	$image->Composite(image=>$shineImage,compose=>'over');

	$image->Set(depth=>24) ;
	$image->Set(alpha=>'Off') ;
	$image->Write(sprintf("%s/%s",$ssOutDir,$outFileName)) ;




}


