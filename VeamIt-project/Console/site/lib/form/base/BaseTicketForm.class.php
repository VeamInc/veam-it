<?php

/**
 * Ticket form base class.
 *
 * @method Ticket getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseTicketForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'             => new sfWidgetFormInputHidden(),
      'app_id'         => new sfWidgetFormInputText(),
      'transaction'    => new sfWidgetFormTextarea(),
      'kind'           => new sfWidgetFormInputText(),
      'title'          => new sfWidgetFormTextarea(),
      'description'    => new sfWidgetFormTextarea(),
      'image_url'      => new sfWidgetFormTextarea(),
      'used_image_url' => new sfWidgetFormTextarea(),
      'used'           => new sfWidgetFormInputText(),
      'code'           => new sfWidgetFormTextarea(),
      'qualified_at'   => new sfWidgetFormDateTime(),
      'del_flg'        => new sfWidgetFormInputText(),
      'created_at'     => new sfWidgetFormDateTime(),
      'updated_at'     => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'             => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'         => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'transaction'    => new sfValidatorString(),
      'kind'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'          => new sfValidatorString(),
      'description'    => new sfValidatorString(),
      'image_url'      => new sfValidatorString(),
      'used_image_url' => new sfValidatorString(),
      'used'           => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'code'           => new sfValidatorString(),
      'qualified_at'   => new sfValidatorDateTime(array('required' => false)),
      'del_flg'        => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'     => new sfValidatorDateTime(array('required' => false)),
      'updated_at'     => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('ticket[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Ticket';
  }


}
