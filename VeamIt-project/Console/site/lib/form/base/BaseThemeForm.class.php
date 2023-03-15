<?php

/**
 * Theme form base class.
 *
 * @method Theme getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseThemeForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                         => new sfWidgetFormInputHidden(),
      'app_id'                     => new sfWidgetFormInputText(),
      'product'                    => new sfWidgetFormTextarea(),
      'title'                      => new sfWidgetFormTextarea(),
      'description'                => new sfWidgetFormTextarea(),
      'base_url'                   => new sfWidgetFormTextarea(),
      'thumbnail_name'             => new sfWidgetFormTextarea(),
      'screenshots'                => new sfWidgetFormTextarea(),
      'images'                     => new sfWidgetFormTextarea(),
      'top_color'                  => new sfWidgetFormTextarea(),
      'top_text_color'             => new sfWidgetFormTextarea(),
      'top_text_font'              => new sfWidgetFormTextarea(),
      'top_text_size'              => new sfWidgetFormTextarea(),
      'base_text_color'            => new sfWidgetFormTextarea(),
      'link_text_color'            => new sfWidgetFormTextarea(),
      'background_color'           => new sfWidgetFormTextarea(),
      'mask_color'                 => new sfWidgetFormTextarea(),
      'post_text_color'            => new sfWidgetFormTextarea(),
      'status_bar_color'           => new sfWidgetFormTextarea(),
      'status_bar_style'           => new sfWidgetFormInputText(),
      'separator_color'            => new sfWidgetFormTextarea(),
      'text1_color'                => new sfWidgetFormTextarea(),
      'text2_color'                => new sfWidgetFormTextarea(),
      'text3_color'                => new sfWidgetFormTextarea(),
      'question_header_color'      => new sfWidgetFormTextarea(),
      'question_header_text_color' => new sfWidgetFormTextarea(),
      'price'                      => new sfWidgetFormInputText(),
      'del_flg'                    => new sfWidgetFormInputText(),
      'created_at'                 => new sfWidgetFormDateTime(),
      'updated_at'                 => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                         => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'                     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'product'                    => new sfValidatorString(),
      'title'                      => new sfValidatorString(),
      'description'                => new sfValidatorString(),
      'base_url'                   => new sfValidatorString(),
      'thumbnail_name'             => new sfValidatorString(),
      'screenshots'                => new sfValidatorString(),
      'images'                     => new sfValidatorString(),
      'top_color'                  => new sfValidatorString(),
      'top_text_color'             => new sfValidatorString(),
      'top_text_font'              => new sfValidatorString(),
      'top_text_size'              => new sfValidatorString(),
      'base_text_color'            => new sfValidatorString(),
      'link_text_color'            => new sfValidatorString(),
      'background_color'           => new sfValidatorString(),
      'mask_color'                 => new sfValidatorString(),
      'post_text_color'            => new sfValidatorString(),
      'status_bar_color'           => new sfValidatorString(),
      'status_bar_style'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'separator_color'            => new sfValidatorString(),
      'text1_color'                => new sfValidatorString(),
      'text2_color'                => new sfValidatorString(),
      'text3_color'                => new sfValidatorString(),
      'question_header_color'      => new sfValidatorString(),
      'question_header_text_color' => new sfValidatorString(),
      'price'                      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'                    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'                 => new sfValidatorDateTime(array('required' => false)),
      'updated_at'                 => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('theme[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Theme';
  }


}
