<?php

/**
 * TextlineSubCategory form base class.
 *
 * @method TextlineSubCategory getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseTextlineSubCategoryForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                   => new sfWidgetFormInputHidden(),
      'textline_category_id' => new sfWidgetFormInputText(),
      'name'                 => new sfWidgetFormTextarea(),
      'del_flg'              => new sfWidgetFormInputText(),
      'created_at'           => new sfWidgetFormDateTime(),
      'updated_at'           => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                   => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'textline_category_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'name'                 => new sfValidatorString(),
      'del_flg'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'           => new sfValidatorDateTime(array('required' => false)),
      'updated_at'           => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('textline_sub_category[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'TextlineSubCategory';
  }


}
