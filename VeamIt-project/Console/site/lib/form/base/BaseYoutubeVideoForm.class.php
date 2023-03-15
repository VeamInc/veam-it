<?php

/**
 * YoutubeVideo form base class.
 *
 * @method YoutubeVideo getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseYoutubeVideoForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                  => new sfWidgetFormInputHidden(),
      'app_id'              => new sfWidgetFormInputText(),
      'kind'                => new sfWidgetFormInputText(),
      'rating'              => new sfWidgetFormInputText(),
      'author'              => new sfWidgetFormTextarea(),
      'duration'            => new sfWidgetFormInputText(),
      'expired_at'          => new sfWidgetFormDateTime(),
      'title'               => new sfWidgetFormTextarea(),
      'description'         => new sfWidgetFormTextarea(),
      'category_id'         => new sfWidgetFormInputText(),
      'sub_category_id'     => new sfWidgetFormInputText(),
      'youtube_code'        => new sfWidgetFormTextarea(),
      'is_new'              => new sfWidgetFormInputText(),
      'downloadable'        => new sfWidgetFormInputText(),
      'small_thumbnail_url' => new sfWidgetFormTextarea(),
      'large_thumbnail_url' => new sfWidgetFormTextarea(),
      'video_url'           => new sfWidgetFormTextarea(),
      'video_size'          => new sfWidgetFormInputText(),
      'video_key'           => new sfWidgetFormTextarea(),
      'price'               => new sfWidgetFormInputText(),
      'link_url'            => new sfWidgetFormTextarea(),
      'display_order'       => new sfWidgetFormInputText(),
      'del_flg'             => new sfWidgetFormInputText(),
      'created_at'          => new sfWidgetFormDateTime(),
      'updated_at'          => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                  => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'                => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'rating'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'author'              => new sfValidatorString(),
      'duration'            => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'expired_at'          => new sfValidatorDateTime(array('required' => false)),
      'title'               => new sfValidatorString(),
      'description'         => new sfValidatorString(),
      'category_id'         => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'sub_category_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'youtube_code'        => new sfValidatorString(),
      'is_new'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'downloadable'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'small_thumbnail_url' => new sfValidatorString(),
      'large_thumbnail_url' => new sfValidatorString(),
      'video_url'           => new sfValidatorString(),
      'video_size'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'video_key'           => new sfValidatorString(),
      'price'               => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'link_url'            => new sfValidatorString(),
      'display_order'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'             => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'          => new sfValidatorDateTime(array('required' => false)),
      'updated_at'          => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('youtube_video[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'YoutubeVideo';
  }


}
