<?php

/**
 * Textline filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseTextlineFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'                   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'textline_category_id'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'textline_sub_category_id' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'                     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'                    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'text'                     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'                  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'               => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'               => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'                   => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'textline_category_id'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'textline_sub_category_id' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'kind'                     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'title'                    => new sfValidatorPass(array('required' => false)),
      'text'                     => new sfValidatorPass(array('required' => false)),
      'del_flg'                  => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'               => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'               => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('textline_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Textline';
  }

  public function getFields()
  {
    return array(
      'id'                       => 'Number',
      'app_id'                   => 'Number',
      'textline_category_id'     => 'Number',
      'textline_sub_category_id' => 'Number',
      'kind'                     => 'Number',
      'title'                    => 'Text',
      'text'                     => 'Text',
      'del_flg'                  => 'Number',
      'created_at'               => 'Date',
      'updated_at'               => 'Date',
    );
  }
}
