<?php

/**
 * Textline form base class.
 *
 * @method Textline getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseTextlineForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                       => new sfWidgetFormInputHidden(),
      'app_id'                   => new sfWidgetFormInputText(),
      'textline_package_id'      => new sfWidgetFormInputText(),
      'textline_category_id'     => new sfWidgetFormInputText(),
      'textline_sub_category_id' => new sfWidgetFormInputText(),
      'kind'                     => new sfWidgetFormInputText(),
      'title'                    => new sfWidgetFormTextarea(),
      'sub_title'                => new sfWidgetFormTextarea(),
      'text'                     => new sfWidgetFormTextarea(),
      'del_flg'                  => new sfWidgetFormInputText(),
      'created_at'               => new sfWidgetFormDateTime(),
      'updated_at'               => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                       => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'app_id'                   => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'textline_package_id'      => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'textline_category_id'     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'textline_sub_category_id' => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'kind'                     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'title'                    => new sfValidatorString(),
      'sub_title'                => new sfValidatorString(),
      'text'                     => new sfValidatorString(),
      'del_flg'                  => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'               => new sfValidatorDateTime(array('required' => false)),
      'updated_at'               => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('textline[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Textline';
  }


}
