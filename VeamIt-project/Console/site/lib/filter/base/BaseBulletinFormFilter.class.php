<?php

/**
 * Bulletin filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseBulletinFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'start_at'         => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'end_at'           => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'index'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'             => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'background_color' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'text_color'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'message'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image_url'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'       => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'       => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'           => new sfValidatorPass(array('required' => false)),
      'start_at'         => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'end_at'           => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'index'            => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'kind'             => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'background_color' => new sfValidatorPass(array('required' => false)),
      'text_color'       => new sfValidatorPass(array('required' => false)),
      'message'          => new sfValidatorPass(array('required' => false)),
      'image_url'        => new sfValidatorPass(array('required' => false)),
      'del_flg'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'       => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'       => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('bulletin_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Bulletin';
  }

  public function getFields()
  {
    return array(
      'id'               => 'Number',
      'app_id'           => 'Text',
      'start_at'         => 'Date',
      'end_at'           => 'Date',
      'index'            => 'Number',
      'kind'             => 'Number',
      'background_color' => 'Text',
      'text_color'       => 'Text',
      'message'          => 'Text',
      'image_url'        => 'Text',
      'del_flg'          => 'Number',
      'created_at'       => 'Date',
      'updated_at'       => 'Date',
    );
  }
}
