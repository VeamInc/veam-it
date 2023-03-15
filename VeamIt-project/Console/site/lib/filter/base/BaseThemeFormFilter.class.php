<?php

/**
 * Theme filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseThemeFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'product'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'description'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'base_url'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail_name'   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'screenshots'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'images'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'top_color'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'top_text_color'   => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'top_text_font'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'top_text_size'    => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'base_text_color'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'link_text_color'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'background_color' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'post_text_color'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'status_bar_color' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'status_bar_style' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'separator_color'  => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'text1_color'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'text2_color'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'text3_color'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'price'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'       => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'       => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'product'          => new sfValidatorPass(array('required' => false)),
      'title'            => new sfValidatorPass(array('required' => false)),
      'description'      => new sfValidatorPass(array('required' => false)),
      'base_url'         => new sfValidatorPass(array('required' => false)),
      'thumbnail_name'   => new sfValidatorPass(array('required' => false)),
      'screenshots'      => new sfValidatorPass(array('required' => false)),
      'images'           => new sfValidatorPass(array('required' => false)),
      'top_color'        => new sfValidatorPass(array('required' => false)),
      'top_text_color'   => new sfValidatorPass(array('required' => false)),
      'top_text_font'    => new sfValidatorPass(array('required' => false)),
      'top_text_size'    => new sfValidatorPass(array('required' => false)),
      'base_text_color'  => new sfValidatorPass(array('required' => false)),
      'link_text_color'  => new sfValidatorPass(array('required' => false)),
      'background_color' => new sfValidatorPass(array('required' => false)),
      'post_text_color'  => new sfValidatorPass(array('required' => false)),
      'status_bar_color' => new sfValidatorPass(array('required' => false)),
      'status_bar_style' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'separator_color'  => new sfValidatorPass(array('required' => false)),
      'text1_color'      => new sfValidatorPass(array('required' => false)),
      'text2_color'      => new sfValidatorPass(array('required' => false)),
      'text3_color'      => new sfValidatorPass(array('required' => false)),
      'price'            => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'del_flg'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'       => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'       => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('theme_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'Theme';
  }

  public function getFields()
  {
    return array(
      'id'               => 'Number',
      'app_id'           => 'Number',
      'product'          => 'Text',
      'title'            => 'Text',
      'description'      => 'Text',
      'base_url'         => 'Text',
      'thumbnail_name'   => 'Text',
      'screenshots'      => 'Text',
      'images'           => 'Text',
      'top_color'        => 'Text',
      'top_text_color'   => 'Text',
      'top_text_font'    => 'Text',
      'top_text_size'    => 'Text',
      'base_text_color'  => 'Text',
      'link_text_color'  => 'Text',
      'background_color' => 'Text',
      'post_text_color'  => 'Text',
      'status_bar_color' => 'Text',
      'status_bar_style' => 'Number',
      'separator_color'  => 'Text',
      'text1_color'      => 'Text',
      'text2_color'      => 'Text',
      'text3_color'      => 'Text',
      'price'            => 'Number',
      'del_flg'          => 'Number',
      'created_at'       => 'Date',
      'updated_at'       => 'Date',
    );
  }
}
