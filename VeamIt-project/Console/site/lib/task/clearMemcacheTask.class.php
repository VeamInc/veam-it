<?php

class clearMemcacheTask extends sfBaseTask
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
    $this->name             = 'clearMemcache';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [clearMemcache|INFO] task does things.
Call it with:

  [php symfony clearMemcache|INFO]
EOF;
  }

	protected function execute($arguments = array(), $options = array())
	{
		// initialize the database connection
		$databaseManager = new sfDatabaseManager($this->configuration);
		$connection = $databaseManager->getDatabase($options['connection'])->getConnection();

		// add your code here


		ConsoleTools::deleteMemcacheValue('publicAPI2_CONTENT_XML31001185') ;
		ConsoleTools::deleteMemcacheValue('publicAPI2_CONTENT_ID31001185') ;

	}
}
