
use FindBin;
chdir($FindBin::Bin) ;

($sec,$min,$hour,$mday,$month,$year,$wday,$stime) = localtime(time) ;

our $textlineId = $ARGV[0] ;
our $textlinePackageId = $ARGV[1] ;
our $dest = $ARGV[2] ;
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

$tableName = 'textline' ;

@targetTables = (
	'textline',
) ;

if($textlineId && $dest){
	$tableList = join(' ',@targetTables) ;
	$backupFile = sprintf('backup/%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$year+1900,$month+1,$mday,$hour,$min,$sec) ;
	$sqlFile = sprintf('sql/%s_%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$textlineId,$year+1900,$month+1,$mday,$hour,$min,$sec) ;

	# backup toDb
	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ -t --opt %s %s > %s',$toDb,$toPass,$toDb,$tableList,$backupFile) ;
	$result = `$command` ;



	#print(sprintf("table=%s\n",$tableName)) ;

	$sql .= sprintf("DELETE FROM `%s` WHERE `id` = %s;\n",$tableName,$textlineId) ;

	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ -t --opt %s %s "-wid=%s"',$fromDb,$fromPass,$fromDb,$tableName,$textlineId) ;
	$result = `$command` ;
	#$result =~ s/--.*?\n//g ;
	$result =~ s/\/\*.*?\*\///g ;
	@lines = split(/\n/,$result) ;
	for(@lines){
		$line = $_ ;
		if(!/^;?$/){
			if(!($line =~ /^--/)){
				if(/INSERT INTO `.*?` VALUES \(([0-9]*?),/){
					$targetId = $1 ;
					if(@matches = $line =~ /\),\(([0-9]*?),/g){
						for(@matches){
							$targetId = $_ ;
							#print("+++ $targetId\n") ;
						}
					}
				}
				$sql .= sprintf("%s\n",$line) ;
			}
		}
	}
	


	

	if(open(OUTFILE,">$sqlFile")){
		print(OUTFILE $sql) ;
		close(OUTFILE) ;

		$command = sprintf('mysql -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=utf8 %s < %s',$toDb,$toPass,$toDb,$sqlFile) ;
		#print("\n\n".$command."\n\n") ;
		$result = `$command` ;
	}
}




$sql = '' ;

$tableName = 'textline_package' ;

@targetTables = (
	'textline_package',
) ;

if($textlinePackageId && $dest){
	$tableList = join(' ',@targetTables) ;
	$backupFile = sprintf('backup/%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$year+1900,$month+1,$mday,$hour,$min,$sec) ;
	$sqlFile = sprintf('sql/%s_%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$textlinePackageId,$year+1900,$month+1,$mday,$hour,$min,$sec) ;

	# backup toDb
	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ -t --opt %s %s > %s',$toDb,$toPass,$toDb,$tableList,$backupFile) ;
	$result = `$command` ;



	#print(sprintf("table=%s\n",$tableName)) ;

	$sql .= sprintf("DELETE FROM `%s` WHERE `id` = %s;\n",$tableName,$textlinePackageId) ;

	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ -t --opt %s %s "-wid=%s"',$fromDb,$fromPass,$fromDb,$tableName,$textlinePackageId) ;
	$result = `$command` ;
	#$result =~ s/--.*?\n//g ;
	$result =~ s/\/\*.*?\*\///g ;
	@lines = split(/\n/,$result) ;
	for(@lines){
		$line = $_ ;
		if(!/^;?$/){
			if(!($line =~ /^--/)){
				if(/INSERT INTO `.*?` VALUES \(([0-9]*?),/){
					$targetId = $1 ;
					if(@matches = $line =~ /\),\(([0-9]*?),/g){
						for(@matches){
							$targetId = $_ ;
							#print("+++ $targetId\n") ;
						}
					}
				}
				$sql .= sprintf("%s\n",$line) ;
			}
		}
	}
	


	

	if(open(OUTFILE,">$sqlFile")){
		print(OUTFILE $sql) ;
		close(OUTFILE) ;

		$command = sprintf('mysql -u %s -p%s -h __DB_HOST_NAME__ %s < %s',$toDb,$toPass,$toDb,$sqlFile) ;
		#print("\n\n".$command."\n\n") ;
		$result = `$command` ;
	}
}


exit(0) ;

