<?php

/**
 * Audio form base class.
 *
 * @method Audio getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseAudioForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                    => new sfWidgetFormInputHidden(),
      'app_id'                => new sfWidgetFormInputText(),
      'audio_category_id'     => new sfWidgetFormInputText(),
      'audio_sub_category_id' => new sfWidgetFormInputText(),
      'kind'                  => new sfWidgetFormInputText(),
      'author'                => new sfWidgetFormTextarea(),
      'duration'              => new sfWidgetFormInputText(),
      'title'                 => new sfWidgetFormTextarea(),
      'description'           => new sfWidgetFormTextarea(),
      'image_url'             => new sfWidgetFormTextarea(),
      'data_url'              => new sfWidgetFormTextarea(),
      'link_url'              => new sfWidgetFormTextarea(),
      'data_size'             => new sfWidgetFormInputText(),
      'display_order'         => new sfWidgetFormInputText(),
      'del_flg'               => new sfWidgetFormInputText(),
      'created_at'            => new sfWidgetFormDateTime(),
      'updated_at'            => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                    => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'                => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'audio_category_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'audio_sub_category_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'                  => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'author'                => new sfValidatorString(),
      'duration'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'                 => new sfValidatorString(),
      'description'           => new sfValidatorString(),
      'image_url'             => new sfValidatorString(),
      'data_url'              => new sfValidatorString(),
      'link_url'              => new sfValidatorString(),
      'data_size'             => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'display_order'         => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'               => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'            => new sfValidatorDateTime(array('required' => false)),
      'updated_at'            => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('audio[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Audio';
  }


}
