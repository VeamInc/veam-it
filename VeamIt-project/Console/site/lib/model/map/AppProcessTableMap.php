<?php


/**
 * This class defines the structure of the 'app_process' table.
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
class AppProcessTableMap extends TableMap {

	/**
	 * The (dot-path) name of this class
	 */
	const CLASS_NAME = 'lib.model.map.AppProcessTableMap';

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
		$this->setName('app_process');
		$this->setPhpName('AppProcess');
		$this->setClassname('AppProcess');
		$this->setPackage('lib.model');
		$this->setUseIdGenerator(true);
		// columns
		$this->addPrimaryKey('ID', 'Id', 'INTEGER', true, 11, null);
		$this->addColumn('APP_PROCESS_CATEGORY_ID', 'AppProcessCategoryId', 'INTEGER', true, 11, null);
		$this->addColumn('KIND', 'Kind', 'INTEGER', true, 11, 1);
		$this->addColumn('DEPENDS_ON', 'DependsOn', 'LONGVARCHAR', true, null, null);
		$this->addColumn('NAME', 'Name', 'LONGVARCHAR', true, null, null);
		$this->addColumn('HELP_URL', 'HelpUrl', 'LONGVARCHAR', true, null, null);
		$this->addColumn('INFO_ACTION', 'InfoAction', 'LONGVARCHAR', true, null, null);
		$this->addColumn('NEXT_PROCESS1', 'NextProcess1', 'INTEGER', true, 11, null);
		$this->addColumn('NEXT_TEXT1', 'NextText1', 'LONGVARCHAR', true, null, null);
		$this->addColumn('NEXT_PROCESS2', 'NextProcess2', 'INTEGER', true, 11, null);
		$this->addColumn('NEXT_TEXT2', 'NextText2', 'LONGVARCHAR', true, null, null);
		$this->addColumn('NEXT_PROCESS3', 'NextProcess3', 'INTEGER', true, 11, null);
		$this->addColumn('NEXT_TEXT3', 'NextText3', 'LONGVARCHAR', true, null, null);
		$this->addColumn('ORDER', 'Order', 'INTEGER', true, 11, null);
		$this->addColumn('DEL_FLAG', 'DelFlag', 'INTEGER', true, 11, 0);
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

} // AppProcessTableMap
