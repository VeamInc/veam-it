<?php

/**
 * IabToken form base class.
 *
 * @method IabToken getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseIabTokenForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'         => new sfWidgetFormInputHidden(),
      'app_id'     => new sfWidgetFormInputText(),
      'product'    => new sfWidgetFormTextarea(),
      'token'      => new sfWidgetFormTextarea(),
      'adid'       => new sfWidgetFormTextarea(),
      'start_time' => new sfWidgetFormInputText(),
      'del_flg'    => new sfWidgetFormInputText(),
      'created_at' => new sfWidgetFormDateTime(),
      'updated_at' => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'         => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'product'    => new sfValidatorString(),
      'token'      => new sfValidatorString(),
      'adid'       => new sfValidatorString(),
      'start_time' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at' => new sfValidatorDateTime(array('required' => false)),
      'updated_at' => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('iab_token[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'IabToken';
  }


}
