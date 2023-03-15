<?php


/**
 * This class defines the structure of the 'music' table.
 *
 *
 * This class was autogenerated by Propel 1.4.2 on:
 *
 * Wed Dec 13 16:31:08 2017
 *
 *
 * This map class is used by Propel to do runtime db structure discovery.
 * For example, the createSelectSql() method checks the type of a given column used in an
 * ORDER BY clause to know whether it needs to apply SQL to make the ORDER BY case-insensitive
 * (i.e. if it's a text column type).
 *
 * @package    lib.model.map
 */
class MusicTableMap extends TableMap {

	/**
	 * The (dot-path) name of this class
	 */
	const CLASS_NAME = 'lib.model.map.MusicTableMap';

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
		$this->setName('music');
		$this->setPhpName('Music');
		$this->setClassname('Music');
		$this->setPackage('lib.model');
		$this->setUseIdGenerator(true);
		// columns
		$this->addPrimaryKey('ID', 'Id', 'INTEGER', true, 11, null);
		$this->addColumn('VIDEO_ID', 'VideoId', 'INTEGER', true, 11, null);
		$this->addColumn('DURATION', 'Duration', 'INTEGER', true, 11, null);
		$this->addColumn('EXPIRED_AT', 'ExpiredAt', 'TIMESTAMP', false, null, null);
		$this->addColumn('EXPLANATION', 'Explanation', 'LONGVARCHAR', true, null, null);
		$this->addColumn('PRICE', 'Price', 'INTEGER', true, 11, null);
		$this->addColumn('SUB_TITLE', 'SubTitle', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TITLE', 'Title', 'LONGVARCHAR', true, null, null);
		$this->addColumn('SAMPLE_URL', 'SampleUrl', 'LONGVARCHAR', true, null, null);
		$this->addColumn('SAMPLE_SIZE', 'SampleSize', 'INTEGER', true, 11, null);
		$this->addColumn('MUSIC_URL', 'MusicUrl', 'LONGVARCHAR', true, null, null);
		$this->addColumn('MUSIC_SIZE', 'MusicSize', 'INTEGER', true, 11, null);
		$this->addColumn('DEL_FLG', 'DelFlg', 'INTEGER', true, 11, 0);
		$this->addColumn('CREATED_AT', 'CreatedAt', 'TIMESTAMP', false, null, null);
		$this->addColumn('UPDATED_AT', 'UpdatedAt', 'TIMESTAMP', false, null, null);
		$this->addColumn('APP_ID', 'AppId', 'INTEGER', true, 11, null);
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

} // MusicTableMap
