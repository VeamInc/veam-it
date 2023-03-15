<?php

/**
 * AppRatingAnswer form base class.
 *
 * @method AppRatingAnswer getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseAppRatingAnswerForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                     => new sfWidgetFormInputHidden(),
      'app_id'                 => new sfWidgetFormInputText(),
      'app_rating_question_id' => new sfWidgetFormInputText(),
      'answer'                 => new sfWidgetFormTextarea(),
      'del_flg'                => new sfWidgetFormInputText(),
      'created_at'             => new sfWidgetFormDateTime(),
      'updated_at'             => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                     => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'                 => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'app_rating_question_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'answer'                 => new sfValidatorString(),
      'del_flg'                => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'             => new sfValidatorDateTime(array('required' => false)),
      'updated_at'             => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('app_rating_answer[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'AppRatingAnswer';
  }


}
