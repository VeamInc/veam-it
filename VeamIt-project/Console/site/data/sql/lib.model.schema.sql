
# This is a fix for InnoDB in MySQL >= 4.1.x
# It "suspends judgement" for fkey relationships until are tables are set.
SET FOREIGN_KEY_CHECKS = 0;

#-----------------------------------------------------------------------------
#-- app
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `app`;


CREATE TABLE `app`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`name` TEXT  NOT NULL,
	`client_id` INTEGER(11)  NOT NULL,
	`getglue_object` TEXT  NOT NULL,
	`getglue_source` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- blog_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `blog_category`;


CREATE TABLE `blog_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- blog_post
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `blog_post`;


CREATE TABLE `blog_post`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`title` TEXT  NOT NULL,
	`html` TEXT  NOT NULL,
	`blog_category_id` INTEGER(11)  NOT NULL,
	`blog_sub_category_id` INTEGER(11)  NOT NULL,
	`thumbnail_url` TEXT  NOT NULL,
	`posted_at` DATETIME,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- blog_sub_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `blog_sub_category`;


CREATE TABLE `blog_sub_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`category_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- bulletin
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `bulletin`;


CREATE TABLE `bulletin`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` TEXT  NOT NULL,
	`start_at` DATETIME,
	`end_at` DATETIME,
	`index` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11)  NOT NULL,
	`background_color` TEXT  NOT NULL,
	`text_color` TEXT  NOT NULL,
	`message` TEXT  NOT NULL,
	`image_url` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- calendar
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `calendar`;


CREATE TABLE `calendar`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` TEXT  NOT NULL,
	`kind` INTEGER(11)  NOT NULL,
	`yymmdd` INTEGER(11)  NOT NULL,
	`data` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `category`;


CREATE TABLE `category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11) default 0 NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- comment
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `comment`;


CREATE TABLE `comment`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`body` TEXT  NOT NULL,
	`app_id` INTEGER(11)  NOT NULL,
	`video_id` INTEGER(11)  NOT NULL,
	`user_id` TEXT  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- device_token
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `device_token`;


CREATE TABLE `device_token`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`token` TEXT  NOT NULL,
	`adid` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- extra_data
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `extra_data`;


