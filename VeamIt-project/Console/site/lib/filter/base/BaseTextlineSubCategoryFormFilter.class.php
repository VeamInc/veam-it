<?php

/**
 * TextlineSubCategory filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseTextlineSubCategoryFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'textline_category_id' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'name'                 => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'           => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'           => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'textline_category_id' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'name'                 => new sfValidatorPass(array('required' => false)),
      'del_flg'              => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'           => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'           => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('textline_sub_category_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'TextlineSubCategory';
  }

  public function getFields()
  {
    return array(
      'id'                   => 'Number',
      'textline_category_id' => 'Number',
      'name'                 => 'Text',
      'del_flg'              => 'Number',
      'created_at'           => 'Date',
      'updated_at'           => 'Date',
    );
  }
}
