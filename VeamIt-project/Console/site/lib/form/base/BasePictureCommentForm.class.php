<?php

/**
 * PictureComment form base class.
 *
 * @method PictureComment getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BasePictureCommentForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'             => new sfWidgetFormInputHidden(),
      'picture_id'     => new sfWidgetFormInputText(),
      'social_user_id' => new sfWidgetFormInputText(),
      'comment'        => new sfWidgetFormTextarea(),
      'del_flag'       => new sfWidgetFormInputText(),
      'created_at'     => new sfWidgetFormDateTime(),
      'updated_at'     => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'             => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'picture_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'social_user_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'comment'        => new sfValidatorString(),
      'del_flag'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'     => new sfValidatorDateTime(array('required' => false)),
      'updated_at'     => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('picture_comment[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'PictureComment';
  }


}
