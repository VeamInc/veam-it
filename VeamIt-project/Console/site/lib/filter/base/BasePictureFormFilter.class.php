<?php

/**
 * Picture filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BasePictureFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'forum_id'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'social_user_id'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'number_of_likes' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'url'             => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flag'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'      => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'      => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'forum_id'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'social_user_id'  => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'number_of_likes' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'url'             => new sfValidatorPass(array('required' => false)),
      'del_flag'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'      => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'      => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('picture_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Picture';
  }

  public function getFields()
  {
    return array(
      'id'              => 'Number',
      'forum_id'        => 'Number',
      'social_user_id'  => 'Number',
      'number_of_likes' => 'Number',
      'url'             => 'Text',
      'del_flag'        => 'Number',
      'created_at'      => 'Date',
      'updated_at'      => 'Date',
    );
  }
}
