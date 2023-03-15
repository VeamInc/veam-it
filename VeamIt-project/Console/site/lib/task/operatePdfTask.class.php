<?php

class operatePdfTask extends sfBaseTask
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
    $this->name             = 'operatePdf';
    $this->briefDescription = '';
    $this->detailedDescription = <<<EOF
The [operatePdf|INFO] task does things.
Call it with:

  [php symfony operatePdf|INFO]
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
		$c->add(PdfSourcePeer::STATUS,4) ;
		$pdfSource = PdfSourcePeer::doSelectOne($c) ;
		if($pdfSource){
			// There is a encoding pdf source
		} else {
			$c = new Criteria() ;
			$c->add(PdfSourcePeer::STATUS,0) ; // waiting
			$c->addAscendingOrderByColumn(PdfSourcePeer::ID) ;
			$pdfSource = PdfSourcePeer::doSelectOne($c) ;
			if($pdfSource){
				$pdfId = $pdfSource->getPdfId() ;

				$c = new Criteria() ;
				$c->add(PdfSourcePeer::STATUS,0) ; // waiting
				$c->add(PdfSourcePeer::PDF_ID,$pdfId) ;
				$c->addAscendingOrderByColumn(PdfSourcePeer::ID) ;
				$pdfSources = PdfSourcePeer::doSelectOne($c) ;
				$count = count($pdfSources) ;
				if($count > 1){
					// There are 
					for($index = 0 ; $index < ($count - 1) ; $index++){
						$skipPdfSource = $pdfSources[$index] ;
						$skipPdfSource->setStatus(3) ; // skipped
						$skipPdfSource->save() ;
					}
					$pdfSourceToBeEncoded = $pdfSources[$count-1] ;
				} else {
					$pdfSourceToBeEncoded = $pdfSource ;
				}



				$appId = $pdfSourceToBeEncoded->getAppId() ;
				$pdfId = $pdfSourceToBeEncoded->getPdfId() ;
				$pdf = PdfPeer::retrieveByPk($pdfId) ;
				if($pdf){
					$url = $pdfSourceToBeEncoded->getUrl() ;
					if(!preg_match('/dl=1/',$url)){
						$url .= '?dl=1' ;
					}

					$imageSourceUrl = $pdfSourceToBeEncoded->getImageUrl() ;
					if($imageSourceUrl){
						if(!preg_match('/dl=1/',$imageSourceUrl)){
							$imageSourceUrl .= '?dl=1' ;
						}
					}

					$commandDir = sprintf("%s/../../bin/pdf",$libDir) ;


					// status ‚ð4(encoding)‚ÉØ‚è‘Ö‚¦
					$pdfSourceToBeEncoded->setStatus(4) ;
					$pdfSourceToBeEncoded->save() ;


					$circleImageUrl = "" ;
					$rectangleImageUrl = "" ;
					if($imageSourceUrl){
						$command = sprintf("perl %s/do_crop_image.pl %s %s",$commandDir,$pdfId,$imageSourceUrl) ;
						print("$command\n") ;
						system($command) ;

						// circle
						$sourceImageFilePath = sprintf("%s/encoded/image%d.png",$commandDir,$pdfId) ;
						if(file_exists($sourceImageFilePath)){

							$fileName = sprintf("i%s_%s_%04d.png",$pdfId,date('YmdHis'),rand(0,9999)) ;
							$renamedImageFilePath = sprintf("%s/encoded/%s",$commandDir,$fileName) ;
							rename($sourceImageFilePath,$renamedImageFilePath) ;


							$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/pdfs',$commandDir,$renamedImageFilePath,$appId) ;
							print("$commandLine\n") ;
							exec($commandLine,$outputs) ;
							if($outputs[0] == '1'){
								$circleImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/pdfs/%s",$appId,$fileName) ;
								print(sprintf('imageUrl=%s',$circleImageUrl));
							}
							unlink($renamedImageFilePath) ;
						}

						// 240x180
						$sourceImageFilePath = sprintf("%s/encoded/image%d_16x9.jpg",$commandDir,$pdfId) ;
						if(file_exists($sourceImageFilePath)){

							$rectangleImagefileSize = filesize($sourceImageFilePath) ;
							$fileName = sprintf("i%s_%s_%04d_16x9.jpg",$pdfId,date('YmdHis'),rand(0,9999)) ;
							$renamedImageFilePath = sprintf("%s/encoded/%s",$commandDir,$fileName) ;
							rename($sourceImageFilePath,$renamedImageFilePath) ;


							$commandLine = sprintf('php %s/UploadToS3Directory.php %s a/%s/pdfs',$commandDir,$renamedImageFilePath,$appId) ;
							print("$commandLine\n") ;
							exec($commandLine,$outputs) ;
							if($outputs[0] == '1'){
								$rectangleImageUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/pdfs/%s",$appId,$fileName) ;
								print(sprintf('imageUrl=%s',$rectangleImageUrl));
							}
							unlink($renamedImageFilePath) ;
						}

					}

					// encode
					//print(sprintf("encode %s %s %s",$pdfSourceToBeEncoded->getId(),$pdfSourceToBeEncoded->getPdfId(),$pdfSourceToBeEncoded->getUrl())) ;
					$command = sprintf("perl %s/do_encode.pl %s %s",$commandDir,$pdfId,$url) ;
					print("$command\n") ;
					system($command) ;

					$encodedPdfFilePath = sprintf("%s/encoded/p%s.pdf",$commandDir,$pdfId) ;
					if(file_exists($encodedPdfFilePath)){
						$fileSize = filesize($encodedPdfFilePath) ;

						$pdfTitle = str_replace('/',' ',$pdf->getTitle()) ;

						$fileDir = sprintf("%s_%s_%05d",date('YmdHis'),$pdfId,rand(0,99999)) ;
						$fileName = sprintf("%s.pdf",$pdfTitle) ;
						$renamedPdfFilePath = sprintf("%s/encoded/%s",$commandDir,$fileName) ;
						rename($encodedPdfFilePath,$renamedPdfFilePath) ;

						$outputs = array() ;
						$commandLine = sprintf('php %s/UploadToS3Directory.php "%s" a/%s/pdfs/%s',$commandDir,$renamedPdfFilePath,$appId,$fileDir) ;
						print("$commandLine\n") ;
						exec($commandLine,$outputs) ;
						if($outputs[0] == '1'){
							$pdfUrl = sprintf("http://__CLOUD_FRONT_HOST__/a/%s/pdfs/%s/%s",$appId,$fileDir,$fileName) ;
							print(sprintf('pdfUrl=%s',$pdfUrl));

							$pdf->setPdfUrl($pdfUrl) ;
							if($rectangleImageUrl){
								$pdf->setThumbnailUrl($rectangleImageUrl) ;
								$pdf->setThumbnailSize($rectangleImagefileSize) ;
							}

							// set sellPdf status
							$c = new Criteria() ;
							$c->add(SellPdfPeer::STATUS,2) ; // preparing
							$c->add(SellPdfPeer::PDF_ID,$pdfId) ;
							$sellPdfs = SellPdfPeer::doSelect($c) ;
							foreach($sellPdfs as $sellPdf){
								$sellPdf->setStatus(3) ; // Submitting
								$sellPdf->setStatusText('Waiting for approval') ; // Submitting
								$sellPdf->save() ;

								$app = AppPeer::retrieveByPk($appId) ;
								if($app){
									if($app->getStatus() == 0){
										$appName = $app->getName() ;
										$title = $pdf->getTitle() ;
										$productId = $sellPdf->getProduct() ;
										$priceText = $sellPdf->getPriceText() ;

										$message = sprintf("The following content has been uploaded.\n\nApp : %s \nKind : PDF \nTitle : %s \nPrice : %s \nProductID : %s \n",$appName,$title,$priceText,$productId) ;
										ConsoleTools::sendInfoMail("[VEAMIT] PPC content uploaded","ppc_notification@veam.co",$message) ;
									}
								}
							}

							// set sellSectionItem status
							$c = new Criteria() ;
							$c->add(SellSectionItemPeer::STATUS,2) ; // preparing
							$c->add(SellSectionItemPeer::KIND,2) ; // PDF
							$c->add(SellSectionItemPeer::CONTENT_ID,$pdfId) ;
							$sellSectionItems = SellSectionItemPeer::doSelect($c) ;
							foreach($sellSectionItems as $sellSectionItem){
								$sellSectionItem->setStatus(0) ; // Ready
								$sellSectionItem->setStatusText('Ready') ; // 
								$sellSectionItem->save() ;
							}

							$pdf->save() ;


							$pdfSourceToBeEncoded->setStatus(1) ;
							$pdfSourceToBeEncoded->setInfo($info) ;
							$pdfSourceToBeEncoded->save() ;

							ConsoleTools::consoleContentsChanged($pdfSourceToBeEncoded->getAppId()) ;

						} else {
							print(sprintf('result=%s',implode(" - ",$outputs)));
							$pdfSourceToBeEncoded->setStatus(2) ; // failed
							$pdfSourceToBeEncoded->setResult(sprintf('upload failed %s:%d',__FILE__,__LINE__)) ;
							$pdfSourceToBeEncoded->save() ;
						}
						unlink($renamedPdfFilePath) ;
					} else {
						// no encoded file
						$pdfSourceToBeEncoded->setStatus(2) ; // failed
						$pdfSourceToBeEncoded->setResult(sprintf('no encoded file %s:%d',__FILE__,__LINE__)) ;
						$pdfSourceToBeEncoded->save() ;
						//ConsoleTools::assert(false,"Failed to encode",__FILE__,__LINE__) ;
						ConsoleTools::assert(false,sprintf("Failed to encode\n\npdf url=%s\n\napp=%s\n\npdfId=%s",$url,$appId,$pdfId),__FILE__,__LINE__) ;
					}
					// send result mail
				} else {
					// no pdf found
					$pdfSourceToBeEncoded->setStatus(3) ; // skipped
					$pdfSourceToBeEncoded->setResult(sprintf('no pdf found %s:%d',__FILE__,__LINE__)) ;
					$pdfSourceToBeEncoded->save() ;
				}
			} else {
				// no pdf source to be encoded
			}
		}
	}


}
