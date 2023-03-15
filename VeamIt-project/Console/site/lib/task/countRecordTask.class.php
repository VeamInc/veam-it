<?php

class countRecordTask extends sfBaseTask
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
    ));

    $this->namespace        = '';
    $this->name             = 'countRecord';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [countRecord|INFO] task does things.
Call it with:

  [php symfony countRecord|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$currentTime = time() ;
		$today = date("Y-m-d",$currentTime) ;
		$currentYear = date("Y",$currentTime) ;
		$currentMonth = date("m",$currentTime) ;
		$lastMonth = $currentMonth - 1 ;
		if($lastMonth == 0){
			$lastMonthYear = $currentYear - 1 ;
			$lastMonth = 12 ;
		} else {
			$lastMonthYear = $currentYear ;
		}
		$firstDayOfLastMonth = sprintf("%04d-%02d-01",$lastMonthYear,$lastMonth) ;
		$firstDayOfThisMonth = sprintf("%04d-%02d-01",$currentYear,$currentMonth) ;

		$startSundayTime = strtotime('last Sunday', time()-518400) ; // 518400 = 6days
		$startSunday = date('Y-m-d',$startSundayTime) ;
		$endSunday = date('Y-m-d',$startSundayTime+604800) ; // 604800 = 7days


		//print($firstDayOfLastMonth . " - " . $firstDayOfThisMonth) ;

		$yesterdayTime = strtotime(sprintf("%s -1day",$today)) ;
		$yesterday = date("Y-m-d",$yesterdayTime) ;





		$numberOfForums = array() ;
		$c = new Criteria() ;
		$c->add(ForumPeer::DEL_FLAG,0) ;
		$forums = ForumPeer::doSelect($c) ;
		foreach($forums as $forum){
			if(isset($numberOfForums[$forum->getAppId()])){
				$numberOfForums[$forum->getAppId()]++ ;
			} else {
				$numberOfForums[$forum->getAppId()] = 1 ;
			}
		}

		$startTimeString = sprintf('%s 00:00:00',$yesterday) ;
		$endTimeString = sprintf('%s 00:00:00',$today) ;

		$lastMonthTimeString = sprintf('%s 00:00:00',$firstDayOfLastMonth) ;
		$thisMonthTimeString = sprintf('%s 00:00:00',$firstDayOfThisMonth) ;

		print("$startTimeString to $endTimeString\n") ;
		print("$lastMonthTimeString to $thisMonthTimeString\n") ;


		$startSundayTimeString = sprintf('%s 00:00:00',$startSunday) ;
		$endSundayTimeString = sprintf('%s 00:00:00',$endSunday) ;

		print("week $startSundayTimeString to $endSundayTimeString\n") ;

		$c = new Criteria() ;
		$c->add(AppPeer::DEL_FLG,0) ;
		$apps = AppPeer::doSelect($c) ;
		foreach($apps as $app){
			$appId = $app->getId() ;
			if(isset($numberOfForums[$appId]) and ($numberOfForums[$appId] > 0)){
				print(sprintf("%s : %s\n",$app->getId(),$app->getName())) ;

				$c = new Criteria() ;
				$c->add(PictureCountPeer::DEL_FLG,0) ;
				$c->add(PictureCountPeer::APP_ID,$appId) ;
				$c->add(PictureCountPeer::DATE,$yesterday) ;
				$pictureCount = PictureCountPeer::doSelectOne($c) ;
				if(!$pictureCount){
					$c = new Criteria() ;
					$c->addJoin(PicturePeer::FORUM_ID,ForumPeer::ID) ;
					$c->addAnd(ForumPeer::APP_ID,$appId) ;
					$c->addAnd(PicturePeer::CREATED_AT,$startTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PicturePeer::CREATED_AT,$endTimeString,Criteria::LESS_THAN) ;
					$count = PicturePeer::doCount($c) ;
					print($count."\n") ;
					$pictureCount = new PictureCount() ;
					$pictureCount->setAppId($appId) ;
					$pictureCount->setDate($yesterday) ;
					$pictureCount->setCount($count) ;
					$pictureCount->save() ;
				}

				$c = new Criteria() ;
				$c->add(PictureUuCountPeer::DEL_FLG,0) ;
				$c->add(PictureUuCountPeer::APP_ID,$appId) ;
				$c->add(PictureUuCountPeer::DATE,$yesterday) ;
				$pictureUuCount = PictureUuCountPeer::doSelectOne($c) ;
				if(!$pictureUuCount){
					$c = new Criteria() ;
					$c->addJoin(PicturePeer::FORUM_ID,ForumPeer::ID) ;
					$c->addAnd(ForumPeer::APP_ID,$appId) ;
					$c->addAnd(PicturePeer::CREATED_AT,$startTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PicturePeer::CREATED_AT,$endTimeString,Criteria::LESS_THAN) ;
					$c->addGroupByColumn('social_user_id');
					$count = PicturePeer::doCount($c) ;
					print($count."\n") ;
					$pictureUu = new PictureUuCount() ;
					$pictureUu->setAppId($appId) ;
					$pictureUu->setDate($yesterday) ;
					$pictureUu->setCount($count) ;
					$pictureUu->save() ;
				}

				$c = new Criteria() ;
				$c->add(PictureMuuCountPeer::DEL_FLG,0) ;
				$c->add(PictureMuuCountPeer::APP_ID,$appId) ;
				$c->add(PictureMuuCountPeer::DATE,$firstDayOfLastMonth) ;
				$pictureMuuCount = PictureMuuCountPeer::doSelectOne($c) ;
				if(!$pictureMuuCount){
					$c = new Criteria() ;
					$c->addJoin(PicturePeer::FORUM_ID,ForumPeer::ID) ;
					$c->addAnd(ForumPeer::APP_ID,$appId) ;
					$c->addAnd(PicturePeer::CREATED_AT,$lastMonthTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PicturePeer::CREATED_AT,$thisMonthTimeString,Criteria::LESS_THAN) ;
					$c->addGroupByColumn('social_user_id');
					$count = PicturePeer::doCount($c) ;
					print($count."\n") ;
					$pictureMuu = new PictureMuuCount() ;
					$pictureMuu->setAppId($appId) ;
					$pictureMuu->setDate($firstDayOfLastMonth) ;
					$pictureMuu->setCount($count) ;
					$pictureMuu->save() ;
				}

				$c = new Criteria() ;
				$c->add(PictureWuuCountPeer::DEL_FLG,0) ;
				$c->add(PictureWuuCountPeer::APP_ID,$appId) ;
				$c->add(PictureWuuCountPeer::DATE,$startSunday) ;
				$pictureWuuCount = PictureWuuCountPeer::doSelectOne($c) ;
				if(!$pictureWuuCount){
					$c = new Criteria() ;
					$c->addJoin(PicturePeer::FORUM_ID,ForumPeer::ID) ;
					$c->addAnd(ForumPeer::APP_ID,$appId) ;
					$c->addAnd(PicturePeer::CREATED_AT,$startSundayTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PicturePeer::CREATED_AT,$endSundayTimeString,Criteria::LESS_THAN) ;
					$c->addGroupByColumn('social_user_id');
					$count = PicturePeer::doCount($c) ;
					print($count."\n") ;
					$pictureWuu = new PictureWuuCount() ;
					$pictureWuu->setAppId($appId) ;
					$pictureWuu->setDate($startSunday) ;
					$pictureWuu->setCount($count) ;
					$pictureWuu->save() ;
				}















				$c = new Criteria() ;
				$c->add(PictureCommentCountPeer::DEL_FLG,0) ;
				$c->add(PictureCommentCountPeer::APP_ID,$appId) ;
				$c->add(PictureCommentCountPeer::DATE,$yesterday) ;
				$pictureCommentCount = PictureCommentCountPeer::doSelectOne($c) ;
				if(!$pictureCommentCount){
					$c = new Criteria() ;
					$c->addJoin(PictureCommentPeer::SOCIAL_USER_ID,SocialUserPeer::ID) ;
					$c->addAnd(SocialUserPeer::APP_ID,$appId) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$startTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$endTimeString,Criteria::LESS_THAN) ;
					$count = PictureCommentPeer::doCount($c) ;
					print($count."\n") ;
					$pictureCommentCount = new PictureCommentCount() ;
					$pictureCommentCount->setAppId($appId) ;
					$pictureCommentCount->setDate($yesterday) ;
					$pictureCommentCount->setCount($count) ;
					$pictureCommentCount->save() ;
				}

				$c = new Criteria() ;
				$c->add(PictureCommentUuCountPeer::DEL_FLG,0) ;
				$c->add(PictureCommentUuCountPeer::APP_ID,$appId) ;
				$c->add(PictureCommentUuCountPeer::DATE,$yesterday) ;
				$pictureCommentUuCount = PictureCommentUuCountPeer::doSelectOne($c) ;
				if(!$pictureCommentUuCount){
					$c = new Criteria() ;
					$c->addJoin(PictureCommentPeer::SOCIAL_USER_ID,SocialUserPeer::ID) ;
					$c->addAnd(SocialUserPeer::APP_ID,$appId) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$startTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$endTimeString,Criteria::LESS_THAN) ;
					$c->addGroupByColumn('social_user_id');
					$count = PictureCommentPeer::doCount($c) ;
					print($count."\n") ;
					$pictureCommentUu = new PictureCommentUuCount() ;
					$pictureCommentUu->setAppId($appId) ;
					$pictureCommentUu->setDate($yesterday) ;
					$pictureCommentUu->setCount($count) ;
					$pictureCommentUu->save() ;
				}

				$c = new Criteria() ;
				$c->add(PictureCommentMuuCountPeer::DEL_FLG,0) ;
				$c->add(PictureCommentMuuCountPeer::APP_ID,$appId) ;
				$c->add(PictureCommentMuuCountPeer::DATE,$firstDayOfLastMonth) ;
				$pictureCommentMuuCount = PictureCommentMuuCountPeer::doSelectOne($c) ;
				if(!$pictureCommentMuuCount){
					$c = new Criteria() ;
					$c->addJoin(PictureCommentPeer::SOCIAL_USER_ID,SocialUserPeer::ID) ;
					$c->addAnd(SocialUserPeer::APP_ID,$appId) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$lastMonthTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$thisMonthTimeString,Criteria::LESS_THAN) ;
					$c->addGroupByColumn('social_user_id');
					$count = PictureCommentPeer::doCount($c) ;
					print($count."\n") ;
					$pictureCommentMuu = new PictureCommentMuuCount() ;
					$pictureCommentMuu->setAppId($appId) ;
					$pictureCommentMuu->setDate($firstDayOfLastMonth) ;
					$pictureCommentMuu->setCount($count) ;
					$pictureCommentMuu->save() ;
				}

				$c = new Criteria() ;
				$c->add(PictureCommentWuuCountPeer::DEL_FLG,0) ;
				$c->add(PictureCommentWuuCountPeer::APP_ID,$appId) ;
				$c->add(PictureCommentWuuCountPeer::DATE,$startSunday) ;
				$pictureCommentWuuCount = PictureCommentWuuCountPeer::doSelectOne($c) ;
				if(!$pictureCommentWuuCount){
					$c = new Criteria() ;
					$c->addJoin(PictureCommentPeer::SOCIAL_USER_ID,SocialUserPeer::ID) ;
					$c->addAnd(SocialUserPeer::APP_ID,$appId) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$startSundayTimeString,Criteria::GREATER_EQUAL) ;
					$c->addAnd(PictureCommentPeer::CREATED_AT,$endSundayTimeString,Criteria::LESS_THAN) ;
					$c->addGroupByColumn('social_user_id');
					$count = PictureCommentPeer::doCount($c) ;
					print($count."\n") ;
					$pictureCommentWuu = new PictureCommentWuuCount() ;
					$pictureCommentWuu->setAppId($appId) ;
					$pictureCommentWuu->setDate($startSunday) ;
					$pictureCommentWuu->setCount($count) ;
					$pictureCommentWuu->save() ;
				}
			}
		}






/*
		$pictures = PicturePeer::doSelect($c) ;
		foreach($pictures as $picture){
			print($picture->getForumId()."\n") ;
		}
*/
	}


}
