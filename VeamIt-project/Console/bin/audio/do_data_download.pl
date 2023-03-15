use Image::Magick;
use File::Basename;
use FindBin;

$audioId = $ARGV[0] ;
$mixedId = $ARGV[1] ;
$dataUrl = $ARGV[2] ;
$imageUrl = $ARGV[3] ;
$linkDataSourceUrl = $ARGV[4] ;

chdir($FindBin::Bin) ;

$command = sprintf("rm -f audio%s*.dat",$audioId) ;
print($command."\n") ;
`$command` ;

$sourceFileName = sprintf("audio%s_SOURCE.dat",$audioId) ;
$linkDataSourceFileName = sprintf("audio%s_LINK.dat",$audioId) ;
$imageFileName = sprintf("audio%s_IMAGE.dat",$audioId) ;
$infoFileName = sprintf("audio%s_INFO.txt",$audioId) ;

print(sprintf("%s : %s\n",$sourceFileName,$url)) ;

if($linkDataSourceUrl){
	$command = sprintf('wget "%s" -O %s',$linkDataSourceUrl,$linkDataSourceFileName) ;
	print($command."\n") ;
	system($command) ;
}

$command = sprintf("wget %s -O %s",$dataUrl,$sourceFileName) ;
print($command."\n") ;
system($command) ;


$command = sprintf("ffmpeg -i %s 2>&1",$sourceFileName) ;
$result = `$command` ;
#print("output=$result\n\n") ;
if($result =~ /Audio: aac,/i){
	$m4aFileName = sprintf("audio%s_SOURCE.m4a",$audioId) ;
	$command = sprintf("ffmpeg -i %s -c:a aac -strict -2 %s",$sourceFileName,$m4aFileName) ;
	$result = `$command` ;

	$command = sprintf("ffmpeg -i %s 2>&1",$m4aFileName) ;
	$result = `$command` ;
	
	unlink($m4aFileName) ;
}

if(open(INFOFILE,">$infoFileName")){
	print(INFOFILE $result) ;
	close(INFOFILE) ;
}


if($imageUrl){
	$command = sprintf("wget %s -O %s",$imageUrl,$imageFileName) ;
	print($command."\n") ;
	system($command) ;

	$outDir = sprintf("image%s",$audioId) ;
	mkdir($outDir) ;

	cropImage($imageFileName,'SrcIn',120,$outDir."/i3.png") ;
	cropImage($imageFileName,'SrcIn',320,$outDir."/i2.png") ;
	resizeImage($imageFileName,'SrcIn',120,sprintf("%s/i4.jpg",$outDir)) ;
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




