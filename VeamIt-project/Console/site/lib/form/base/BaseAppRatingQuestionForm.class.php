<?php

/**
 * AppRatingQuestion form base class.
 *
 * @method AppRatingQuestion getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseAppRatingQuestionForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'            => new sfWidgetFormInputHidden(),
      'question'      => new sfWidgetFormTextarea(),
      'selections'    => new sfWidgetFormTextarea(),
      'display_order' => new sfWidgetFormInputText(),
      'del_flg'       => new sfWidgetFormInputText(),
      'created_at'    => new sfWidgetFormDateTime(),
      'updated_at'    => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'            => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'question'      => new sfValidatorString(),
      'selections'    => new sfValidatorString(),
      'display_order' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'del_flg'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'    => new sfValidatorDateTime(array('required' => false)),
      'updated_at'    => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('app_rating_question[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'AppRatingQuestion';
  }


}
