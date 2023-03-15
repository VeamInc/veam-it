<?php


/**
 * This class defines the structure of the 'theme' table.
 *
 *
 * This class was autogenerated by Propel 1.4.2 on:
 *
 * Wed Dec 13 16:31:11 2017
 *
 *
 * This map class is used by Propel to do runtime db structure discovery.
 * For example, the createSelectSql() method checks the type of a given column used in an
 * ORDER BY clause to know whether it needs to apply SQL to make the ORDER BY case-insensitive
 * (i.e. if it's a text column type).
 *
 * @package    lib.model.map
 */
class ThemeTableMap extends TableMap {

	/**
	 * The (dot-path) name of this class
	 */
	const CLASS_NAME = 'lib.model.map.ThemeTableMap';

	/**
	 * Initialize the table attributes, columns and validators
	 * Relations are not initialized by this method since they are lazy loaded
	 *
	 * @return     void
	 * @throws     PropelException
	 */
	public function initialize()
	{
	  // attributes
		$this->setName('theme');
		$this->setPhpName('Theme');
		$this->setClassname('Theme');
		$this->setPackage('lib.model');
		$this->setUseIdGenerator(true);
		// columns
		$this->addPrimaryKey('ID', 'Id', 'INTEGER', true, 11, null);
		$this->addColumn('APP_ID', 'AppId', 'INTEGER', true, 11, null);
		$this->addColumn('PRODUCT', 'Product', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TITLE', 'Title', 'LONGVARCHAR', true, null, null);
		$this->addColumn('DESCRIPTION', 'Description', 'LONGVARCHAR', true, null, null);
		$this->addColumn('BASE_URL', 'BaseUrl', 'LONGVARCHAR', true, null, null);
		$this->addColumn('THUMBNAIL_NAME', 'ThumbnailName', 'LONGVARCHAR', true, null, null);
		$this->addColumn('SCREENSHOTS', 'Screenshots', 'LONGVARCHAR', true, null, null);
		$this->addColumn('IMAGES', 'Images', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TOP_COLOR', 'TopColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TOP_TEXT_COLOR', 'TopTextColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TOP_TEXT_FONT', 'TopTextFont', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TOP_TEXT_SIZE', 'TopTextSize', 'LONGVARCHAR', true, null, null);
		$this->addColumn('BASE_TEXT_COLOR', 'BaseTextColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('LINK_TEXT_COLOR', 'LinkTextColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('BACKGROUND_COLOR', 'BackgroundColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('MASK_COLOR', 'MaskColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('POST_TEXT_COLOR', 'PostTextColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('STATUS_BAR_COLOR', 'StatusBarColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('STATUS_BAR_STYLE', 'StatusBarStyle', 'INTEGER', true, 11, null);
		$this->addColumn('SEPARATOR_COLOR', 'SeparatorColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TEXT1_COLOR', 'Text1Color', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TEXT2_COLOR', 'Text2Color', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TEXT3_COLOR', 'Text3Color', 'LONGVARCHAR', true, null, null);
		$this->addColumn('QUESTION_HEADER_COLOR', 'QuestionHeaderColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('QUESTION_HEADER_TEXT_COLOR', 'QuestionHeaderTextColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('PRICE', 'Price', 'INTEGER', true, 11, 99);
		$this->addColumn('DEL_FLG', 'DelFlg', 'INTEGER', true, 11, 0);
		$this->addColumn('CREATED_AT', 'CreatedAt', 'TIMESTAMP', false, null, null);
		$this->addColumn('UPDATED_AT', 'UpdatedAt', 'TIMESTAMP', false, null, null);
		// validators
	} // initialize()

	/**
	 * Build the RelationMap objects for this table relationships
	 */
	public function buildRelations()
	{
	} // buildRelations()

	/**
	 * 
	 * Gets the list of behaviors registered for this table
	 * 
	 * @return array Associative array (name => parameters) of behaviors
	 */
	public function getBehaviors()
	{
		return array(
			'symfony' => array('form' => 'true', 'filter' => 'true', ),
			'symfony_behaviors' => array(),
			'symfony_timestampable' => array('create_column' => 'created_at', 'update_column' => 'updated_at', ),
		);
	} // getBehaviors()

} // ThemeTableMap
