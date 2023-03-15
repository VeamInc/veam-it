<?php

/**
 * YoutubeVideo filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseYoutubeVideoFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'                => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'rating'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'author'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'duration'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'expired_at'          => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'title'               => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'description'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'category_id'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'sub_category_id'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'youtube_code'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'is_new'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'downloadable'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'small_thumbnail_url' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'large_thumbnail_url' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'video_url'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'video_size'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'video_key'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'price'               => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'link_url'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'             => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'          => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'          => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'              => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'kind'                => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'rating'              => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'author'              => new sfValidatorPass(array('required' => false)),
      'duration'            => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'expired_at'          => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'title'               => new sfValidatorPass(array('required' => false)),
      'description'         => new sfValidatorPass(array('required' => false)),
      'category_id'         => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'sub_category_id'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'youtube_code'        => new sfValidatorPass(array('required' => false)),
      'is_new'              => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'downloadable'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'small_thumbnail_url' => new sfValidatorPass(array('required' => false)),
      'large_thumbnail_url' => new sfValidatorPass(array('required' => false)),
      'video_url'           => new sfValidatorPass(array('required' => false)),
      'video_size'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'video_key'           => new sfValidatorPass(array('required' => false)),
      'price'               => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'link_url'            => new sfValidatorPass(array('required' => false)),
      'del_flg'             => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'          => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'          => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('youtube_video_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'YoutubeVideo';
  }

  public function getFields()
  {
    return array(
      'id'                  => 'Number',
      'app_id'              => 'Number',
      'kind'                => 'Number',
      'rating'              => 'Number',
      'author'              => 'Text',
      'duration'            => 'Number',
      'expired_at'          => 'Date',
      'title'               => 'Text',
      'description'         => 'Text',
      'category_id'         => 'Number',
      'sub_category_id'     => 'Number',
      'youtube_code'        => 'Text',
      'is_new'              => 'Number',
      'downloadable'        => 'Number',
      'small_thumbnail_url' => 'Text',
      'large_thumbnail_url' => 'Text',
      'video_url'           => 'Text',
      'video_size'          => 'Number',
      'video_key'           => 'Text',
      'price'               => 'Number',
      'link_url'            => 'Text',
      'del_flg'             => 'Number',
      'created_at'          => 'Date',
      'updated_at'          => 'Date',
    );
  }
}
