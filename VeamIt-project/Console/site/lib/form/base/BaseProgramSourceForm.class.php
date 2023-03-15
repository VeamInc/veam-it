<?php

/**
 * ProgramSource form base class.
 *
 * @method ProgramSource getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseProgramSourceForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'         => new sfWidgetFormInputHidden(),
      'app_id'     => new sfWidgetFormInputText(),
      'program_id' => new sfWidgetFormInputText(),
      'image_url'  => new sfWidgetFormTextarea(),
      'data_url'   => new sfWidgetFormTextarea(),
      'status'     => new sfWidgetFormInputText(),
      'info'       => new sfWidgetFormTextarea(),
      'result'     => new sfWidgetFormTextarea(),
      'del_flg'    => new sfWidgetFormInputText(),
      'created_at' => new sfWidgetFormDateTime(),
      'updated_at' => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'         => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'program_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'image_url'  => new sfValidatorString(),
      'data_url'   => new sfValidatorString(),
      'status'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'info'       => new sfValidatorString(),
      'result'     => new sfValidatorString(),
      'del_flg'    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at' => new sfValidatorDateTime(array('required' => false)),
      'updated_at' => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('program_source[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'ProgramSource';
  }


}
