<?php

/**
 * Recipe filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseRecipeFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'recipe_category_id' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image_url'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'ingredients'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'directions'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'nutrition'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flag'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'         => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'         => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'recipe_category_id' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'title'              => new sfValidatorPass(array('required' => false)),
      'image_url'          => new sfValidatorPass(array('required' => false)),
      'ingredients'        => new sfValidatorPass(array('required' => false)),
      'directions'         => new sfValidatorPass(array('required' => false)),
      'nutrition'          => new sfValidatorPass(array('required' => false)),
      'del_flag'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'         => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'         => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('recipe_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Recipe';
  }

  public function getFields()
  {
    return array(
      'id'                 => 'Number',
      'recipe_category_id' => 'Number',
      'title'              => 'Text',
      'image_url'          => 'Text',
      'ingredients'        => 'Text',
      'directions'         => 'Text',
      'nutrition'          => 'Text',
      'del_flag'           => 'Number',
      'created_at'         => 'Date',
      'updated_at'         => 'Date',
    );
  }
}
