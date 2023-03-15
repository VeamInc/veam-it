<?php

/**
 * UploadVideo form base class.
 *
 * @method UploadVideo getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseUploadVideoForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'         => new sfWidgetFormInputHidden(),
      'user_id'    => new sfWidgetFormTextarea(),
      'video_id'   => new sfWidgetFormInputText(),
      'del_flg'    => new sfWidgetFormInputText(),
      'created_at' => new sfWidgetFormDateTime(),
      'updated_at' => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'         => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'user_id'    => new sfValidatorString(),
      'video_id'   => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at' => new sfValidatorDateTime(array('required' => false)),
      'updated_at' => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('upload_video[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'UploadVideo';
  }


}
