
use FindBin;
chdir($FindBin::Bin) ;

($sec,$min,$hour,$mday,$month,$year,$wday,$stime) = localtime(time) ;

our $appId = $ARGV[0] ;

if($appId < 31000019){
	die("$appId not supported\n") ;
}


our $dest = $ARGV[1] ;
our $fromDb = 'veam_preview' ;
our $fromPass = '__PREVIEW_DB_PASSWORD__' ;
our $toDb = '' ;
our $toPass = '' ;
if($dest eq 'public'){
	$toDb = 'veam_public' ;
	$toPass = '__PUBLIC_DB_PASSWORD__' ;
} else {
	$toDb = 'veam_work' ;
	$toPass = '__WORK_DB_PASSWORD__' ;
}
our $sql = '' ;

if(length($appId) == 8){
	$backupFile = sprintf('backup/%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$year+1900,$month+1,$mday,$hour,$min,$sec) ;
	$sqlFile = sprintf('sql/%s_%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$appId,$year+1900,$month+1,$mday,$hour,$min,$sec) ;

	# backup toDb
	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=binary -t --opt %s app > %s',$toDb,$toPass,$toDb,$backupFile) ;
	#$result = `$command` ;


	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=binary -t --opt %s app "-wid=%s"',$fromDb,$fromPass,$fromDb,$appId) ;
	$result = `$command` ;
	#$result =~ s/--.*?\n//g ;
	$result =~ s/\/\*.*?\*\///g ;
	@lines = split(/\n/,$result) ;
	for(@lines){
		$line = $_ ;
		if(!/^;?$/){
			if(!($line =~ /^--/)){
				if(/INSERT INTO `app` VALUES \(([0-9]*?),/){
					$line =~ s/INSERT INTO/REPLACE INTO/ ;
					$sql .= sprintf("%s\n",$line) ;
				}
			}
		}
	}

	if($sql){
		if(open(OUTFILE,">$sqlFile")){
			print(OUTFILE $sql) ;
			close(OUTFILE) ;

			$command = sprintf('mysql -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=binary %s < %s',$toDb,$toPass,$toDb,$sqlFile) ;
			#print("\n\n".$command."\n\n") ;
			$result = `$command` ;
			print("1\n") ;
		} else {
			print("out file open failed\n") ;
			exit(1) ;
		}
	} else {
		print("no sql\n") ;
		exit(1) ;
	}
} else {
	print("invalid app id\n") ;
	exit(1) ;
}

exit(0) ;

