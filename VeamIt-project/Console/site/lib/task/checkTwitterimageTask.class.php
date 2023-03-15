<?php

class checkTwitterimageTask extends sfBaseTask
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
    $this->name             = 'checkTwitterimage';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [checkTwitterimage|INFO] task does things.
Call it with:

  [php symfony checkTwitterimage|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here

		$rootDir = sfConfig::get('sf_root_dir') ;
		$libDir = sfConfig::get("sf_lib_dir") ; 

		$amount = 100 ;

		$logFilePath = sprintf("%s/update_twitter_image/update_twitter_image_%s.log",sfConfig::get('sf_log_dir'),date('YmdHis')) ; 
		$errorFilePath = sprintf("%s/update_twitter_image/update_twitter_image_error_%s.log",sfConfig::get('sf_log_dir'),date('YmdHis')) ; 

		$criteria = new Criteria() ;
		$criteria->add(SocialUserPeer::DEL_FLG, 0) ;
		$criteria->add(SocialUserPeer::TWITTER_ID, "",Criteria::NOT_EQUAL) ;
		$criteria->addAscendingOrderByColumn(SocialUserPeer::ID) ; 

		$pager = new sfPropelPager('SocialUser', $amount) ;
		$pager->setCriteria($criteria) ;
		$pager->setPage(1) ;
		$pager->init() ;
		$lastPageNo = $pager->getLastPage() ;
		for($pageNo = 1 ; $pageNo <= $lastPageNo ; $pageNo++){
			$command = sprintf("php %s/symfony updateTwitterimage --amount=\"%d\" --pageno=\"%d\" >>%s 2>>%s",$rootDir,$amount,$pageNo,$logFilePath,$errorFilePath) ;
			//print("$command\n") ;
			$return = system($command) ;
			sleep(20) ;
		}
	}
}
