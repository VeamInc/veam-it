<?php

/**
 * Base static class for performing query and update operations on the 'youtube_video' table.
 *
 * 
 *
 * This class was autogenerated by Propel 1.4.2 on:
 *
 * Wed Dec 13 16:31:12 2017
 *
 * @package    lib.model.om
 */
abstract class BaseYoutubeVideoPeer {

	/** the default database name for this class */
	const DATABASE_NAME = 'propel';

	/** the table name for this class */
	const TABLE_NAME = 'youtube_video';

	/** the related Propel class for this table */
	const OM_CLASS = 'YoutubeVideo';

	/** A class that can be returned by this peer. */
	const CLASS_DEFAULT = 'lib.model.YoutubeVideo';

	/** the related TableMap class for this table */
	const TM_CLASS = 'YoutubeVideoTableMap';
	
	/** The total number of columns. */
	const NUM_COLUMNS = 25;

	/** The number of lazy-loaded columns. */
	const NUM_LAZY_LOAD_COLUMNS = 0;

	/** the column name for the ID field */
	const ID = 'youtube_video.ID';

	/** the column name for the APP_ID field */
	const APP_ID = 'youtube_video.APP_ID';

	/** the column name for the KIND field */
	const KIND = 'youtube_video.KIND';

	/** the column name for the RATING field */
	const RATING = 'youtube_video.RATING';

	/** the column name for the AUTHOR field */
	const AUTHOR = 'youtube_video.AUTHOR';

	/** the column name for the DURATION field */
	const DURATION = 'youtube_video.DURATION';

	/** the column name for the EXPIRED_AT field */
	const EXPIRED_AT = 'youtube_video.EXPIRED_AT';

	/** the column name for the TITLE field */
	const TITLE = 'youtube_video.TITLE';

	/** the column name for the DESCRIPTION field */
	const DESCRIPTION = 'youtube_video.DESCRIPTION';

	/** the column name for the CATEGORY_ID field */
	const CATEGORY_ID = 'youtube_video.CATEGORY_ID';

	/** the column name for the SUB_CATEGORY_ID field */
	const SUB_CATEGORY_ID = 'youtube_video.SUB_CATEGORY_ID';

	/** the column name for the YOUTUBE_CODE field */
	const YOUTUBE_CODE = 'youtube_video.YOUTUBE_CODE';

	/** the column name for the IS_NEW field */
	const IS_NEW = 'youtube_video.IS_NEW';

	/** the column name for the DOWNLOADABLE field */
	const DOWNLOADABLE = 'youtube_video.DOWNLOADABLE';

	/** the column name for the SMALL_THUMBNAIL_URL field */
	const SMALL_THUMBNAIL_URL = 'youtube_video.SMALL_THUMBNAIL_URL';

	/** the column name for the LARGE_THUMBNAIL_URL field */
	const LARGE_THUMBNAIL_URL = 'youtube_video.LARGE_THUMBNAIL_URL';

	/** the column name for the VIDEO_URL field */
	const VIDEO_URL = 'youtube_video.VIDEO_URL';

	/** the column name for the VIDEO_SIZE field */
	const VIDEO_SIZE = 'youtube_video.VIDEO_SIZE';

	/** the column name for the VIDEO_KEY field */
	const VIDEO_KEY = 'youtube_video.VIDEO_KEY';

	/** the column name for the PRICE field */
	const PRICE = 'youtube_video.PRICE';

	/** the column name for the LINK_URL field */
	const LINK_URL = 'youtube_video.LINK_URL';

	/** the column name for the DISPLAY_ORDER field */
	const DISPLAY_ORDER = 'youtube_video.DISPLAY_ORDER';

	/** the column name for the DEL_FLG field */
	const DEL_FLG = 'youtube_video.DEL_FLG';

	/** the column name for the CREATED_AT field */
	const CREATED_AT = 'youtube_video.CREATED_AT';

	/** the column name for the UPDATED_AT field */
	const UPDATED_AT = 'youtube_video.UPDATED_AT';

