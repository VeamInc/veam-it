<?php

/**
 * Forum form base class.
 *
 * @method Forum getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseForumForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                 => new sfWidgetFormInputHidden(),
      'app_id'             => new sfWidgetFormInputText(),
      'kind'               => new sfWidgetFormInputText(),
      'name'               => new sfWidgetFormTextarea(),
      'number_of_likes'    => new sfWidgetFormInputText(),
      'number_of_comments' => new sfWidgetFormInputText(),
      'number_of_pictures' => new sfWidgetFormInputText(),
      'display_order'      => new sfWidgetFormInputText(),
      'del_flag'           => new sfWidgetFormInputText(),
      'created_at'         => new sfWidgetFormDateTime(),
      'updated_at'         => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                 => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'             => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'               => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'name'               => new sfValidatorString(),
      'number_of_likes'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'number_of_comments' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'number_of_pictures' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'display_order'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flag'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'         => new sfValidatorDateTime(array('required' => false)),
      'updated_at'         => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('forum[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Forum';
  }


}
