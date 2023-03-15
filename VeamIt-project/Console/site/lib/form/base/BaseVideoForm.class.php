<?php

/**
 * Video form base class.
 *
 * @method Video getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseVideoForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                    => new sfWidgetFormInputHidden(),
      'composer'              => new sfWidgetFormTextarea(),
      'duration'              => new sfWidgetFormInputText(),
      'expired_at'            => new sfWidgetFormDateTime(),
      'explanation'           => new sfWidgetFormTextarea(),
      'genre_id'              => new sfWidgetFormInputText(),
      'video_category_id'     => new sfWidgetFormInputText(),
      'video_sub_category_id' => new sfWidgetFormInputText(),
      'has_preview'           => new sfWidgetFormInputText(),
      'is_priced'             => new sfWidgetFormInputText(),
      'kind'                  => new sfWidgetFormInputText(),
      'price'                 => new sfWidgetFormInputText(),
      'sub_title'             => new sfWidgetFormTextarea(),
      'title'                 => new sfWidgetFormTextarea(),
      'rating'                => new sfWidgetFormInputText(),
      'share_text'            => new sfWidgetFormTextarea(),
      'thumbnail_url'         => new sfWidgetFormTextarea(),
      'thumbnail_size'        => new sfWidgetFormInputText(),
      'source_url'            => new sfWidgetFormTextarea(),
      'preview_url'           => new sfWidgetFormTextarea(),
      'preview_size'          => new sfWidgetFormInputText(),
      'preview_key'           => new sfWidgetFormTextarea(),
      'drm_preview_url'       => new sfWidgetFormTextarea(),
      'drm_preview_size'      => new sfWidgetFormInputText(),
      'drm_preview_key'       => new sfWidgetFormTextarea(),
      'zip_url'               => new sfWidgetFormTextarea(),
      'zip_size'              => new sfWidgetFormInputText(),
      'zip_key'               => new sfWidgetFormTextarea(),
      'video_url'             => new sfWidgetFormTextarea(),
      'video_size'            => new sfWidgetFormInputText(),
      'video_key'             => new sfWidgetFormTextarea(),
      'drm_video_url'         => new sfWidgetFormTextarea(),
      'drm_video_size'        => new sfWidgetFormInputText(),
      'drm_video_key'         => new sfWidgetFormTextarea(),
      'pending'               => new sfWidgetFormInputText(),
      'getglue_object'        => new sfWidgetFormTextarea(),
      'landingpage'           => new sfWidgetFormTextarea(),
      'shorten_title'         => new sfWidgetFormTextarea(),
      'display_order'         => new sfWidgetFormInputText(),
      'status'                => new sfWidgetFormInputText(),
      'status_text'           => new sfWidgetFormTextarea(),
      'del_flg'               => new sfWidgetFormInputText(),
      'created_at'            => new sfWidgetFormDateTime(),
      'updated_at'            => new sfWidgetFormDateTime(),
      'app_id'                => new sfWidgetFormInputText(),
    ));

    $this->setValidators(array(
      'id'                    => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'composer'              => new sfValidatorString(),
      'duration'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'expired_at'            => new sfValidatorDateTime(array('required' => false)),
      'explanation'           => new sfValidatorString(),
      'genre_id'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'video_category_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'video_sub_category_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'has_preview'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'is_priced'             => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'                  => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'price'                 => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'sub_title'             => new sfValidatorString(),
      'title'                 => new sfValidatorString(),
      'rating'                => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'share_text'            => new sfValidatorString(),
      'thumbnail_url'         => new sfValidatorString(),
      'thumbnail_size'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'source_url'            => new sfValidatorString(),
      'preview_url'           => new sfValidatorString(),
      'preview_size'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'preview_key'           => new sfValidatorString(),
      'drm_preview_url'       => new sfValidatorString(),
      'drm_preview_size'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'drm_preview_key'       => new sfValidatorString(),
      'zip_url'               => new sfValidatorString(),
      'zip_size'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'zip_key'               => new sfValidatorString(),
      'video_url'             => new sfValidatorString(),
      'video_size'            => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'video_key'             => new sfValidatorString(),
      'drm_video_url'         => new sfValidatorString(),
      'drm_video_size'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'drm_video_key'         => new sfValidatorString(),
      'pending'               => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'getglue_object'        => new sfValidatorString(),
      'landingpage'           => new sfValidatorString(),
      'shorten_title'         => new sfValidatorString(),
      'display_order'         => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'status'                => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'status_text'           => new sfValidatorString(),
      'del_flg'               => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'            => new sfValidatorDateTime(array('required' => false)),
      'updated_at'            => new sfValidatorDateTime(array('required' => false)),
      'app_id'                => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
    ));

    $this->widgetSchema->setNameFormat('video[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Video';
  }


}
