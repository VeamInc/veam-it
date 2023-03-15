<?php

/**
 * Live filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseLiveFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'composer'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'duration'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'expired_at'       => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'explanation'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'genre_id'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'has_preview'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'is_priced'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'             => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'price'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'sub_title'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'rating'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'share_text'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail_url'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail_size'   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'preview_url'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'preview_size'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'preview_key'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'drm_preview_url'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'drm_preview_size' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'drm_preview_key'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'video_url'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'video_size'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'video_key'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'pending'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'       => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'       => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'composer'         => new sfValidatorPass(array('required' => false)),
      'duration'         => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'expired_at'       => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'explanation'      => new sfValidatorPass(array('required' => false)),
      'genre_id'         => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'has_preview'      => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'is_priced'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'kind'             => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'price'            => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'sub_title'        => new sfValidatorPass(array('required' => false)),
      'title'            => new sfValidatorPass(array('required' => false)),
      'rating'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'share_text'       => new sfValidatorPass(array('required' => false)),
      'thumbnail_url'    => new sfValidatorPass(array('required' => false)),
      'thumbnail_size'   => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'preview_url'      => new sfValidatorPass(array('required' => false)),
      'preview_size'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'preview_key'      => new sfValidatorPass(array('required' => false)),
      'drm_preview_url'  => new sfValidatorPass(array('required' => false)),
      'drm_preview_size' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'drm_preview_key'  => new sfValidatorPass(array('required' => false)),
      'video_url'        => new sfValidatorPass(array('required' => false)),
      'video_size'       => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'video_key'        => new sfValidatorPass(array('required' => false)),
      'pending'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'del_flg'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'       => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'       => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('live_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Live';
  }

  public function getFields()
  {
    return array(
      'id'               => 'Number',
      'app_id'           => 'Number',
      'composer'         => 'Text',
      'duration'         => 'Number',
      'expired_at'       => 'Date',
      'explanation'      => 'Text',
      'genre_id'         => 'Number',
      'has_preview'      => 'Number',
      'is_priced'        => 'Number',
      'kind'             => 'Number',
      'price'            => 'Number',
      'sub_title'        => 'Text',
      'title'            => 'Text',
      'rating'           => 'Number',
      'share_text'       => 'Text',
      'thumbnail_url'    => 'Text',
      'thumbnail_size'   => 'Number',
      'preview_url'      => 'Text',
      'preview_size'     => 'Number',
      'preview_key'      => 'Text',
      'drm_preview_url'  => 'Text',
      'drm_preview_size' => 'Number',
      'drm_preview_key'  => 'Text',
      'video_url'        => 'Text',
      'video_size'       => 'Number',
      'video_key'        => 'Text',
      'pending'          => 'Number',
      'del_flg'          => 'Number',
      'created_at'       => 'Date',
      'updated_at'       => 'Date',
    );
  }
}
