<?php

/**
 * Textline form.
 *
 * @package    console
 * @subpackage form
 * @author     Your name here
 */
class TextlineForm extends BaseTextlineForm
{
	public function configure()
	{
		unset(
			$this['app_id'],
			//$this['textline_category_id'],
			$this['textline_sub_category_id'],
			$this['textline_package_id'],
			//$this['kind'],
			$this['created_at'],
			$this['updated_at'],
			$this['del_flg']
		);

		$this->widgetSchema['kind'] = new sfWidgetFormSelect(
			array('label'=>'type',"choices" =>array('2' => 'fixed','3' => 'normal')));

	  	$c = new Criteria() ;
	  	$c->add(TextlineCategoryPeer::DEL_FLG,0) ;
	  	$c->add(TextlineCategoryPeer::APP_ID,'31000018') ;
	  	$textlineCategories = TextlineCategoryPeer::doSelect($c) ;
		$textlineCategoryArray = array() ;
		foreach($textlineCategories as $textlineCategory){
			$textlineCategoryArray[$textlineCategory->getId()] = $textlineCategory->getName() ;
		}
		$this->widgetSchema['textline_category_id'] = new sfWidgetFormSelect(
			array('label'=>'category',"choices" =>$textlineCategoryArray));


		/*
		$this->setWidgets( array(
		    'fixed'=> new sfWidgetFormInputCheckbox(
		        array(
		            'value_attribute_value'=>'1',
		            'default'=>false
		        )
		    )
		));
		*/
	}

	public function save($con = null)
	{
		$textline = $_POST['textline'] ;

		$this->values['title'] = $this->escapeText($textline['title']) ;
		$this->values['sub_title'] = $this->escapeText($textline['sub_title']) ;
		$this->values['text'] = $this->escapeText($textline['text']) ;

		$user = sfContext::getInstance()->getUser() ;
		$groups = $user->getGroups() ;
		if(count($groups) > 0){
			$group = array_shift($groups) ;
			$appId = $group->getName() ;
			if($appId == '31000018'){
				$this->values['app_id'] = $appId ;
				unset($_POST['textline']['fixed']) ;
				$this->values['textline_sub_category_id'] = '0' ;
				//$this->values['kind'] = '1' ;

				if($this->isNew()){
					// renew date
				  	$c = new Criteria() ;
				  	$c->add(ExtraDataPeer::DEL_FLG,0) ;
				  	$c->add(ExtraDataPeer::APP_ID,'31000018') ;
				  	$c->add(ExtraDataPeer::NAME,'modification_time') ;
				  	$extraData = ExtraDataPeer::doSelectOne($c) ;
					if(!$extraData){
						$extraData = new ExtraData() ;
						$extraData->setAppId('31000018') ;
						$extraData->setName('modification_time') ;
					}
					$extraData->setData(time()) ;
					$extraData->save() ;

					ConsoleTools::clearContentCache('31000018') ;
				}
			}
		}


		return parent::save($con) ;
	}

	private function escapeText($targetText)
	{
		$text = $targetText ;
		$text = str_replace('&','&amp;',$text) ;
		$text = str_replace('<','&lt;',$text) ;
		$text = str_replace('>','&gt;',$text) ;
		$text = str_replace('"','&quot;',$text) ;
		$text = str_replace("\r\n",'&#xa;',$text) ;
		return $text ;
	}

}
