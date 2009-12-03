<?php

$HOME = getenv('HOME');

/** Define the location of the config file */
define('CONFIG_FILE_PATH', $HOME . '/.lblmailrc');

/** Define the share dir path */
define('SHARE_DIR', '@SHARE_DIR@');

/** Define the lib dir path */
define('LIB_DIR', realpath(dirname(__FILE__)));

/** Check if the user has actually created a config file, exception if not */
if(!file_exists(CONFIG_FILE_PATH)) {
	die("You should create " . CONFIG_FILE_PATH . " and put your configs there\nYou can copy the sample file from " . SHARE_DIR . "/lblmailrc.example\n");
}

/** Do we have an email file */
if(count($argv) < 2) {
	die("USAGE: lblmail <mail file>\n");
}

/** Get the mail file */
$mailFile = $argv[1];

/** define an empty operations */
$operations = array();

/** Include the config file */
require_once(CONFIG_FILE_PATH);

/** Include the Mail Class */
require_once(LIB_DIR . '/MailEditor.class.php');

/** Create the MailEditor object */
try {
	$mailEditor = new MailEditor($mailFile);
} catch (Exception $e) {
	die($e->getMessage() . "\n");
}

/** Pass all the operations from the config file */
try {
	$mailEditor->doOperations($operations);
} catch (Exception $e) {
	die($e->getMessage() . "\n");
}

/** Save the mail file */
try {
	$mailEditor->save();
} catch (Exception $e) {
	die($e->getMessage() . "\n");
}

?>