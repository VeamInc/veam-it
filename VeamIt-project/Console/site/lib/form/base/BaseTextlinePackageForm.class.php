<?php

/**
 * TextlinePackage form base class.
 *
 * @method TextlinePackage getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseTextlinePackageForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'         => new sfWidgetFormInputHidden(),
      'app_id'     => new sfWidgetFormInputText(),
      'product'    => new sfWidgetFormTextarea(),
      'title'      => new sfWidgetFormTextarea(),
      'caption'    => new sfWidgetFormTextarea(),
      'price'      => new sfWidgetFormInputText(),
      'del_flag'   => new sfWidgetFormInputText(),
      'created_at' => new sfWidgetFormDateTime(),
      'updated_at' => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'         => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'product'    => new sfValidatorString(),
      'title'      => new sfValidatorString(),
      'caption'    => new sfValidatorString(),
      'price'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flag'   => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at' => new sfValidatorDateTime(array('required' => false)),
      'updated_at' => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('textline_package[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'TextlinePackage';
  }


}
