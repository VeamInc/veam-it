<?php

/**
 * Web form base class.
 *
 * @method Web getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseWebForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'              => new sfWidgetFormInputHidden(),
      'app_id'          => new sfWidgetFormTextarea(),
      'web_category_id' => new sfWidgetFormInputText(),
      'title'           => new sfWidgetFormTextarea(),
      'url'             => new sfWidgetFormTextarea(),
      'display_order'   => new sfWidgetFormInputText(),
      'del_flag'        => new sfWidgetFormInputText(),
      'created_at'      => new sfWidgetFormDateTime(),
      'updated_at'      => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'              => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'          => new sfValidatorString(),
      'web_category_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'           => new sfValidatorString(),
      'url'             => new sfValidatorString(),
      'display_order'   => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flag'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'      => new sfValidatorDateTime(array('required' => false)),
      'updated_at'      => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('web[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Web';
  }


}
