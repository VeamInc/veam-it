
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

@targetTables = (
	'template_subscription',
	'template_youtube',
	'template_forum',
	'template_mixed',
	'template_web',
	'alternative_image',
	'app_color',
	'app_data',
	'blog_post',
	'calendar_day',
	'calendar_month',
	'category',
	'forum',
	'mixed',
	'mixed_category',
	'mixed_sub_category',
	'recipe',
	'sub_category',
	'sell_video',
	'video',
	'video_category',
	'video_sub_category',
	'audio',
	'audio_category',
	'audio_sub_category',
	'sell_audio',
	'web',
	'web_category',
	'sell_item_category',
	'pdf_category',
	'pdf',
	'pdf_sub_category',
	'sell_pdf',
	'sell_section_category',
	'sell_section_item',
	'youtube_video',
) ;

if(length($appId) == 8){
	$tableList = join(' ',@targetTables) ;
	$backupFile = sprintf('backup/%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$year+1900,$month+1,$mday,$hour,$min,$sec) ;
	$sqlFile = sprintf('sql/%s_%s_%04d%02d%02d%02d%02d%02d.txt',$toDb,$appId,$year+1900,$month+1,$mday,$hour,$min,$sec) ;

	# backup toDb
	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=binary -t --opt %s %s > %s',$toDb,$toPass,$toDb,$tableList,$backupFile) ;
	#$result = `$command` ;

	for(@targetTables){
		operateOneTable($_) ;
	}
	
	if(open(OUTFILE,">$sqlFile")){
		print(OUTFILE $sql) ;
		close(OUTFILE) ;

		$command = sprintf('mysql -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=binary %s < %s',$toDb,$toPass,$toDb,$sqlFile) ;
		#print("\n\n".$command."\n\n") ;
		$result = `$command` ;
		print("1\n") ;
	}
}

exit(0) ;

sub operateOneTable
{
	($tableName) = @_ ;
	
	#print(sprintf("table=%s\n",$tableName)) ;

	@targetIds = () ;
	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=binary -t --opt %s %s "-wapp_id<>%s"',$toDb,$toPass,$toDb,$tableName,$appId) ;
	$result = `$command` ;
	#$result =~ s/--.*?\n//g ;
	$result =~ s/\/\*.*?\*\///g ;
	@unexpectedIds = () ;
	@lines = split(/\n/,$result) ;
	for(@lines){
		$line = $_ ;
		if(!($line =~ /^;?$/)){
			if(!($line =~ /^--/)){
				if($line =~ /INSERT INTO `.*?` VALUES \(([0-9]*?),/){
					#print("$line\n") ;
					$unexpectedId = $1 ;
					push(@unexpectedIds,$unexpectedId) ;
					if(@matches = $line =~ /\),\(([0-9]*?),/g){
						for(@matches){
							$unexpectedId = $_ ;
							#print("--- $unexpectedId\n") ;
							push(@unexpectedIds,$unexpectedId) ;
						}
					}
				}
				#print("$line\n") ;
			}
		}
	}
	$sql .= sprintf("DELETE FROM `%s` WHERE `app_id` = %s;\n",$tableName,$appId) ;

	@targetIds = () ;
	if(($tableName eq 'sell_video') || ($tableName eq 'sell_pdf') || ($tableName eq 'sell_section_item') || ($tableName eq 'sell_audio')){
		$where = sprintf('-wapp_id=%s and status=0',$appId) ;
	} else {
		$where = sprintf('-wapp_id=%s',$appId) ;
	}

	$command = sprintf('mysqldump -u %s -p%s -h __DB_HOST_NAME__ --default-character-set=binary -t --opt %s %s "%s"',$fromDb,$fromPass,$fromDb,$tableName,$where) ;
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
					push(@targetIds,$targetId) ;
					if(@matches = $line =~ /\),\(([0-9]*?),/g){
						for(@matches){
							$targetId = $_ ;
							#print("+++ $targetId\n") ;
							push(@targetIds,$targetId) ;
						}
					}
				}
				$sql .= sprintf("%s\n",$line) ;
			}
		}
	}
	
	# check if illegal value
	for(@targetIds){
		$targetId = $_ ;
		#print(sprintf("targetId %s\n",$targetId)) ;
		for(@unexpectedIds){
			$unexpectedId = $_ ;
			#print(sprintf("check %s,%s\n",$targetId,$unexpectedId)) ;
			if($targetId == $unexpectedId){
				print(sprintf("different app id - table=%s id=%s \n",$tableName,$targetId)) ;
				exit(1) ;
			}
		}
	}
}

