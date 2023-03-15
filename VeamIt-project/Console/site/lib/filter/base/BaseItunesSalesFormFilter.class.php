<?php

/**
 * ItunesSales filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseItunesSalesFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'provider'                => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'provider_country'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'sku'                     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'developer'               => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'                   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'version'                 => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'product_type_identifier' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'units'                   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'developer_proceeds'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'begin_date'              => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'end_date'                => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'customer_currency'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'country_code'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'currency_of_proceeds'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'apple_identifier'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'customer_price'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'promo_code'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'parent_identifier'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'subscription'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'period'                  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'                 => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'              => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'              => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'provider'                => new sfValidatorPass(array('required' => false)),
      'provider_country'        => new sfValidatorPass(array('required' => false)),
      'sku'                     => new sfValidatorPass(array('required' => false)),
      'developer'               => new sfValidatorPass(array('required' => false)),
      'title'                   => new sfValidatorPass(array('required' => false)),
      'version'                 => new sfValidatorPass(array('required' => false)),
      'product_type_identifier' => new sfValidatorPass(array('required' => false)),
      'units'                   => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'developer_proceeds'      => new sfValidatorPass(array('required' => false)),
      'begin_date'              => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'end_date'                => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'customer_currency'       => new sfValidatorPass(array('required' => false)),
      'country_code'            => new sfValidatorPass(array('required' => false)),
      'currency_of_proceeds'    => new sfValidatorPass(array('required' => false)),
      'apple_identifier'        => new sfValidatorPass(array('required' => false)),
      'customer_price'          => new sfValidatorPass(array('required' => false)),
      'promo_code'              => new sfValidatorPass(array('required' => false)),
      'parent_identifier'       => new sfValidatorPass(array('required' => false)),
      'subscription'            => new sfValidatorPass(array('required' => false)),
      'period'                  => new sfValidatorPass(array('required' => false)),
      'del_flg'                 => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'              => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'              => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('itunes_sales_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'ItunesSales';
  }

  public function getFields()
  {
    return array(
      'id'                      => 'Number',
      'provider'                => 'Text',
      'provider_country'        => 'Text',
      'sku'                     => 'Text',
      'developer'               => 'Text',
      'title'                   => 'Text',
      'version'                 => 'Text',
      'product_type_identifier' => 'Text',
      'units'                   => 'Number',
      'developer_proceeds'      => 'Text',
      'begin_date'              => 'Date',
      'end_date'                => 'Date',
      'customer_currency'       => 'Text',
      'country_code'            => 'Text',
      'currency_of_proceeds'    => 'Text',
      'apple_identifier'        => 'Text',
      'customer_price'          => 'Text',
      'promo_code'              => 'Text',
      'parent_identifier'       => 'Text',
      'subscription'            => 'Text',
      'period'                  => 'Text',
      'del_flg'                 => 'Number',
      'created_at'              => 'Date',
      'updated_at'              => 'Date',
    );
  }
}
