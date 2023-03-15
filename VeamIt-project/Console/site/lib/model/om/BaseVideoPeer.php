<?php

/**
 * Base static class for performing query and update operations on the 'video' table.
 *
 * 
 *
 * This class was autogenerated by Propel 1.4.2 on:
 *
 * Wed Dec 13 16:31:11 2017
 *
 * @package    lib.model.om
 */
abstract class BaseVideoPeer {

	/** the default database name for this class */
	const DATABASE_NAME = 'propel';

	/** the table name for this class */
	const TABLE_NAME = 'video';

	/** the related Propel class for this table */
	const OM_CLASS = 'Video';

	/** A class that can be returned by this peer. */
	const CLASS_DEFAULT = 'lib.model.Video';

	/** the related TableMap class for this table */
	const TM_CLASS = 'VideoTableMap';
	
	/** The total number of columns. */
	const NUM_COLUMNS = 45;

	/** The number of lazy-loaded columns. */
	const NUM_LAZY_LOAD_COLUMNS = 0;

	/** the column name for the ID field */
	const ID = 'video.ID';

	/** the column name for the COMPOSER field */
	const COMPOSER = 'video.COMPOSER';

	/** the column name for the DURATION field */
	const DURATION = 'video.DURATION';

	/** the column name for the EXPIRED_AT field */
	const EXPIRED_AT = 'video.EXPIRED_AT';

	/** the column name for the EXPLANATION field */
	const EXPLANATION = 'video.EXPLANATION';

	/** the column name for the GENRE_ID field */
	const GENRE_ID = 'video.GENRE_ID';

	/** the column name for the VIDEO_CATEGORY_ID field */
	const VIDEO_CATEGORY_ID = 'video.VIDEO_CATEGORY_ID';

	/** the column name for the VIDEO_SUB_CATEGORY_ID field */
	const VIDEO_SUB_CATEGORY_ID = 'video.VIDEO_SUB_CATEGORY_ID';

	/** the column name for the HAS_PREVIEW field */
	const HAS_PREVIEW = 'video.HAS_PREVIEW';

	/** the column name for the IS_PRICED field */
	const IS_PRICED = 'video.IS_PRICED';

	/** the column name for the KIND field */
	const KIND = 'video.KIND';

	/** the column name for the PRICE field */
	const PRICE = 'video.PRICE';

	/** the column name for the SUB_TITLE field */
	const SUB_TITLE = 'video.SUB_TITLE';

	/** the column name for the TITLE field */
	const TITLE = 'video.TITLE';

	/** the column name for the RATING field */
	const RATING = 'video.RATING';

	/** the column name for the SHARE_TEXT field */
	const SHARE_TEXT = 'video.SHARE_TEXT';

	/** the column name for the THUMBNAIL_URL field */
	const THUMBNAIL_URL = 'video.THUMBNAIL_URL';

	/** the column name for the THUMBNAIL_SIZE field */
	const THUMBNAIL_SIZE = 'video.THUMBNAIL_SIZE';

	/** the column name for the SOURCE_URL field */
	const SOURCE_URL = 'video.SOURCE_URL';

	/** the column name for the PREVIEW_URL field */
	const PREVIEW_URL = 'video.PREVIEW_URL';

	/** the column name for the PREVIEW_SIZE field */
	const PREVIEW_SIZE = 'video.PREVIEW_SIZE';

	/** the column name for the PREVIEW_KEY field */
	const PREVIEW_KEY = 'video.PREVIEW_KEY';

	/** the column name for the DRM_PREVIEW_URL field */
	const DRM_PREVIEW_URL = 'video.DRM_PREVIEW_URL';

	/** the column name for the DRM_PREVIEW_SIZE field */
	const DRM_PREVIEW_SIZE = 'video.DRM_PREVIEW_SIZE';

	/** the column name for the DRM_PREVIEW_KEY field */
	const DRM_PREVIEW_KEY = 'video.DRM_PREVIEW_KEY';

	/** the column name for the ZIP_URL field */
	const ZIP_URL = 'video.ZIP_URL';