CREATE TABLE `extra_data`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`video_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`data` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- featured_video
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `featured_video`;


CREATE TABLE `featured_video`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11)  NOT NULL,
	`order` INTEGER(11)  NOT NULL,
	`video_id` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- forum
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `forum`;


CREATE TABLE `forum`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11) default 1 NOT NULL,
	`name` TEXT  NOT NULL,
	`number_of_likes` INTEGER(11)  NOT NULL,
	`number_of_comments` INTEGER(11)  NOT NULL,
	`number_of_pictures` INTEGER(11)  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- gcm_register
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `gcm_register`;


CREATE TABLE `gcm_register`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`token` TEXT  NOT NULL,
	`adid` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- genre
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `genre`;


CREATE TABLE `genre`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`name` TEXT  NOT NULL,
	`app_id` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- itunes_sales
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `itunes_sales`;


CREATE TABLE `itunes_sales`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`provider` TEXT  NOT NULL,
	`provider_country` TEXT  NOT NULL,
	`sku` TEXT  NOT NULL,
	`developer` TEXT  NOT NULL,
	`title` TEXT  NOT NULL,
	`version` TEXT  NOT NULL,
	`product_type_identifier` TEXT  NOT NULL,
	`units` INTEGER(11) default 0 NOT NULL,
	`developer_proceeds` TEXT  NOT NULL,
	`begin_date` DATE,
	`end_date` DATE,
	`customer_currency` TEXT  NOT NULL,
	`country_code` TEXT  NOT NULL,
	`currency_of_proceeds` TEXT  NOT NULL,
	`apple_identifier` TEXT  NOT NULL,
	`customer_price` TEXT  NOT NULL,
	`promo_code` TEXT  NOT NULL,
	`parent_identifier` TEXT  NOT NULL,
	`subscription` TEXT  NOT NULL,
	`period` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- like_video
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `like_video`;


CREATE TABLE `like_video`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`user_id` TEXT  NOT NULL,
	`video_id` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- live
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `live`;


CREATE TABLE `live`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`composer` TEXT  NOT NULL,
	`duration` INTEGER(11)  NOT NULL,
	`expired_at` DATETIME,
	`explanation` TEXT  NOT NULL,
	`genre_id` INTEGER(11)  NOT NULL,
	`has_preview` INTEGER(11)  NOT NULL,
	`is_priced` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11)  NOT NULL,
	`price` INTEGER(11)  NOT NULL,
	`sub_title` TEXT  NOT NULL,
	`title` TEXT  NOT NULL,
	`rating` INTEGER(11)  NOT NULL,
	`share_text` TEXT  NOT NULL,
	`thumbnail_url` TEXT  NOT NULL,
	`thumbnail_size` INTEGER(11)  NOT NULL,
	`preview_url` TEXT  NOT NULL,
	`preview_size` INTEGER(11)  NOT NULL,
	`preview_key` TEXT  NOT NULL,
	`drm_preview_url` TEXT  NOT NULL,
	`drm_preview_size` INTEGER(11)  NOT NULL,
	`drm_preview_key` TEXT  NOT NULL,
	`video_url` TEXT  NOT NULL,
	`video_size` INTEGER(11)  NOT NULL,
	`video_key` TEXT  NOT NULL,
	`pending` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- message
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `message`;


CREATE TABLE `message`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`video_id` INTEGER(11)  NOT NULL,
	`user_id` TEXT  NOT NULL,
	`name` TEXT  NOT NULL,
	`email` TEXT  NOT NULL,
	`zip` TEXT  NOT NULL,
	`comment` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- music
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `music`;


CREATE TABLE `music`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`video_id` INTEGER(11)  NOT NULL,
	`duration` INTEGER(11)  NOT NULL,
	`expired_at` DATETIME,
	`explanation` TEXT  NOT NULL,
	`price` INTEGER(11)  NOT NULL,
	`sub_title` TEXT  NOT NULL,
	`title` TEXT  NOT NULL,
	`sample_url` TEXT  NOT NULL,
	`sample_size` INTEGER(11)  NOT NULL,
	`music_url` TEXT  NOT NULL,
	`music_size` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	`app_id` INTEGER(11)  NOT NULL,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- notification
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `notification`;


CREATE TABLE `notification`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`message` TEXT  NOT NULL,
	`finished` INTEGER(11) default 0 NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- picture
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `picture`;


CREATE TABLE `picture`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`forum_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`number_of_likes` INTEGER(11)  NOT NULL,
	`url` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `forum_id`(`forum_id`),
	KEY `social_user_id`(`social_user_id`),
	KEY `created_at`(`created_at`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- picture_comment
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `picture_comment`;


CREATE TABLE `picture_comment`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`picture_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`comment` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `picture_id`(`picture_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- picture_like
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `picture_like`;


CREATE TABLE `picture_like`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11) default 0 NOT NULL,
	`picture_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `social_user_id`(`social_user_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- program
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `program`;


CREATE TABLE `program`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11) default 1 NOT NULL,
	`author` TEXT  NOT NULL,
	`duration` INTEGER(11)  NOT NULL,
	`title` TEXT  NOT NULL,
	`description` TEXT  NOT NULL,
	`small_image_url` TEXT  NOT NULL,
	`large_image_url` TEXT  NOT NULL,
	`data_url` TEXT  NOT NULL,
	`data_size` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- program_comment
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `program_comment`;


CREATE TABLE `program_comment`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`program_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`comment` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `program_id`(`program_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- program_like
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `program_like`;


CREATE TABLE `program_like`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11) default 0 NOT NULL,
	`program_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `social_user_id`(`social_user_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- purchased_video
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `purchased_video`;


CREATE TABLE `purchased_video`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`user_id` INTEGER(11)  NOT NULL,
	`video_id` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- recipe
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `recipe`;


CREATE TABLE `recipe`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`recipe_category_id` INTEGER(11)  NOT NULL,
	`title` TEXT  NOT NULL,
	`image_url` TEXT  NOT NULL,
	`ingredients` TEXT  NOT NULL,
	`directions` TEXT  NOT NULL,
	`nutrition` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- recipe_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `recipe_category`;


