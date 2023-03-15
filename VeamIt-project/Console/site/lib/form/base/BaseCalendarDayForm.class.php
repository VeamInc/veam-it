<?php

/**
 * CalendarDay form base class.
 *
 * @method CalendarDay getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseCalendarDayForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'         => new sfWidgetFormInputHidden(),
      'app_id'     => new sfWidgetFormTextarea(),
      'kind'       => new sfWidgetFormInputText(),
      'year'       => new sfWidgetFormInputText(),
      'month'      => new sfWidgetFormInputText(),
      'day'        => new sfWidgetFormInputText(),
      'title'      => new sfWidgetFormTextarea(),
      'message'    => new sfWidgetFormTextarea(),
      'mixed_ids'  => new sfWidgetFormTextarea(),
      'del_flag'   => new sfWidgetFormInputText(),
      'created_at' => new sfWidgetFormDateTime(),
      'updated_at' => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'         => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'     => new sfValidatorString(),
      'kind'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'year'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'month'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'day'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'      => new sfValidatorString(),
      'message'    => new sfValidatorString(),
      'mixed_ids'  => new sfValidatorString(),
      'del_flag'   => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at' => new sfValidatorDateTime(array('required' => false)),
      'updated_at' => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('calendar_day[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'CalendarDay';
  }


}