	/** the column name for the ZIP_SIZE field */
	const ZIP_SIZE = 'video.ZIP_SIZE';

	/** the column name for the ZIP_KEY field */
	const ZIP_KEY = 'video.ZIP_KEY';

	/** the column name for the VIDEO_URL field */
	const VIDEO_URL = 'video.VIDEO_URL';

	/** the column name for the VIDEO_SIZE field */
	const VIDEO_SIZE = 'video.VIDEO_SIZE';

	/** the column name for the VIDEO_KEY field */
	const VIDEO_KEY = 'video.VIDEO_KEY';

	/** the column name for the DRM_VIDEO_URL field */
	const DRM_VIDEO_URL = 'video.DRM_VIDEO_URL';

	/** the column name for the DRM_VIDEO_SIZE field */
	const DRM_VIDEO_SIZE = 'video.DRM_VIDEO_SIZE';

	/** the column name for the DRM_VIDEO_KEY field */
	const DRM_VIDEO_KEY = 'video.DRM_VIDEO_KEY';

	/** the column name for the PENDING field */
	const PENDING = 'video.PENDING';

	/** the column name for the GETGLUE_OBJECT field */
	const GETGLUE_OBJECT = 'video.GETGLUE_OBJECT';

	/** the column name for the LANDINGPAGE field */
	const LANDINGPAGE = 'video.LANDINGPAGE';

	/** the column name for the SHORTEN_TITLE field */
	const SHORTEN_TITLE = 'video.SHORTEN_TITLE';

	/** the column name for the DISPLAY_ORDER field */
	const DISPLAY_ORDER = 'video.DISPLAY_ORDER';

	/** the column name for the STATUS field */
	const STATUS = 'video.STATUS';

	/** the column name for the STATUS_TEXT field */
	const STATUS_TEXT = 'video.STATUS_TEXT';

	/** the column name for the DEL_FLG field */
	const DEL_FLG = 'video.DEL_FLG';

	/** the column name for the CREATED_AT field */
	const CREATED_AT = 'video.CREATED_AT';

	/** the column name for the UPDATED_AT field */
	const UPDATED_AT = 'video.UPDATED_AT';

	/** the column name for the APP_ID field */
	const APP_ID = 'video.APP_ID';

