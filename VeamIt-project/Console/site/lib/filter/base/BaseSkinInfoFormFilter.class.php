<?php

/**
 * SkinInfo filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseSkinInfoFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'picture_id'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'social_user_id' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'skin_tone'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'skin_type'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'eye_color'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flag'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'     => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'picture_id'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'social_user_id' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'skin_tone'      => new sfValidatorPass(array('required' => false)),
      'skin_type'      => new sfValidatorPass(array('required' => false)),
      'eye_color'      => new sfValidatorPass(array('required' => false)),
      'del_flag'       => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'     => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('skin_info_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'SkinInfo';
  }

  public function getFields()
  {
    return array(
      'id'             => 'Number',
      'picture_id'     => 'Number',
      'social_user_id' => 'Number',
      'skin_tone'      => 'Text',
      'skin_type'      => 'Text',
      'eye_color'      => 'Text',
      'del_flag'       => 'Number',
      'created_at'     => 'Date',
      'updated_at'     => 'Date',
    );
  }
}
