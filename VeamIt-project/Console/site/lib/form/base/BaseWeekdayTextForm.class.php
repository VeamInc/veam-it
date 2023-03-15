<?php

/**
 * WeekdayText form base class.
 *
 * @method WeekdayText getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseWeekdayTextForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'          => new sfWidgetFormInputHidden(),
      'app_id'      => new sfWidgetFormTextarea(),
      'start_at'    => new sfWidgetFormInputText(),
      'end_at'      => new sfWidgetFormInputText(),
      'weekday'     => new sfWidgetFormInputText(),
      'action'      => new sfWidgetFormInputText(),
      'title'       => new sfWidgetFormTextarea(),
      'description' => new sfWidgetFormTextarea(),
      'link_url'    => new sfWidgetFormTextarea(),
      'del_flg'     => new sfWidgetFormInputText(),
      'created_at'  => new sfWidgetFormDateTime(),
      'updated_at'  => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'          => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'      => new sfValidatorString(),
      'start_at'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647, 'required' => false)),
      'end_at'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647, 'required' => false)),
      'weekday'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'action'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'       => new sfValidatorString(),
      'description' => new sfValidatorString(),
      'link_url'    => new sfValidatorString(),
      'del_flg'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'  => new sfValidatorDateTime(array('required' => false)),
      'updated_at'  => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('weekday_text[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'WeekdayText';
  }


}
