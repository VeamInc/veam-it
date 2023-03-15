<?php

class reorderMixeddisplayorderTask extends sfBaseTask
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
    $this->name             = 'reorderMixeddisplayorder';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [reorderMixeddisplayorder|INFO] task does things.
Call it with:

  [php symfony |INFO]
EOF;
  }

  protected function execute($arguments = array(), $options = array())
  {
    // initialize the database connection
    $databaseManager = new sfDatabaseManager($this->configuration);
    $connection = $databaseManager->getDatabase($options['connection'])->getConnection();

    // add your code here
	$appId = $options['app_id'] ;

  	$c = new Criteria() ;
  	$c->add(MixedPeer::APP_ID,$appId) ;
  	$c->addDescendingorderByColumn(MixedPeer::CREATED_AT) ;
	$mixeds = MixedPeer::doSelect($c) ;
	$displayOrder = 1 ;
	foreach($mixeds as $mixed){
		print(sprintf("%d name=%s created=%s\n",$displayOrder,$mixed->getName(),$mixed->getCreatedAt())) ;
		$mixed->setDisplayOrder($displayOrder) ;
		$mixed->save() ;
		$displayOrder++ ;
	}

  }
}
