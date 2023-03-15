<?php

/**
 * Report form base class.
 *
 * @method Report getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseReportForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'             => new sfWidgetFormInputHidden(),
      'app_id'         => new sfWidgetFormTextarea(),
      'social_user_id' => new sfWidgetFormInputText(),
      'kind'           => new sfWidgetFormInputText(),
      'content'        => new sfWidgetFormInputText(),
      'message'        => new sfWidgetFormTextarea(),
      'del_flg'        => new sfWidgetFormInputText(),
      'created_at'     => new sfWidgetFormDateTime(),
      'updated_at'     => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'             => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'         => new sfValidatorString(),
      'social_user_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647, 'required' => false)),
      'content'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647, 'required' => false)),
      'message'        => new sfValidatorString(),
      'del_flg'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'     => new sfValidatorDateTime(array('required' => false)),
      'updated_at'     => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('report[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Report';
  }


}
