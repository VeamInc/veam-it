use File::Basename;
use FindBin;

$audioId = $ARGV[0] ;
$url = $ARGV[1] ;

chdir($FindBin::Bin) ;

$command = sprintf("rm -f a%s*.dat",$audioId) ;
print($command."\n") ;
`$command` ;

$sourceFileName = sprintf("a%s_SOURCE.dat",$audioId) ;

print(sprintf("%s : %s\n",$sourceFileName,$url)) ;

$command = sprintf("wget %s -O %s",$url,$sourceFileName) ;
print($command."\n") ;
system($command) ;

