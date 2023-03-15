<?php


/**
 * This class defines the structure of the 'bulletin' table.
 *
 *
 * This class was autogenerated by Propel 1.4.2 on:
 *
 * Wed Dec 13 16:31:06 2017
 *
 *
 * This map class is used by Propel to do runtime db structure discovery.
 * For example, the createSelectSql() method checks the type of a given column used in an
 * ORDER BY clause to know whether it needs to apply SQL to make the ORDER BY case-insensitive
 * (i.e. if it's a text column type).
 *
 * @package    lib.model.map
 */
class BulletinTableMap extends TableMap {

	/**
	 * The (dot-path) name of this class
	 */
	const CLASS_NAME = 'lib.model.map.BulletinTableMap';

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
		$this->setName('bulletin');
		$this->setPhpName('Bulletin');
		$this->setClassname('Bulletin');
		$this->setPackage('lib.model');
		$this->setUseIdGenerator(true);
		// columns
		$this->addPrimaryKey('ID', 'Id', 'INTEGER', true, 11, null);
		$this->addColumn('APP_ID', 'AppId', 'LONGVARCHAR', true, null, null);
		$this->addColumn('START_AT', 'StartAt', 'TIMESTAMP', false, null, null);
		$this->addColumn('END_AT', 'EndAt', 'TIMESTAMP', false, null, null);
		$this->addColumn('INDEX', 'Index', 'INTEGER', true, 11, null);
		$this->addColumn('KIND', 'Kind', 'INTEGER', true, 11, null);
		$this->addColumn('BACKGROUND_COLOR', 'BackgroundColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TEXT_COLOR', 'TextColor', 'LONGVARCHAR', true, null, null);
		$this->addColumn('MESSAGE', 'Message', 'LONGVARCHAR', true, null, null);
		$this->addColumn('IMAGE_URL', 'ImageUrl', 'LONGVARCHAR', true, null, null);
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

} // BulletinTableMap
