<?php

/**
 * WorldWideInfo filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseWorldWideInfoFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'video_id'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'sales_amount'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'category_name' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'    => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'    => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'video_id'      => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'sales_amount'  => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'category_name' => new sfValidatorPass(array('required' => false)),
      'del_flg'       => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'    => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'    => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('world_wide_info_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'WorldWideInfo';
  }

  public function getFields()
  {
    return array(
      'id'            => 'Number',
      'video_id'      => 'Number',
      'sales_amount'  => 'Number',
      'category_name' => 'Text',
      'del_flg'       => 'Number',
      'created_at'    => 'Date',
      'updated_at'    => 'Date',
    );
  }
}
