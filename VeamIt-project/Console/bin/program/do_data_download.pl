use Image::Magick;
use File::Basename;
use FindBin;

$programId = $ARGV[0] ;
$dataUrl = $ARGV[1] ;
$imageUrl = $ARGV[2] ;

chdir($FindBin::Bin) ;

$command = sprintf("rm -f program%s*.dat",$audioId) ;
print($command."\n") ;
`$command` ;

$sourceFileName = sprintf("program%s_SOURCE.dat",$programId) ;
$imageFileName = sprintf("program%s_IMAGE.dat",$programId) ;

print(sprintf("%s : %s\n",$sourceFileName,$url)) ;

$command = sprintf("wget %s -O %s",$dataUrl,$sourceFileName) ;
print($command."\n") ;
system($command) ;

$command = sprintf("wget %s -O %s",$imageUrl,$imageFileName) ;
print($command."\n") ;
system($command) ;

$outDir = sprintf("image%s",$programId) ;
mkdir($outDir) ;

cropImage($imageFileName,'SrcIn',120,$outDir."/i3.png") ;
cropImage($imageFileName,'SrcIn',320,$outDir."/i2.png") ;

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




