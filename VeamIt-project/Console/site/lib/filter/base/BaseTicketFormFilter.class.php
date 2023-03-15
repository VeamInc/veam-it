<?php

/**
 * Ticket filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseTicketFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'transaction'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'description'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image_url'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'used_image_url' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'used'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'code'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'qualified_at'   => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'del_flg'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'         => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'transaction'    => new sfValidatorPass(array('required' => false)),
      'kind'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'title'          => new sfValidatorPass(array('required' => false)),
      'description'    => new sfValidatorPass(array('required' => false)),
      'image_url'      => new sfValidatorPass(array('required' => false)),
      'used_image_url' => new sfValidatorPass(array('required' => false)),
      'used'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'code'           => new sfValidatorPass(array('required' => false)),
      'qualified_at'   => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'del_flg'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('ticket_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Ticket';
  }

  public function getFields()
  {
    return array(
      'id'             => 'Number',
      'app_id'         => 'Number',
      'transaction'    => 'Text',
      'kind'           => 'Number',
      'title'          => 'Text',
      'description'    => 'Text',
      'image_url'      => 'Text',
      'used_image_url' => 'Text',
      'used'           => 'Number',
      'code'           => 'Text',
      'qualified_at'   => 'Date',
      'del_flg'        => 'Number',
      'created_at'     => 'Date',
      'updated_at'     => 'Date',
    );
  }
}
