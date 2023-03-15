<?php

/**
 * WorldWideInfo form base class.
 *
 * @method WorldWideInfo getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseWorldWideInfoForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'            => new sfWidgetFormInputHidden(),
      'video_id'      => new sfWidgetFormInputText(),
      'sales_amount'  => new sfWidgetFormInputText(),
      'category_name' => new sfWidgetFormTextarea(),
      'del_flg'       => new sfWidgetFormInputText(),
      'created_at'    => new sfWidgetFormDateTime(),
      'updated_at'    => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'            => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'video_id'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'sales_amount'  => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'category_name' => new sfValidatorString(),
      'del_flg'       => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'    => new sfValidatorDateTime(array('required' => false)),
      'updated_at'    => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('world_wide_info[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'WorldWideInfo';
  }


}