	/**
	 * An identiy map to hold any loaded instances of YoutubeVideo objects.
	 * This must be public so that other peer classes can access this when hydrating from JOIN
	 * queries.
	 * @var        array YoutubeVideo[]
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
		BasePeer::TYPE_PHPNAME => array ('Id', 'AppId', 'Kind', 'Rating', 'Author', 'Duration', 'ExpiredAt', 'Title', 'Description', 'CategoryId', 'SubCategoryId', 'YoutubeCode', 'IsNew', 'Downloadable', 'SmallThumbnailUrl', 'LargeThumbnailUrl', 'VideoUrl', 'VideoSize', 'VideoKey', 'Price', 'LinkUrl', 'DisplayOrder', 'DelFlg', 'CreatedAt', 'UpdatedAt', ),
		BasePeer::TYPE_STUDLYPHPNAME => array ('id', 'appId', 'kind', 'rating', 'author', 'duration', 'expiredAt', 'title', 'description', 'categoryId', 'subCategoryId', 'youtubeCode', 'isNew', 'downloadable', 'smallThumbnailUrl', 'largeThumbnailUrl', 'videoUrl', 'videoSize', 'videoKey', 'price', 'linkUrl', 'displayOrder', 'delFlg', 'createdAt', 'updatedAt', ),
		BasePeer::TYPE_COLNAME => array (self::ID, self::APP_ID, self::KIND, self::RATING, self::AUTHOR, self::DURATION, self::EXPIRED_AT, self::TITLE, self::DESCRIPTION, self::CATEGORY_ID, self::SUB_CATEGORY_ID, self::YOUTUBE_CODE, self::IS_NEW, self::DOWNLOADABLE, self::SMALL_THUMBNAIL_URL, self::LARGE_THUMBNAIL_URL, self::VIDEO_URL, self::VIDEO_SIZE, self::VIDEO_KEY, self::PRICE, self::LINK_URL, self::DISPLAY_ORDER, self::DEL_FLG, self::CREATED_AT, self::UPDATED_AT, ),
		BasePeer::TYPE_FIELDNAME => array ('id', 'app_id', 'kind', 'rating', 'author', 'duration', 'expired_at', 'title', 'description', 'category_id', 'sub_category_id', 'youtube_code', 'is_new', 'downloadable', 'small_thumbnail_url', 'large_thumbnail_url', 'video_url', 'video_size', 'video_key', 'price', 'link_url', 'display_order', 'del_flg', 'created_at', 'updated_at', ),
		BasePeer::TYPE_NUM => array (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, )
	);

	/**
	 * holds an array of keys for quick access to the fieldnames array
	 *
	 * first dimension keys are the type constants
	 * e.g. self::$fieldNames[BasePeer::TYPE_PHPNAME]['Id'] = 0
	 */
	private static $fieldKeys = array (
		BasePeer::TYPE_PHPNAME => array ('Id' => 0, 'AppId' => 1, 'Kind' => 2, 'Rating' => 3, 'Author' => 4, 'Duration' => 5, 'ExpiredAt' => 6, 'Title' => 7, 'Description' => 8, 'CategoryId' => 9, 'SubCategoryId' => 10, 'YoutubeCode' => 11, 'IsNew' => 12, 'Downloadable' => 13, 'SmallThumbnailUrl' => 14, 'LargeThumbnailUrl' => 15, 'VideoUrl' => 16, 'VideoSize' => 17, 'VideoKey' => 18, 'Price' => 19, 'LinkUrl' => 20, 'DisplayOrder' => 21, 'DelFlg' => 22, 'CreatedAt' => 23, 'UpdatedAt' => 24, ),
		BasePeer::TYPE_STUDLYPHPNAME => array ('id' => 0, 'appId' => 1, 'kind' => 2, 'rating' => 3, 'author' => 4, 'duration' => 5, 'expiredAt' => 6, 'title' => 7, 'description' => 8, 'categoryId' => 9, 'subCategoryId' => 10, 'youtubeCode' => 11, 'isNew' => 12, 'downloadable' => 13, 'smallThumbnailUrl' => 14, 'largeThumbnailUrl' => 15, 'videoUrl' => 16, 'videoSize' => 17, 'videoKey' => 18, 'price' => 19, 'linkUrl' => 20, 'displayOrder' => 21, 'delFlg' => 22, 'createdAt' => 23, 'updatedAt' => 24, ),
		BasePeer::TYPE_COLNAME => array (self::ID => 0, self::APP_ID => 1, self::KIND => 2, self::RATING => 3, self::AUTHOR => 4, self::DURATION => 5, self::EXPIRED_AT => 6, self::TITLE => 7, self::DESCRIPTION => 8, self::CATEGORY_ID => 9, self::SUB_CATEGORY_ID => 10, self::YOUTUBE_CODE => 11, self::IS_NEW => 12, self::DOWNLOADABLE => 13, self::SMALL_THUMBNAIL_URL => 14, self::LARGE_THUMBNAIL_URL => 15, self::VIDEO_URL => 16, self::VIDEO_SIZE => 17, self::VIDEO_KEY => 18, self::PRICE => 19, self::LINK_URL => 20, self::DISPLAY_ORDER => 21, self::DEL_FLG => 22, self::CREATED_AT => 23, self::UPDATED_AT => 24, ),
		BasePeer::TYPE_FIELDNAME => array ('id' => 0, 'app_id' => 1, 'kind' => 2, 'rating' => 3, 'author' => 4, 'duration' => 5, 'expired_at' => 6, 'title' => 7, 'description' => 8, 'category_id' => 9, 'sub_category_id' => 10, 'youtube_code' => 11, 'is_new' => 12, 'downloadable' => 13, 'small_thumbnail_url' => 14, 'large_thumbnail_url' => 15, 'video_url' => 16, 'video_size' => 17, 'video_key' => 18, 'price' => 19, 'link_url' => 20, 'display_order' => 21, 'del_flg' => 22, 'created_at' => 23, 'updated_at' => 24, ),
		BasePeer::TYPE_NUM => array (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, )
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
	 * @param      string $column The column name for current table. (i.e. YoutubeVideoPeer::COLUMN_NAME).
	 * @return     string
	 */
	public static function alias($alias, $column)
	{
		return str_replace(YoutubeVideoPeer::TABLE_NAME.'.', $alias.'.', $column);
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
		$criteria->addSelectColumn(YoutubeVideoPeer::ID);
		$criteria->addSelectColumn(YoutubeVideoPeer::APP_ID);
		$criteria->addSelectColumn(YoutubeVideoPeer::KIND);
		$criteria->addSelectColumn(YoutubeVideoPeer::RATING);
		$criteria->addSelectColumn(YoutubeVideoPeer::AUTHOR);
		$criteria->addSelectColumn(YoutubeVideoPeer::DURATION);
		$criteria->addSelectColumn(YoutubeVideoPeer::EXPIRED_AT);
		$criteria->addSelectColumn(YoutubeVideoPeer::TITLE);
		$criteria->addSelectColumn(YoutubeVideoPeer::DESCRIPTION);
		$criteria->addSelectColumn(YoutubeVideoPeer::CATEGORY_ID);
		$criteria->addSelectColumn(YoutubeVideoPeer::SUB_CATEGORY_ID);
		$criteria->addSelectColumn(YoutubeVideoPeer::YOUTUBE_CODE);
		$criteria->addSelectColumn(YoutubeVideoPeer::IS_NEW);
		$criteria->addSelectColumn(YoutubeVideoPeer::DOWNLOADABLE);
		$criteria->addSelectColumn(YoutubeVideoPeer::SMALL_THUMBNAIL_URL);
		$criteria->addSelectColumn(YoutubeVideoPeer::LARGE_THUMBNAIL_URL);
		$criteria->addSelectColumn(YoutubeVideoPeer::VIDEO_URL);
		$criteria->addSelectColumn(YoutubeVideoPeer::VIDEO_SIZE);
		$criteria->addSelectColumn(YoutubeVideoPeer::VIDEO_KEY);
		$criteria->addSelectColumn(YoutubeVideoPeer::PRICE);
		$criteria->addSelectColumn(YoutubeVideoPeer::LINK_URL);
		$criteria->addSelectColumn(YoutubeVideoPeer::DISPLAY_ORDER);
		$criteria->addSelectColumn(YoutubeVideoPeer::DEL_FLG);
		$criteria->addSelectColumn(YoutubeVideoPeer::CREATED_AT);
		$criteria->addSelectColumn(YoutubeVideoPeer::UPDATED_AT);
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
		$criteria->setPrimaryTableName(YoutubeVideoPeer::TABLE_NAME);

		if ($distinct && !in_array(Criteria::DISTINCT, $criteria->getSelectModifiers())) {
			$criteria->setDistinct();
		}

		if (!$criteria->hasSelectClause()) {
			YoutubeVideoPeer::addSelectColumns($criteria);
		}

		$criteria->clearOrderByColumns(); // ORDER BY won't ever affect the count
		$criteria->setDbName(self::DATABASE_NAME); // Set the correct dbName

		if ($con === null) {
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}
		// symfony_behaviors behavior
		foreach (sfMixer::getCallables(self::getMixerPreSelectHook(__FUNCTION__)) as $sf_hook)
		{
		  call_user_func($sf_hook, 'BaseYoutubeVideoPeer', $criteria, $con);
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
	 * @return     YoutubeVideo
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doSelectOne(Criteria $criteria, PropelPDO $con = null)
	{
		$critcopy = clone $criteria;
		$critcopy->setLimit(1);
		$objects = YoutubeVideoPeer::doSelect($critcopy, $con);
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
		return YoutubeVideoPeer::populateObjects(YoutubeVideoPeer::doSelectStmt($criteria, $con));
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
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		if (!$criteria->hasSelectClause()) {
			$criteria = clone $criteria;
			YoutubeVideoPeer::addSelectColumns($criteria);
		}

		// Set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);
		// symfony_behaviors behavior
		foreach (sfMixer::getCallables(self::getMixerPreSelectHook(__FUNCTION__)) as $sf_hook)
		{
		  call_user_func($sf_hook, 'BaseYoutubeVideoPeer', $criteria, $con);
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
	 * @param      YoutubeVideo $value A YoutubeVideo object.
	 * @param      string $key (optional) key to use for instance map (for performance boost if key was already calculated externally).
	 */
	public static function addInstanceToPool(YoutubeVideo $obj, $key = null)
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
	 * @param      mixed $value A YoutubeVideo object or a primary key value.
	 */
	public static function removeInstanceFromPool($value)
	{
		if (Propel::isInstancePoolingEnabled() && $value !== null) {
			if (is_object($value) && $value instanceof YoutubeVideo) {
				$key = (string) $value->getId();
			} elseif (is_scalar($value)) {
				// assume we've been passed a primary key
				$key = (string) $value;
			} else {
				$e = new PropelException("Invalid value passed to removeInstanceFromPool().  Expected primary key or YoutubeVideo object; got " . (is_object($value) ? get_class($value) . ' object.' : var_export($value,true)));
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
	 * @return     YoutubeVideo Found object or NULL if 1) no instance exists for specified key or 2) instance pooling has been disabled.
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
	 * Method to invalidate the instance pool of all tables related to youtube_video
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
		$cls = YoutubeVideoPeer::getOMClass(false);
		// populate the object(s)
		while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
			$key = YoutubeVideoPeer::getPrimaryKeyHashFromRow($row, 0);
			if (null !== ($obj = YoutubeVideoPeer::getInstanceFromPool($key))) {
				// We no longer rehydrate the object, since this can cause data loss.
				// See http://propel.phpdb.org/trac/ticket/509
				// $obj->hydrate($row, 0, true); // rehydrate
				$results[] = $obj;
			} else {
				$obj = new $cls();
				$obj->hydrate($row);
				$results[] = $obj;
				YoutubeVideoPeer::addInstanceToPool($obj, $key);
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
	  $dbMap = Propel::getDatabaseMap(BaseYoutubeVideoPeer::DATABASE_NAME);
	  if (!$dbMap->hasTable(BaseYoutubeVideoPeer::TABLE_NAME))
	  {
	    $dbMap->addTableObject(new YoutubeVideoTableMap());
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
		return $withPrefix ? YoutubeVideoPeer::CLASS_DEFAULT : YoutubeVideoPeer::OM_CLASS;
	}

	/**
	 * Method perform an INSERT on the database, given a YoutubeVideo or Criteria object.
	 *
	 * @param      mixed $values Criteria or YoutubeVideo object containing data that is used to create the INSERT statement.
	 * @param      PropelPDO $con the PropelPDO connection to use
	 * @return     mixed The new primary key.
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doInsert($values, PropelPDO $con = null)
	{
    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseYoutubeVideoPeer:doInsert:pre') as $sf_hook)
    {
      if (false !== $sf_hook_retval = call_user_func($sf_hook, 'BaseYoutubeVideoPeer', $values, $con))
      {
        return $sf_hook_retval;
      }
    }

		if ($con === null) {
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		if ($values instanceof Criteria) {
			$criteria = clone $values; // rename for clarity
		} else {
			$criteria = $values->buildCriteria(); // build Criteria from YoutubeVideo object
		}

		if ($criteria->containsKey(YoutubeVideoPeer::ID) && $criteria->keyContainsValue(YoutubeVideoPeer::ID) ) {
			throw new PropelException('Cannot insert a value for auto-increment primary key ('.YoutubeVideoPeer::ID.')');
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
    foreach (sfMixer::getCallables('BaseYoutubeVideoPeer:doInsert:post') as $sf_hook)
    {
      call_user_func($sf_hook, 'BaseYoutubeVideoPeer', $values, $con, $pk);
    }

		return $pk;
	}

	/**
	 * Method perform an UPDATE on the database, given a YoutubeVideo or Criteria object.
	 *
	 * @param      mixed $values Criteria or YoutubeVideo object containing data that is used to create the UPDATE statement.
	 * @param      PropelPDO $con The connection to use (specify PropelPDO connection object to exert more control over transactions).
	 * @return     int The number of affected rows (if supported by underlying database driver).
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doUpdate($values, PropelPDO $con = null)
	{
    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseYoutubeVideoPeer:doUpdate:pre') as $sf_hook)
    {
      if (false !== $sf_hook_retval = call_user_func($sf_hook, 'BaseYoutubeVideoPeer', $values, $con))
      {
        return $sf_hook_retval;
      }
    }

		if ($con === null) {
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		$selectCriteria = new Criteria(self::DATABASE_NAME);

		if ($values instanceof Criteria) {
			$criteria = clone $values; // rename for clarity

			$comparison = $criteria->getComparison(YoutubeVideoPeer::ID);
			$selectCriteria->add(YoutubeVideoPeer::ID, $criteria->remove(YoutubeVideoPeer::ID), $comparison);

		} else { // $values is YoutubeVideo object
			$criteria = $values->buildCriteria(); // gets full criteria
			$selectCriteria = $values->buildPkeyCriteria(); // gets criteria w/ primary key(s)
		}

		// set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);

		$ret = BasePeer::doUpdate($selectCriteria, $criteria, $con);

    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseYoutubeVideoPeer:doUpdate:post') as $sf_hook)
    {
      call_user_func($sf_hook, 'BaseYoutubeVideoPeer', $values, $con, $ret);
    }

    return $ret;
	}

	/**
	 * Method to DELETE all rows from the youtube_video table.
	 *
	 * @return     int The number of affected rows (if supported by underlying database driver).
	 */
	public static function doDeleteAll($con = null)
	{
		if ($con === null) {
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}
		$affectedRows = 0; // initialize var to track total num of affected rows
		try {
			// use transaction because $criteria could contain info
			// for more than one table or we could emulating ON DELETE CASCADE, etc.
			$con->beginTransaction();
			$affectedRows += BasePeer::doDeleteAll(YoutubeVideoPeer::TABLE_NAME, $con);
			// Because this db requires some delete cascade/set null emulation, we have to
			// clear the cached instance *after* the emulation has happened (since
			// instances get re-added by the select statement contained therein).
			YoutubeVideoPeer::clearInstancePool();
			YoutubeVideoPeer::clearRelatedInstancePool();
			$con->commit();
			return $affectedRows;
		} catch (PropelException $e) {
			$con->rollBack();
			throw $e;
		}
	}

	/**
	 * Method perform a DELETE on the database, given a YoutubeVideo or Criteria object OR a primary key value.
	 *
	 * @param      mixed $values Criteria or YoutubeVideo object or primary key or array of primary keys
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
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		if ($values instanceof Criteria) {
			// invalidate the cache for all objects of this type, since we have no
			// way of knowing (without running a query) what objects should be invalidated
			// from the cache based on this Criteria.
			YoutubeVideoPeer::clearInstancePool();
			// rename for clarity
			$criteria = clone $values;
		} elseif ($values instanceof YoutubeVideo) { // it's a model object
			// invalidate the cache for this single object
			YoutubeVideoPeer::removeInstanceFromPool($values);
			// create criteria based on pk values
			$criteria = $values->buildPkeyCriteria();
		} else { // it's a primary key, or an array of pks
			$criteria = new Criteria(self::DATABASE_NAME);
			$criteria->add(YoutubeVideoPeer::ID, (array) $values, Criteria::IN);
			// invalidate the cache for this object(s)
			foreach ((array) $values as $singleval) {
				YoutubeVideoPeer::removeInstanceFromPool($singleval);
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
			YoutubeVideoPeer::clearRelatedInstancePool();
			$con->commit();
			return $affectedRows;
		} catch (PropelException $e) {
			$con->rollBack();
			throw $e;
		}
	}

	/**
	 * Validates all modified columns of given YoutubeVideo object.
	 * If parameter $columns is either a single column name or an array of column names
	 * than only those columns are validated.
	 *
	 * NOTICE: This does not apply to primary or foreign keys for now.
	 *
	 * @param      YoutubeVideo $obj The object to validate.
	 * @param      mixed $cols Column name or array of column names.
	 *
	 * @return     mixed TRUE if all columns are valid or the error message of the first invalid column.
	 */
	public static function doValidate(YoutubeVideo $obj, $cols = null)
	{
		$columns = array();

		if ($cols) {
			$dbMap = Propel::getDatabaseMap(YoutubeVideoPeer::DATABASE_NAME);
			$tableMap = $dbMap->getTable(YoutubeVideoPeer::TABLE_NAME);

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

		return BasePeer::doValidate(YoutubeVideoPeer::DATABASE_NAME, YoutubeVideoPeer::TABLE_NAME, $columns);
	}

	/**
	 * Retrieve a single object by pkey.
	 *
	 * @param      int $pk the primary key.
	 * @param      PropelPDO $con the connection to use
	 * @return     YoutubeVideo
	 */
	public static function retrieveByPK($pk, PropelPDO $con = null)
	{

		if (null !== ($obj = YoutubeVideoPeer::getInstanceFromPool((string) $pk))) {
			return $obj;
		}

		if ($con === null) {
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		$criteria = new Criteria(YoutubeVideoPeer::DATABASE_NAME);
		$criteria->add(YoutubeVideoPeer::ID, $pk);

		$v = YoutubeVideoPeer::doSelect($criteria, $con);

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
			$con = Propel::getConnection(YoutubeVideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		$objs = null;
		if (empty($pks)) {
			$objs = array();
		} else {
			$criteria = new Criteria(YoutubeVideoPeer::DATABASE_NAME);
			$criteria->add(YoutubeVideoPeer::ID, $pks, Criteria::IN);
			$objs = YoutubeVideoPeer::doSelect($criteria, $con);
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
	    return sprintf('BaseYoutubeVideoPeer:%s:%1$s', 'Count' == $match[1] ? 'doCount' : $match[0]);
	  }
	
	  throw new LogicException(sprintf('Unrecognized function "%s"', $method));
	}

} // BaseYoutubeVideoPeer

// This is the static code needed to register the TableMap for this table with the main Propel class.
//
BaseYoutubeVideoPeer::buildTableMap();

