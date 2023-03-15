<?php

/**
 * WeekdayText filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseWeekdayTextFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'start_at'    => new sfWidgetFormFilterInput(),
      'end_at'      => new sfWidgetFormFilterInput(),
      'weekday'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'action'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'description' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'link_url'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'  => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'  => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'      => new sfValidatorPass(array('required' => false)),
      'start_at'    => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'end_at'      => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'weekday'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'action'      => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'title'       => new sfValidatorPass(array('required' => false)),
      'description' => new sfValidatorPass(array('required' => false)),
      'link_url'    => new sfValidatorPass(array('required' => false)),
      'del_flg'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'  => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'  => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('weekday_text_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'WeekdayText';
  }

  public function getFields()
  {
    return array(
      'id'          => 'Number',
      'app_id'      => 'Text',
      'start_at'    => 'Number',
      'end_at'      => 'Number',
      'weekday'     => 'Number',
      'action'      => 'Number',
      'title'       => 'Text',
      'description' => 'Text',
      'link_url'    => 'Text',
      'del_flg'     => 'Number',
      'created_at'  => 'Date',
      'updated_at'  => 'Date',
    );
  }
}
