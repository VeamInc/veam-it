<?php

class uploadProgramTask extends sfBaseTask
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
    $this->name             = 'uploadProgram';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [uploadProgram|INFO] task does things.
Call it with:

  [php symfony uploadProgram|INFO]
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

		//status 0:waiting 1:encoded 2:failed 3:skipped 4:encoding
		$c = new Criteria() ;
		$c->add(ProgramSourcePeer::STATUS,4) ;
		$programSource = ProgramSourcePeer::doSelectOne($c) ;
		if($programSource){
			// There is a encoding program source
		} else {
			$c = new Criteria() ;
			$c->add(ProgramSourcePeer::STATUS,0) ; // waiting
			$c->addAscendingOrderByColumn(ProgramSourcePeer::ID) ;
			$programSource = ProgramSourcePeer::doSelectOne($c) ;
			if($programSource){
				$programId = $programSource->getProgramId() ;

				$c = new Criteria() ;
				$c->add(ProgramSourcePeer::STATUS,0) ; // waiting
				$c->add(ProgramSourcePeer::PROGRAM_ID,$programId) ;
				$c->addAscendingOrderByColumn(ProgramSourcePeer::ID) ;
				$programSources = ProgramSourcePeer::doSelectOne($c) ;
				$count = count($programSources) ;
				if($count > 1){
					// There are 
					for($index = 0 ; $index < ($count - 1) ; $index++){
						$skipProgramSource = $programSources[$index] ;
						$skipProgramSource->setStatus(3) ; // skipped
						$skipProgramSource->save() ;
					}
					$programSourceToBeEncoded = $programSources[$count-1] ;
				} else {
					$programSourceToBeEncoded = $programSource ;
				}



				$appId = $programSourceToBeEncoded->getAppId() ;
				$programId = $programSourceToBeEncoded->getProgramId() ;
				$program = ProgramPeer::retrieveByPk($programId) ;
				if($program){
					$dataUrl = $programSourceToBeEncoded->getDataUrl() ;
					if(!preg_match('/dl=1/',$dataUrl)){
						$dataUrl .= '?dl=1' ;
					}

					$imageUrl = $programSourceToBeEncoded->getImageUrl() ;
					if(!preg_match('/dl=1/',$imageUrl)){
						$imageUrl .= '?dl=1' ;
					}


					$commandDir = sprintf("%s/../../bin/program",$libDir) ;


					// status ‚ð4(encoding)‚ÉØ‚è‘Ö‚¦
					$programSourceToBeEncoded->setStatus(4) ;
					$programSourceToBeEncoded->save() ;

					// encode
					//print(sprintf("encode %s %s %s",$programSourceToBeEncoded->getId(),$programSourceToBeEncoded->getProgramId(),$programSourceToBeEncoded->getUrl())) ;
					$command = sprintf("perl %s/do_data_download.pl %s %s %s",$commandDir,$programId,$dataUrl,$imageUrl) ;
					print("$command\n") ;
					system($command) ;

					$encodedProgramFilePath = sprintf("%s/program%s_SOURCE.dat",$commandDir,$programId) ;
					$smallImageFilePath = sprintf("%s/image%s/i3.png",$commandDir,$programId) ;
					$largeImageFilePath = sprintf("%s/image%s/i2.png",$commandDir,$programId) ;
					$encodedProgramFilePath = sprintf("%s/program%s_SOURCE.dat",$commandDir,$programId) ;
					if(file_exists($encodedProgramFilePath)){
						$fileSize = filesize($encodedProgramFilePath) ;
						$fileName = sprintf("p%s_%s_%04d.dat",$programId,date('YmdHis'),rand(0,9999)) ;
						$renamedProgramFilePath = sprintf("%s/%s",$commandDir,$fileName) ;
						rename($encodedProgramFilePath,$renamedProgramFilePath) ;

						$outputs = array() ;
						$commandLine = sprintf('php %s/UploadToS3Directory.php %s program/%s',$commandDir,$renamedProgramFilePath,$programId) ;
						print("$commandLine\n") ;
						exec($commandLine,$outputs) ;

						if($outputs[0] == '1'){
							$programUrl = sprintf("http://__CLOUD_FRONT_HOST__/program/%s/%s",$programId,$fileName) ;
							print(sprintf('programUrl=%s',$programUrl));


							if(file_exists($smallImageFilePath)){
								$fileName = sprintf("s%s_%s_%04d.png",$programId,date('YmdHis'),rand(0,9999)) ;
								$renamedSmallImageFilePath = sprintf("%s/image%s/%s",$commandDir,$programId,$fileName) ;
								rename($smallImageFilePath,$renamedSmallImageFilePath) ;

								$outputs = array() ;
								$commandLine = sprintf('php %s/UploadToS3Directory.php %s program/%s',$commandDir,$renamedSmallImageFilePath,$programId) ;
								print("$commandLine\n") ;
								exec($commandLine,$outputs) ;
								if($outputs[0] == '1'){
									$smallImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/program/%s/%s",$programId,$fileName) ;
									print(sprintf('smallImageUrl=%s',$smallImageUrl));
								}
							}

							if(file_exists($largeImageFilePath)){
								$fileName = sprintf("l%s_%s_%04d.png",$programId,date('YmdHis'),rand(0,9999)) ;
								$renamedLargeImageFilePath = sprintf("%s/image%s/%s",$commandDir,$programId,$fileName) ;
								rename($largeImageFilePath,$renamedLargeImageFilePath) ;

								$outputs = array() ;
								$commandLine = sprintf('php %s/UploadToS3Directory.php %s program/%s',$commandDir,$renamedLargeImageFilePath,$programId) ;
								print("$commandLine\n") ;
								exec($commandLine,$outputs) ;
								if($outputs[0] == '1'){
									$largeImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/program/%s/%s",$programId,$fileName) ;
									print(sprintf('largeImageUrl=%s',$largeImageUrl));
								}
							}


							//$program->setDuration($duration) ;
							$program->setDataUrl($programUrl) ;
							$program->setDataSize($fileSize) ;
							if($smallImageUrl){
								$program->setSmallImageUrl($smallImageUrl) ;
							}
							if($largeImageUrl){
								$program->setLargeImageUrl($largeImageUrl) ;
							}
							$program->save() ;




							$programSourceToBeEncoded->setStatus(1) ;
							//$programSourceToBeEncoded->setInfo($info) ;
							$programSourceToBeEncoded->save() ;

							ConsoleTools::consoleContentsChanged($programSourceToBeEncoded->getAppId()) ;

						} else {
							print(sprintf('result=%s',implode(" - ",$outputs)));
							$programSourceToBeEncoded->setStatus(2) ; // failed
							$programSourceToBeEncoded->setResult(sprintf('upload failed %s:%d',__FILE__,__LINE__)) ;
							$programSourceToBeEncoded->save() ;
						}
						unlink($renamedProgramFilePath) ;
					} else {
						// no encoded file
						$programSourceToBeEncoded->setStatus(2) ; // failed
						$programSourceToBeEncoded->setResult(sprintf('no encoded file %s:%d',__FILE__,__LINE__)) ;
						$programSourceToBeEncoded->save() ;
						//ConsoleTools::assert(false,"Failed to encode",__FILE__,__LINE__) ;
						ConsoleTools::assert(false,sprintf("Failed to encode\n\nprogram url=%s\n\napp=%s\n\nprogramId=%s",$url,$appId,$programId),__FILE__,__LINE__) ;
					}
					// send result mail
				} else {
					// no program found
					$programSourceToBeEncoded->setStatus(3) ; // skipped
					$programSourceToBeEncoded->setResult(sprintf('no program found %s:%d',__FILE__,__LINE__)) ;
					$programSourceToBeEncoded->save() ;
				}
			} else {
				// no program source to be encoded
			}
		}
	}


}
