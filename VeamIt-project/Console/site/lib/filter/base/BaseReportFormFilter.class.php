<?php

/**
 * Report filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseReportFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'social_user_id' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'           => new sfWidgetFormFilterInput(),
      'content'        => new sfWidgetFormFilterInput(),
      'message'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'         => new sfValidatorPass(array('required' => false)),
      'social_user_id' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'kind'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'content'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'message'        => new sfValidatorPass(array('required' => false)),
      'del_flg'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('report_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Report';
  }

  public function getFields()
  {
    return array(
      'id'             => 'Number',
      'app_id'         => 'Text',
      'social_user_id' => 'Number',
      'kind'           => 'Number',
      'content'        => 'Number',
      'message'        => 'Text',
      'del_flg'        => 'Number',
      'created_at'     => 'Date',
      'updated_at'     => 'Date',
    );
  }
}
