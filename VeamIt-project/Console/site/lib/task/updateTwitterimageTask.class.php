<?php

class updateTwitterimageTask extends sfBaseTask
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
    $this->addOption('pageno', null, sfCommandOption::PARAMETER_REQUIRED, 'pageno', '');
    $this->addOption('amount', null, sfCommandOption::PARAMETER_REQUIRED, 'amount', '');

    $this->namespace        = '';
    $this->name             = 'updateTwitterimage';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [updateTwitterimage|INFO] task does things.
Call it with:

  [php symfony updateTwitterimage|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

//		require_once('twitteroauth/twitteroauth.php');

		$rootDir = sfConfig::get('sf_root_dir') ;
		$libDir = sfConfig::get("sf_lib_dir") ; 

		$pageNo = $options['pageno'] ;
		$amount = $options['amount'] ;
		if($amount <= 100){
			$criteria = new Criteria() ;
			$criteria->add(SocialUserPeer::DEL_FLG, 0) ;
			$criteria->add(SocialUserPeer::TWITTER_ID, "",Criteria::NOT_EQUAL) ;
			$criteria->addAscendingOrderByColumn(SocialUserPeer::ID) ; 

			$pager = new sfPropelPager('SocialUser', $amount) ;
			$pager->setCriteria($criteria) ;
			$pager->setPage($pageNo) ;
			$pager->init() ;
			$lastPageNo = $pager->getLastPage() ;
			if($pageNo <= $lastPageNo){
				$socialUsers = $pager->getResults() ;

				$numberOfUsers = count($socialUsers) ;
				$userIds = "" ;
				$socialUserList = array() ;
				foreach($socialUsers as $socialUser){
					$twitterId = $socialUser->getTwitterId() ;
					if($twitterId > 1000){
						$socialUserList[$twitterId] = $socialUser ;
						if($userIds){
							$userIds .= ",".$twitterId ;
						} else {
							$userIds = $twitterId ;
						}
					}
				}
				if($userIds){
					$this->doUpdate($userIds,$socialUserList) ;
				}
			}
		} else {
			print("should be less than 100\n") ;
		}
	}

	private function doUpdate($userIds,$socialUserList)
	{
		//print("user_id=".$userIds."\n") ;

		$connection = new TwitterOAuth(
			"__TWITTER_CONSUMER_KEY__", 
			"__TWITTER_CONSUMER_SECRET__", 
			"", 
			"");
		$parameters = array('user_id' => $userIds);
		$users = $connection->post('users/lookup',$parameters);
		foreach($users as $user){
			$twitterId = $user->id_str ;
			if($twitterId != ""){
				$name = $user->name ;
				$imageUrl = $user->profile_image_url_https ;
				$imageUrl = str_replace('_normal.','_bigger.',$imageUrl) ;
				$socialUser = $socialUserList[$twitterId] ;
				if($socialUser){
					$orgName = $socialUser->getName() ;
					$orgImageUrl = $socialUser->getProfileImage() ;
					$modified = 0 ; 

					if($orgName != $name){
						$socialUser->setName($name) ;
						$modified = 1 ;
					}

					if($orgImageUrl != $imageUrl){
						$socialUser->setProfileImage($imageUrl) ;
						$modified = 1 ;
					}

					if($modified){
						$socialUser->save() ;
						print(sprintf("social_user=%d : name %s -> %s : image %s -> %s : %s\n",$socialUser->getId(),$orgName,$socialUser->getName(),$orgImageUrl,$socialUser->getProfileImage(),$user->screen_name)) ;
					}
				}
			}
		}
	}
}
