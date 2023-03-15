<?php

class createAppforyoutubechannelTask extends sfBaseTask
{

	private $myChannelIds ;

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
      new sfCommandOption('channel_id', null, sfCommandOption::PARAMETER_REQUIRED, 'Youtube Channel ID', 0),
      new sfCommandOption('color_id', null, sfCommandOption::PARAMETER_REQUIRED, 'Color ID', 0),
      new sfCommandOption('icon_url', null, sfCommandOption::PARAMETER_REQUIRED, 'Icon Image File URL', 0),
    ));

    $this->namespace        = '';
    $this->name             = 'createAppforyoutubechannel';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [createAppforyoutubechannel|INFO] task does things.
Call it with:

  [php symfony createAppforyoutubechannel|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$libDir = sfConfig::get("sf_lib_dir") ; 
		preg_match('/console.*\.veam.co/',$libDir,$matches) ;
		$_SERVER['SERVER_NAME'] = $matches[0] ;
		$commandDir = sprintf("%s/../../bin/image",$libDir) ;

		$youtubeChannelId = $options['channel_id'] ;
		$colorId = $options['color_id'] ;
		$iconUrl = $options['icon_url'] ;







		$c = new Criteria() ;
	  	$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
	  	$c->add(YoutubeUserPeer::NAME,$youtubeChannelId) ;
		$youtubeUser = YoutubeUserPeer::doSelectOne($c) ;
		if(!$youtubeUser){
			$channels = $this->getYoutubeChannels($youtubeChannelId) ;
			if(count($channels) > 0){
				$item = $channels[0] ;
				$channelName = $item->{'snippet'}->{'title'} ;

				if(isset($item->{'snippet'}->{'country'})){
					$country = $item->{'snippet'}->{'country'} ;
				} else {
					$country = '' ;
				}

				if($country == 'JP'){
					$language = 'ja' ;
				} else {
					$language = 'en' ;
				}

				$app = new App() ;
				$app->setName($channelName) ;
				$app->setStoreAppName($channelName) ;
				$app->setDescription('') ;
				$app->setStatus(4) ; // 4:Initialized
				$app->setMcnId(1) ; // Veam
				$app->setCurrentProcess(10100) ; 
				$app->save() ;

				$appId = $app->getId() ;

				$youtubeUser = new YoutubeUser() ;
				$youtubeUser->setAppId($appId) ;
				$youtubeUser->setAutoList(1) ;
				$youtubeUser->setName($youtubeChannelId) ;
				$youtubeUser->save() ;

				//print("item count = ".count($channels)) ;

				$appCreatorName = sprintf("y%04d@veam.co",substr($appId,2)) ;
				$alpha = 'acdefghijkmnprstuvwxyz' ;
				$appCreatorPassword = substr($alpha,rand(0,strlen($alpha)-1),1) . substr($alpha,rand(0,strlen($alpha)-1),1) . sprintf("%05d",rand(10000,99999)) ;
				$firstName = $channelName ;
				$lastName = '' ;

				$appCreator = new AppCreator() ;
				$appCreator->setAppId($appId) ;
				$appCreator->setUserName($appCreatorName) ;
				$appCreator->setFirstName($firstName) ;
				$appCreator->setLastName($lastName) ;
				$appCreator->setPassword(strtolower(sha1($appCreatorPassword))) ;
				$appCreator->save() ;

				$creatorNotificationAddress = new CreatorNotificationAddress() ;
				$creatorNotificationAddress->setAppId($appId) ;
				$creatorNotificationAddress->setEmail($appCreatorName) ;
				$creatorNotificationAddress->setKind(65535) ;
				$creatorNotificationAddress->save() ;

				// create youtube list
				$this->createYoutubeList($youtubeUser) ;

				AdminTools::setAppDefaultValues($appId,$language,$databaseManager) ;

				// �A�C�R���摜���Z�b�g
				$imageUrls = $this->uploadIconPNGFileToS3($appId,$iconUrl) ;
				if(count($imageUrls) > 1){
					$app->setIconImage($imageUrls[0]) ;
					$app->setStatus(1) ; // 1:Setting
					$app->save() ;

					$this->setAlternativeImage($appId,'c_veam_icon.png',$imageUrls[0]) ;
					$this->setAlternativeImage($appId,'t1_top_right.png',$imageUrls[0]) ;
					$this->setAlternativeImage($appId,'t6_top_right.png',$imageUrls[0]) ;
					$this->setAlternativeImage($appId,'t8_top_right.png',$imageUrls[0]) ;
					$this->setAlternativeImage($appId,'c_small_icon.png',$imageUrls[1]) ;
				}

				// �Œ�̃J���[�Ńp�[�c��ݒ�
				$this->setColorImage($appId) ;
			    $name = 'concept_color_argb' ;
				$appColor = $this->getAppColor($appId,$name) ;
				$appColor->setColor('FF3DBCFF') ;
				$appColor->save() ;

			    $name = 'new_videos_text_color_argb' ;
				$appColor = $this->getAppColor($appId,$name) ;
				$appColor->setColor('FF3DBCFF') ;
				$appColor->save() ;

			    $name = 'table_selection_color_argb' ;
				$appColor = $this->getAppColor($appId,$name) ;
				$appColor->setColor('303DBCFF') ;
				$appColor->save() ;

				$outputs = array() ;
		 		$commandLine = sprintf("cp -r %s/31000000 %s/%s",$commandDir,$commandDir,$appId) ;
				//print($commandLine."\n") ;
				exec($commandLine,$outputs) ;

				AdminTools::completeProcess($appId,10100,1,'tool',$databaseManager) ;

				//VeamTools::executeConsoleCommand($appId,'UPDATE_SCREEN_SHOT','') ;
				$screenShotUrl = $this->createScreenShot($appId,$commandDir) ;


				$outputs = array() ;
		 		$commandLine = sprintf("find %s/%s -type d -exec chmod 777 {} \\;",$commandDir,$appId) ;
				//print($commandLine."\n") ;
				exec($commandLine,$outputs) ;

				$outputs = array() ;
		 		$commandLine = sprintf("find %s/%s -type f -exec chmod 666 {} \\;",$commandDir,$appId) ;
				//print($commandLine."\n") ;
				exec($commandLine,$outputs) ;


				/*
				$c = new Criteria() ;
			  	$c->add(TemplateSubscriptionPeer::DEL_FLG,0) ;
			  	$c->add(TemplateSubscriptionPeer::APP_ID,$appId) ;
				$templateSubscription = TemplateSubscriptionPeer::doSelectOne($c) ;
				if($templateSubscription){
					$templateSubscription->setLayout(2) ; // grid
					$templateSubscription->setKind(4) ; // grid
					$templateSubscription->save() ;
				}
				*/

				$remoteCommant = new RemoteCommand() ;
				$remoteCommant->setAppId($appId) ;
				$remoteCommant->setName('UPDATE_CONCEPT_COLOR') ;
				$remoteCommant->setStatus(1) ;
				$remoteCommant->save() ;

				$remoteCommant = new RemoteCommand() ;
				$remoteCommant->setAppId($appId) ;
				$remoteCommant->setName('UPDATE_SCREEN_SHOT') ;
				$remoteCommant->setStatus(1) ;
				$remoteCommant->save() ;

				AdminTools::deployApp($appId,$databaseManager) ;










				$result->code = 1 ;
				$result->appUser = $appCreatorName ;
				$result->appPassword = $appCreatorPassword ;
				$result->screenShotUrl = $screenShotUrl ;

			} else {
				$result->code = -1 ;
				$result->errorMessage = 'Channel data not found' ;
			}
		} else {
			$result->code = -1 ;
			$result->errorMessage = 'App Already Created' ;
		}




































		echo json_encode($result) ;

	}


	public function getYoutubeChannels($channelId)
	{
		$items = "" ;
		$url = sprintf('https://www.googleapis.com/youtube/v3/channels?key=__YOUTUBE_API_KEY__&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&id=%s',$channelId) ;
		$result = file_get_contents($url) ;
		if($result){
			$channelList = json_decode($result) ;
			if($channelList){
				$items = $channelList->{'items'} ;
			} else {
			}
		} else {
		}
		
		return $items ;
	}




	public function createYoutubeList($youtubeUser)
	{

		$this->debugPrint("createYoutubeList\n") ;
		$apiKey = '__YOUTUBE_API_KEY__' ;
		$appId = $youtubeUser->getAppId() ;
		//print(sprintf("app : %s\n",$appId)) ;

		$this->myChannelIds = array() ;

		$c = new Criteria() ;
		$c->add(CategoryPeer::APP_ID,$appId) ;
		$c->add(CategoryPeer::DEL_FLG,0) ;
		$categories =  CategoryPeer::doSelect($c) ;
		$categoriesToBeUpdated = array() ;
		$categoriesToBeRemoved = array() ;

		$c = new Criteria() ;
		$c->add(YoutubeVideoPeer::APP_ID,$appId) ;
		$c->add(YoutubeVideoPeer::DEL_FLG,0) ;
		$youtubeVideos = YoutubeVideoPeer::doSelect($c) ;
		$youtubeVideosToBeUpdated = array() ;
		$youtubeVideosToBeRemoved = array() ;

		$uploadsPlaylistId = '' ;
		$numberOfLatestVideos = 10 ;

		$channelId = $youtubeUser->getName() ;
		// Channel��� ���擾
		$url = sprintf("https://www.googleapis.com/youtube/v3/channels?key=%s&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&id=%s",$apiKey,$channelId) ;
		$json = file_get_contents($url,true) ;
		if(!$json){
			return -1 ;
		}

		$channelListResponse = json_decode($json) ;
		$channels = $channelListResponse->{'items'} ;
		foreach($channels as $channel){
			$channelId = $channel->id ;
			$this->myChannelIds[] = $channelId ;
			$channelTitle = $channel->{'snippet'}->{'title'} ;

			$uploadsPlaylistId = $channel->{'contentDetails'}->{'relatedPlaylists'}->{'uploads'} ;
			$playlistId = $uploadsPlaylistId ;
			$playlistTitle = 'New Videos' ;
			//print(sprintf("   playlist : %s : %s\n",$playlistId,$playlistTitle)) ;
			$category = $this->categoryForPlaylistId($categories,$playlistId) ;
			if(!$category){
				$category = new Category() ;
				$category->setAppId($appId) ;
				$category->setYoutubePlaylistId($playlistId) ;
			}
			$category->setName($this->escapeTitle($playlistTitle)) ;
			$categoriesToBeUpdated[] = $category ;

			$nextPageToken = '' ;
			do {
				if($nextPageToken){
					$pageToken = sprintf('&pageToken=%s',$nextPageToken) ;
				} else {
					$pageToken = '' ;
				}
				$url = sprintf("https://www.googleapis.com/youtube/v3/playlists?key=%s&part=id,snippet&maxResults=10&channelId=%s%s",$apiKey,$channelId,$pageToken) ; // 10playlists/channel �ɐ���
				$json = file_get_contents($url,true) ;
				if(!$json){
					//print("query failed\n");
					return -1 ;
				}
				$playlistListResponse = json_decode($json) ;
				if(property_exists($playlistListResponse,'nextPageToken')){
					$nextPageToken = $playlistListResponse->{'nextPageToken'} ;
				} else {
					$nextPageToken = '' ;
				}
				$playlists = $playlistListResponse->{'items'} ;
				foreach($playlists as $playlist){
					$playlistId = $playlist->{'id'} ;
					$playlistTitle = $playlist->{'snippet'}->{'title'} ;
					//print(sprintf("   playlist : %s : %s\n",$playlistId,$playlistTitle)) ;
					$category = $this->categoryForPlaylistId($categories,$playlistId) ;
					if(!$category){
						$category = new Category() ;
						$category->setAppId($appId) ;
						$category->setYoutubePlaylistId($playlistId) ;
					}
					$category->setName($this->escapeTitle($playlistTitle)) ;
					$categoriesToBeUpdated[] = $category ;
				}
			} while(false) ;// 10playlists/channel �ɐ���
			//} while($nextPageToken) ;
		}

		foreach($categories as $category){
			$workCategory = $this->categoryForPlaylistId($categoriesToBeUpdated,$category->getYoutubePlaylistId()) ;
			if(!$workCategory){
				$categoriesToBeRemoved[] = $category ;
			}
		}

		//print("--- categories to be updated ---\n") ;
		$displayOrder = 1 ;
		foreach($categoriesToBeUpdated as $category){
			//print(sprintf("- %s : %s\n",$category->getName(),$category->getYoutubePlaylistId())) ;
			$category->setDisplayOrder($displayOrder++) ;
			$category->save() ;
		}
		//print("------\n") ;

		//print("categories to be removed\n") ;
		foreach($categoriesToBeRemoved as $category){
			//print(sprintf("- %s : %s\n",$category->getName(),$category->getYoutubePlaylistId())) ;
			$category->delete() ;
		}
		//print("------\n") ;

		foreach($categoriesToBeUpdated as $category){
			$playlistId = $category->getYoutubePlaylistId() ;
			$categoryId = $category->getId() ;

			$nextPageToken = '' ;
			$videos = array() ;
			do {
				if($nextPageToken){
					$pageToken = sprintf('&pageToken=%s',$nextPageToken) ;
				} else {
					$pageToken = '' ;
				}

				if($playlistId == $uploadsPlaylistId){
					$url = sprintf("https://www.googleapis.com/youtube/v3/search?key=%s&part=id,snippet&channelId=%s&maxResults=10&order=date&type=video",$apiKey,$channelId) ;
				} else {
					$url = sprintf("https://www.googleapis.com/youtube/v3/playlistItems?key=%s&part=id,snippet,contentDetails,status&maxResults=20&playlistId=%s%s",$apiKey,$playlistId,$pageToken) ; // 20videos/playlist �ɐ���
				}
				$json = file_get_contents($url,true) ;
				if(!$json){
					//print("query failed\n");
					return -1 ;
				}
				$playlistListResponse = json_decode($json) ;

				if($playlistId != $uploadsPlaylistId){
					if(property_exists($playlistListResponse,'nextPageToken')){
						$nextPageToken = $playlistListResponse->{'nextPageToken'} ;
					} else {
						$nextPageToken = '' ;
					}
				}
				$videos = array_merge($videos,$playlistListResponse->{'items'}) ;
			} while(false) ; // 20videos/playlist �ɐ���
			//} while($nextPageToken) ;

			if($playlistId == $uploadsPlaylistId){
				$count = 0 ;
				$nextPageToken = '' ;

				//print("--- new video before sorting ---\n") ;
				foreach($videos as $video){
					$videoId = $video->{'id'}->{'videoId'} ;
					$videoTitle = $video->{'snippet'}->{'title'} ;
					$videoDescription = $video->{'snippet'}->{'description'} ;
					//print(sprintf("    video : %s : %s : %s\n",$video->{'snippet'}->{'publishedAt'},$videoId,$videoTitle)) ;
				}
				//print("---  ---\n") ;

			}
			foreach($videos as $video){
				if(isset($video->{'status'}->{'privacyStatus'})){
					$privacyStatus = $video->{'status'}->{'privacyStatus'} ;
				} else {
					$privacyStatus = 'public' ;
				}
				if($privacyStatus == 'public'){
					$videoChannelId = $video->{'snippet'}->{'channelId'} ;
					$videoChannelTitle = $video->{'snippet'}->{'channelTitle'} ;
					if($this->validChannelId($videoChannelId)){
						if(isset($video->{'snippet'}->{'resourceId'}->{'videoId'})){
							$videoId = $video->{'snippet'}->{'resourceId'}->{'videoId'} ;
						} else {
							$videoId = $video->{'id'}->{'videoId'} ;
						}

						$videoTitle = $video->{'snippet'}->{'title'} ;
						$videoDescription = $video->{'snippet'}->{'description'} ;
						//print(sprintf("    video : %s : %s : %s : %s\n",$video->{'snippet'}->{'publishedAt'},$videoId,$videoTitle,$videoChannelTitle)) ;
						$youtubeVideo = $this->youtubeVideoForCategoryIdAndVideoId($youtubeVideos,$categoryId,$videoId) ;
						if(!$youtubeVideo){
							$youtubeVideo = new YoutubeVideo() ;
							$youtubeVideo->setAppId($appId) ;
							$youtubeVideo->setCategoryId($categoryId) ;
							$youtubeVideo->setSubCategoryId(0) ;
							$youtubeVideo->setYoutubeCode($videoId) ;
						}
						$youtubeVideo->setTitle($this->escapeTitle($videoTitle)) ;

						$youtubeVideosToBeUpdated[] = $youtubeVideo ;
						$count++ ;
						if(($playlistId == $uploadsPlaylistId) && ($count >= 10)){
							break ;
						}
					}
				}
			}

		}

		$count = count($youtubeVideosToBeUpdated) ;
		for($offset = 0 ; $offset < $count ; $offset += 50){
			$videoIds = '' ;
			for($index = 0 ; ($index < 50) && (($offset+$index) < $count) ; $index++){
				if(isset($youtubeVideosToBeUpdated[$offset+$index])){
					if($videoIds){
						$videoIds .= ',' ;
					}
					$videoIds .= $youtubeVideosToBeUpdated[$offset+$index]->getYoutubeCode() ;
				}
			}

			if($videoIds){
				$url = sprintf("https://www.googleapis.com/youtube/v3/videos?key=%s&part=id,snippet,contentDetails&id=%s",$apiKey,$videoIds) ;
				$json = file_get_contents($url,true) ;
				if(!$json){
					//print("query failed\n");
					return -1 ;
				}
				$videoListResponse = json_decode($json) ;
				$videos = $videoListResponse->{'items'} ;
				foreach($videos as $video){
					$videoId = $video->{'id'} ;
					$channelId = $video->{'snippet'}->{'channelId'} ;
					if($this->validChannelId($channelId)){
						$durationString = $video->{'contentDetails'}->{'duration'} ;
						$description = $video->{'snippet'}->{'description'} ;
						$this->setDurationAndDescription(&$youtubeVideosToBeUpdated,$videoId,$this->getDurationInSec($durationString),$description) ;
					} else {
						$this->unsetYoutubeVideos(&$youtubeVideosToBeUpdated,$videoId) ;
					}
				}
			}
		}

		foreach($youtubeVideos as $youtubeVideo){
			$workYoutubeVideo = $this->youtubeVideoForCategoryIdAndVideoId($youtubeVideosToBeUpdated,$youtubeVideo->getCategoryId(),$youtubeVideo->getYoutubeCode()) ;
			if(!$workYoutubeVideo){
				$youtubeVideosToBeRemoved[] = $youtubeVideo ;
			}
		}

		$displayOrder = 1 ;
		//print("--- youtubeVideos to be updated ---\n") ;
		foreach($youtubeVideosToBeUpdated as $youtubeVideo){
			//print(sprintf("- %s : %s\n",$youtubeVideo->getTitle(),$youtubeVideo->getYoutubeCode())) ;
			$youtubeVideo->setDisplayOrder($displayOrder++) ;
			$youtubeVideo->save() ;
		}
		//print("------\n") ;


		//print("--- youtubeVideos to be removed ---\n") ;
		foreach($youtubeVideosToBeRemoved as $youtubeVideo){
			//print(sprintf("- %s : %s\n",$youtubeVideo->getTitle(),$youtubeVideo->getYoutubeCode())) ;
			$youtubeVideo->delete() ;
		}
		//print("------\n") ;



		// disable empty category
		$c = new Criteria() ;
		$c->add(YoutubeVideoPeer::APP_ID,$appId) ;
		$c->add(YoutubeVideoPeer::DEL_FLG,0) ;
		$youtubeVideos = YoutubeVideoPeer::doSelect($c) ;
		$videoCounts = array() ;
		foreach($youtubeVideos as $youtubeVideo){
			if(isset($videoCounts[$youtubeVideo->getCategoryId()])){
				$videoCounts[$youtubeVideo->getCategoryId()]++ ;
			} else {
				$videoCounts[$youtubeVideo->getCategoryId()] = 1 ;
			}
		}

		$c = new Criteria() ;
		$c->add(CategoryPeer::APP_ID,$appId) ;
		$c->add(CategoryPeer::DEL_FLG,0) ;
		$categories =  CategoryPeer::doSelect($c) ;
		foreach($categories as $category){
			if(!$videoCounts[$category->getId()]){
				$category->setDisabled(1) ;
				$category->save() ;
			}
		}


		ConsoleTools::consoleContentsChanged($appId) ;

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
		$description = str_replace("�L","'",$description) ;

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


	private function debugPrint($message)
	{
		//print($message) ;
	}


	private function validChannelId($channelId)
	{
		$retValue = false ;
		foreach($this->myChannelIds as $myChannelId){
			if($myChannelId == $channelId){
				$retValue = true ;
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

	private function setDurationAndDescription($youtubeVideos,$videoId,$duration,$description)
	{
		foreach($youtubeVideos as $key=>$youtubeVideo){
			if($youtubeVideo->getYoutubeCode() == $videoId){
				$youtubeVideo->setDuration($duration) ;
				$youtubeVideo->setDescription($this->escapeDescription($description)) ;
			}
		}
	}


	private function unsetYoutubeVideos($youtubeVideos,$videoId)
	{
		foreach($youtubeVideos as $key=>$youtubeVideo){
			if($youtubeVideo->getYoutubeCode() == $videoId){
				//print("found unset : $key\n") ;
				unset($youtubeVideos[$key]) ;
			}
		}
	}





	public function uploadIconPNGFileToS3($appId,$iconUrl)
	{
		$fileName = sprintf("c_%s_%s_%04d.png",$appId,date('YmdHis'),rand()%10000) ;
		$filePath = "/tmp/" . $fileName ;

		$smallFileName = sprintf("c_%s_%s_%04d_s.png",$appId,date('YmdHis'),rand()%10000) ;
		$smallFilePath = "/tmp/" . $smallFileName ;

		$tmpFileName = sprintf("c_%s_%s_%04d_t.png",$appId,date('YmdHis'),rand()%10000) ;
		$tmpFilePath = "/tmp/" . $tmpFileName ;

		$imageUrls = array() ;

		if($data = file_get_contents($iconUrl)){
	    	file_put_contents($tmpFilePath,$data) ;
			$this->resizeImage($tmpFilePath,$filePath,1024,1024) ;
			$this->removeImageAlpha($filePath) ;
			$this->resizeImage($filePath,$smallFilePath,64,64) ;
			chmod($filePath, 0666) ;
			chmod($smallFilePath, 0666) ;

			$outputs = array() ;
			$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$filePath,$appId) ;
			exec($commandLine,$outputs) ;
			if($outputs[0] == '1'){
				$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$fileName) ;

				$outputs = array() ;
				$commandLine = sprintf('php /data/console/console-work.veam.co/bin/image/UploadToS3Directory.php %s a/%s/images',$smallFilePath,$appId) ;
				exec($commandLine,$outputs) ;
				if($outputs[0] == '1'){
					$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s",$appId,$smallFileName) ;
				}
			} else {
				//sfContext::getInstance()->getLogger()->info(sprintf('result=%s',implode(" - ",$outputs)));
			}

			unlink($filePath) ;
			unlink($smallFilePath) ;
			unlink($tmpFilePath) ;

		} else {
			//echo "�t�@�C�����A�b�v���[�h�ł��܂���B";
			//sfContext::getInstance()->getLogger()->info(sprintf('failed to upload'));
		}

		return $imageUrls ;

	}


	public function resizeImage($imagePath1,$imagePath2,$width,$height)
	{
		$image = imagecreatefrompng($imagePath1) ;
		if(!$image){
			$image = imagecreatefromjpeg($imagePath1) ;
		}
		list($width1, $height1) = getimagesize($imagePath1) ;

		$resizedImage = imagecreatetruecolor($width, $height);
		imagecopyresized($resizedImage, $image, 0, 0, 0, 0, $width, $height, $width1, $height1);

		imagepng($resizedImage,$imagePath2);
	}

	public function removeImageAlpha($imagePath1)
	{
		$image = imagecreatefrompng($imagePath1) ;
		imagesavealpha($image,false) ;
		imagepng($image,$imagePath1);
	}

	public function setAlternativeImage($appId,$fileName,$url)
	{
		//sfContext::getInstance()->getLogger()->info(sprintf("setAlternativeImage %s %s %s",$appId,$fileName,$url)) ;

	  	$c = new Criteria() ;
	  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
	  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
	  	$c->add(AlternativeImagePeer::FILE_NAME,$fileName) ;
		$alternativeImage = AlternativeImagePeer::doSelectOne($c) ;
		if(!$alternativeImage){
			$alternativeImage = new AlternativeImage() ;
			$alternativeImage->setAppId($appId) ;
			$alternativeImage->setFileName($fileName) ;
		}
		$alternativeImage->setUrl($url) ;
		$alternativeImage->save() ;
	}


	public function setColorImage($appId)
	{
		$this->setAlternativeImage($appId,'video_left.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/video_left.png') ;
		$this->setAlternativeImage($appId,'share_twitter_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_twitter_on.png') ;
		$this->setAlternativeImage($appId,'program_comment.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/program_comment.png') ;
		$this->setAlternativeImage($appId,'goodjob.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/goodjob.png') ;
		$this->setAlternativeImage($appId,'forum_like_button_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/forum_like_button_on.png') ;
		$this->setAlternativeImage($appId,'grid_audio.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_audio.png') ;
		$this->setAlternativeImage($appId,'q_vote_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_vote_icon.png') ;
		$this->setAlternativeImage($appId,'flame.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/flame.png') ;
		$this->setAlternativeImage($appId,'share_facebook_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_facebook_on.png') ;
		$this->setAlternativeImage($appId,'program_like.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/program_like.png') ;
		$this->setAlternativeImage($appId,'pro_post_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_post_icon.png') ;
		$this->setAlternativeImage($appId,'list_following.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/list_following.png') ;
		$this->setAlternativeImage($appId,'list_clip.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/list_clip.png') ;
		$this->setAlternativeImage($appId,'audio_thumbnail.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/audio_thumbnail.png') ;
		$this->setAlternativeImage($appId,'share_facebook_off.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_facebook_off.png') ;
		$this->setAlternativeImage($appId,'select_back.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/select_back.png') ;
		$this->setAlternativeImage($appId,'pro_settings.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_settings.png') ;
		$this->setAlternativeImage($appId,'share_twitter_off.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/share_twitter_off.png') ;
		$this->setAlternativeImage($appId,'thankyou.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/thankyou.png') ;
		$this->setAlternativeImage($appId,'forum_comment.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/forum_comment.png') ;
		$this->setAlternativeImage($appId,'q_answer_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_answer_icon.png') ;
		$this->setAlternativeImage($appId,'vote_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/vote_on.png') ;
		$this->setAlternativeImage($appId,'video_thumbnail.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/video_thumbnail.png') ;
		$this->setAlternativeImage($appId,'answer_audio_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/answer_audio_on.png') ;
		$this->setAlternativeImage($appId,'grid_back2.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_back2.png') ;
		$this->setAlternativeImage($appId,'expand_comment.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/expand_comment.png') ;
		$this->setAlternativeImage($appId,'report.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/report.png') ;
		$this->setAlternativeImage($appId,'list_my_post.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/list_my_post.png') ;
		$this->setAlternativeImage($appId,'grid_back1.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_back1.png') ;
		$this->setAlternativeImage($appId,'pro_follow.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_follow.png') ;
		$this->setAlternativeImage($appId,'check_box_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/check_box_on.png') ;
		$this->setAlternativeImage($appId,'like.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/like.png') ;
		$this->setAlternativeImage($appId,'q_ranking_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_ranking_icon.png') ;
		$this->setAlternativeImage($appId,'calendar_dot2.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/calendar_dot2.png') ;
		$this->setAlternativeImage($appId,'tab_selected_back.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/tab_selected_back.png') ;
		$this->setAlternativeImage($appId,'pro_person_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/pro_person_icon.png') ;
		$this->setAlternativeImage($appId,'grid_video.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_video.png') ;
		$this->setAlternativeImage($appId,'add_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/add_on.png') ;
		$this->setAlternativeImage($appId,'answer_video_on.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/answer_video_on.png') ;
		$this->setAlternativeImage($appId,'camera_button.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/camera_button.png') ;
		$this->setAlternativeImage($appId,'q_video_icon.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/q_video_icon.png') ;
		$this->setAlternativeImage($appId,'t1_top_left.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/t1_top_left.png') ;
		$this->setAlternativeImage($appId,'grid_year.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_year.png') ;
		$this->setAlternativeImage($appId,'tab_selected_back@2x.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/tab_selected_back@2x.png') ;
		$this->setAlternativeImage($appId,'grid_back.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/grid_back.png') ;
		$this->setAlternativeImage($appId,'default_grid_0.png', 'http://__CLOUD_FRONT_HOST__/a/31000000/images/3DBCFF/default_grid_0.png') ;
	}

	private function getAppColor($appId,$name)
	{
		$c = new Criteria() ;
	  	$c->add(AppColorPeer::DEL_FLG,0) ;
	  	$c->add(AppColorPeer::APP_ID,$appId) ;
	  	$c->add(AppColorPeer::NAME,$name) ;
		$appColor = AppColorPeer::doSelectOne($c) ;

		if(!$appColor){
			$appColor = new AppColor() ;
			$appColor->setAppId($appId) ;
			$appColor->setName($name) ;
		}

		return $appColor ;
	}








	private function createScreenShot($appId,$commandDir)
	{

		$screenShotUrl = '' ;
		$status = 1 ;
		$result = '' ;

		$ssConfig = "" ;

		$configImages = array(
			'initial_background.png'	=>	'SPLASH',
			'background.png'			=>	'BACKGROUND',
			't1_top_right.png'			=>	'YOUTUBE_RIGHT',
		) ;

		$pngFileNames = array() ;
		foreach($configImages as $imageFileName => $imageName){
			$pngFileNames[] = $imageFileName ;
		}

	  	$c = new Criteria() ;
	  	$c->add(AlternativeImagePeer::DEL_FLG,0) ;
	  	$c->add(AlternativeImagePeer::APP_ID,$appId) ;
	  	$c->add(AlternativeImagePeer::FILE_NAME,$pngFileNames,Criteria::IN) ;
		$alternativeImages = AlternativeImagePeer::doSelect($c) ;
		$imageUrlMap = array() ;
		foreach($alternativeImages as $alternativeImage){
			$fileName = $alternativeImage->getFileName() ;
			if($configImages[$fileName]){
				$ssConfig .= sprintf("%s=%s\n",$configImages[$fileName],$alternativeImage->getUrl()) ;
			}
		}

	  	$c = new Criteria() ;
	  	$c->add(MixedPeer::DEL_FLG,0) ;
	  	$c->add(MixedPeer::APP_ID,$appId) ;
		$c->addAscendingOrderByColumn(MixedPeer::ID) ;
		$mixeds = MixedPeer::doSelect($c) ;
		if($mixeds){
			$mixedIndex = 0 ;
			foreach($mixeds as $mixed){
				$mixedIndex++ ;
				if($mixedIndex > 2){
					break ;
				}
				$thumbnailUrl = $mixed->getThumbnailUrl() ;
				if($thumbnailUrl){
					$ssConfig .= sprintf("GRID%d=%s\n",$mixedIndex,$thumbnailUrl) ;
				}
			}
		}

	  	$c = new Criteria() ;
	  	$c->add(AudioPeer::DEL_FLG,0) ;
	  	$c->add(AudioPeer::APP_ID,$appId) ;
		$c->addAscendingOrderByColumn(AudioPeer::ID) ;
		$audios = AudioPeer::doSelect($c) ;
		if($audios){
			foreach($audios as $audio){
				$thumbnailUrl = $audio->getImageUrl() ;
				if($thumbnailUrl){
					$ssConfig .= sprintf("AUDIO1=%s\n",$thumbnailUrl) ;
					break ;
				}
			}
		}


	  	$c = new Criteria() ;
	  	$c->add(ForumPeer::DEL_FLAG,0) ;
	  	$c->add(ForumPeer::APP_ID,$appId) ;
	  	$c->add(ForumPeer::DISPLAY_ORDER,0,Criteria::GREATER_THAN) ;
		$c->addAscendingOrderByColumn(ForumPeer::DISPLAY_ORDER) ;
		$forums = ForumPeer::doSelect($c) ;
		if($forums){
			$forumString = '' ;
			foreach($forums as $forum){
				if($forumString){
					$forumString .= '|' ;
				}
				$forumName = AdminTools::unescapeName($forum->getName()) ;
				$forumString .= $forumName ;
			}
			$ssConfig .= sprintf("FORUMS=%s\n",$forumString) ;
		}


	  	$c = new Criteria() ;
	  	$c->add(CategoryPeer::DEL_FLG,0) ;
	  	$c->add(CategoryPeer::DISABLED,0) ;
	  	$c->add(CategoryPeer::APP_ID,$appId) ;
		$c->addAscendingOrderByColumn(CategoryPeer::DISPLAY_ORDER) ;
		$categories = CategoryPeer::doSelect($c) ;
		if($categories){
			$categoryString = '' ;
			foreach($categories as $category){
				if($categoryString){
					$categoryString .= '|' ;
				}
				$categoryName = AdminTools::unescapeName($category->getName()) ;
				$categoryString .= $categoryName ;
			}
			$ssConfig .= sprintf("YOUTUBES=%s\n",$categoryString) ;
		}




		$configPath = sprintf("%s/%s/ss_config.txt",$commandDir,$appId) ;
		file_put_contents($configPath,$ssConfig) ;

	  	$c = new Criteria() ;
	  	$c->add(AppColorPeer::DEL_FLG,0) ;
	  	$c->add(AppColorPeer::APP_ID,$appId) ;
	  	$c->add(AppColorPeer::NAME,'concept_color_argb') ;
		$appColor = AppColorPeer::doSelectOne($c) ;
		$conceptColor = substr($appColor->getColor(),2) ;

		$ssDir = sprintf('ss%s_%04d',date('YmdHis'),rand(0,9999)) ;

		$outputs = array() ;
 		$commandLine = sprintf("perl %s/create_ss.pl %s %s %s",$commandDir,$appId,$conceptColor,$ssDir) ; // create_ss.pl 31000172 3D21FF ss2015021914075679_4761
		//print($commandLine."\n") ;
		$result .= $commandLine."\n" ;


		exec($commandLine,$outputs) ;


		$outDir = sprintf("%s/%s/%s",$commandDir,$appId,$ssDir) ;
		if($outDirHandle = opendir($outDir)) {
			$imageUrls = array() ;
			$fileNames = array() ;
	        while(($fileName = readdir($outDirHandle)) !== false){
				if(preg_match('/\.png$/',$fileName)){
					$fileNames[] = $fileName ;
				}
	        }

			sort($fileNames) ;
			foreach($fileNames as $fileName){
	            //print("upload $fileName\n") ;

				$imageFilePath = sprintf("%s/%s",$outDir,$fileName) ;

				$outputs = array() ;
				$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/images/%s',$commandDir,$imageFilePath,$appId,$conceptColor) ;
				//print("$commandLine\n") ;
				$result .= sprintf("%s\n",$commandLine) ;
				exec($commandLine,$outputs) ;
				if($outputs[0] == '1'){
					if(preg_match('/4inch/',$fileName)){
						$imageUrls[] = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/images/%s/%s",$appId,$conceptColor,$fileName) ;
					}
				}
			}

	        closedir($outDirHandle);

			$imageCount = count($imageUrls) ;
			$app = AppPeer::retrieveByPk($appId) ;
			if($app){
				if($imageCount >= 1){
					$app->setScreenShot1($imageUrls[0]) ;
				} else {
					$app->setScreenShot1('') ;
				}
				if($imageCount >= 2){
					$app->setScreenShot2($imageUrls[1]) ;
				} else {
					$app->setScreenShot2('') ;
				}
				if($imageCount >= 3){
					$app->setScreenShot3($imageUrls[2]) ;
				} else {
					$app->setScreenShot3('') ;
				}
				if($imageCount >= 4){
					$app->setScreenShot4($imageUrls[3]) ;
					$screenShotUrl = $imageUrls[3] ;
				} else {
					$app->setScreenShot4('') ;
				}
				if($imageCount >= 5){
					$app->setScreenShot5($imageUrls[4]) ;
				} else {
					$app->setScreenShot5('') ;
				}
				$app->save() ;
			}
	    } else {
			$status = 2 ;
			$result .= sprintf("open dir failed : %s\n",$outDir) ;
		}
		return $screenShotUrl ;
	}


}
