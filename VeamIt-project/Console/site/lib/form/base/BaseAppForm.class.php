<?php

/**
 * App form base class.
 *
 * @method App getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseAppForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'               => new sfWidgetFormInputHidden(),
      'name'             => new sfWidgetFormTextarea(),
      'client_id'        => new sfWidgetFormInputText(),
      'getglue_object'   => new sfWidgetFormTextarea(),
      'getglue_source'   => new sfWidgetFormTextarea(),
      'secret'           => new sfWidgetFormTextarea(),
      'category'         => new sfWidgetFormTextarea(),
      'sub_category'     => new sfWidgetFormTextarea(),
      'store_app_name'   => new sfWidgetFormTextarea(),
      'description'      => new sfWidgetFormTextarea(),
      'key_word'         => new sfWidgetFormTextarea(),
      'icon_image'       => new sfWidgetFormTextarea(),
      'splash_image'     => new sfWidgetFormTextarea(),
      'background_image' => new sfWidgetFormTextarea(),
      'screen_shot_1'    => new sfWidgetFormTextarea(),
      'screen_shot_2'    => new sfWidgetFormTextarea(),
      'screen_shot_3'    => new sfWidgetFormTextarea(),
      'screen_shot_4'    => new sfWidgetFormTextarea(),
      'screen_shot_5'    => new sfWidgetFormTextarea(),
      'status'           => new sfWidgetFormInputText(),
      'status_text'      => new sfWidgetFormTextarea(),
      'del_flg'          => new sfWidgetFormInputText(),
      'created_at'       => new sfWidgetFormDateTime(),
      'updated_at'       => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'               => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'name'             => new sfValidatorString(),
      'client_id'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'getglue_object'   => new sfValidatorString(),
      'getglue_source'   => new sfValidatorString(),
      'secret'           => new sfValidatorString(),
      'category'         => new sfValidatorString(),
      'sub_category'     => new sfValidatorString(),
      'store_app_name'   => new sfValidatorString(),
      'description'      => new sfValidatorString(),
      'key_word'         => new sfValidatorString(),
      'icon_image'       => new sfValidatorString(),
      'splash_image'     => new sfValidatorString(),
      'background_image' => new sfValidatorString(),
      'screen_shot_1'    => new sfValidatorString(),
      'screen_shot_2'    => new sfValidatorString(),
      'screen_shot_3'    => new sfValidatorString(),
      'screen_shot_4'    => new sfValidatorString(),
      'screen_shot_5'    => new sfValidatorString(),
      'status'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'status_text'      => new sfValidatorString(),
      'del_flg'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'       => new sfValidatorDateTime(array('required' => false)),
      'updated_at'       => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('app[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'App';
  }


}