CREATE TABLE `recipe_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- report
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `report`;


CREATE TABLE `report`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` TEXT  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11),
	`content` INTEGER(11),
	`message` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- report_address
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `report_address`;


CREATE TABLE `report_address`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`email` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- skin_info
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `skin_info`;


CREATE TABLE `skin_info`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`picture_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`skin_tone` TEXT  NOT NULL,
	`skin_type` TEXT  NOT NULL,
	`eye_color` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `forum_id`(`picture_id`),
	KEY `social_user_id`(`social_user_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- social_follow
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `social_follow`;


CREATE TABLE `social_follow`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`from_user` INTEGER(11)  NOT NULL,
	`to_user` INTEGER(11)  NOT NULL,
	`comment` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `from_user`(`from_user`),
	KEY `to_user`(`to_user`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- social_post
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `social_post`;


CREATE TABLE `social_post`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`reply_to` INTEGER(11)  NOT NULL,
	`message` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- social_user
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `social_user`;


CREATE TABLE `social_user`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`secret` TEXT  NOT NULL,
	`twitter_id` TEXT  NOT NULL,
	`facebook_id` TEXT  NOT NULL,
	`name` TEXT  NOT NULL,
	`twitter_user` TEXT  NOT NULL,
	`profile_image` TEXT  NOT NULL,
	`description` TEXT  NOT NULL,
	`location` TEXT  NOT NULL,
	`latitude` INTEGER(11)  NOT NULL,
	`longitude` INTEGER(11)  NOT NULL,
	`block_level` INTEGER(11) default 0 NOT NULL,
	`number_of_pictures` INTEGER(11) default 0 NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- stamp
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `stamp`;


CREATE TABLE `stamp`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`product` TEXT  NOT NULL,
	`name` TEXT  NOT NULL,
	`description` TEXT  NOT NULL,
	`image_url` TEXT  NOT NULL,
	`back_palet` TEXT  NOT NULL,
	`price` INTEGER(11) default 99 NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- stamp_image
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `stamp_image`;


CREATE TABLE `stamp_image`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`stamp_id` INTEGER(11)  NOT NULL,
	`url` TEXT  NOT NULL,
	`back_palet` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- store_receipt
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `store_receipt`;


CREATE TABLE `store_receipt`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`user_id` TEXT  NOT NULL,
	`quantity` INTEGER(11)  NOT NULL,
	`product_id` TEXT  NOT NULL,
	`transaction_id` TEXT  NOT NULL,
	`purchase_date` TEXT,
	`original_transaction_id` TEXT  NOT NULL,
	`original_purchase_date` TEXT,
	`app_item_id` TEXT  NOT NULL,
	`version_external_identifier` TEXT  NOT NULL,
	`bid` TEXT  NOT NULL,
	`bvrs` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- store_subscription_receipt
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `store_subscription_receipt`;


CREATE TABLE `store_subscription_receipt`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`user_id` TEXT  NOT NULL,
	`quantity` INTEGER(11)  NOT NULL,
	`product_id` TEXT  NOT NULL,
	`transaction_id` TEXT  NOT NULL,
	`purchase_date` TEXT,
	`original_transaction_id` TEXT  NOT NULL,
	`original_purchase_date` TEXT,
	`app_item_id` TEXT  NOT NULL,
	`version_external_identifier` TEXT  NOT NULL,
	`bid` TEXT  NOT NULL,
	`bvrs` TEXT  NOT NULL,
	`expires_date` TEXT  NOT NULL,
	`latest_receipt` TEXT  NOT NULL,
	`latest_receipt_info` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- sub_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `sub_category`;


CREATE TABLE `sub_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`category_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- swatch
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `swatch`;


CREATE TABLE `swatch`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`picture_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`number_of_likes` INTEGER(11)  NOT NULL,
	`base_url` TEXT  NOT NULL,
	`image1` TEXT  NOT NULL,
	`image2` TEXT  NOT NULL,
	`image3` TEXT  NOT NULL,
	`image4` TEXT  NOT NULL,
	`image5` TEXT  NOT NULL,
	`thumbnail1` TEXT  NOT NULL,
	`thumbnail2` TEXT  NOT NULL,
	`thumbnail3` TEXT  NOT NULL,
	`thumbnail4` TEXT  NOT NULL,
	`thumbnail5` TEXT  NOT NULL,
	`product_name` TEXT  NOT NULL,
	`category` TEXT  NOT NULL,
	`brand` TEXT  NOT NULL,
	`rating` INTEGER(11)  NOT NULL,
	`skin_tone` TEXT  NOT NULL,
	`skin_type` TEXT  NOT NULL,
	`eye_color` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `forum_id`(`picture_id`),
	KEY `social_user_id`(`social_user_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- swatch_comment
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `swatch_comment`;


CREATE TABLE `swatch_comment`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`swatch_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`comment` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `swatch_id`(`swatch_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- textline
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `textline`;


CREATE TABLE `textline`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`textline_category_id` INTEGER(11)  NOT NULL,
	`textline_sub_category_id` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11) default 0 NOT NULL,
	`title` TEXT  NOT NULL,
	`text` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- textline_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `textline_category`;


