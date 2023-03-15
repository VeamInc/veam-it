<?php

/**
 * Swatch form base class.
 *
 * @method Swatch getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseSwatchForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'              => new sfWidgetFormInputHidden(),
      'picture_id'      => new sfWidgetFormInputText(),
      'social_user_id'  => new sfWidgetFormInputText(),
      'number_of_likes' => new sfWidgetFormInputText(),
      'base_url'        => new sfWidgetFormTextarea(),
      'image1'          => new sfWidgetFormTextarea(),
      'image2'          => new sfWidgetFormTextarea(),
      'image3'          => new sfWidgetFormTextarea(),
      'image4'          => new sfWidgetFormTextarea(),
      'image5'          => new sfWidgetFormTextarea(),
      'thumbnail1'      => new sfWidgetFormTextarea(),
      'thumbnail2'      => new sfWidgetFormTextarea(),
      'thumbnail3'      => new sfWidgetFormTextarea(),
      'thumbnail4'      => new sfWidgetFormTextarea(),
      'thumbnail5'      => new sfWidgetFormTextarea(),
      'product_name'    => new sfWidgetFormTextarea(),
      'category'        => new sfWidgetFormTextarea(),
      'brand'           => new sfWidgetFormTextarea(),
      'rating'          => new sfWidgetFormInputText(),
      'skin_tone'       => new sfWidgetFormTextarea(),
      'skin_type'       => new sfWidgetFormTextarea(),
      'eye_color'       => new sfWidgetFormTextarea(),
      'del_flag'        => new sfWidgetFormInputText(),
      'created_at'      => new sfWidgetFormDateTime(),
      'updated_at'      => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'              => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'picture_id'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'social_user_id'  => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'number_of_likes' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'base_url'        => new sfValidatorString(),
      'image1'          => new sfValidatorString(),
      'image2'          => new sfValidatorString(),
      'image3'          => new sfValidatorString(),
      'image4'          => new sfValidatorString(),
      'image5'          => new sfValidatorString(),
      'thumbnail1'      => new sfValidatorString(),
      'thumbnail2'      => new sfValidatorString(),
      'thumbnail3'      => new sfValidatorString(),
      'thumbnail4'      => new sfValidatorString(),
      'thumbnail5'      => new sfValidatorString(),
      'product_name'    => new sfValidatorString(),
      'category'        => new sfValidatorString(),
      'brand'           => new sfValidatorString(),
      'rating'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'skin_tone'       => new sfValidatorString(),
      'skin_type'       => new sfValidatorString(),
      'eye_color'       => new sfValidatorString(),
      'del_flag'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'      => new sfValidatorDateTime(array('required' => false)),
      'updated_at'      => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('swatch[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Swatch';
  }


}
