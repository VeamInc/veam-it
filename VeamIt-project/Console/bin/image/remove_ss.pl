#
# perl remove_ss.pl 31001234
#   to remove 31001234
#
# perl remove_ss.pl 31001
#   to remove 31001*
#
use File::Path ;


$dirName = $ARGV[0] ;

if(!$dirName){
	die("usage : perl remove_ss.pl dirname\n") ;
}

if(opendir(CURDIR,".")){
	@list = sort(grep(/^$dirName/,readdir(CURDIR))) ;
	for(@list){
		if(-d){
			$targetDir = $_ ;
			print("$targetDir\n") ;
			operateOneDir($targetDir) ;
		}
	}
	closedir(CURDIR) ;
} else {
	die("open dir failed\n") ;
} 

exit ;


sub operateOneDir
{
	my($targetDirName) = @_ ;
	if(opendir(TARGETDIR,$targetDir)){
		@files = readdir(TARGETDIR) ;
		@ssDirs = grep(/^ss[0-9]{14}_[0-9]{4}$/,@files) ;
		for(@ssDirs){
			$ssDir = $_ ;
			print(" $ssDir\n") ;
			$ssDirPath = sprintf("%s/%s",$targetDir,$ssDir) ;
			if(opendir(SSDIR,$ssDirPath)){
				@ssFiles = grep(/^ss[0-9]{14}_[0-9]{4}_[0-9]inch_[0-9]\.png$/,readdir(SSDIR)) ;
				if(grep(/^ss[0-9]{14}_[0-9]{4}_[0-9]inch_1\.png$/,@ssFiles)){
					print("  skip\n") ;
				} else {
					for(@ssFiles){
						$ssFile = $_ ;
						$ssFilePath = sprintf("%s/%s/%s",$targetDir,$ssDir,$ssFile) ;
						print("  remove $ssFilePath\n") ;
						unlink($ssFilePath) ;
					}
				}
				closedir(SSDIR) ;
				
				

			} else {
				die("open dir failed : $ssDirPath\n") ;
			}


			if(opendir(SSDIR,$ssDirPath)){
				@restFiles = grep(/^[^\.]/,readdir(SSDIR)) ;
				closedir(SSDIR) ;
				if($#restFiles < 0){
					print("remove ssDir\n") ;
					rmdir($ssDirPath) ;
				}
			}



		}
		
		@colorDirs = grep(/^[0-9A-F]{6}$/,@files) ;
		if($#colorDirs == 0){
			if($colorDirs[0] eq '3DBCFF'){
				@removeFiles = (
					'ss1_3i_text.png',
					'ss1_text.png',
					'ss2_3i_text.png',
					'ss2_text.png',
					'ss3_3i_text.png',
					'ss3_text.png',
					'ss4_3i_text.png',
					'ss4_text.png',
					'ss5_3i_text.png',
					'ss5_text.png',
					'YOUTUBE_RIGHT.png',
				) ;
				for(@removeFiles){
					$removeFileName = $_ ;
					$removeFilePath = sprintf("%s/%s",$targetDir,$removeFileName) ;
					if(-e $removeFilePath){
						print("  remove $removeFilePath\n") ;
						unlink($removeFilePath) ;
					}
				}
			}
		} else {
			print("  new color exists " . $#colorDirs . "\n" ) ;
		}

		closedir(TARGETDIR) ;
	} else {
		die("open failed : $targetDirName\n") ;
	}

	$templateDir = sprintf("%s/31000000",$targetDir) ;
	if(-e $templateDir){
		print("remove $templateDir\n") ;
		rmtree($templateDir) ;
	}
}
