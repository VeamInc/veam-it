<?php

/**
 * Base static class for performing query and update operations on the 'theme' table.
 *
 * 
 *
 * This class was autogenerated by Propel 1.4.2 on:
 *
 * Wed Dec 13 16:31:11 2017
 *
 * @package    lib.model.om
 */
abstract class BaseThemePeer {

	/** the default database name for this class */
	const DATABASE_NAME = 'propel';

	/** the table name for this class */
	const TABLE_NAME = 'theme';

	/** the related Propel class for this table */
	const OM_CLASS = 'Theme';

	/** A class that can be returned by this peer. */
	const CLASS_DEFAULT = 'lib.model.Theme';

	/** the related TableMap class for this table */
	const TM_CLASS = 'ThemeTableMap';
	
	/** The total number of columns. */
	const NUM_COLUMNS = 30;

	/** The number of lazy-loaded columns. */
	const NUM_LAZY_LOAD_COLUMNS = 0;

	/** the column name for the ID field */
	const ID = 'theme.ID';

	/** the column name for the APP_ID field */
	const APP_ID = 'theme.APP_ID';

	/** the column name for the PRODUCT field */
	const PRODUCT = 'theme.PRODUCT';

	/** the column name for the TITLE field */
	const TITLE = 'theme.TITLE';

	/** the column name for the DESCRIPTION field */
	const DESCRIPTION = 'theme.DESCRIPTION';

	/** the column name for the BASE_URL field */
	const BASE_URL = 'theme.BASE_URL';

	/** the column name for the THUMBNAIL_NAME field */
	const THUMBNAIL_NAME = 'theme.THUMBNAIL_NAME';

	/** the column name for the SCREENSHOTS field */
	const SCREENSHOTS = 'theme.SCREENSHOTS';

	/** the column name for the IMAGES field */
	const IMAGES = 'theme.IMAGES';

	/** the column name for the TOP_COLOR field */
	const TOP_COLOR = 'theme.TOP_COLOR';

	/** the column name for the TOP_TEXT_COLOR field */
	const TOP_TEXT_COLOR = 'theme.TOP_TEXT_COLOR';

	/** the column name for the TOP_TEXT_FONT field */
	const TOP_TEXT_FONT = 'theme.TOP_TEXT_FONT';

	/** the column name for the TOP_TEXT_SIZE field */
	const TOP_TEXT_SIZE = 'theme.TOP_TEXT_SIZE';

	/** the column name for the BASE_TEXT_COLOR field */
	const BASE_TEXT_COLOR = 'theme.BASE_TEXT_COLOR';

	/** the column name for the LINK_TEXT_COLOR field */
	const LINK_TEXT_COLOR = 'theme.LINK_TEXT_COLOR';

	/** the column name for the BACKGROUND_COLOR field */
	const BACKGROUND_COLOR = 'theme.BACKGROUND_COLOR';

	/** the column name for the MASK_COLOR field */
	const MASK_COLOR = 'theme.MASK_COLOR';

	/** the column name for the POST_TEXT_COLOR field */
	const POST_TEXT_COLOR = 'theme.POST_TEXT_COLOR';

	/** the column name for the STATUS_BAR_COLOR field */
	const STATUS_BAR_COLOR = 'theme.STATUS_BAR_COLOR';

	/** the column name for the STATUS_BAR_STYLE field */
	const STATUS_BAR_STYLE = 'theme.STATUS_BAR_STYLE';

	/** the column name for the SEPARATOR_COLOR field */
	const SEPARATOR_COLOR = 'theme.SEPARATOR_COLOR';

	/** the column name for the TEXT1_COLOR field */
	const TEXT1_COLOR = 'theme.TEXT1_COLOR';

	/** the column name for the TEXT2_COLOR field */
	const TEXT2_COLOR = 'theme.TEXT2_COLOR';

	/** the column name for the TEXT3_COLOR field */
	const TEXT3_COLOR = 'theme.TEXT3_COLOR';

	/** the column name for the QUESTION_HEADER_COLOR field */
	const QUESTION_HEADER_COLOR = 'theme.QUESTION_HEADER_COLOR';

	/** the column name for the QUESTION_HEADER_TEXT_COLOR field */
	const QUESTION_HEADER_TEXT_COLOR = 'theme.QUESTION_HEADER_TEXT_COLOR';

	/** the column name for the PRICE field */
	const PRICE = 'theme.PRICE';

	/** the column name for the DEL_FLG field */
	const DEL_FLG = 'theme.DEL_FLG';

	/** the column name for the CREATED_AT field */
	const CREATED_AT = 'theme.CREATED_AT';

