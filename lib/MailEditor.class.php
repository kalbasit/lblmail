<?php

class MailEditor {

	/** this represents the path to the mailFile */
	protected $_mailFile;

	/** This represents the header part of the mail */
	protected $_header = null;

	/** This represents the body part of the mail */
	protected $_body = null;

	/**
	 * This functions extracts the mail header and record it in $_header (protected)
	 *
	 * @return void
	 */
	protected function _extractHeader() {}

	/**
	 * This function extract the body and record it in $_body (protected)
	 *
	 * @return void
	 */
	protected function _extractBody() {}


	/**
	 * Create an email editor object out of an email file (NOT an mbox file)
	 *
	 * @param string $mailFile The path to the mail file
	 * @return $this
	 */
	public function __construct($mailFile) {

		/** Sanity check */
		if(file_exists($mailFile) === false) {
			throw new Exception($mailFile . ' does not exist or can not be opened');
		}

		/** record the path */
		$this->_mailFile = $mailFile;

		/** Extract the header */
		$this->_extractHeader();

		/** Extract the body */
		$this->_extractBody();
	}

	/**
	 * Do given operations on the mail
	 *
	 * @param array $operations
	 * @return bool
	 */
	public function doOperations($operations) {}

	/**
	 * Save the mail to mailFile
	 *
	 * @return bool
	 */
	public function save() {}
}
?>