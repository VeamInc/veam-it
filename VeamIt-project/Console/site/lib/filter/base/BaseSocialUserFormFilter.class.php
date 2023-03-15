<?php

/**
 * SocialUser filter form base class.
 *
 * @package    console
 * @subpackage filter
 * @author     Your name here
 */
abstract class BaseSocialUserFormFilter extends BaseFormFilterPropel
{
  public function setup()
  {
    $this->setWidgets(array(
      'app_id'             => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'secret'             => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'twitter_id'         => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'facebook_id'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'name'               => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'twitter_user'       => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'profile_image'      => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'description'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'location'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'latitude'           => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'longitude'          => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'block_level'        => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'number_of_pictures' => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'del_flg'            => new sfWidgetFormFilterInput(array('with_empty' => false)),
      'created_at'         => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
      'updated_at'         => new sfWidgetFormFilterDate(array('from_date' => new sfWidgetFormDate(), 'to_date' => new sfWidgetFormDate())),
    ));

    $this->setValidators(array(
      'app_id'             => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'secret'             => new sfValidatorPass(array('required' => false)),
      'twitter_id'         => new sfValidatorPass(array('required' => false)),
      'facebook_id'        => new sfValidatorPass(array('required' => false)),
      'name'               => new sfValidatorPass(array('required' => false)),
      'twitter_user'       => new sfValidatorPass(array('required' => false)),
      'profile_image'      => new sfValidatorPass(array('required' => false)),
      'description'        => new sfValidatorPass(array('required' => false)),
      'location'           => new sfValidatorPass(array('required' => false)),
      'latitude'           => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'longitude'          => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'block_level'        => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'number_of_pictures' => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'del_flg'            => new sfValidatorSchemaFilter('text', new sfValidatorInteger(array('required' => false))),
      'created_at'         => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
      'updated_at'         => new sfValidatorDateRange(array('required' => false, 'from_date' => new sfValidatorDate(array('required' => false)), 'to_date' => new sfValidatorDate(array('required' => false)))),
    ));

    $this->widgetSchema->setNameFormat('social_user_filters[%s]');

    $this->errorSchema = new sfValidatorErrorSchema($this->validatorSchema);

    parent::setup();
  }

  public function getModelName()
  {
    return 'SocialUser';
  }

  public function getFields()
  {
    return array(
      'id'                 => 'Number',
      'app_id'             => 'Number',
      'secret'             => 'Text',
      'twitter_id'         => 'Text',
      'facebook_id'        => 'Text',
      'name'               => 'Text',
      'twitter_user'       => 'Text',
      'profile_image'      => 'Text',
      'description'        => 'Text',
      'location'           => 'Text',
      'latitude'           => 'Number',
      'longitude'          => 'Number',
      'block_level'        => 'Number',
      'number_of_pictures' => 'Number',
      'del_flg'            => 'Number',
      'created_at'         => 'Date',
      'updated_at'         => 'Date',
    );
  }
}
