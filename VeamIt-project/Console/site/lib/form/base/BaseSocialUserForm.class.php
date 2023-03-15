<?php

/**
 * SocialUser form base class.
 *
 * @method SocialUser getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseSocialUserForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                 => new sfWidgetFormInputHidden(),
      'app_id'             => new sfWidgetFormInputText(),
      'secret'             => new sfWidgetFormTextarea(),
      'twitter_id'         => new sfWidgetFormTextarea(),
      'facebook_id'        => new sfWidgetFormTextarea(),
      'name'               => new sfWidgetFormTextarea(),
      'twitter_user'       => new sfWidgetFormTextarea(),
      'profile_image'      => new sfWidgetFormTextarea(),
      'description'        => new sfWidgetFormTextarea(),
      'location'           => new sfWidgetFormTextarea(),
      'latitude'           => new sfWidgetFormInputText(),
      'longitude'          => new sfWidgetFormInputText(),
      'block_level'        => new sfWidgetFormInputText(),
      'number_of_pictures' => new sfWidgetFormInputText(),
      'del_flg'            => new sfWidgetFormInputText(),
      'created_at'         => new sfWidgetFormDateTime(),
      'updated_at'         => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                 => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'             => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'secret'             => new sfValidatorString(),
      'twitter_id'         => new sfValidatorString(),
      'facebook_id'        => new sfValidatorString(),
      'name'               => new sfValidatorString(),
      'twitter_user'       => new sfValidatorString(),
      'profile_image'      => new sfValidatorString(),
      'description'        => new sfValidatorString(),
      'location'           => new sfValidatorString(),
      'latitude'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'longitude'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'block_level'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'number_of_pictures' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'            => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'         => new sfValidatorDateTime(array('required' => false)),
      'updated_at'         => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('social_user[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'SocialUser';
  }


}
