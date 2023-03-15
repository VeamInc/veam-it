<?php

/**
 * StoreReceipt form base class.
 *
 * @method StoreReceipt getObject() Returns the current form's model object
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
abstract class BaseStoreReceiptForm extends BaseFormPropel
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
      'del_flg'                     => new sfValidatorInteger(array('min' => -2147483648, 'max' => 2147483647)),
      'created_at'                  => new sfValidatorDateTime(array('required' => false)),
      'updated_at'                  => new sfValidatorDateTime(array('required' => false)),
    ));

    $this->widgetSchema->setNameFormat('store_receipt[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'StoreReceipt';
  }


}
