<?php

/**
 * Recipe form base class.
 *
 * @method Recipe getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseRecipeForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                 => new sfWidgetFormInputHidden(),
      'app_id'             => new sfWidgetFormInputText(),
      'recipe_category_id' => new sfWidgetFormInputText(),
      'title'              => new sfWidgetFormTextarea(),
      'image_url'          => new sfWidgetFormTextarea(),
      'ingredients'        => new sfWidgetFormTextarea(),
      'directions'         => new sfWidgetFormTextarea(),
      'nutrition'          => new sfWidgetFormTextarea(),
      'display_order'      => new sfWidgetFormInputText(),
      'del_flag'           => new sfWidgetFormInputText(),
      'created_at'         => new sfWidgetFormDateTime(),
      'updated_at'         => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                 => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'             => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'recipe_category_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'              => new sfValidatorString(),
      'image_url'          => new sfValidatorString(),
      'ingredients'        => new sfValidatorString(),
      'directions'         => new sfValidatorString(),
      'nutrition'          => new sfValidatorString(),
      'display_order'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flag'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'         => new sfValidatorDateTime(array('required' => false)),
      'updated_at'         => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('recipe[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Recipe';
  }


}
