<?php

/**
 * App filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseAppFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'name'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'client_id'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'getglue_object' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'getglue_source' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'name'           => new sfValidatorPass(array('required' => false)),
      'client_id'      => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'getglue_object' => new sfValidatorPass(array('required' => false)),
      'getglue_source' => new sfValidatorPass(array('required' => false)),
      'del_flg'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('app_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'App';
  }

  public function getFields()
  {
    return array(
      'id'             => 'Number',
      'name'           => 'Text',
      'client_id'      => 'Number',
      'getglue_object' => 'Text',
      'getglue_source' => 'Text',
      'del_flg'        => 'Number',
      'created_at'     => 'Date',
      'updated_at'     => 'Date',
    );
  }
}
