<?php

/**
 * SocialPost form base class.
 *
 * @method SocialPost getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseSocialPostForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'             => new sfWidgetFormInputHidden(),
      'app_id'         => new sfWidgetFormInputText(),
      'social_user_id' => new sfWidgetFormInputText(),
      'reply_to'       => new sfWidgetFormInputText(),
      'message'        => new sfWidgetFormTextarea(),
      'del_flg'        => new sfWidgetFormInputText(),
      'created_at'     => new sfWidgetFormDateTime(),
      'updated_at'     => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'             => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'         => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'social_user_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'reply_to'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'message'        => new sfValidatorString(),
      'del_flg'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'     => new sfValidatorDateTime(array('required' => false)),
      'updated_at'     => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('social_post[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'SocialPost';
  }


}
