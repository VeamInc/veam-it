<?php


/**
 * This class defines the structure of the 'app_creator' table.
 *
 *
 * This class was autogenerated by Propel 1.4.2 on:
 *
 * Wed Dec 13 16:31:05 2017
 *
 *
 * This map class is used by Propel to do runtime db structure discovery.
 * For example, the createSelectSql() method checks the type of a given column used in an
 * ORDER BY clause to know whether it needs to apply SQL to make the ORDER BY case-insensitive
 * (i.e. if it's a text column type).
 *
 * @package    lib.model.map
 */
class AppCreatorTableMap extends TableMap {

	/**
	 * The (dot-path) name of this class
	 */
	const CLASS_NAME = 'lib.model.map.AppCreatorTableMap';

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
		$this->setName('app_creator');
		$this->setPhpName('AppCreator');
		$this->setClassname('AppCreator');
		$this->setPackage('lib.model');
		$this->setUseIdGenerator(true);
		// columns
		$this->addPrimaryKey('ID', 'Id', 'INTEGER', true, 11, null);
		$this->addColumn('APP_ID', 'AppId', 'INTEGER', true, 11, null);
		$this->addColumn('USERNAME', 'Username', 'LONGVARCHAR', true, null, null);
		$this->addColumn('FIRST_NAME', 'FirstName', 'LONGVARCHAR', true, null, null);
		$this->addColumn('LAST_NAME', 'LastName', 'LONGVARCHAR', true, null, null);
		$this->addColumn('PASSWORD', 'Password', 'LONGVARCHAR', true, null, null);
		$this->addColumn('COMPANY_NAME', 'CompanyName', 'LONGVARCHAR', true, null, null);
		$this->addColumn('TELEPHONE', 'Telephone', 'LONGVARCHAR', true, null, null);
		$this->addColumn('SNS', 'Sns', 'LONGVARCHAR', true, null, null);
		$this->addColumn('VALIDATION_TOKEN', 'ValidationToken', 'LONGVARCHAR', true, null, null);
		$this->addColumn('APPROVAL_TOKEN', 'ApprovalToken', 'LONGVARCHAR', true, null, null);
		$this->addColumn('VALID', 'Valid', 'INTEGER', true, 11, 1);
		$this->addColumn('APPROVE', 'Approve', 'INTEGER', true, 11, 1);
		$this->addColumn('PRIVILAGES', 'Privilages', 'INTEGER', true, 11, 65535);
		$this->addColumn('EXPIRATION', 'Expiration', 'TIMESTAMP', true, null, '2030-01-01 00:00:00');
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

} // AppCreatorTableMap