<?php

/**
 * Bulletin form base class.
 *
 * @method Bulletin getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseBulletinForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'               => new sfWidgetFormInputHidden(),
      'app_id'           => new sfWidgetFormTextarea(),
      'start_at'         => new sfWidgetFormDateTime(),
      'end_at'           => new sfWidgetFormDateTime(),
      'index'            => new sfWidgetFormInputText(),
      'kind'             => new sfWidgetFormInputText(),
      'background_color' => new sfWidgetFormTextarea(),
      'text_color'       => new sfWidgetFormTextarea(),
      'message'          => new sfWidgetFormTextarea(),
      'image_url'        => new sfWidgetFormTextarea(),
      'del_flg'          => new sfWidgetFormInputText(),
      'created_at'       => new sfWidgetFormDateTime(),
      'updated_at'       => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'               => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'           => new sfValidatorString(),
      'start_at'         => new sfValidatorDateTime(array('required' => false)),
      'end_at'           => new sfValidatorDateTime(array('required' => false)),
      'index'            => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'             => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'background_color' => new sfValidatorString(),
      'text_color'       => new sfValidatorString(),
      'message'          => new sfValidatorString(),
      'image_url'        => new sfValidatorString(),
      'del_flg'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'       => new sfValidatorDateTime(array('required' => false)),
      'updated_at'       => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('bulletin[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Bulletin';
  }


}
