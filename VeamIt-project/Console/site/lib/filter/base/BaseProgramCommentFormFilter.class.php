<?php

/**
 * ProgramComment filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseProgramCommentFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'program_id'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'social_user_id' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'comment'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flag'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'program_id'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'social_user_id' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'comment'        => new sfValidatorPass(array('required' => false)),
      'del_flag'       => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('program_comment_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'ProgramComment';
  }

  public function getFields()
  {
    return array(
      'id'             => 'Number',
      'program_id'     => 'Number',
      'social_user_id' => 'Number',
      'comment'        => 'Text',
      'del_flag'       => 'Number',
      'created_at'     => 'Date',
      'updated_at'     => 'Date',
    );
  }
}
