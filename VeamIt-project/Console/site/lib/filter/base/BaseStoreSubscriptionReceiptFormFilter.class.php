<?php

/**
 * StoreSubscriptionReceipt filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseStoreSubscriptionReceiptFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'user_id'                     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'quantity'                    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'product_id'                  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'transaction_id'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'purchase_date'               => new sfWidgetFormFilterInput(),
      'original_transaction_id'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'original_purchase_date'      => new sfWidgetFormFilterInput(),
      'app_item_id'                 => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'version_external_identifier' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'bid'                         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'bvrs'                        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'expires_date'                => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'latest_receipt'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'latest_receipt_info'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'                     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'                  => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'                  => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'user_id'                     => new sfValidatorPass(array('required' => false)),
      'quantity'                    => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'product_id'                  => new sfValidatorPass(array('required' => false)),
      'transaction_id'              => new sfValidatorPass(array('required' => false)),
      'purchase_date'               => new sfValidatorPass(array('required' => false)),
      'original_transaction_id'     => new sfValidatorPass(array('required' => false)),
      'original_purchase_date'      => new sfValidatorPass(array('required' => false)),
      'app_item_id'                 => new sfValidatorPass(array('required' => false)),
      'version_external_identifier' => new sfValidatorPass(array('required' => false)),
      'bid'                         => new sfValidatorPass(array('required' => false)),
      'bvrs'                        => new sfValidatorPass(array('required' => false)),
      'expires_date'                => new sfValidatorPass(array('required' => false)),
      'latest_receipt'              => new sfValidatorPass(array('required' => false)),
      'latest_receipt_info'         => new sfValidatorPass(array('required' => false)),
      'del_flg'                     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'                  => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'                  => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('store_subscription_receipt_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'StoreSubscriptionReceipt';
  }

  public function getFields()
  {
    return array(
      'id'                          => 'Number',
      'user_id'                     => 'Text',
      'quantity'                    => 'Number',
      'product_id'                  => 'Text',
      'transaction_id'              => 'Text',
      'purchase_date'               => 'Text',
      'original_transaction_id'     => 'Text',
      'original_purchase_date'      => 'Text',
      'app_item_id'                 => 'Text',
      'version_external_identifier' => 'Text',
      'bid'                         => 'Text',
      'bvrs'                        => 'Text',
      'expires_date'                => 'Text',
      'latest_receipt'              => 'Text',
      'latest_receipt_info'         => 'Text',
      'del_flg'                     => 'Number',
      'created_at'                  => 'Date',
      'updated_at'                  => 'Date',
    );
  }
}
