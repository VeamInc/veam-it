use File::Basename;
use FindBin;

$videoId = $ARGV[0] ;
$url = $ARGV[1] ;

chdir($FindBin::Bin) ;

$command = sprintf("rm -f encoded/p%s_*",$videoId) ;
print($command."\n") ;
`$command` ;

$command = sprintf("rm -f p*_SOURCE.dat",$videoId) ;
print($command."\n") ;
`$command` ;

$sourceFileName = sprintf("p%s_SOURCE.dat",$videoId) ;

print(sprintf("%s : %s\n",$sourceFileName,$url)) ;

if($url =~ /^[0-9]/){
	if($url =~ /sa/){ #android
		$android = 1 ;
	} else {
		$android = 0 ;
	}
	rename($url,$sourceFileName) ;
	$crop = 1 ;
} else {
	$crop = 0 ;
	$command = sprintf("wget %s -O %s",$url,$sourceFileName) ;
	print($command."\n") ;
	system($command) ;
}

if($crop){
	$command = sprintf("perl encode_video_crop_qmax37.pl %d",$android) ;
} else {
	$command = sprintf("perl encode_video_qmax37.pl") ;
}
print($command."\n") ;
system($command) ;

mkdir(sprintf('thumbnails/%s',$videoId)) ;
$command = sprintf('ffmpeg -i %s -y -r 0.05 -vf "scale=240:135,pad=0:180:0:22:black" -s 240x180 "thumbnails/%s/t_%%03d.jpg"',$sourceFileName,$videoId) ;
print($command."\n") ;
system($command) ;

