<?php

/**
 * Question form base class.
 *
 * @method Question getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseQuestionForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'              => new sfWidgetFormInputHidden(),
      'app_id'          => new sfWidgetFormInputText(),
      'social_user_id'  => new sfWidgetFormInputText(),
      'title'           => new sfWidgetFormTextarea(),
      'text'            => new sfWidgetFormTextarea(),
      'number_of_likes' => new sfWidgetFormInputText(),
      'answer_kind'     => new sfWidgetFormInputText(),
      'answer_id'       => new sfWidgetFormInputText(),
      'del_flag'        => new sfWidgetFormInputText(),
      'answered_at'     => new sfWidgetFormDateTime(),
      'created_at'      => new sfWidgetFormDateTime(),
      'updated_at'      => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'              => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'          => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'social_user_id'  => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'           => new sfValidatorString(),
      'text'            => new sfValidatorString(),
      'number_of_likes' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'answer_kind'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'answer_id'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flag'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'answered_at'     => new sfValidatorDateTime(array('required' => false)),
      'created_at'      => new sfValidatorDateTime(array('required' => false)),
      'updated_at'      => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('question[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Question';
  }


}
