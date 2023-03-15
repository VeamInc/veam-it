<?php

class checkNewyoutubevideoTask extends sfBaseTask
{
	private $apiKey = '__YOUTUBE_API_KEY__' ;

  protected function configure()
  {
    // // add your own arguments here
    // $this->addArguments(array(
    //   new sfCommandArgument('my_arg', sfCommandArgument::REQUIRED, 'My argument'),
    // ));

    $this->addOptions(array(
      new sfCommandOption('application', null, sfCommandOption::PARAMETER_REQUIRED, 'The application name'),
      new sfCommandOption('env', null, sfCommandOption::PARAMETER_REQUIRED, 'The environment', 'dev'),
      new sfCommandOption('connection', null, sfCommandOption::PARAMETER_REQUIRED, 'The connection name', 'propel'),
      // add your own options here
      new sfCommandOption('command_id', null, sfCommandOption::PARAMETER_REQUIRED, 'Remote Command ID', 0),
    ));

    $this->namespace        = '';
    $this->name             = 'checkNewyoutubevideo';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [checkNewyoutubevideo|INFO] task does things.
Call it with:

  [php symfony checkNewyoutubevideo|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$libDir = sfConfig::get("sf_lib_dir") ; 
		preg_match('/console[^\/]*\.veam.co/',$libDir,$matches) ;
		$_SERVER['SERVER_NAME'] = $matches[0] ;
		$commandDir = sprintf("%s/../../bin/image",$libDir) ;

		$remoteCommandId = $options['command_id'] ;
		$remoteCommand = "" ;

		$targetAppId = 0 ;
		if($remoteCommandId){
			$c = new Criteria() ;
			$c->add(RemoteCommandPeer::ID,$remoteCommandId) ;
			$c->add(RemoteCommandPeer::STATUS,0) ;
			$remoteCommand = RemoteCommandPeer::doSelectOne($c) ;
			if($remoteCommand){
				$commandName = $remoteCommand->getName() ;
				$appId = $remoteCommand->getAppId() ;
				$targetAppId = $appId ;
				$retry = 0 ;
				do {
					if($retry > 0){
						sleep(5) ;
					}
				  	$c = new Criteria() ;
				  	$c->add(RemoteCommandPeer::APP_ID,$appId) ;
				  	$c->add(RemoteCommandPeer::NAME,$commandName) ;
				  	$c->add(RemoteCommandPeer::STATUS,3) ;
					$workingRemoteCommand = RemoteCommandPeer::doSelectOne($c) ;
					$retry++ ;
				} while($workingRemoteCommand && ($retry < 30)) ;

				if($workingRemoteCommand){
					ConsoleTools::assert(false,sprintf("remote command is still working commandname=%s id=%s appid=%s",$commandName,$remoteCommandId,$appId),__FILE__,__LINE__) ;
					return ;
				} else {
					$remoteCommand->setStatus(3) ; // executing
					$remoteCommand->save() ;

					$status = 1 ;
					$result = '' ;
				}
			}
		}



		//status 0:waiting 1:encoded 2:failed 3:skipped 4:encoding
		$c = new Criteria() ;
		if($targetAppId){
			$c->add(YoutubeUserPeer::APP_ID,$targetAppId) ;
		}
		$c->add(YoutubeUserPeer::NEW_VIDEO_CHECK,1) ;
		$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
		$youtubeUsers = YoutubeUserPeer::doSelect($c) ;
		if(count($youtubeUsers)> 0){
			foreach($youtubeUsers as $youtubeUser){
				$appId = $youtubeUser->getAppId() ;
				$app = AppPeer::RetrieveByPk($appId) ;
				if($app){
					if($app->getReleasedAt()){
						$this->operateOneApp($youtubeUser,$databaseManager) ;
					} else {
						print(sprintf("app %d is not released\n",$app->getId())) ;
					}
				}
			}
		} else {
			// 
			print("no user\n") ;
		}


		if($remoteCommand){
			$remoteCommand->setStatus($status) ; // executing
			$remoteCommand->setResult($result) ;
			$remoteCommand->save() ;
		}

	}




	private function categoryForPlaylistId($categories,$playlistId)
	{
		$retValue = false ;
		foreach($categories as $category){
			if($category->getYoutubePlaylistId() == $playlistId){
				$retValue = $category ;
				break ;
			}
		}
		return $retValue ;
	}


	private function youtubeVideoForCategoryIdAndVideoId($youtubeVideos,$categoryId,$videoId)
	{
		$retValue = false ;
		foreach($youtubeVideos as $youtubeVideo){
			if(($youtubeVideo->getCategoryId() == $categoryId) && ($youtubeVideo->getYoutubeCode() == $videoId)){
				$retValue = $youtubeVideo ;
				break ;
			}
		}
		return $retValue ;
	}


	private $myChannelIds ;

	private function validChannelId($channelId)
	{

//print("validChannelId $channelId\n") ;

		$retValue = false ;
		foreach($this->myChannelIds as $myChannelId){
			if($myChannelId == $channelId){
				$retValue = true ;
				break ;
			}
		}
		return $retValue ;
	}

	private function unsetYoutubeVideos($youtubeVideos,$videoId)
	{
		foreach($youtubeVideos as $key=>$youtubeVideo){
			if($youtubeVideo->getYoutubeCode() == $videoId){
				print("found unset : $key\n") ;
				unset($youtubeVideos[$key]) ;
			}
		}
	}


	private function setDurationAndDescription($youtubeVideos,$videoId,$duration,$description)
	{
		foreach($youtubeVideos as $key=>$youtubeVideo){
			if($youtubeVideo->getYoutubeCode() == $videoId){
				$youtubeVideo->setDuration($duration) ;
				$youtubeVideo->setDescription($this->escapeDescription($description)) ;
			}
		}
	}



	private function removeEmojis($string)
	{
		$stringWithoutEmoji = $string ;
		//$stringWithoutEmoji = preg_replace('/[\xF0-\xF7][\x80-\xBF][\x80-\xBF][\x80-\xBF]/', '', $string) ;
		//$stringWithoutEmoji = preg_replace('/[\xE2-\xEF][\x80-\xBF][\x80-\xBF]/', '', $stringWithoutEmoji) ;

		$stringWithoutEmoji = preg_replace('/[\xF0][\x9F][\x80-\x9B][\x80-\xBF]/', '', $stringWithoutEmoji) ;
		$stringWithoutEmoji = preg_replace('/[\xE2][\x81-\xAD][\x80-\xBF]/', '', $stringWithoutEmoji) ;
		$stringWithoutEmoji = preg_replace('/[\xE3][\x80][\xB0]/', '', $stringWithoutEmoji) ;
		$stringWithoutEmoji = preg_replace('/[\xE3][\x80][\xBD]/', '', $stringWithoutEmoji) ;
		$stringWithoutEmoji = preg_replace('/[\xE3][\x8A][\x97]/', '', $stringWithoutEmoji) ;
		$stringWithoutEmoji = preg_replace('/[\xE3][\x8A][\x99]/', '', $stringWithoutEmoji) ;
		$stringWithoutEmoji = preg_replace('/[\xEF][\xB8][\x8F]/', '', $stringWithoutEmoji) ;

		return $stringWithoutEmoji ;
	}

	private function escapeTitle($title)
	{

		$title = $this->removeEmojis($title) ;
		$title = str_replace('&','&amp;',$title) ;
		$title = str_replace('<','&lt;',$title) ;
		$title = str_replace('>','&gt;',$title) ;
		$title = str_replace('"','&quot;',$title) ;
		$title = str_replace("\n",'&#xa;',$title) ;

		$title = str_replace("á",'a',$title) ;
		$title = str_replace("í",'i',$title) ;
		$title = str_replace("ú",'u',$title) ;
		$title = str_replace("é",'e',$title) ;
		$title = str_replace("ó",'o',$title) ;

		// Estírate y Siéntete Mas Sexy para el Día de San Valentin con esta Rutina de Flexibilidad! 
		// Activa tus glúteos y muslos exteriores con este ejercicio rápido y eficaz. 
		// Motivación y Testimoniales

		return $title ;
	}
	
	private function escapeDescription($description)
	{
		$description = $this->removeEmojis($description) ;
		$description = str_replace('&','&amp;amp;',$description) ;
		$description = str_replace('<','&lt;',$description) ;
		$description = str_replace('>','&gt;',$description) ;
		$description = str_replace('"','&quot;',$description) ;
		$description = str_replace("\n",'&#xa;',$description) ;
		$description = str_replace("´","'",$description) ;

		$description = str_replace("á",'a',$description) ;
		$description = str_replace("í",'i',$description) ;
		$description = str_replace("ú",'u',$description) ;
		$description = str_replace("é",'e',$description) ;
		$description = str_replace("ó",'o',$description) ;

		return $description ;
	}
	
	private function getDurationInSec($durationString)
	{

		$totalSec = 0 ; 
		if(preg_match('/^PT([0-9]*?)M?([0-9]*)S?$/',$durationString,$matches)){
			$min = $matches[1] ;
			$sec = $matches[2] ;
			$totalSec = $min * 60 + $sec ;
		} else {
			$totalSec = 0 ; 
		}
	
		return $totalSec ;
	}


	public function getDurationAndDescription($videoId){
		$result = array() ;
		$url = sprintf("https://www.googleapis.com/youtube/v3/videos?key=%s&part=id,snippet,contentDetails&id=%s",$this->apiKey,$videoId) ;
		//print("url=$url\n") ;
		$json = file_get_contents($url,true) ;
		if(!$json){
			print("query failed\n");
			return;
		}
		$videoListResponse = json_decode($json) ;
		$videos = $videoListResponse->{'items'} ;
		$video = $videos[0] ;
		if($video){
			$durationString = $video->{'contentDetails'}->{'duration'} ;
		}

		$result['duration'] = $this->getDurationInSec($durationString) ;
		$result['description'] = $video->{'snippet'}->{'description'} ;
	
		return $result ;
	}



	public function getChannelIdFromUploadPlaylistId($uploadPlaylistId)
	{
		$channelId = '' ;

		$url = sprintf("https://www.googleapis.com/youtube/v3/playlistItems?key=%s&part=id,snippet,contentDetails,status&maxResults=1&playlistId=%s",$this->apiKey,$uploadPlaylistId) ;
		//print("url=$url\n") ;
		$json = file_get_contents($url,true) ;
		if(!$json){
			print("query failed\n");
			return '' ;
		}
		$playlistListResponse = json_decode($json) ;

		$videos = $playlistListResponse->{'items'} ;
		if(count($videos) > 0){
			$video = $videos[0] ;
			$channelId = $video->{'snippet'}->{'channelId'} ;
		}

		return $channelId ;
	}



	public function operateOneApp($youtubeUser,$databaseManager)
	{
		$appId = $youtubeUser->getAppId() ;
		print(sprintf("app : %s\n",$appId)) ;

		$newPeriod = 2 * 24 * 3600 ;
		$currentTime = time() ;
		$criteriaTime = $currentTime - $newPeriod ;

		$c = new Criteria() ;
		$c->add(CategoryPeer::APP_ID,$appId) ;
		$c->add(CategoryPeer::DISABLED,0) ;
		$c->add(CategoryPeer::NAME,"New Videos") ;
		$c->add(CategoryPeer::DEL_FLG,0) ;
		$category =  CategoryPeer::doSelectOne($c) ;
		if($category){
			$newVideoFound = false ;
			$videoAdded = false ;
			$newVideoId = '' ;

			$numberOfLatestVideos = 10 ;

			$playlistId = $category->getYoutubePlaylistId() ;
			$categoryId = $category->getId() ;

			$c = new Criteria() ;
			$c->add(YoutubeVideoPeer::APP_ID,$appId) ;
			$c->add(YoutubeVideoPeer::DEL_FLG,0) ;
			$c->add(YoutubeVideoPeer::CATEGORY_ID,$categoryId) ;
			$youtubeVideos = YoutubeVideoPeer::doSelect($c) ;

			print(sprintf("category %s %s : %s\n",$categoryId,$playlistId,$category->getName())) ;

			$channelId = $this->getChannelIdFromUploadPlaylistId($playlistId) ;
			if($channelId){
				$videos = array() ;
				$url = sprintf("https://www.googleapis.com/youtube/v3/search?key=%s&part=id,snippet&channelId=%s&maxResults=10&order=date&type=video",$this->apiKey,$channelId) ;
				print("url=$url\n") ;
				$json = file_get_contents($url,true) ;
				if(!$json){
					print("query failed\n");
					return;
				}
				$playlistListResponse = json_decode($json) ;

				$videos = $playlistListResponse->{'items'} ;

				foreach($videos as $video){
					if(isset($video->{'status'}->{'privacyStatus'})){
						$privacyStatus = $video->{'status'}->{'privacyStatus'} ;
					} else {
						$privacyStatus = 'public' ;
					}
					if($privacyStatus == 'public'){
						if(isset($video->{'snippet'}->{'resourceId'}->{'videoId'})){
							$videoId = $video->{'snippet'}->{'resourceId'}->{'videoId'} ;
						} else {
							$videoId = $video->{'id'}->{'videoId'} ;
						}

						$videoTitle = $video->{'snippet'}->{'title'} ;
						$publishedAt = $video->{'snippet'}->{'publishedAt'} ;
						$publishedAtInSec = strtotime($publishedAt) ;
						print(sprintf("    video : %s(%s) : %s : %s\n",$publishedAt,$publishedAtInSec,$videoId,$videoTitle)) ;
						$youtubeVideo = $this->youtubeVideoForCategoryIdAndVideoId($youtubeVideos,$categoryId,$videoId) ;
						if(!$youtubeVideo){
							$videoAdded = true ;
							if(!$newVideoFound){
								if($criteriaTime <= $publishedAtInSec){
									$newVideoFound = true ;
									$newVideoId = $videoId ;
									print("New Video Found +++++++++++++++++++++++\n") ;
								}
							}
							$info = $this->getDurationAndDescription($videoId) ;
							$youtubeVideo = new YoutubeVideo() ;
							$youtubeVideo->setAppId($appId) ;
							$youtubeVideo->setCategoryId($categoryId) ;
							$youtubeVideo->setSubCategoryId(0) ;
							$youtubeVideo->setDescription($this->escapeDescription($info['description'])) ;
							$youtubeVideo->setDuration($info['duration']) ;
							$youtubeVideo->setYoutubeCode($videoId) ;
						}
						$youtubeVideo->setTitle($this->escapeTitle($videoTitle)) ;

						$youtubeVideosToBeUpdated[] = $youtubeVideo ;
					}
				}


				if($videoAdded){
					$displayOrder = 1 ;
					print("--- youtubeVideos to be updated ---\n") ;
					foreach($youtubeVideosToBeUpdated as $youtubeVideo){
						print(sprintf("- %s : %s : %s\n",$youtubeVideo->getCategoryId(),$youtubeVideo->getTitle(),$youtubeVideo->getYoutubeCode())) ;
						$youtubeVideo->setDisplayOrder($displayOrder++) ;
						$youtubeVideo->save() ;
					}

					if($_SERVER['SERVER_NAME'] == 'console-work.veam.co'){
						print("env : work skip deploy\n") ;
					} else {
						//print("not skipped : ". $_SERVER['SERVER_NAME']."\n") ;
						AdminTools::deployAppYoutubeContents($appId,$databaseManager) ;
						ConsoleTools::consoleContentsChanged($appId) ;
					}

					if($newVideoFound){

						$lastNotifiedAt = $youtubeUser->getNewVideoNotifiedAt() ;
						$lastNotificationTime = 0 ; 
						if($lastNotifiedAt){
							$lastNotificationTime = strtotime($lastNotifiedAt) ;
						}
						$notificationCriteriaTime = time() - (24 * 3600) ;  // 24 hours ago
						if($lastNotificationTime < $notificationCriteriaTime){
							$youtubeUser->setNewVideoNotifiedAt(date("Y-m-d H:i:s")) ;
							$youtubeUser->save() ;
							// set broadcast notification
							$commandLine = sprintf("php /data/console/console.veam.co/site/symfony setBroadcastnotification --app_id=%d --message=\"Watch the new video by tapping 'New Videos' in the YouTube section!\" --badge=0 > /dev/null",$appId) ;
							exec($commandLine) ;

							//// MAIL
							$subject = sprintf("[VEAM_CONSOLE] NEW YOUTUBE VIDEO %s",$appId) ;
							$body = sprintf("https://www.youtube.com/watch?v=%s\n",$newVideoId) ;
							$to = 'tech@veam.co' ;
							ConsoleTools::sendInfoMail($subject,$to,$body) ;
							///////////////
						}
					}
				}

				print("------\n") ;
			} else {
				$subject = sprintf("[VEAM_CONSOLE] ChannelId not found %s",$appId) ;
				$body = sprintf("Could not extract ChannelId for playlistId=%s categoryId=%s",$playlistId,$categoryId) ;
				$to = 'tech@veam.co' ;
				ConsoleTools::sendInfoMail($subject,$to,$body) ;
			}

		} else {
			$subject = sprintf("[VEAM_CONSOLE] New Videos Category not found %s",$appId) ;
			$body = sprintf("Please enable 'New Videos' category or disable new video check for %s",$appId) ;
			$to = 'tech@veam.co' ;
			ConsoleTools::sendInfoMail($subject,$to,$body) ;
		}

	}
}