	/** the column name for the UPDATED_AT field */
	const UPDATED_AT = 'theme.UPDATED_AT';

	/**
	 * An identiy map to hold any loaded instances of Theme objects.
	 * This must be public so that other peer classes can access this when hydrating from JOIN
	 * queries.
	 * @var        array Theme[]
	 */
	public static $instances = array();


	// symfony behavior
	
	/**
	 * Indicates whether the current model includes I18N.
	 */
	const IS_I18N = false;

	/**
	 * holds an array of fieldnames
	 *
	 * first dimension keys are the type constants
	 * e.g. self::$fieldNames[self::TYPE_PHPNAME][0] = 'Id'
	 */
	private static $fieldNames = array (
		BasePeer::TYPE_PHPNAME => array ('Id', 'AppId', 'Product', 'Title', 'Description', 'BaseUrl', 'ThumbnailName', 'Screenshots', 'Images', 'TopColor', 'TopTextColor', 'TopTextFont', 'TopTextSize', 'BaseTextColor', 'LinkTextColor', 'BackgroundColor', 'MaskColor', 'PostTextColor', 'StatusBarColor', 'StatusBarStyle', 'SeparatorColor', 'Text1Color', 'Text2Color', 'Text3Color', 'QuestionHeaderColor', 'QuestionHeaderTextColor', 'Price', 'DelFlg', 'CreatedAt', 'UpdatedAt', ),
		BasePeer::TYPE_STUDLYPHPNAME => array ('id', 'appId', 'product', 'title', 'description', 'baseUrl', 'thumbnailName', 'screenshots', 'images', 'topColor', 'topTextColor', 'topTextFont', 'topTextSize', 'baseTextColor', 'linkTextColor', 'backgroundColor', 'maskColor', 'postTextColor', 'statusBarColor', 'statusBarStyle', 'separatorColor', 'text1Color', 'text2Color', 'text3Color', 'questionHeaderColor', 'questionHeaderTextColor', 'price', 'delFlg', 'createdAt', 'updatedAt', ),
		BasePeer::TYPE_COLNAME => array (self::ID, self::APP_ID, self::PRODUCT, self::TITLE, self::DESCRIPTION, self::BASE_URL, self::THUMBNAIL_NAME, self::SCREENSHOTS, self::IMAGES, self::TOP_COLOR, self::TOP_TEXT_COLOR, self::TOP_TEXT_FONT, self::TOP_TEXT_SIZE, self::BASE_TEXT_COLOR, self::LINK_TEXT_COLOR, self::BACKGROUND_COLOR, self::MASK_COLOR, self::POST_TEXT_COLOR, self::STATUS_BAR_COLOR, self::STATUS_BAR_STYLE, self::SEPARATOR_COLOR, self::TEXT1_COLOR, self::TEXT2_COLOR, self::TEXT3_COLOR, self::QUESTION_HEADER_COLOR, self::QUESTION_HEADER_TEXT_COLOR, self::PRICE, self::DEL_FLG, self::CREATED_AT, self::UPDATED_AT, ),
		BasePeer::TYPE_FIELDNAME => array ('id', 'app_id', 'product', 'title', 'description', 'base_url', 'thumbnail_name', 'screenshots', 'images', 'top_color', 'top_text_color', 'top_text_font', 'top_text_size', 'base_text_color', 'link_text_color', 'background_color', 'mask_color', 'post_text_color', 'status_bar_color', 'status_bar_style', 'separator_color', 'text1_color', 'text2_color', 'text3_color', 'question_header_color', 'question_header_text_color', 'price', 'del_flg', 'created_at', 'updated_at', ),
		BasePeer::TYPE_NUM => array (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, )
	);

