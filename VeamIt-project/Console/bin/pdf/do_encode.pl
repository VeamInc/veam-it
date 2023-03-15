use File::Basename;
use FindBin;

$pdfId = $ARGV[0] ;
$url = $ARGV[1] ;

chdir($FindBin::Bin) ;

$command = sprintf("rm -f encoded/p%s.pdf",$pdfId) ;
print($command."\n") ;
`$command` ;

$sourceFileName = sprintf("encoded/p%s.pdf",$pdfId) ;
print(sprintf("%s : %s\n",$sourceFileName,$url)) ;
$command = sprintf("wget %s -O %s",$url,$sourceFileName) ;
print($command."\n") ;
system($command) ;

