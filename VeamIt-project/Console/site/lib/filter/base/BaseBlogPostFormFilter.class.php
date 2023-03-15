<?php

/**
 * BlogPost filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseBlogPostFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'               => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'title'                => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'html'                 => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'blog_category_id'     => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'blog_sub_category_id' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'thumbnail_url'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'posted_at'            => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'del_flg'              => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'           => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'           => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'               => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'title'                => new sfValidatorPass(array('required' => false)),
      'html'                 => new sfValidatorPass(array('required' => false)),
      'blog_category_id'     => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'blog_sub_category_id' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'thumbnail_url'        => new sfValidatorPass(array('required' => false)),
      'posted_at'            => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'del_flg'              => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'           => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'           => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('blog_post_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'BlogPost';
  }

  public function getFields()
  {
    return array(
      'id'                   => 'Number',
      'app_id'               => 'Number',
      'title'                => 'Text',
      'html'                 => 'Text',
      'blog_category_id'     => 'Number',
      'blog_sub_category_id' => 'Number',
      'thumbnail_url'        => 'Text',
      'posted_at'            => 'Date',
      'del_flg'              => 'Number',
      'created_at'           => 'Date',
      'updated_at'           => 'Date',
    );
  }
}