	/**
	 * holds an array of keys for quick access to the fieldnames array
	 *
	 * first dimension keys are the type constants
	 * e.g. self::$fieldNames[BasePeer::TYPE_PHPNAME]['Id'] = 0
	 */
	private static $fieldKeys = array (
		BasePeer::TYPE_PHPNAME => array ('Id' => 0, 'AppId' => 1, 'Product' => 2, 'Title' => 3, 'Description' => 4, 'BaseUrl' => 5, 'ThumbnailName' => 6, 'Screenshots' => 7, 'Images' => 8, 'TopColor' => 9, 'TopTextColor' => 10, 'TopTextFont' => 11, 'TopTextSize' => 12, 'BaseTextColor' => 13, 'LinkTextColor' => 14, 'BackgroundColor' => 15, 'MaskColor' => 16, 'PostTextColor' => 17, 'StatusBarColor' => 18, 'StatusBarStyle' => 19, 'SeparatorColor' => 20, 'Text1Color' => 21, 'Text2Color' => 22, 'Text3Color' => 23, 'QuestionHeaderColor' => 24, 'QuestionHeaderTextColor' => 25, 'Price' => 26, 'DelFlg' => 27, 'CreatedAt' => 28, 'UpdatedAt' => 29, ),
		BasePeer::TYPE_STUDLYPHPNAME => array ('id' => 0, 'appId' => 1, 'product' => 2, 'title' => 3, 'description' => 4, 'baseUrl' => 5, 'thumbnailName' => 6, 'screenshots' => 7, 'images' => 8, 'topColor' => 9, 'topTextColor' => 10, 'topTextFont' => 11, 'topTextSize' => 12, 'baseTextColor' => 13, 'linkTextColor' => 14, 'backgroundColor' => 15, 'maskColor' => 16, 'postTextColor' => 17, 'statusBarColor' => 18, 'statusBarStyle' => 19, 'separatorColor' => 20, 'text1Color' => 21, 'text2Color' => 22, 'text3Color' => 23, 'questionHeaderColor' => 24, 'questionHeaderTextColor' => 25, 'price' => 26, 'delFlg' => 27, 'createdAt' => 28, 'updatedAt' => 29, ),
		BasePeer::TYPE_COLNAME => array (self::ID => 0, self::APP_ID => 1, self::PRODUCT => 2, self::TITLE => 3, self::DESCRIPTION => 4, self::BASE_URL => 5, self::THUMBNAIL_NAME => 6, self::SCREENSHOTS => 7, self::IMAGES => 8, self::TOP_COLOR => 9, self::TOP_TEXT_COLOR => 10, self::TOP_TEXT_FONT => 11, self::TOP_TEXT_SIZE => 12, self::BASE_TEXT_COLOR => 13, self::LINK_TEXT_COLOR => 14, self::BACKGROUND_COLOR => 15, self::MASK_COLOR => 16, self::POST_TEXT_COLOR => 17, self::STATUS_BAR_COLOR => 18, self::STATUS_BAR_STYLE => 19, self::SEPARATOR_COLOR => 20, self::TEXT1_COLOR => 21, self::TEXT2_COLOR => 22, self::TEXT3_COLOR => 23, self::QUESTION_HEADER_COLOR => 24, self::QUESTION_HEADER_TEXT_COLOR => 25, self::PRICE => 26, self::DEL_FLG => 27, self::CREATED_AT => 28, self::UPDATED_AT => 29, ),
		BasePeer::TYPE_FIELDNAME => array ('id' => 0, 'app_id' => 1, 'product' => 2, 'title' => 3, 'description' => 4, 'base_url' => 5, 'thumbnail_name' => 6, 'screenshots' => 7, 'images' => 8, 'top_color' => 9, 'top_text_color' => 10, 'top_text_font' => 11, 'top_text_size' => 12, 'base_text_color' => 13, 'link_text_color' => 14, 'background_color' => 15, 'mask_color' => 16, 'post_text_color' => 17, 'status_bar_color' => 18, 'status_bar_style' => 19, 'separator_color' => 20, 'text1_color' => 21, 'text2_color' => 22, 'text3_color' => 23, 'question_header_color' => 24, 'question_header_text_color' => 25, 'price' => 26, 'del_flg' => 27, 'created_at' => 28, 'updated_at' => 29, ),
		BasePeer::TYPE_NUM => array (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, )
	);

	/**
	 * Translates a fieldname to another type
	 *
	 * @param      string $name field name
	 * @param      string $fromType One of the class type constants BasePeer::TYPE_PHPNAME, BasePeer::TYPE_STUDLYPHPNAME
	 *                         BasePeer::TYPE_COLNAME, BasePeer::TYPE_FIELDNAME, BasePeer::TYPE_NUM
	 * @param      string $toType   One of the class type constants
	 * @return     string translated name of the field.
	 * @throws     PropelException - if the specified name could not be found in the fieldname mappings.
	 */
	static public function translateFieldName($name, $fromType, $toType)
	{
		$toNames = self::getFieldNames($toType);
		$key = isset(self::$fieldKeys[$fromType][$name]) ? self::$fieldKeys[$fromType][$name] : null;
		if ($key === null) {
			throw new PropelException("'$name' could not be found in the field names of type '$fromType'. These are: " . print_r(self::$fieldKeys[$fromType], true));
		}
		return $toNames[$key];
	}

	/**
	 * Returns an array of field names.
	 *
	 * @param      string $type The type of fieldnames to return:
	 *                      One of the class type constants BasePeer::TYPE_PHPNAME, BasePeer::TYPE_STUDLYPHPNAME
	 *                      BasePeer::TYPE_COLNAME, BasePeer::TYPE_FIELDNAME, BasePeer::TYPE_NUM
	 * @return     array A list of field names
	 */

