
if(opendir(CURDIR,".")){
	@files = grep(/[pv][0-9]{8}_SOURCE\..+$/,readdir(CURDIR)) ;
	for(@files){
	
		$fps = 0 ;
		$width = 0 ;
		$heigh = 0 ; 
		$padding = "" ;

		$fileName = $_ ;
		/([pv][0-9]{8})/ ;
		$encodedFilePrefix = $1 ;
		
		print("$fileName -> $encodedFilePrefix\n") ;
#		print("++++++++++++++++++ fps = %s\n",$fps) ;
		
		#$command = sprintf("/usr/bin/ffmpeg -i %s 2>&1",$fileName) ;
		$command = sprintf("ffmpeg -i %s 2>&1",$fileName) ;
		$result = `$command` ;
		print("output=$result\n\n") ;

		if($result =~ /([0-9\.]+)\s*fps/i){
			$fps = $1 ;
		}
		
		if(!$fps){
			if($result =~ /([0-9\.]+)\s*tbr/i){
				$fps = $1 ;
			}
		}

		if($result =~ /\s+([0-9]+)x([0-9]+)\s+/i){
			$width = $1 ;
			$height = $2 ;
			
			if($result =~ /\[SAR 4:3 DAR 16:9\]/){
				$width = $width * 16 / 12 ;
			}
		}
		
		if($result =~ /\s*rotate\s*:\s*180/i){
			$rotateOption = ' -vf "hflip,vflip" -metadata:s:v:0 rotate=0 ' ;
		}
		
		$compValue = ($height * 16) / 9 ;
		
		
		$newWidth = 854 ;
		$newHeight = 480 ;
		if($compValue == $width){
			print(sprintf("width=%s height=%s fps=%s\n",$width,$height,$fps)) ;
		} else {
			if($compValue > $width){
				$padding = sprintf("-vf pad=%d:%d:%d:0:black ",$compValue,$height,int(($compValue-$width)/2)) ;

				#$workWidth = $width * 480 / $height ;
				#$pad = int((854 - $workWidth) / 2) ;
				#if($pad > 0){
				#	if($pad % 2){
				#		$padLeft = $pad ;
				#		$padRight = $pad ;
				#	} else {
				#		$padLeft = $pad + 1 ;
				#		$padRight = $pad - 1 ;
				#	}
				#	$padding = sprintf("-padleft %d -padright %d ",$padLeft,$padRight) ;
				#	$newWidth = 854 - $padLeft - $padRight ;
				#}
			} else {
				$padding = sprintf("-vf pad=%d:%d:0:%d:black ",$width,int($width*9/16),int(($width*9/16-$height)/2)) ;
				
				#$workHeight = $height * 854 / $width ;
				#$pad = int((480 - $workHeight) / 2) ;
				#if($pad > 0){
				#	if($pad % 2){
				#		$padTop = $pad ;
				#		$padBottom = $pad ;
				#	} else {
				#		$padTop = $pad + 1 ;
				#		$padBottom = $pad - 1 ;
				#	}
				#	$padding = sprintf("-padtop %d -padbottom %d ",$padTop,$padBottom) ;
				#	$newHeight = 480 - $padTop - $padBottom ;
				#}
			}
			print(sprintf("not 16:9 width=%s height=%s fps=%s\n",$width,$height,$fps)) ;
		}
		
		$command = sprintf("ffmpeg -y -i %s %s -vcodec libx264 -b 256k -bt 256k -g 33 -qscale 1 -qmin 2 -qmax 37 -qcomp 0.7 -qdiff 4 -subq 6 -me_range 16 -i_qfactor 0.714286 -aspect 16:9 -s %dx%d %s -r %s -an %s.m4v",$fileName,$rotateOption,$newWidth,$newHeight,$padding,$fps,$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("ffmpeg -y -i %s -vn -ar 48000 %s.wav",$fileName,$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("faac -b 96 --mpeg-vers 4 -o %s.aac %s.wav",$encodedFilePrefix,$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf('MP4Box -add "%s.m4v"#video -add "%s.aac"#audio -brand mmp4:1  -new "%s.mp4"',$encodedFilePrefix,$encodedFilePrefix,$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("java -jar ./AESEncrypter.jar %s.mp4",$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("rm %s.wav",$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("rm %s.aac",$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("rm %s.m4v",$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		
		$command = sprintf("mv -f %s.mp4.KEY encoded",$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("mv -f %s.mp4.AES encoded",$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;
		$command = sprintf("mv -f %s.mp4 encoded",$encodedFilePrefix) ;
		print($command."\n") ;
		`$command` ;

	}
	closedir(CURDIR) ;
} else {
	die("open failed current dir") ;
}

