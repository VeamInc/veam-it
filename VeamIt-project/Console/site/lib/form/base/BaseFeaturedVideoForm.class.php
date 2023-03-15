<?php

/**
 * FeaturedVideo form base class.
 *
 * @method FeaturedVideo getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseFeaturedVideoForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'         => new sfWidgetFormInputHidden(),
      'app_id'     => new sfWidgetFormInputText(),
      'kind'       => new sfWidgetFormInputText(),
      'order'      => new sfWidgetFormInputText(),
      'video_id'   => new sfWidgetFormInputText(),
      'del_flg'    => new sfWidgetFormInputText(),
      'created_at' => new sfWidgetFormDateTime(),
      'updated_at' => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'         => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'order'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'video_id'   => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at' => new sfValidatorDateTime(array('required' => false)),
      'updated_at' => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('featured_video[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'FeaturedVideo';
  }


}