	static public function getFieldNames($type = BasePeer::TYPE_PHPNAME)
	{
		if (!array_key_exists($type, self::$fieldNames)) {
			throw new PropelException('Method getFieldNames() expects the parameter $type to be one of the class constants BasePeer::TYPE_PHPNAME, BasePeer::TYPE_STUDLYPHPNAME, BasePeer::TYPE_COLNAME, BasePeer::TYPE_FIELDNAME, BasePeer::TYPE_NUM. ' . $type . ' was given.');
		}
		return self::$fieldNames[$type];
	}

	/**
	 * Convenience method which changes table.column to alias.column.
	 *
	 * Using this method you can maintain SQL abstraction while using column aliases.
	 * <code>
	 *		$c->addAlias("alias1", TablePeer::TABLE_NAME);
	 *		$c->addJoin(TablePeer::alias("alias1", TablePeer::PRIMARY_KEY_COLUMN), TablePeer::PRIMARY_KEY_COLUMN);
	 * </code>
	 * @param      string $alias The alias for the current table.
	 * @param      string $column The column name for current table. (i.e. ThemePeer::COLUMN_NAME).
	 * @return     string
	 */
	public static function alias($alias, $column)
	{
		return str_replace(ThemePeer::TABLE_NAME.'.', $alias.'.', $column);
	}

	/**
	 * Add all the columns needed to create a new object.
	 *
	 * Note: any columns that were marked with lazyLoad="true" in the
	 * XML schema will not be added to the select list and only loaded
	 * on demand.
	 *
	 * @param      criteria object containing the columns to add.
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function addSelectColumns(Criteria $criteria)
	{
		$criteria->addSelectColumn(ThemePeer::ID);
		$criteria->addSelectColumn(ThemePeer::APP_ID);
		$criteria->addSelectColumn(ThemePeer::PRODUCT);
		$criteria->addSelectColumn(ThemePeer::TITLE);
		$criteria->addSelectColumn(ThemePeer::DESCRIPTION);
		$criteria->addSelectColumn(ThemePeer::BASE_URL);
		$criteria->addSelectColumn(ThemePeer::THUMBNAIL_NAME);
		$criteria->addSelectColumn(ThemePeer::SCREENSHOTS);
		$criteria->addSelectColumn(ThemePeer::IMAGES);
		$criteria->addSelectColumn(ThemePeer::TOP_COLOR);
		$criteria->addSelectColumn(ThemePeer::TOP_TEXT_COLOR);
		$criteria->addSelectColumn(ThemePeer::TOP_TEXT_FONT);
		$criteria->addSelectColumn(ThemePeer::TOP_TEXT_SIZE);
		$criteria->addSelectColumn(ThemePeer::BASE_TEXT_COLOR);
		$criteria->addSelectColumn(ThemePeer::LINK_TEXT_COLOR);
		$criteria->addSelectColumn(ThemePeer::BACKGROUND_COLOR);
		$criteria->addSelectColumn(ThemePeer::MASK_COLOR);
		$criteria->addSelectColumn(ThemePeer::POST_TEXT_COLOR);
		$criteria->addSelectColumn(ThemePeer::STATUS_BAR_COLOR);
		$criteria->addSelectColumn(ThemePeer::STATUS_BAR_STYLE);
		$criteria->addSelectColumn(ThemePeer::SEPARATOR_COLOR);
		$criteria->addSelectColumn(ThemePeer::TEXT1_COLOR);
		$criteria->addSelectColumn(ThemePeer::TEXT2_COLOR);
		$criteria->addSelectColumn(ThemePeer::TEXT3_COLOR);
		$criteria->addSelectColumn(ThemePeer::QUESTION_HEADER_COLOR);
		$criteria->addSelectColumn(ThemePeer::QUESTION_HEADER_TEXT_COLOR);
		$criteria->addSelectColumn(ThemePeer::PRICE);
		$criteria->addSelectColumn(ThemePeer::DEL_FLG);
		$criteria->addSelectColumn(ThemePeer::CREATED_AT);
		$criteria->addSelectColumn(ThemePeer::UPDATED_AT);
	}

	/**
	 * Returns the number of rows matching criteria.
	 *
	 * @param      Criteria $criteria
	 * @param      boolean $distinct Whether to select only distinct columns; deprecated: use Criteria->setDistinct() instead.
	 * @param      PropelPDO $con
	 * @return     int Number of matching rows.
	 */
	public static function doCount(Criteria $criteria, $distinct = false, PropelPDO $con = null)
	{
		// we may modify criteria, so copy it first
		$criteria = clone $criteria;

		// We need to set the primary table name, since in the case that there are no WHERE columns
		// it will be impossible for the BasePeer::createSelectSql() method to determine which
		// tables go into the FROM clause.
		$criteria->setPrimaryTableName(ThemePeer::TABLE_NAME);

		if ($distinct && !in_array(Criteria::DISTINCT, $criteria->getSelectModifiers())) {
			$criteria->setDistinct();
		}

		if (!$criteria->hasSelectClause()) {
			ThemePeer::addSelectColumns($criteria);
		}

		$criteria->clearOrderByColumns(); // ORDER BY won't ever affect the count
		$criteria->setDbName(self::DATABASE_NAME); // Set the correct dbName

		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}
		// symfony_behaviors behavior
		foreach (sfMixer::getCallables(self::getMixerPreSelectHook(__FUNCTION__)) as $sf_hook)
		{
		  call_user_func($sf_hook, 'BaseThemePeer', $criteria, $con);
		}

