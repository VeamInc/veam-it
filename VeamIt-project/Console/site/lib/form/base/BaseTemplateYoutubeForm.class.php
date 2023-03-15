<?php

/**
 * TemplateYoutube form base class.
 *
 * @method TemplateYoutube getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseTemplateYoutubeForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'              => new sfWidgetFormInputHidden(),
      'app_id'          => new sfWidgetFormInputText(),
      'title'           => new sfWidgetFormTextarea(),
      'embed_flag'      => new sfWidgetFormInputText(),
      'embed_url'       => new sfWidgetFormTextarea(),
      'left_image_url'  => new sfWidgetFormTextarea(),
      'right_image_url' => new sfWidgetFormTextarea(),
      'del_flg'         => new sfWidgetFormInputText(),
      'created_at'      => new sfWidgetFormDateTime(),
      'updated_at'      => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'              => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'           => new sfValidatorString(),
      'embed_flag'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'embed_url'       => new sfValidatorString(),
      'left_image_url'  => new sfValidatorString(),
      'right_image_url' => new sfValidatorString(),
      'del_flg'         => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'      => new sfValidatorDateTime(array('required' => false)),
      'updated_at'      => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('template_youtube[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'TemplateYoutube';
  }


}
