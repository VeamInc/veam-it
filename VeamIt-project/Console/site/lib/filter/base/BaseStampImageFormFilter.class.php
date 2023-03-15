<?php

/**
 * StampImage filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseStampImageFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'stamp_id'   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'url'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'back_palet' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at' => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at' => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'stamp_id'   => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'url'        => new sfValidatorPass(array('required' => false)),
      'back_palet' => new sfValidatorPass(array('required' => false)),
      'del_flg'    => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at' => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at' => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('stamp_image_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'StampImage';
  }

  public function getFields()
  {
    return array(
      'id'         => 'Number',
      'stamp_id'   => 'Number',
      'url'        => 'Text',
      'back_palet' => 'Text',
      'del_flg'    => 'Number',
      'created_at' => 'Date',
      'updated_at' => 'Date',
    );
  }
}