		// BasePeer returns a PDOStatement
		$stmt = BasePeer::doCount($criteria, $con);

		if ($row = $stmt->fetch(PDO::FETCH_NUM)) {
			$count = (int) $row[0];
		} else {
			$count = 0; // no rows returned; we infer that means 0 matches.
		}
		$stmt->closeCursor();
		return $count;
	}
	/**
	 * Method to select one object from the DB.
	 *
	 * @param      Criteria $criteria object used to create the SELECT statement.
	 * @param      PropelPDO $con
	 * @return     Theme
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doSelectOne(Criteria $criteria, PropelPDO $con = null)
	{
		$critcopy = clone $criteria;
		$critcopy->setLimit(1);
		$objects = ThemePeer::doSelect($critcopy, $con);
		if ($objects) {
			return $objects[0];
		}
		return null;
	}
	/**
	 * Method to do selects.
	 *
	 * @param      Criteria $criteria The Criteria object used to build the SELECT statement.
	 * @param      PropelPDO $con
	 * @return     array Array of selected Objects
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doSelect(Criteria $criteria, PropelPDO $con = null)
	{
		return ThemePeer::populateObjects(ThemePeer::doSelectStmt($criteria, $con));
	}
	/**
	 * Prepares the Criteria object and uses the parent doSelect() method to execute a PDOStatement.
	 *
	 * Use this method directly if you want to work with an executed statement durirectly (for example
	 * to perform your own object hydration).
	 *
	 * @param      Criteria $criteria The Criteria object used to build the SELECT statement.
	 * @param      PropelPDO $con The connection to use
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 * @return     PDOStatement The executed PDOStatement object.
	 * @see        BasePeer::doSelect()
	 */
	public static function doSelectStmt(Criteria $criteria, PropelPDO $con = null)
	{
		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		if (!$criteria->hasSelectClause()) {
			$criteria = clone $criteria;
			ThemePeer::addSelectColumns($criteria);
		}

		// Set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);
		// symfony_behaviors behavior
		foreach (sfMixer::getCallables(self::getMixerPreSelectHook(__FUNCTION__)) as $sf_hook)
		{
		  call_user_func($sf_hook, 'BaseThemePeer', $criteria, $con);
		}


		// BasePeer returns a PDOStatement
		return BasePeer::doSelect($criteria, $con);
	}
	/**
	 * Adds an object to the instance pool.
	 *
	 * Propel keeps cached copies of objects in an instance pool when they are retrieved
	 * from the database.  In some cases -- especially when you override doSelect*()
	 * methods in your stub classes -- you may need to explicitly add objects
	 * to the cache in order to ensure that the same objects are always returned by doSelect*()
	 * and retrieveByPK*() calls.
	 *
	 * @param      Theme $value A Theme object.
	 * @param      string $key (optional) key to use for instance map (for performance boost if key was already calculated externally).
	 */
	public static function addInstanceToPool(Theme $obj, $key = null)
	{
		if (Propel::isInstancePoolingEnabled()) {
			if ($key === null) {
				$key = (string) $obj->getId();
			} // if key === null
			self::$instances[$key] = $obj;
		}
	}

	/**
	 * Removes an object from the instance pool.
	 *
	 * Propel keeps cached copies of objects in an instance pool when they are retrieved
	 * from the database.  In some cases -- especially when you override doDelete
	 * methods in your stub classes -- you may need to explicitly remove objects
	 * from the cache in order to prevent returning objects that no longer exist.
	 *
	 * @param      mixed $value A Theme object or a primary key value.
	 */
	public static function removeInstanceFromPool($value)
	{
		if (Propel::isInstancePoolingEnabled() && $value !== null) {
			if (is_object($value) && $value instanceof Theme) {
				$key = (string) $value->getId();
			} elseif (is_scalar($value)) {
				// assume we've been passed a primary key
				$key = (string) $value;
			} else {
				$e = new PropelException("Invalid value passed to removeInstanceFromPool().  Expected primary key or Theme object; got " . (is_object($value) ? get_class($value) . ' object.' : var_export($value,true)));
				throw $e;
			}

			unset(self::$instances[$key]);
		}
	} // removeInstanceFromPool()

	/**
	 * Retrieves a string version of the primary key from the DB resultset row that can be used to uniquely identify a row in this table.
	 *
	 * For tables with a single-column primary key, that simple pkey value will be returned.  For tables with
	 * a multi-column primary key, a serialize()d version of the primary key will be returned.
	 *
	 * @param      string $key The key (@see getPrimaryKeyHash()) for this instance.
	 * @return     Theme Found object or NULL if 1) no instance exists for specified key or 2) instance pooling has been disabled.
	 * @see        getPrimaryKeyHash()
	 */
	public static function getInstanceFromPool($key)
	{
		if (Propel::isInstancePoolingEnabled()) {
			if (isset(self::$instances[$key])) {
				return self::$instances[$key];
			}
		}
		return null; // just to be explicit
	}
	
	/**
	 * Clear the instance pool.
	 *
	 * @return     void
	 */
	public static function clearInstancePool()
	{
		self::$instances = array();
	}
	
	/**
	 * Method to invalidate the instance pool of all tables related to theme
	 * by a foreign key with ON DELETE CASCADE
	 */
	public static function clearRelatedInstancePool()
	{
	}

	/**
	 * Retrieves a string version of the primary key from the DB resultset row that can be used to uniquely identify a row in this table.
	 *
	 * For tables with a single-column primary key, that simple pkey value will be returned.  For tables with
	 * a multi-column primary key, a serialize()d version of the primary key will be returned.
	 *
	 * @param      array $row PropelPDO resultset row.
	 * @param      int $startcol The 0-based offset for reading from the resultset row.
	 * @return     string A string version of PK or NULL if the components of primary key in result array are all null.
	 */
	public static function getPrimaryKeyHashFromRow($row, $startcol = 0)
	{
		// If the PK cannot be derived from the row, return NULL.
		if ($row[$startcol] === null) {
			return null;
		}
		return (string) $row[$startcol];
	}

	/**
	 * The returned array will contain objects of the default type or
	 * objects that inherit from the default.
	 *
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function populateObjects(PDOStatement $stmt)
	{
		$results = array();
	
		// set the class once to avoid overhead in the loop
		$cls = ThemePeer::getOMClass(false);
		// populate the object(s)
		while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
			$key = ThemePeer::getPrimaryKeyHashFromRow($row, 0);
			if (null !== ($obj = ThemePeer::getInstanceFromPool($key))) {
				// We no longer rehydrate the object, since this can cause data loss.
				// See http://propel.phpdb.org/trac/ticket/509
				// $obj->hydrate($row, 0, true); // rehydrate
				$results[] = $obj;
			} else {
				$obj = new $cls();
				$obj->hydrate($row);
				$results[] = $obj;
				ThemePeer::addInstanceToPool($obj, $key);
			} // if key exists
		}
		$stmt->closeCursor();
		return $results;
	}
	/**
	 * Returns the TableMap related to this peer.
	 * This method is not needed for general use but a specific application could have a need.
	 * @return     TableMap
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function getTableMap()
	{
		return Propel::getDatabaseMap(self::DATABASE_NAME)->getTable(self::TABLE_NAME);
	}

	/**
	 * Add a TableMap instance to the database for this peer class.
	 */
	public static function buildTableMap()
	{
	  $dbMap = Propel::getDatabaseMap(BaseThemePeer::DATABASE_NAME);
	  if (!$dbMap->hasTable(BaseThemePeer::TABLE_NAME))
	  {
	    $dbMap->addTableObject(new ThemeTableMap());
	  }
	}

	/**
	 * The class that the Peer will make instances of.
	 *
	 * If $withPrefix is true, the returned path
	 * uses a dot-path notation which is tranalted into a path
	 * relative to a location on the PHP include_path.
	 * (e.g. path.to.MyClass -> 'path/to/MyClass.php')
	 *
	 * @param      boolean  Whether or not to return the path wit hthe class name 
	 * @return     string path.to.ClassName
	 */
	public static function getOMClass($withPrefix = true)
	{
		return $withPrefix ? ThemePeer::CLASS_DEFAULT : ThemePeer::OM_CLASS;
	}

	/**
	 * Method perform an INSERT on the database, given a Theme or Criteria object.
	 *
	 * @param      mixed $values Criteria or Theme object containing data that is used to create the INSERT statement.
	 * @param      PropelPDO $con the PropelPDO connection to use
	 * @return     mixed The new primary key.
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doInsert($values, PropelPDO $con = null)
	{
    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseThemePeer:doInsert:pre') as $sf_hook)
    {
      if (false !== $sf_hook_retval = call_user_func($sf_hook, 'BaseThemePeer', $values, $con))
      {
        return $sf_hook_retval;
      }
    }

		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		if ($values instanceof Criteria) {
			$criteria = clone $values; // rename for clarity
		} else {
			$criteria = $values->buildCriteria(); // build Criteria from Theme object
		}

		if ($criteria->containsKey(ThemePeer::ID) && $criteria->keyContainsValue(ThemePeer::ID) ) {
			throw new PropelException('Cannot insert a value for auto-increment primary key ('.ThemePeer::ID.')');
		}


		// Set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);

		try {
			// use transaction because $criteria could contain info
			// for more than one table (I guess, conceivably)
			$con->beginTransaction();
			$pk = BasePeer::doInsert($criteria, $con);
			$con->commit();
		} catch(PropelException $e) {
			$con->rollBack();
			throw $e;
		}

    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseThemePeer:doInsert:post') as $sf_hook)
    {
      call_user_func($sf_hook, 'BaseThemePeer', $values, $con, $pk);
    }

		return $pk;
	}

	/**
	 * Method perform an UPDATE on the database, given a Theme or Criteria object.
	 *
	 * @param      mixed $values Criteria or Theme object containing data that is used to create the UPDATE statement.
	 * @param      PropelPDO $con The connection to use (specify PropelPDO connection object to exert more control over transactions).
	 * @return     int The number of affected rows (if supported by underlying database driver).
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doUpdate($values, PropelPDO $con = null)
	{
    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseThemePeer:doUpdate:pre') as $sf_hook)
    {
      if (false !== $sf_hook_retval = call_user_func($sf_hook, 'BaseThemePeer', $values, $con))
      {
        return $sf_hook_retval;
      }
    }

		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		$selectCriteria = new Criteria(self::DATABASE_NAME);

		if ($values instanceof Criteria) {
			$criteria = clone $values; // rename for clarity

			$comparison = $criteria->getComparison(ThemePeer::ID);
			$selectCriteria->add(ThemePeer::ID, $criteria->remove(ThemePeer::ID), $comparison);

		} else { // $values is Theme object
			$criteria = $values->buildCriteria(); // gets full criteria
			$selectCriteria = $values->buildPkeyCriteria(); // gets criteria w/ primary key(s)
		}

		// set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);

		$ret = BasePeer::doUpdate($selectCriteria, $criteria, $con);

    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseThemePeer:doUpdate:post') as $sf_hook)
    {
      call_user_func($sf_hook, 'BaseThemePeer', $values, $con, $ret);
    }

    return $ret;
	}

	/**
	 * Method to DELETE all rows from the theme table.
	 *
	 * @return     int The number of affected rows (if supported by underlying database driver).
	 */
	public static function doDeleteAll($con = null)
	{
		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}
		$affectedRows = 0; // initialize var to track total num of affected rows
		try {
			// use transaction because $criteria could contain info
			// for more than one table or we could emulating ON DELETE CASCADE, etc.
			$con->beginTransaction();
			$affectedRows += BasePeer::doDeleteAll(ThemePeer::TABLE_NAME, $con);
			// Because this db requires some delete cascade/set null emulation, we have to
			// clear the cached instance *after* the emulation has happened (since
			// instances get re-added by the select statement contained therein).
			ThemePeer::clearInstancePool();
			ThemePeer::clearRelatedInstancePool();
			$con->commit();
			return $affectedRows;
		} catch (PropelException $e) {
			$con->rollBack();
			throw $e;
		}
	}

	/**
	 * Method perform a DELETE on the database, given a Theme or Criteria object OR a primary key value.
	 *
	 * @param      mixed $values Criteria or Theme object or primary key or array of primary keys
	 *              which is used to create the DELETE statement
	 * @param      PropelPDO $con the connection to use
	 * @return     int 	The number of affected rows (if supported by underlying database driver).  This includes CASCADE-related rows
	 *				if supported by native driver or if emulated using Propel.
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	 public static function doDelete($values, PropelPDO $con = null)
	 {
		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		if ($values instanceof Criteria) {
			// invalidate the cache for all objects of this type, since we have no
			// way of knowing (without running a query) what objects should be invalidated
			// from the cache based on this Criteria.
			ThemePeer::clearInstancePool();
			// rename for clarity
			$criteria = clone $values;
		} elseif ($values instanceof Theme) { // it's a model object
			// invalidate the cache for this single object
			ThemePeer::removeInstanceFromPool($values);
			// create criteria based on pk values
			$criteria = $values->buildPkeyCriteria();
		} else { // it's a primary key, or an array of pks
			$criteria = new Criteria(self::DATABASE_NAME);
			$criteria->add(ThemePeer::ID, (array) $values, Criteria::IN);
			// invalidate the cache for this object(s)
			foreach ((array) $values as $singleval) {
				ThemePeer::removeInstanceFromPool($singleval);
			}
		}

		// Set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);

		$affectedRows = 0; // initialize var to track total num of affected rows

		try {
			// use transaction because $criteria could contain info
			// for more than one table or we could emulating ON DELETE CASCADE, etc.
			$con->beginTransaction();
			
			$affectedRows += BasePeer::doDelete($criteria, $con);
			ThemePeer::clearRelatedInstancePool();
			$con->commit();
			return $affectedRows;
		} catch (PropelException $e) {
			$con->rollBack();
			throw $e;
		}
	}

	/**
	 * Validates all modified columns of given Theme object.
	 * If parameter $columns is either a single column name or an array of column names
	 * than only those columns are validated.
	 *
	 * NOTICE: This does not apply to primary or foreign keys for now.
	 *
	 * @param      Theme $obj The object to validate.
	 * @param      mixed $cols Column name or array of column names.
	 *
	 * @return     mixed TRUE if all columns are valid or the error message of the first invalid column.
	 */
	public static function doValidate(Theme $obj, $cols = null)
	{
		$columns = array();

		if ($cols) {
			$dbMap = Propel::getDatabaseMap(ThemePeer::DATABASE_NAME);
			$tableMap = $dbMap->getTable(ThemePeer::TABLE_NAME);

			if (! is_array($cols)) {
				$cols = array($cols);
			}

			foreach ($cols as $colName) {
				if ($tableMap->containsColumn($colName)) {
					$get = 'get' . $tableMap->getColumn($colName)->getPhpName();
					$columns[$colName] = $obj->$get();
				}
			}
		} else {

		}

		return BasePeer::doValidate(ThemePeer::DATABASE_NAME, ThemePeer::TABLE_NAME, $columns);
	}

	/**
	 * Retrieve a single object by pkey.
	 *
	 * @param      int $pk the primary key.
	 * @param      PropelPDO $con the connection to use
	 * @return     Theme
	 */
	public static function retrieveByPK($pk, PropelPDO $con = null)
	{

		if (null !== ($obj = ThemePeer::getInstanceFromPool((string) $pk))) {
			return $obj;
		}

		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		$criteria = new Criteria(ThemePeer::DATABASE_NAME);
		$criteria->add(ThemePeer::ID, $pk);

		$v = ThemePeer::doSelect($criteria, $con);

		return !empty($v) > 0 ? $v[0] : null;
	}

	/**
	 * Retrieve multiple objects by pkey.
	 *
	 * @param      array $pks List of primary keys
	 * @param      PropelPDO $con the connection to use
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function retrieveByPKs($pks, PropelPDO $con = null)
	{
		if ($con === null) {
			$con = Propel::getConnection(ThemePeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		$objs = null;
		if (empty($pks)) {
			$objs = array();
		} else {
			$criteria = new Criteria(ThemePeer::DATABASE_NAME);
			$criteria->add(ThemePeer::ID, $pks, Criteria::IN);
			$objs = ThemePeer::doSelect($criteria, $con);
		}
		return $objs;
	}

	// symfony behavior
	
	/**
	 * Returns an array of arrays that contain columns in each unique index.
	 *
	 * @return array
	 */
	static public function getUniqueColumnNames()
	{
	  return array();
	}

	// symfony_behaviors behavior
	
	/**
	 * Returns the name of the hook to call from inside the supplied method.
	 *
	 * @param string $method The calling method
	 *
	 * @return string A hook name for {@link sfMixer}
	 *
	 * @throws LogicException If the method name is not recognized
	 */
	static private function getMixerPreSelectHook($method)
	{
	  if (preg_match('/^do(Select|Count)(Join(All(Except)?)?|Stmt)?/', $method, $match))
	  {
	    return sprintf('BaseThemePeer:%s:%1$s', 'Count' == $match[1] ? 'doCount' : $match[0]);
	  }
	
	  throw new LogicException(sprintf('Unrecognized function "%s"', $method));
	}

} // BaseThemePeer

// This is the static code needed to register the TableMap for this table with the main Propel class.
//
BaseThemePeer::buildTableMap();

