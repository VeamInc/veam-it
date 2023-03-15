<?php

/**
 * Music filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseMusicFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'video_id'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'duration'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'expired_at'  => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'explanation' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'price'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'sub_title'   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'sample_url'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'sample_size' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'music_url'   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'music_size'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'  => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'  => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'app_id'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
    ));

    $this->setValidators(array(
      'video_id'    => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'duration'    => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'expired_at'  => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'explanation' => new sfValidatorPass(array('required' => false)),
      'price'       => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'sub_title'   => new sfValidatorPass(array('required' => false)),
      'title'       => new sfValidatorPass(array('required' => false)),
      'sample_url'  => new sfValidatorPass(array('required' => false)),
      'sample_size' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'music_url'   => new sfValidatorPass(array('required' => false)),
      'music_size'  => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'del_flg'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'  => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'  => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'app_id'      => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
    ));

    $this->widgetSchema->setNameFormat('music_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Music';
  }

  public function getFields()
  {
    return array(
      'id'          => 'Number',
      'video_id'    => 'Number',
      'duration'    => 'Number',
      'expired_at'  => 'Date',
      'explanation' => 'Text',
      'price'       => 'Number',
      'sub_title'   => 'Text',
      'title'       => 'Text',
      'sample_url'  => 'Text',
      'sample_size' => 'Number',
      'music_url'   => 'Text',
      'music_size'  => 'Number',
      'del_flg'     => 'Number',
      'created_at'  => 'Date',
      'updated_at'  => 'Date',
      'app_id'      => 'Number',
    );
  }
}
