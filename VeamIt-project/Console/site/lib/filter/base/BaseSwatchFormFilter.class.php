<?php

/**
 * Swatch filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseSwatchFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'picture_id'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'social_user_id'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'number_of_likes' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'base_url'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image1'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image2'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image3'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image4'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'image5'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail1'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail2'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail3'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail4'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail5'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'product_name'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'category'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'brand'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'rating'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'skin_tone'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'skin_type'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'eye_color'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flag'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'      => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'      => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'picture_id'      => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'social_user_id'  => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'number_of_likes' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'base_url'        => new sfValidatorPass(array('required' => false)),
      'image1'          => new sfValidatorPass(array('required' => false)),
      'image2'          => new sfValidatorPass(array('required' => false)),
      'image3'          => new sfValidatorPass(array('required' => false)),
      'image4'          => new sfValidatorPass(array('required' => false)),
      'image5'          => new sfValidatorPass(array('required' => false)),
      'thumbnail1'      => new sfValidatorPass(array('required' => false)),
      'thumbnail2'      => new sfValidatorPass(array('required' => false)),
      'thumbnail3'      => new sfValidatorPass(array('required' => false)),
      'thumbnail4'      => new sfValidatorPass(array('required' => false)),
      'thumbnail5'      => new sfValidatorPass(array('required' => false)),
      'product_name'    => new sfValidatorPass(array('required' => false)),
      'category'        => new sfValidatorPass(array('required' => false)),
      'brand'           => new sfValidatorPass(array('required' => false)),
      'rating'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'skin_tone'       => new sfValidatorPass(array('required' => false)),
      'skin_type'       => new sfValidatorPass(array('required' => false)),
      'eye_color'       => new sfValidatorPass(array('required' => false)),
      'del_flag'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'      => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'      => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('swatch_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Swatch';
  }

  public function getFields()
  {
    return array(
      'id'              => 'Number',
      'picture_id'      => 'Number',
      'social_user_id'  => 'Number',
      'number_of_likes' => 'Number',
      'base_url'        => 'Text',
      'image1'          => 'Text',
      'image2'          => 'Text',
      'image3'          => 'Text',
      'image4'          => 'Text',
      'image5'          => 'Text',
      'thumbnail1'      => 'Text',
      'thumbnail2'      => 'Text',
      'thumbnail3'      => 'Text',
      'thumbnail4'      => 'Text',
      'thumbnail5'      => 'Text',
      'product_name'    => 'Text',
      'category'        => 'Text',
      'brand'           => 'Text',
      'rating'          => 'Number',
      'skin_tone'       => 'Text',
      'skin_type'       => 'Text',
      'eye_color'       => 'Text',
      'del_flag'        => 'Number',
      'created_at'      => 'Date',
      'updated_at'      => 'Date',
    );
  }
}
