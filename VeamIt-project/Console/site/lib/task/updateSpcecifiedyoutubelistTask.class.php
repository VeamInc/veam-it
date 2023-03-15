<?php

class updateSpecifiedyoutubelistTask extends sfBaseTask
{
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
      new sfCommandOption('app_id', null, sfCommandOption::PARAMETER_REQUIRED, 'App ID', 0),
    ));

    $this->namespace        = '';
    $this->name             = 'updateSpecifiedyoutubelist';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [updateSpecifiedyoutubelist|INFO] task does things.
Call it with:

  [php symfony updateSpecifiedyoutubelist|INFO]
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

		$targetAppId = $options['app_id'] ;
		if(!$targetAppId){
			print("please input app_id\n") ;
			return ;
		}


		//status 0:waiting 1:encoded 2:failed 3:skipped 4:encoding
		$c = new Criteria() ;
		$c->add(YoutubeUserPeer::APP_ID,$targetAppId) ;
		$c->add(YoutubeUserPeer::AUTO_LIST,1) ;
		$c->add(YoutubeUserPeer::DEL_FLAG,0) ;
		$youtubeUsers = YoutubeUserPeer::doSelect($c) ;
		if(count($youtubeUsers)> 0){
			foreach($youtubeUsers as $youtubeUser){
				$appId = $youtubeUser->getAppId() ;
				$app = AppPeer::RetrieveByPk($appId) ;
				if($app){
					//if($app->getReleasedAt()){
						print("update $appId\n") ;
						$this->updateOneApp($youtubeUser,$databaseManager) ;
					//} else {
					//}
				}
			}
		} else {
			// 
			print("no user\n") ;
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

		$title = str_replace("´","'",$title) ;


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






	public function updateOneApp($youtubeUser,$databaseManager)
	{
		$apiKey = '__YOUTUBE_API_KEY__' ;
		$appId = $youtubeUser->getAppId() ;
		print(sprintf("app : %s\n",$appId)) ;

		$this->myChannelIds = array() ;

		$c = new Criteria() ;
		$c->add(YoutubeAdditionalChannelPeer::APP_ID,$appId) ;
		$c->add(YoutubeAdditionalChannelPeer::DEL_FLG,0) ;
		$youtubeAdditionalChannels =  YoutubeAdditionalChannelPeer::doSelect($c) ;
		foreach($youtubeAdditionalChannels as $youtubeAdditionalChannel){
			$channelId = $youtubeAdditionalChannel->getYoutubeChannelId() ;
			if($channelId){
				$this->myChannelIds[] = $channelId ;
			}
		}

		$c = new Criteria() ;
		$c->add(YoutubePlaylistAltNamePeer::APP_ID,$appId) ;
		$c->add(YoutubePlaylistAltNamePeer::DEL_FLG,0) ;
		$youtubePlaylistAltNames =  YoutubePlaylistAltNamePeer::doSelect($c) ;
		$youtubePlaylistAltNameMap = array() ;
		foreach($youtubePlaylistAltNames as $youtubePlaylistAltName){
			$youtubePlaylistAltNameMap[$youtubePlaylistAltName->getYoutubePlaylistId()] = $youtubePlaylistAltName->getName() ;
		}

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

		$userNames = explode(',',$youtubeUser->getName()) ;
		foreach($userNames as $userName){
			print(sprintf(" user : %s\n",$userName)) ;

			// username から ChannelID を取得
			$url = sprintf("https://www.googleapis.com/youtube/v3/channels?key=%s&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&forUsername=%s",$apiKey,$userName) ;
			$json = file_get_contents($url,true) ;

			$reload = false ;
			if(!$json){
				$reload = true ;
			} else {
				$channelList = json_decode($json) ;
				if($channelList){
					#print(var_export($channelList,true)) ;
					$items = $channelList->{'items'} ;
					if(count($items) == 0){
						$reload = true ;
					}
				} else {
					$reload = true ;
				}
			}

			if($reload){
				$url = sprintf('https://www.googleapis.com/youtube/v3/channels?key=__YOUTUBE_API_KEY__&part=id,snippet,brandingSettings,contentDetails,invideoPromotion,statistics,topicDetails&id=%s',$userName) ;
				$json = file_get_contents($url) ;
			}

			if(!$json){
				print("query failed\n");
				return;
			}
			$channelListResponse = json_decode($json) ;
			$channels = $channelListResponse->{'items'} ;
			foreach($channels as $channel){
				$channelId = $channel->{'id'} ;
				$this->myChannelIds[] = $channelId ;

				$channelTitle = $channel->{'snippet'}->{'title'} ;
				print(sprintf("  channel : %s : %s\n",$channelId,$channelTitle)) ;

				$uploadsPlaylistId = $channel->{'contentDetails'}->{'relatedPlaylists'}->{'uploads'} ;
				$playlistId = $uploadsPlaylistId ;
				$playlistTitle = 'New Videos' ;
				print(sprintf("   playlist : %s : %s\n",$playlistId,$playlistTitle)) ;
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
					$url = sprintf("https://www.googleapis.com/youtube/v3/playlists?key=%s&part=id,snippet&maxResults=50&channelId=%s%s",$apiKey,$channelId,$pageToken) ;
					$json = file_get_contents($url,true) ;
					if(!$json){
						print("query failed\n");
						return;
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
						print(sprintf("   playlist : %s : %s\n",$playlistId,$playlistTitle)) ;
						$category = $this->categoryForPlaylistId($categories,$playlistId) ;
						if(!$category){
							$category = new Category() ;
							$category->setAppId($appId) ;
							$category->setYoutubePlaylistId($playlistId) ;
						}
						if($youtubePlaylistAltNameMap[$playlistId]){
							$playlistTitle = $youtubePlaylistAltNameMap[$playlistId] ;
						}
						$category->setName($this->escapeTitle($playlistTitle)) ;
						$categoriesToBeUpdated[] = $category ;
					}
				} while($nextPageToken) ;
			}

		}

		foreach($categories as $category){
			$workCategory = $this->categoryForPlaylistId($categoriesToBeUpdated,$category->getYoutubePlaylistId()) ;
			if(!$workCategory){
				$categoriesToBeRemoved[] = $category ;
			}
		}

		print("--- categories to be updated ---\n") ;
		$displayOrder = 1 ;
		foreach($categoriesToBeUpdated as $category){
			print(sprintf("- %s : %s\n",$category->getName(),$category->getYoutubePlaylistId())) ;
			//$category->setDisplayOrder($displayOrder++) ;
			$category->save() ;
		}
		print("------\n") ;

		print("categories to be removed\n") ;
		foreach($categoriesToBeRemoved as $category){
			print(sprintf("- %s : %s\n",$category->getName(),$category->getYoutubePlaylistId())) ;
			$category->delete() ;
		}
		print("------\n") ;

		foreach($categoriesToBeUpdated as $category){
			$playlistId = $category->getYoutubePlaylistId() ;
			$categoryId = $category->getId() ;

			print(sprintf("category %s : %s\n",$playlistId,$category->getName())) ;
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
					$url = sprintf("https://www.googleapis.com/youtube/v3/playlistItems?key=%s&part=id,snippet,contentDetails,status&maxResults=50&playlistId=%s%s",$apiKey,$playlistId,$pageToken) ;
				}
				$json = file_get_contents($url,true) ;
				if(!$json){
					print("query failed\n");
					return;
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
			} while($nextPageToken) ;

			if($playlistId == $uploadsPlaylistId){
				$count = 0 ;
				$nextPageToken = '' ;

				print("--- new video before sorting ---\n") ;
				foreach($videos as $video){
					$videoId = $video->{'id'}->{'videoId'} ;
					$videoTitle = $video->{'snippet'}->{'title'} ;
					$videoDescription = $video->{'snippet'}->{'description'} ;
					print(sprintf("    video : %s : %s : %s\n",$video->{'snippet'}->{'publishedAt'},$videoId,$videoTitle)) ;
				}
				print("---  ---\n") ;

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
						print(sprintf("    video : %s : %s : %s : %s\n",$video->{'snippet'}->{'publishedAt'},$videoId,$videoTitle,$videoChannelTitle)) ;
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
					print("query failed\n");
					return;
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
		print("--- youtubeVideos to be updated ---\n") ;
		foreach($youtubeVideosToBeUpdated as $youtubeVideo){
			print(sprintf("- %s : %s : %s\n",$youtubeVideo->getCategoryId(),$youtubeVideo->getTitle(),$youtubeVideo->getYoutubeCode())) ;
			//$youtubeVideo->setDisplayOrder($displayOrder++) ;
			$youtubeVideo->save() ;
		}
		print("------\n") ;


		print("--- youtubeVideos to be removed ---\n") ;
		foreach($youtubeVideosToBeRemoved as $youtubeVideo){
			print(sprintf("- %s : %s\n",$youtubeVideo->getTitle(),$youtubeVideo->getYoutubeCode())) ;
			$youtubeVideo->delete() ;
		}
		print("------\n") ;



		// disable empty category
		$c = new Criteria() ;
		$c->add(YoutubeVideoPeer::APP_ID,$appId) ;
		$c->add(YoutubeVideoPeer::DEL_FLG,0) ;
		$youtubeVideos = YoutubeVideoPeer::doSelect($c) ;
		$videoCounts = array() ;
		foreach($youtubeVideos as $youtubeVideo){
			$videoCounts[$youtubeVideo->getCategoryId()]++ ;
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


		AdminTools::deployAppYoutubeContents($appId,$databaseManager) ;

		ConsoleTools::consoleContentsChanged($appId) ;

	}
}

