<?php

/**
 * StoreSubscriptionReceipt form base class.
 *
 * @method StoreSubscriptionReceipt getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseStoreSubscriptionReceiptForm extends BaseFormPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'id'                          => new sfWidgetFormInputHidden(),
      'user_id'                     => new sfWidgetFormTextarea(),
      'quantity'                    => new sfWidgetFormInputText(),
      'product_id'                  => new sfWidgetFormTextarea(),
      'transaction_id'              => new sfWidgetFormTextarea(),
      'purchase_date'               => new sfWidgetFormTextarea(),
      'original_transaction_id'     => new sfWidgetFormTextarea(),
      'original_purchase_date'      => new sfWidgetFormTextarea(),
      'app_item_id'                 => new sfWidgetFormTextarea(),
      'version_external_identifier' => new sfWidgetFormTextarea(),
      'bid'                         => new sfWidgetFormTextarea(),
      'bvrs'                        => new sfWidgetFormTextarea(),
      'expires_date'                => new sfWidgetFormTextarea(),
      'latest_receipt'              => new sfWidgetFormTextarea(),
      'latest_receipt_info'         => new sfWidgetFormTextarea(),
      'del_flg'                     => new sfWidgetFormInputText(),
      'created_at'                  => new sfWidgetFormDateTime(),
      'updated_at'                  => new sfWidgetFormDateTime(),
    ));

    $this->setValidators(array(
      'id'                          => new sfValidatorChoice(array('choices' => array($this->getObject()->getId()), 'empty_value' => $this->getObject()->getId(), 'required' => false)),
      'user_id'                     => new sfValidatorString(),
      'quantity'                    => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'product_id'                  => new sfValidatorString(),
      'transaction_id'              => new sfValidatorString(),
      'purchase_date'               => new sfValidatorString(array('required' => false)),
      'original_transaction_id'     => new sfValidatorString(),
      'original_purchase_date'      => new sfValidatorString(array('required' => false)),
      'app_item_id'                 => new sfValidatorString(),
      'version_external_identifier' => new sfValidatorString(),
      'bid'                         => new sfValidatorString(),
      'bvrs'                        => new sfValidatorString(),
      'expires_date'                => new sfValidatorString(),
      'latest_receipt'              => new sfValidatorString(),
      'latest_receipt_info'         => new sfValidatorString(),
      'del_flg'                     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'                  => new sfValidatorDateTime(array('required' => false)),
      'updated_at'                  => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('store_subscription_receipt[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'StoreSubscriptionReceipt';
  }


}
