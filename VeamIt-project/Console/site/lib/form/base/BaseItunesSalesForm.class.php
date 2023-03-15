<?php

/**
 * ItunesSales form base class.
 *
 * @method ItunesSales getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseItunesSalesForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                      => new sfWidgetFormInputHidden(),
      'provider'                => new sfWidgetFormTextarea(),
      'provider_country'        => new sfWidgetFormTextarea(),
      'sku'                     => new sfWidgetFormTextarea(),
      'developer'               => new sfWidgetFormTextarea(),
      'title'                   => new sfWidgetFormTextarea(),
      'version'                 => new sfWidgetFormTextarea(),
      'product_type_identifier' => new sfWidgetFormTextarea(),
      'units'                   => new sfWidgetFormInputText(),
      'developer_proceeds'      => new sfWidgetFormTextarea(),
      'begin_date'              => new sfWidgetFormDate(),
      'end_date'                => new sfWidgetFormDate(),
      'customer_currency'       => new sfWidgetFormTextarea(),
      'country_code'            => new sfWidgetFormTextarea(),
      'currency_of_proceeds'    => new sfWidgetFormTextarea(),
      'apple_identifier'        => new sfWidgetFormTextarea(),
      'customer_price'          => new sfWidgetFormTextarea(),
      'promo_code'              => new sfWidgetFormTextarea(),
      'parent_identifier'       => new sfWidgetFormTextarea(),
      'subscription'            => new sfWidgetFormTextarea(),
      'period'                  => new sfWidgetFormTextarea(),
      'del_flg'                 => new sfWidgetFormInputText(),
      'created_at'              => new sfWidgetFormDateTime(),
      'updated_at'              => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                      => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'provider'                => new sfValidatorString(),
      'provider_country'        => new sfValidatorString(),
      'sku'                     => new sfValidatorString(),
      'developer'               => new sfValidatorString(),
      'title'                   => new sfValidatorString(),
      'version'                 => new sfValidatorString(),
      'product_type_identifier' => new sfValidatorString(),
      'units'                   => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'developer_proceeds'      => new sfValidatorString(),
      'begin_date'              => new sfValidatorDate(array('required' => false)),
      'end_date'                => new sfValidatorDate(array('required' => false)),
      'customer_currency'       => new sfValidatorString(),
      'country_code'            => new sfValidatorString(),
      'currency_of_proceeds'    => new sfValidatorString(),
      'apple_identifier'        => new sfValidatorString(),
      'customer_price'          => new sfValidatorString(),
      'promo_code'              => new sfValidatorString(),
      'parent_identifier'       => new sfValidatorString(),
      'subscription'            => new sfValidatorString(),
      'period'                  => new sfValidatorString(),
      'del_flg'                 => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'              => new sfValidatorDateTime(array('required' => false)),
      'updated_at'              => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('itunes_sales[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'ItunesSales';
  }


}
