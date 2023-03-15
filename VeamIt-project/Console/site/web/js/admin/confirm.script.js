$(document).ready(function(){
	
	$('.confirmitem .delete').click(function(){
		
		var elem = $(this).closest('.confirmitem');
		
		$.confirm({
			'title'		: 'Delete Confirmation',
			'message'	: 'You are about to delete this item. <br />It cannot be restored at a later time! Continue?',
			'buttons'	: {
				'Yes'	: {
					'class'	: 'blue',
					'action': function(){
						elem.slideUp();
					}
				},
				'No'	: {
					'class'	: 'gray',
					'action': function(){}	// Nothing to do in this case. You can as well omit the action property.
				}
			}
		});
		
	});
	
});


function selectJump(obj)
{
	index = obj.selectedIndex ;
	location.href = obj.options[index].value ;
}

function addUserToGroup(obj)
{
	index = obj.selectedIndex ;
	var url = obj.options[index].value ;

	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
		},
		error: function(xhr, textStatus, errorThrown){
			alert('Error! ' + textStatus + ' ' + errorThrown);
		}
	});
}

function removeUserFromGroup(obj)
{
	var url = obj.href ;
	if(confirm('Remove user from this notification group?')){
		//alert("go " + url) ;
		$.ajax({
			url: url,
			dataType: "json",
			cache: false,
			success: function(data, textStatus){
				$(data.number_of_groups_target).html(data.number_of_groups);
				$(data.html_target).html(data.html);
			},
			error: function(xhr, textStatus, errorThrown){
				//alert('Error! ' + textStatus + ' ' + errorThrown);
				location.href = "/creator2.php/error/index?m=Error" ;
			}
		});
	} else {
		// alert("cancel") ;
	}

	return false ;
}


function changeYoutubeCategoryOrder(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}

function activateYoutubeCategory(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}

function changeForumCategoryName(url,name)
{
	$.ajax({
		type: "POST",
		url: url,
		data: { 
	        'na': name, 
	    },
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}

function changeForumCategoryOrder(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}


function removeForumCategory(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}



function addForumCategory(url)
{
	//alert("addForumCategory:"+url) ;
	var forumId = 0 ;
	$.ajax({
		type: "POST",
		url: url,
		async: false,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
			forumId = data.forumId ;
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});

	//alert("addForumCategory end : " + forumId) ;
	return forumId ;

}
























function changeLinkName(url,name)
{
	$.ajax({
		type: "POST",
		url: url,
		data: { 
	        'na': name, 
	    },
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}

function changeLinkUrl(url,name)
{
	$.ajax({
		type: "POST",
		url: url,
		data: { 
	        'na': name, 
	    },
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}

function changeLinkOrder(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}


function removeLink(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}



function addLink(url)
{
	var webId = 0 ;
	$.ajax({
		type: "POST",
		url: url,
		async: false,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
			webId = data.webId ;
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});

	return webId ;

}

function changeConceptColor(url)
{
	var webId = 0 ;
	$.ajax({
		url: url,
		async: false,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
			//webId = data.webId ;
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});

	return webId ;

}






function addSellItemCategory(url)
{
	var sellItemCategoryId = 0 ;
	$.ajax({
		type: "POST",
		url: url,
		async: false,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
			sellItemCategoryId = data.sellItemCategoryId ;
		},
		error: function(xhr, textStatus, errorThrown){
			alert('Error! ' + textStatus + ' ' + errorThrown);
			//location.href = '/creator.php/login' ;
		}
	});

	return sellItemCategoryId ;

}

function changeSellItemCategoryName(url,name)
{
	$.ajax({
		type: "POST",
		url: url,
		data: { 
	        'na': name, 
	    },
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}

function removeSellItemCategory(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			alert('Error! ' + textStatus + ' ' + errorThrown);
			//location.href = '/creator.php/login' ;
		}
	});
}























function addSellSectionCategory(url)
{
	var sellSectionCategoryId = 0 ;
	$.ajax({
		type: "POST",
		url: url,
		async: false,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
			sellSectionCategoryId = data.sellSectionCategoryId ;
		},
		error: function(xhr, textStatus, errorThrown){
			alert('Error! ' + textStatus + ' ' + errorThrown);
			//location.href = '/creator.php/login' ;
		}
	});

	return sellSectionCategoryId ;

}

function changeSellSectionCategoryName(url,name)
{
	$.ajax({
		type: "POST",
		url: url,
		data: { 
	        'na': name, 
	    },
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			//alert('Error! ' + textStatus + ' ' + errorThrown);
			location.href = '/creator.php/login' ;
		}
	});
}

function removeSellSectionCategory(url)
{
	$.ajax({
		url: url,
		dataType: "json",
		cache: false,
		success: function(data, textStatus){
			/*
			$(data.number_of_groups_target).html(data.number_of_groups);
			$(data.html_target).html(data.html);
			*/
		},
		error: function(xhr, textStatus, errorThrown){
			alert('Error! ' + textStatus + ' ' + errorThrown);
			//location.href = '/creator.php/login' ;
		}
	});
}


