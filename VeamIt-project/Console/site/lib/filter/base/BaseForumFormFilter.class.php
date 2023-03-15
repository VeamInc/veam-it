<?php

/**
 * Forum filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseForumFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'             => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'kind'               => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'name'               => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'number_of_likes'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'number_of_comments' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'number_of_pictures' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flag'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'         => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'         => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'             => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'kind'               => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'name'               => new sfValidatorPass(array('required' => false)),
      'number_of_likes'    => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'number_of_comments' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'number_of_pictures' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'del_flag'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'         => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'         => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('forum_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Forum';
  }

  public function getFields()
  {
    return array(
      'id'                 => 'Number',
      'app_id'             => 'Number',
      'kind'               => 'Number',
      'name'               => 'Text',
      'number_of_likes'    => 'Number',
      'number_of_comments' => 'Number',
      'number_of_pictures' => 'Number',
      'del_flag'           => 'Number',
      'created_at'         => 'Date',
      'updated_at'         => 'Date',
    );
  }
}
