<?php

/**
 * Music form base class.
 *
 * @method Music getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseMusicForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'          => new sfWidgetFormInputHidden(),
      'video_id'    => new sfWidgetFormInputText(),
      'duration'    => new sfWidgetFormInputText(),
      'expired_at'  => new sfWidgetFormDateTime(),
      'explanation' => new sfWidgetFormTextarea(),
      'price'       => new sfWidgetFormInputText(),
      'sub_title'   => new sfWidgetFormTextarea(),
      'title'       => new sfWidgetFormTextarea(),
      'sample_url'  => new sfWidgetFormTextarea(),
      'sample_size' => new sfWidgetFormInputText(),
      'music_url'   => new sfWidgetFormTextarea(),
      'music_size'  => new sfWidgetFormInputText(),
      'del_flg'     => new sfWidgetFormInputText(),
      'created_at'  => new sfWidgetFormDateTime(),
      'updated_at'  => new sfWidgetFormDateTime(),
      'app_id'      => new sfWidgetFormInputText(),
    ));

    $this->setValidators(array(
      'id'          => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'video_id'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'duration'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'expired_at'  => new sfValidatorDateTime(array('required' => false)),
      'explanation' => new sfValidatorString(),
      'price'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'sub_title'   => new sfValidatorString(),
      'title'       => new sfValidatorString(),
      'sample_url'  => new sfValidatorString(),
      'sample_size' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'music_url'   => new sfValidatorString(),
      'music_size'  => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'  => new sfValidatorDateTime(array('required' => false)),
      'updated_at'  => new sfValidatorDateTime(array('required' => false)),
      'app_id'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
    ));

    $this->widgetSchema->setNameFormat('music[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Music';
  }


}