CREATE TABLE `textline_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- textline_sub_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `textline_sub_category`;


CREATE TABLE `textline_sub_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`textline_category_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- theme
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `theme`;


CREATE TABLE `theme`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`product` TEXT  NOT NULL,
	`title` TEXT  NOT NULL,
	`description` TEXT  NOT NULL,
	`base_url` TEXT  NOT NULL,
	`thumbnail_name` TEXT  NOT NULL,
	`screenshots` TEXT  NOT NULL,
	`images` TEXT  NOT NULL,
	`top_color` TEXT  NOT NULL,
	`top_text_color` TEXT  NOT NULL,
	`top_text_font` TEXT  NOT NULL,
	`top_text_size` TEXT  NOT NULL,
	`base_text_color` TEXT  NOT NULL,
	`link_text_color` TEXT  NOT NULL,
	`background_color` TEXT  NOT NULL,
	`post_text_color` TEXT  NOT NULL,
	`status_bar_color` TEXT  NOT NULL,
	`status_bar_style` INTEGER(11)  NOT NULL,
	`separator_color` TEXT  NOT NULL,
	`text1_color` TEXT  NOT NULL,
	`text2_color` TEXT  NOT NULL,
	`text3_color` TEXT  NOT NULL,
	`price` INTEGER(11) default 99 NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- ticket
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `ticket`;


CREATE TABLE `ticket`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`transaction` TEXT  NOT NULL,
	`kind` INTEGER(11) default 1 NOT NULL,
	`title` TEXT  NOT NULL,
	`description` TEXT  NOT NULL,
	`image_url` TEXT  NOT NULL,
	`used_image_url` TEXT  NOT NULL,
	`used` INTEGER(11) default 0 NOT NULL,
	`code` TEXT  NOT NULL,
	`qualified_at` DATETIME,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- upload_video
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `upload_video`;


CREATE TABLE `upload_video`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`user_id` TEXT  NOT NULL,
	`video_id` INTEGER(11)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- user_adid
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `user_adid`;


CREATE TABLE `user_adid`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`adid` VARCHAR(64)  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `social_user_id`(`social_user_id`),
	KEY `adid`(`adid`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- video
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `video`;


CREATE TABLE `video`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`composer` TEXT  NOT NULL,
	`duration` INTEGER(11)  NOT NULL,
	`expired_at` DATETIME,
	`explanation` TEXT  NOT NULL,
	`genre_id` INTEGER(11)  NOT NULL,
	`video_category_id` INTEGER(11) default 0 NOT NULL,
	`video_sub_category_id` INTEGER(11) default 0 NOT NULL,
	`has_preview` INTEGER(11)  NOT NULL,
	`is_priced` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11)  NOT NULL,
	`price` INTEGER(11)  NOT NULL,
	`sub_title` TEXT  NOT NULL,
	`title` TEXT  NOT NULL,
	`rating` INTEGER(11)  NOT NULL,
	`share_text` TEXT  NOT NULL,
	`thumbnail_url` TEXT  NOT NULL,
	`thumbnail_size` INTEGER(11)  NOT NULL,
	`preview_url` TEXT  NOT NULL,
	`preview_size` INTEGER(11)  NOT NULL,
	`preview_key` TEXT  NOT NULL,
	`drm_preview_url` TEXT  NOT NULL,
	`drm_preview_size` INTEGER(11)  NOT NULL,
	`drm_preview_key` TEXT  NOT NULL,
	`zip_url` TEXT  NOT NULL,
	`zip_size` INTEGER(11)  NOT NULL,
	`zip_key` TEXT  NOT NULL,
	`video_url` TEXT  NOT NULL,
	`video_size` INTEGER(11)  NOT NULL,
	`video_key` TEXT  NOT NULL,
	`drm_video_url` TEXT  NOT NULL,
	`drm_video_size` INTEGER(11)  NOT NULL,
	`drm_video_key` TEXT  NOT NULL,
	`pending` INTEGER(11)  NOT NULL,
	`getglue_object` TEXT  NOT NULL,
	`landingpage` TEXT  NOT NULL,
	`shorten_title` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	`app_id` INTEGER(11)  NOT NULL,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- video_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `video_category`;


CREATE TABLE `video_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- video_sub_category
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `video_sub_category`;


