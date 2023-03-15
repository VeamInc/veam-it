use Image::Magick;
use File::Basename;
use FindBin;

$pdfId = $ARGV[0] ;
$imageUrl = $ARGV[1] ;

chdir($FindBin::Bin) ;

#$command = sprintf("rm -f image%s*.dat",$pdfId) ;
#print($command."\n") ;
#`$command` ;

$outDir = "encoded" ;

$imageFileName = sprintf("%s/pdf%s_IMAGE.dat",$outDir,$pdfId) ;

if($imageUrl){
	$command = sprintf("wget %s -O %s",$imageUrl,$imageFileName) ;
	print($command."\n") ;
	system($command) ;

	cropImage($imageFileName,'SrcIn',120,sprintf("%s/image%d.png",$outDir,$pdfId)) ;
	resizeImage($imageFileName,'SrcIn',120,sprintf("%s/image%d_16x9.jpg",$outDir,$pdfId)) ;
}

exit ;

sub cropImage
{
	($fileName,$compose,$size,$outPath) = @_ ;
	
	$fileName =~ /^(.*)\..+$/ ;
	$prefix = $1 ;

	my $image = Image::Magick->new();
	$image->ReadImage(sprintf("%s",$fileName));
	$image->Set(depth=>24) ;
	$width = $image->Get('width') ;
	$height = $image->Get('height') ;
	print("$width x $height\n") ;
	if($width > $height){
		$x = ($width - $height) / 2 ;
		$y = 0 ;
		$width = $height ;
	} else {
		$y = ($height - $width) / 2 ;
		$x = 0 ;
		$height = $width ;
	}
	$image->Crop(geometry=>sprintf('%dx%d+%d+%d',$width,$height,$x,$y));
	$image->Set(page=>'0x0+0+0');
	$image->Resize(width=>$size,height=>$size) ;
	$image->Set(depth=>24) ;

	my $maskImage = Image::Magick->new();
	$maskImage->ReadImage(sprintf("mask%d.png",$size));
	$maskImage->Set(depth=>24) ;
	$maskImage->Composite(image=>$image,compose=>$compose);
	$maskImage->Set(depth=>8) ;
	$maskImage->Set(quality=>93) ;
	$maskImage->write($outPath) ;

}

sub resizeImage
{
	($fileName,$compose,$size,$outPath) = @_ ;
	
	$fileName =~ /^(.*)\..+$/ ;
	$prefix = $1 ;
	
	my $baseImage = Image::Magick->new();
	$baseImage->ReadImage('base240x180.png');
	$targetWidth = $baseImage->Get('width') ;
	$targetHeight = $baseImage->Get('height') ;

	my $image = Image::Magick->new();
	$image->ReadImage(sprintf("%s",$fileName));
	$image->Set(depth=>24) ;
	$width = $image->Get('width') ;
	$height = $image->Get('height') ;
	#print("$width x $height\n") ;
	
	if($width / $height > $targetWidth / $targetHeight){
		$newWidth = $targetWidth ;
		$newHeight = $height * $targetWidth / $width ;
		$x = 0 ;
		$y = ($targetHeight - $newHeight) / 2 ;
	} else {
		$newWidth = $width * $targetHeight / $height ;
		$newHeight = $targetHeight ;
		$x = ($targetWidth - $newWidth) / 2 ;
		$y = 0 ;
	}
	
	#print("$newWidth x $newHeight\n") ;
	
	$image->Resize(width=>$newWidth,height=>$newHeight) ;
	
	$baseImage->Composite(image=>$image,compose=>$compose,x=>$x,y=>$y);
	$baseImage->write($outPath) ;
}



