<?php

/**
 * Program filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseProgramFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'author'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'duration'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'description'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'small_image_url' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'large_image_url' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'data_url'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'data_size'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'      => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'      => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'kind'            => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'author'          => new sfValidatorPass(array('required' => false)),
      'duration'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'title'           => new sfValidatorPass(array('required' => false)),
      'description'     => new sfValidatorPass(array('required' => false)),
      'small_image_url' => new sfValidatorPass(array('required' => false)),
      'large_image_url' => new sfValidatorPass(array('required' => false)),
      'data_url'        => new sfValidatorPass(array('required' => false)),
      'data_size'       => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'del_flg'         => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'      => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'      => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('program_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Program';
  }

  public function getFields()
  {
    return array(
      'id'              => 'Number',
      'app_id'          => 'Number',
      'kind'            => 'Number',
      'author'          => 'Text',
      'duration'        => 'Number',
      'title'           => 'Text',
      'description'     => 'Text',
      'small_image_url' => 'Text',
      'large_image_url' => 'Text',
      'data_url'        => 'Text',
      'data_size'       => 'Number',
      'del_flg'         => 'Number',
      'created_at'      => 'Date',
      'updated_at'      => 'Date',
    );
  }
}
