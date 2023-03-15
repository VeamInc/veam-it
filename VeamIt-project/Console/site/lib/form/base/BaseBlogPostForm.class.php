<?php

/**
 * BlogPost form base class.
 *
 * @method BlogPost getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseBlogPostForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                   => new sfWidgetFormInputHidden(),
      'app_id'               => new sfWidgetFormInputText(),
      'title'                => new sfWidgetFormTextarea(),
      'html'                 => new sfWidgetFormTextarea(),
      'blog_category_id'     => new sfWidgetFormInputText(),
      'blog_sub_category_id' => new sfWidgetFormInputText(),
      'thumbnail_url'        => new sfWidgetFormTextarea(),
      'posted_at'            => new sfWidgetFormDateTime(),
      'del_flg'              => new sfWidgetFormInputText(),
      'created_at'           => new sfWidgetFormDateTime(),
      'updated_at'           => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                   => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'               => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'                => new sfValidatorString(),
      'html'                 => new sfValidatorString(),
      'blog_category_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'blog_sub_category_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'thumbnail_url'        => new sfValidatorString(),
      'posted_at'            => new sfValidatorDateTime(array('required' => false)),
      'del_flg'              => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'           => new sfValidatorDateTime(array('required' => false)),
      'updated_at'           => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('blog_post[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'BlogPost';
  }


}
