#!/usr/local/bin/php
<?php
/**
* $Id: example.php 37 2008-11-27 00:31:13Z don.schonknecht $
*
* S3 class usage
*/


if (!class_exists('S3')) require_once 'S3.php';

// AWS access info
if (!defined('awsAccessKey')) define('awsAccessKey', '__AWS_ACCESS_KEY__');
if (!defined('awsSecretKey')) define('awsSecretKey', '__AWS_SECRET_KEY__');

//$uploadFile = dirname(__FILE__).'/S3.php'; // File to upload, we'll use the S3 class since it exists
$uploadFile = $argv[1] ;
$uploadDirectory = $argv[2] ;
$bucketName = 'veamsxsw' ; // Temporary bucket
$uri = sprintf("%s/%s",$uploadDirectory,baseName($uploadFile)) ;

// If you want to use PECL Fileinfo for MIME types:
//if (!extension_loaded('fileinfo') && @dl('fileinfo.so')) $_ENV['MAGIC'] = '/usr/share/file/magic';


// Check if our upload file exists
if (!file_exists($uploadFile) || !is_file($uploadFile))
	exit("\nERROR: No such file: $uploadFile\n\n");

// Check for CURL
if (!extension_loaded('curl') && !@dl(PHP_SHLIB_SUFFIX == 'so' ? 'curl.so' : 'php_curl.dll'))
	exit("\nERROR: CURL extension not loaded\n\n");

// Pointless without your keys!
if (awsAccessKey == 'change-this' || awsSecretKey == 'change-this')
	exit("\nERROR: AWS access information required\n\nPlease edit the following lines in this file:\n\n".
	"define('awsAccessKey', 'change-me');\ndefine('awsSecretKey', 'change-me');\n\n");

// Instantiate the class
$s3 = new S3(awsAccessKey, awsSecretKey);

// List your buckets:
//echo "S3::listBuckets(): ".print_r($s3->listBuckets(), 1)."\n";

// Put our file (also with public read access)
if ($s3->putObjectFile($uploadFile, $bucketName, $uri, S3::ACL_PUBLIC_READ)) {
	echo "1".PHP_EOL;
	//echo "S3::putObjectFile(): File copied to {$bucketName}/".baseName($uploadFile).PHP_EOL;
} else {
	echo "S3::putObjectFile(): Failed to copy file\n";
}