	/**
	 * An identiy map to hold any loaded instances of Video objects.
	 * This must be public so that other peer classes can access this when hydrating from JOIN
	 * queries.
	 * @var        array Video[]
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
		BasePeer::TYPE_PHPNAME => array ('Id', 'Composer', 'Duration', 'ExpiredAt', 'Explanation', 'GenreId', 'VideoCategoryId', 'VideoSubCategoryId', 'HasPreview', 'IsPriced', 'Kind', 'Price', 'SubTitle', 'Title', 'Rating', 'ShareText', 'ThumbnailUrl', 'ThumbnailSize', 'SourceUrl', 'PreviewUrl', 'PreviewSize', 'PreviewKey', 'DrmPreviewUrl', 'DrmPreviewSize', 'DrmPreviewKey', 'ZipUrl', 'ZipSize', 'ZipKey', 'VideoUrl', 'VideoSize', 'VideoKey', 'DrmVideoUrl', 'DrmVideoSize', 'DrmVideoKey', 'Pending', 'GetglueObject', 'Landingpage', 'ShortenTitle', 'DisplayOrder', 'Status', 'StatusText', 'DelFlg', 'CreatedAt', 'UpdatedAt', 'AppId', ),
		BasePeer::TYPE_STUDLYPHPNAME => array ('id', 'composer', 'duration', 'expiredAt', 'explanation', 'genreId', 'videoCategoryId', 'videoSubCategoryId', 'hasPreview', 'isPriced', 'kind', 'price', 'subTitle', 'title', 'rating', 'shareText', 'thumbnailUrl', 'thumbnailSize', 'sourceUrl', 'previewUrl', 'previewSize', 'previewKey', 'drmPreviewUrl', 'drmPreviewSize', 'drmPreviewKey', 'zipUrl', 'zipSize', 'zipKey', 'videoUrl', 'videoSize', 'videoKey', 'drmVideoUrl', 'drmVideoSize', 'drmVideoKey', 'pending', 'getglueObject', 'landingpage', 'shortenTitle', 'displayOrder', 'status', 'statusText', 'delFlg', 'createdAt', 'updatedAt', 'appId', ),
		BasePeer::TYPE_COLNAME => array (self::ID, self::COMPOSER, self::DURATION, self::EXPIRED_AT, self::EXPLANATION, self::GENRE_ID, self::VIDEO_CATEGORY_ID, self::VIDEO_SUB_CATEGORY_ID, self::HAS_PREVIEW, self::IS_PRICED, self::KIND, self::PRICE, self::SUB_TITLE, self::TITLE, self::RATING, self::SHARE_TEXT, self::THUMBNAIL_URL, self::THUMBNAIL_SIZE, self::SOURCE_URL, self::PREVIEW_URL, self::PREVIEW_SIZE, self::PREVIEW_KEY, self::DRM_PREVIEW_URL, self::DRM_PREVIEW_SIZE, self::DRM_PREVIEW_KEY, self::ZIP_URL, self::ZIP_SIZE, self::ZIP_KEY, self::VIDEO_URL, self::VIDEO_SIZE, self::VIDEO_KEY, self::DRM_VIDEO_URL, self::DRM_VIDEO_SIZE, self::DRM_VIDEO_KEY, self::PENDING, self::GETGLUE_OBJECT, self::LANDINGPAGE, self::SHORTEN_TITLE, self::DISPLAY_ORDER, self::STATUS, self::STATUS_TEXT, self::DEL_FLG, self::CREATED_AT, self::UPDATED_AT, self::APP_ID, ),
		BasePeer::TYPE_FIELDNAME => array ('id', 'composer', 'duration', 'expired_at', 'explanation', 'genre_id', 'video_category_id', 'video_sub_category_id', 'has_preview', 'is_priced', 'kind', 'price', 'sub_title', 'title', 'rating', 'share_text', 'thumbnail_url', 'thumbnail_size', 'source_url', 'preview_url', 'preview_size', 'preview_key', 'drm_preview_url', 'drm_preview_size', 'drm_preview_key', 'zip_url', 'zip_size', 'zip_key', 'video_url', 'video_size', 'video_key', 'drm_video_url', 'drm_video_size', 'drm_video_key', 'pending', 'getglue_object', 'landingpage', 'shorten_title', 'display_order', 'status', 'status_text', 'del_flg', 'created_at', 'updated_at', 'app_id', ),
		BasePeer::TYPE_NUM => array (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, )
	);

	/**
	 * holds an array of keys for quick access to the fieldnames array
	 *
	 * first dimension keys are the type constants
	 * e.g. self::$fieldNames[BasePeer::TYPE_PHPNAME]['Id'] = 0
	 */
	private static $fieldKeys = array (
		BasePeer::TYPE_PHPNAME => array ('Id' => 0, 'Composer' => 1, 'Duration' => 2, 'ExpiredAt' => 3, 'Explanation' => 4, 'GenreId' => 5, 'VideoCategoryId' => 6, 'VideoSubCategoryId' => 7, 'HasPreview' => 8, 'IsPriced' => 9, 'Kind' => 10, 'Price' => 11, 'SubTitle' => 12, 'Title' => 13, 'Rating' => 14, 'ShareText' => 15, 'ThumbnailUrl' => 16, 'ThumbnailSize' => 17, 'SourceUrl' => 18, 'PreviewUrl' => 19, 'PreviewSize' => 20, 'PreviewKey' => 21, 'DrmPreviewUrl' => 22, 'DrmPreviewSize' => 23, 'DrmPreviewKey' => 24, 'ZipUrl' => 25, 'ZipSize' => 26, 'ZipKey' => 27, 'VideoUrl' => 28, 'VideoSize' => 29, 'VideoKey' => 30, 'DrmVideoUrl' => 31, 'DrmVideoSize' => 32, 'DrmVideoKey' => 33, 'Pending' => 34, 'GetglueObject' => 35, 'Landingpage' => 36, 'ShortenTitle' => 37, 'DisplayOrder' => 38, 'Status' => 39, 'StatusText' => 40, 'DelFlg' => 41, 'CreatedAt' => 42, 'UpdatedAt' => 43, 'AppId' => 44, ),
		BasePeer::TYPE_STUDLYPHPNAME => array ('id' => 0, 'composer' => 1, 'duration' => 2, 'expiredAt' => 3, 'explanation' => 4, 'genreId' => 5, 'videoCategoryId' => 6, 'videoSubCategoryId' => 7, 'hasPreview' => 8, 'isPriced' => 9, 'kind' => 10, 'price' => 11, 'subTitle' => 12, 'title' => 13, 'rating' => 14, 'shareText' => 15, 'thumbnailUrl' => 16, 'thumbnailSize' => 17, 'sourceUrl' => 18, 'previewUrl' => 19, 'previewSize' => 20, 'previewKey' => 21, 'drmPreviewUrl' => 22, 'drmPreviewSize' => 23, 'drmPreviewKey' => 24, 'zipUrl' => 25, 'zipSize' => 26, 'zipKey' => 27, 'videoUrl' => 28, 'videoSize' => 29, 'videoKey' => 30, 'drmVideoUrl' => 31, 'drmVideoSize' => 32, 'drmVideoKey' => 33, 'pending' => 34, 'getglueObject' => 35, 'landingpage' => 36, 'shortenTitle' => 37, 'displayOrder' => 38, 'status' => 39, 'statusText' => 40, 'delFlg' => 41, 'createdAt' => 42, 'updatedAt' => 43, 'appId' => 44, ),
		BasePeer::TYPE_COLNAME => array (self::ID => 0, self::COMPOSER => 1, self::DURATION => 2, self::EXPIRED_AT => 3, self::EXPLANATION => 4, self::GENRE_ID => 5, self::VIDEO_CATEGORY_ID => 6, self::VIDEO_SUB_CATEGORY_ID => 7, self::HAS_PREVIEW => 8, self::IS_PRICED => 9, self::KIND => 10, self::PRICE => 11, self::SUB_TITLE => 12, self::TITLE => 13, self::RATING => 14, self::SHARE_TEXT => 15, self::THUMBNAIL_URL => 16, self::THUMBNAIL_SIZE => 17, self::SOURCE_URL => 18, self::PREVIEW_URL => 19, self::PREVIEW_SIZE => 20, self::PREVIEW_KEY => 21, self::DRM_PREVIEW_URL => 22, self::DRM_PREVIEW_SIZE => 23, self::DRM_PREVIEW_KEY => 24, self::ZIP_URL => 25, self::ZIP_SIZE => 26, self::ZIP_KEY => 27, self::VIDEO_URL => 28, self::VIDEO_SIZE => 29, self::VIDEO_KEY => 30, self::DRM_VIDEO_URL => 31, self::DRM_VIDEO_SIZE => 32, self::DRM_VIDEO_KEY => 33, self::PENDING => 34, self::GETGLUE_OBJECT => 35, self::LANDINGPAGE => 36, self::SHORTEN_TITLE => 37, self::DISPLAY_ORDER => 38, self::STATUS => 39, self::STATUS_TEXT => 40, self::DEL_FLG => 41, self::CREATED_AT => 42, self::UPDATED_AT => 43, self::APP_ID => 44, ),
		BasePeer::TYPE_FIELDNAME => array ('id' => 0, 'composer' => 1, 'duration' => 2, 'expired_at' => 3, 'explanation' => 4, 'genre_id' => 5, 'video_category_id' => 6, 'video_sub_category_id' => 7, 'has_preview' => 8, 'is_priced' => 9, 'kind' => 10, 'price' => 11, 'sub_title' => 12, 'title' => 13, 'rating' => 14, 'share_text' => 15, 'thumbnail_url' => 16, 'thumbnail_size' => 17, 'source_url' => 18, 'preview_url' => 19, 'preview_size' => 20, 'preview_key' => 21, 'drm_preview_url' => 22, 'drm_preview_size' => 23, 'drm_preview_key' => 24, 'zip_url' => 25, 'zip_size' => 26, 'zip_key' => 27, 'video_url' => 28, 'video_size' => 29, 'video_key' => 30, 'drm_video_url' => 31, 'drm_video_size' => 32, 'drm_video_key' => 33, 'pending' => 34, 'getglue_object' => 35, 'landingpage' => 36, 'shorten_title' => 37, 'display_order' => 38, 'status' => 39, 'status_text' => 40, 'del_flg' => 41, 'created_at' => 42, 'updated_at' => 43, 'app_id' => 44, ),
		BasePeer::TYPE_NUM => array (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, )
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
	 * @param      string $column The column name for current table. (i.e. VideoPeer::COLUMN_NAME).
	 * @return     string
	 */
	public static function alias($alias, $column)
	{
		return str_replace(VideoPeer::TABLE_NAME.'.', $alias.'.', $column);
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
		$criteria->addSelectColumn(VideoPeer::ID);
		$criteria->addSelectColumn(VideoPeer::COMPOSER);
		$criteria->addSelectColumn(VideoPeer::DURATION);
		$criteria->addSelectColumn(VideoPeer::EXPIRED_AT);
		$criteria->addSelectColumn(VideoPeer::EXPLANATION);
		$criteria->addSelectColumn(VideoPeer::GENRE_ID);
		$criteria->addSelectColumn(VideoPeer::VIDEO_CATEGORY_ID);
		$criteria->addSelectColumn(VideoPeer::VIDEO_SUB_CATEGORY_ID);
		$criteria->addSelectColumn(VideoPeer::HAS_PREVIEW);
		$criteria->addSelectColumn(VideoPeer::IS_PRICED);
		$criteria->addSelectColumn(VideoPeer::KIND);
		$criteria->addSelectColumn(VideoPeer::PRICE);
		$criteria->addSelectColumn(VideoPeer::SUB_TITLE);
		$criteria->addSelectColumn(VideoPeer::TITLE);
		$criteria->addSelectColumn(VideoPeer::RATING);
		$criteria->addSelectColumn(VideoPeer::SHARE_TEXT);
		$criteria->addSelectColumn(VideoPeer::THUMBNAIL_URL);
		$criteria->addSelectColumn(VideoPeer::THUMBNAIL_SIZE);
		$criteria->addSelectColumn(VideoPeer::SOURCE_URL);
		$criteria->addSelectColumn(VideoPeer::PREVIEW_URL);
		$criteria->addSelectColumn(VideoPeer::PREVIEW_SIZE);
		$criteria->addSelectColumn(VideoPeer::PREVIEW_KEY);
		$criteria->addSelectColumn(VideoPeer::DRM_PREVIEW_URL);
		$criteria->addSelectColumn(VideoPeer::DRM_PREVIEW_SIZE);
		$criteria->addSelectColumn(VideoPeer::DRM_PREVIEW_KEY);
		$criteria->addSelectColumn(VideoPeer::ZIP_URL);
		$criteria->addSelectColumn(VideoPeer::ZIP_SIZE);
		$criteria->addSelectColumn(VideoPeer::ZIP_KEY);
		$criteria->addSelectColumn(VideoPeer::VIDEO_URL);
		$criteria->addSelectColumn(VideoPeer::VIDEO_SIZE);
		$criteria->addSelectColumn(VideoPeer::VIDEO_KEY);
		$criteria->addSelectColumn(VideoPeer::DRM_VIDEO_URL);
		$criteria->addSelectColumn(VideoPeer::DRM_VIDEO_SIZE);
		$criteria->addSelectColumn(VideoPeer::DRM_VIDEO_KEY);
		$criteria->addSelectColumn(VideoPeer::PENDING);
		$criteria->addSelectColumn(VideoPeer::GETGLUE_OBJECT);
		$criteria->addSelectColumn(VideoPeer::LANDINGPAGE);
		$criteria->addSelectColumn(VideoPeer::SHORTEN_TITLE);
		$criteria->addSelectColumn(VideoPeer::DISPLAY_ORDER);
		$criteria->addSelectColumn(VideoPeer::STATUS);
		$criteria->addSelectColumn(VideoPeer::STATUS_TEXT);
		$criteria->addSelectColumn(VideoPeer::DEL_FLG);
		$criteria->addSelectColumn(VideoPeer::CREATED_AT);
		$criteria->addSelectColumn(VideoPeer::UPDATED_AT);
		$criteria->addSelectColumn(VideoPeer::APP_ID);
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
		$criteria->setPrimaryTableName(VideoPeer::TABLE_NAME);

		if ($distinct && !in_array(Criteria::DISTINCT, $criteria->getSelectModifiers())) {
			$criteria->setDistinct();
		}

		if (!$criteria->hasSelectClause()) {
			VideoPeer::addSelectColumns($criteria);
		}

		$criteria->clearOrderByColumns(); // ORDER BY won't ever affect the count
		$criteria->setDbName(self::DATABASE_NAME); // Set the correct dbName

		if ($con === null) {
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}
		// symfony_behaviors behavior
		foreach (sfMixer::getCallables(self::getMixerPreSelectHook(__FUNCTION__)) as $sf_hook)
		{
		  call_user_func($sf_hook, 'BaseVideoPeer', $criteria, $con);
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
	 * @return     Video
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doSelectOne(Criteria $criteria, PropelPDO $con = null)
	{
		$critcopy = clone $criteria;
		$critcopy->setLimit(1);
		$objects = VideoPeer::doSelect($critcopy, $con);
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
		return VideoPeer::populateObjects(VideoPeer::doSelectStmt($criteria, $con));
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
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		if (!$criteria->hasSelectClause()) {
			$criteria = clone $criteria;
			VideoPeer::addSelectColumns($criteria);
		}

		// Set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);
		// symfony_behaviors behavior
		foreach (sfMixer::getCallables(self::getMixerPreSelectHook(__FUNCTION__)) as $sf_hook)
		{
		  call_user_func($sf_hook, 'BaseVideoPeer', $criteria, $con);
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
	 * @param      Video $value A Video object.
	 * @param      string $key (optional) key to use for instance map (for performance boost if key was already calculated externally).
	 */
	public static function addInstanceToPool(Video $obj, $key = null)
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
	 * @param      mixed $value A Video object or a primary key value.
	 */
	public static function removeInstanceFromPool($value)
	{
		if (Propel::isInstancePoolingEnabled() && $value !== null) {
			if (is_object($value) && $value instanceof Video) {
				$key = (string) $value->getId();
			} elseif (is_scalar($value)) {
				// assume we've been passed a primary key
				$key = (string) $value;
			} else {
				$e = new PropelException("Invalid value passed to removeInstanceFromPool().  Expected primary key or Video object; got " . (is_object($value) ? get_class($value) . ' object.' : var_export($value,true)));
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
	 * @return     Video Found object or NULL if 1) no instance exists for specified key or 2) instance pooling has been disabled.
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
	 * Method to invalidate the instance pool of all tables related to video
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
		$cls = VideoPeer::getOMClass(false);
		// populate the object(s)
		while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
			$key = VideoPeer::getPrimaryKeyHashFromRow($row, 0);
			if (null !== ($obj = VideoPeer::getInstanceFromPool($key))) {
				// We no longer rehydrate the object, since this can cause data loss.
				// See http://propel.phpdb.org/trac/ticket/509
				// $obj->hydrate($row, 0, true); // rehydrate
				$results[] = $obj;
			} else {
				$obj = new $cls();
				$obj->hydrate($row);
				$results[] = $obj;
				VideoPeer::addInstanceToPool($obj, $key);
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
	  $dbMap = Propel::getDatabaseMap(BaseVideoPeer::DATABASE_NAME);
	  if (!$dbMap->hasTable(BaseVideoPeer::TABLE_NAME))
	  {
	    $dbMap->addTableObject(new VideoTableMap());
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
		return $withPrefix ? VideoPeer::CLASS_DEFAULT : VideoPeer::OM_CLASS;
	}

	/**
	 * Method perform an INSERT on the database, given a Video or Criteria object.
	 *
	 * @param      mixed $values Criteria or Video object containing data that is used to create the INSERT statement.
	 * @param      PropelPDO $con the PropelPDO connection to use
	 * @return     mixed The new primary key.
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doInsert($values, PropelPDO $con = null)
	{
    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseVideoPeer:doInsert:pre') as $sf_hook)
    {
      if (false !== $sf_hook_retval = call_user_func($sf_hook, 'BaseVideoPeer', $values, $con))
      {
        return $sf_hook_retval;
      }
    }

		if ($con === null) {
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		if ($values instanceof Criteria) {
			$criteria = clone $values; // rename for clarity
		} else {
			$criteria = $values->buildCriteria(); // build Criteria from Video object
		}

		if ($criteria->containsKey(VideoPeer::ID) && $criteria->keyContainsValue(VideoPeer::ID) ) {
			throw new PropelException('Cannot insert a value for auto-increment primary key ('.VideoPeer::ID.')');
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
    foreach (sfMixer::getCallables('BaseVideoPeer:doInsert:post') as $sf_hook)
    {
      call_user_func($sf_hook, 'BaseVideoPeer', $values, $con, $pk);
    }

		return $pk;
	}

	/**
	 * Method perform an UPDATE on the database, given a Video or Criteria object.
	 *
	 * @param      mixed $values Criteria or Video object containing data that is used to create the UPDATE statement.
	 * @param      PropelPDO $con The connection to use (specify PropelPDO connection object to exert more control over transactions).
	 * @return     int The number of affected rows (if supported by underlying database driver).
	 * @throws     PropelException Any exceptions caught during processing will be
	 *		 rethrown wrapped into a PropelException.
	 */
	public static function doUpdate($values, PropelPDO $con = null)
	{
    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseVideoPeer:doUpdate:pre') as $sf_hook)
    {
      if (false !== $sf_hook_retval = call_user_func($sf_hook, 'BaseVideoPeer', $values, $con))
      {
        return $sf_hook_retval;
      }
    }

		if ($con === null) {
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		$selectCriteria = new Criteria(self::DATABASE_NAME);

		if ($values instanceof Criteria) {
			$criteria = clone $values; // rename for clarity

			$comparison = $criteria->getComparison(VideoPeer::ID);
			$selectCriteria->add(VideoPeer::ID, $criteria->remove(VideoPeer::ID), $comparison);

		} else { // $values is Video object
			$criteria = $values->buildCriteria(); // gets full criteria
			$selectCriteria = $values->buildPkeyCriteria(); // gets criteria w/ primary key(s)
		}

		// set the correct dbName
		$criteria->setDbName(self::DATABASE_NAME);

		$ret = BasePeer::doUpdate($selectCriteria, $criteria, $con);

    // symfony_behaviors behavior
    foreach (sfMixer::getCallables('BaseVideoPeer:doUpdate:post') as $sf_hook)
    {
      call_user_func($sf_hook, 'BaseVideoPeer', $values, $con, $ret);
    }

    return $ret;
	}

	/**
	 * Method to DELETE all rows from the video table.
	 *
	 * @return     int The number of affected rows (if supported by underlying database driver).
	 */
	public static function doDeleteAll($con = null)
	{
		if ($con === null) {
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}
		$affectedRows = 0; // initialize var to track total num of affected rows
		try {
			// use transaction because $criteria could contain info
			// for more than one table or we could emulating ON DELETE CASCADE, etc.
			$con->beginTransaction();
			$affectedRows += BasePeer::doDeleteAll(VideoPeer::TABLE_NAME, $con);
			// Because this db requires some delete cascade/set null emulation, we have to
			// clear the cached instance *after* the emulation has happened (since
			// instances get re-added by the select statement contained therein).
			VideoPeer::clearInstancePool();
			VideoPeer::clearRelatedInstancePool();
			$con->commit();
			return $affectedRows;
		} catch (PropelException $e) {
			$con->rollBack();
			throw $e;
		}
	}

	/**
	 * Method perform a DELETE on the database, given a Video or Criteria object OR a primary key value.
	 *
	 * @param      mixed $values Criteria or Video object or primary key or array of primary keys
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
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_WRITE);
		}

		if ($values instanceof Criteria) {
			// invalidate the cache for all objects of this type, since we have no
			// way of knowing (without running a query) what objects should be invalidated
			// from the cache based on this Criteria.
			VideoPeer::clearInstancePool();
			// rename for clarity
			$criteria = clone $values;
		} elseif ($values instanceof Video) { // it's a model object
			// invalidate the cache for this single object
			VideoPeer::removeInstanceFromPool($values);
			// create criteria based on pk values
			$criteria = $values->buildPkeyCriteria();
		} else { // it's a primary key, or an array of pks
			$criteria = new Criteria(self::DATABASE_NAME);
			$criteria->add(VideoPeer::ID, (array) $values, Criteria::IN);
			// invalidate the cache for this object(s)
			foreach ((array) $values as $singleval) {
				VideoPeer::removeInstanceFromPool($singleval);
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
			VideoPeer::clearRelatedInstancePool();
			$con->commit();
			return $affectedRows;
		} catch (PropelException $e) {
			$con->rollBack();
			throw $e;
		}
	}

	/**
	 * Validates all modified columns of given Video object.
	 * If parameter $columns is either a single column name or an array of column names
	 * than only those columns are validated.
	 *
	 * NOTICE: This does not apply to primary or foreign keys for now.
	 *
	 * @param      Video $obj The object to validate.
	 * @param      mixed $cols Column name or array of column names.
	 *
	 * @return     mixed TRUE if all columns are valid or the error message of the first invalid column.
	 */
	public static function doValidate(Video $obj, $cols = null)
	{
		$columns = array();

		if ($cols) {
			$dbMap = Propel::getDatabaseMap(VideoPeer::DATABASE_NAME);
			$tableMap = $dbMap->getTable(VideoPeer::TABLE_NAME);

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

		return BasePeer::doValidate(VideoPeer::DATABASE_NAME, VideoPeer::TABLE_NAME, $columns);
	}

	/**
	 * Retrieve a single object by pkey.
	 *
	 * @param      int $pk the primary key.
	 * @param      PropelPDO $con the connection to use
	 * @return     Video
	 */
	public static function retrieveByPK($pk, PropelPDO $con = null)
	{

		if (null !== ($obj = VideoPeer::getInstanceFromPool((string) $pk))) {
			return $obj;
		}

		if ($con === null) {
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		$criteria = new Criteria(VideoPeer::DATABASE_NAME);
		$criteria->add(VideoPeer::ID, $pk);

		$v = VideoPeer::doSelect($criteria, $con);

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
			$con = Propel::getConnection(VideoPeer::DATABASE_NAME, Propel::CONNECTION_READ);
		}

		$objs = null;
		if (empty($pks)) {
			$objs = array();
		} else {
			$criteria = new Criteria(VideoPeer::DATABASE_NAME);
			$criteria->add(VideoPeer::ID, $pks, Criteria::IN);
			$objs = VideoPeer::doSelect($criteria, $con);
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
	    return sprintf('BaseVideoPeer:%s:%1$s', 'Count' == $match[1] ? 'doCount' : $match[0]);
	  }
	
	  throw new LogicException(sprintf('Unrecognized function "%s"', $method));
	}

} // BaseVideoPeer

// This is the static code needed to register the TableMap for this table with the main Propel class.
//
BaseVideoPeer::buildTableMap();