CREATE TABLE `video_sub_category`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`video_category_id` INTEGER(11)  NOT NULL,
	`name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- weekday_text
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `weekday_text`;


CREATE TABLE `weekday_text`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` TEXT  NOT NULL,
	`start_at` INTEGER(11),
	`end_at` INTEGER(11),
	`weekday` INTEGER(11)  NOT NULL,
	`action` INTEGER(11) default 0 NOT NULL,
	`title` TEXT  NOT NULL,
	`description` TEXT  NOT NULL,
	`link_url` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- world_wide_info
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `world_wide_info`;


CREATE TABLE `world_wide_info`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`video_id` INTEGER(11)  NOT NULL,
	`sales_amount` INTEGER(11)  NOT NULL,
	`category_name` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- youtube_comment
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `youtube_comment`;


CREATE TABLE `youtube_comment`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`youtube_video_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`comment` TEXT  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `youtube_video_id`(`youtube_video_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- youtube_feed
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `youtube_feed`;


CREATE TABLE `youtube_feed`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`id_url` TEXT  NOT NULL,
	`title` TEXT  NOT NULL,
	`published` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- youtube_like
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `youtube_like`;


CREATE TABLE `youtube_like`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11) default 0 NOT NULL,
	`youtube_video_id` INTEGER(11)  NOT NULL,
	`social_user_id` INTEGER(11)  NOT NULL,
	`del_flag` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`),
	KEY `social_user_id`(`social_user_id`)
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- youtube_video
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `youtube_video`;


CREATE TABLE `youtube_video`
(
	`id` INTEGER(11)  NOT NULL AUTO_INCREMENT,
	`app_id` INTEGER(11)  NOT NULL,
	`kind` INTEGER(11) default 1 NOT NULL,
	`rating` INTEGER(11)  NOT NULL,
	`author` TEXT  NOT NULL,
	`duration` INTEGER(11)  NOT NULL,
	`expired_at` DATETIME,
	`title` TEXT  NOT NULL,
	`description` TEXT  NOT NULL,
	`category_id` INTEGER(11)  NOT NULL,
	`sub_category_id` INTEGER(11)  NOT NULL,
	`youtube_code` TEXT  NOT NULL,
	`is_new` INTEGER(11) default 0 NOT NULL,
	`downloadable` INTEGER(11)  NOT NULL,
	`small_thumbnail_url` TEXT  NOT NULL,
	`large_thumbnail_url` TEXT  NOT NULL,
	`video_url` TEXT  NOT NULL,
	`video_size` INTEGER(11)  NOT NULL,
	`video_key` TEXT  NOT NULL,
	`price` INTEGER(11)  NOT NULL,
	`link_url` TEXT  NOT NULL,
	`del_flg` INTEGER(11) default 0 NOT NULL,
	`created_at` DATETIME,
	`updated_at` DATETIME,
	PRIMARY KEY (`id`)
)Type=InnoDB;

# This restores the fkey checks, after having unset them earlier
SET FOREIGN_KEY_CHECKS = 1;
