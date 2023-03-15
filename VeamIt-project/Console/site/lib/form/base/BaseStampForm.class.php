<?php

/**
 * Stamp form base class.
 *
 * @method Stamp getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseStampForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'          => new sfWidgetFormInputHidden(),
      'app_id'      => new sfWidgetFormInputText(),
      'product'     => new sfWidgetFormTextarea(),
      'name'        => new sfWidgetFormTextarea(),
      'description' => new sfWidgetFormTextarea(),
      'image_url'   => new sfWidgetFormTextarea(),
      'back_palet'  => new sfWidgetFormTextarea(),
      'price'       => new sfWidgetFormInputText(),
      'del_flg'     => new sfWidgetFormInputText(),
      'created_at'  => new sfWidgetFormDateTime(),
      'updated_at'  => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'          => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'product'     => new sfValidatorString(),
      'name'        => new sfValidatorString(),
      'description' => new sfValidatorString(),
      'image_url'   => new sfValidatorString(),
      'back_palet'  => new sfValidatorString(),
      'price'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'  => new sfValidatorDateTime(array('required' => false)),
      'updated_at'  => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('stamp[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Stamp';
  }


}
