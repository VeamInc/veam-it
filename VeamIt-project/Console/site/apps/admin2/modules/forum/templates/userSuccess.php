<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">User</h5></div>


		<!-- divider -->
		<div class="solidline"></div>
		<!-- end divider -->

		<?php 
			if($targetSocialUser->getFacebookId()){ 
				$socialLink = sprintf("https://www.facebook.com/profile.php?id=%s",$targetSocialUser->getFacebookId()) ;
				$socialText = "Facebook page" ;
			} else {
				$socialLink = sprintf("https://twitter.com/intent/user?user_id=%s",$targetSocialUser->getTwitterId()) ;
				$socialText = "Twitter page" ;
			}
		?>

		<h5>User info</h5>
		<div class="media">
			<a href="<?php echo $socialLink ?>" target="_blank" class="thumbnail pull-left"><img src="<?php echo $targetSocialUser->getProfileImage() ?>" alt=""></a>
			<div class="media-body">
				<div class="media-content">
					<h6><?php echo $targetSocialUser->getName() ?></h6>
					<p>
						Status : <?php echo ($targetSocialUser->getBlockLevel() == 0)?"Not blocked":"Blocked";  ?>
					</p>
					<p>Description : <?php echo $targetSocialUser->getDescription() ?></p>
					<a target="_blank" href="<?php echo $socialLink ?>"><?php echo $socialText ?></a><br />
					<?php if($targetSocialUser->getBlockLevel() == 0): ?>
					<p class="align-right">
						<?php echo AdminTools::link_to('<i class="icon-remove"></i>Block this user', "forum/blockuser", array("onclick"=>"return confirm('Block this user?')","query_string"=>sprintf("i=%s&r=0",$targetSocialUser->getId()))) ; ?><br/>
						<?php echo AdminTools::link_to('<i class="icon-remove-sign"></i>Block this user and remove all posts and comments', "forum/blockuser", array("onclick"=>"return confirm('Block and remove posts?')","query_string"=>sprintf("i=%s&r=1",$targetSocialUser->getId()))) ; ?>
					</p>
					<?php endif ?>
				</div>
			</div>
		</div>


		<!-- divider -->
		<div class="solidline"></div>
		<!-- end divider -->

		<h5>User's posts</h5>

		<?php if(count($pictures) > 0): ?>
		<?php 
			foreach($pictures as $picture): 
				$comments = $commentsForPictureId[$picture->getId()] ;
				$forum = $forumMap[$picture->getForumId()] ;
				if($forum){
					$forumName = AdminTools::unescapeName($forum->getName()) ;
					$app = $appMap[$forum->getAppId()] ;
					if($app){
						$appName = $app->getName() ;
					} else {
						$appName = "" ;
					}
				} else {
					$forumName = "" ;
					$appName = "" ;
				}
		?>
		<div class="media">
			<div class="thumbnail pull-left"><img src="<?php echo $picture->getUrl() ?>" alt="" width="150" height="150" /></div>
			<div class="media-body">
				<div class="media-content">

					<div class="accordion stripped" id="accordion-comment<?php echo $picture->getId() ?>">
						<div class="accordion-group">
							<div class="accordion-heading">
								<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion-comment<?php echo $picture->getId() ?>" href="#collapse-comment<?php echo $picture->getId() ?>"><span class="icon-comment"></span> Comments(<?php echo count($comments) ?>) </a>
							</div>
							<div id="collapse-comment<?php echo $picture->getId() ?>" class="accordion-body collapse">
								<div class="accordion-inner">

									<ul class="folio-detail">
										<?php foreach($comments as $comment): 
											$socialUser = $socialUserMap[$comment->getSocialUserId()] ;
											if($socialUser){
												$socialUserName = $socialUser->getName() ;
											} else {
												$socialUserName = "" ;
											}
										?>
										<li class="<?php echo ($comment->getDelFlag() == 0) ? "":"media-opacity40"?>">
											<label><?php echo $socialUserName ?> :</label> 
											<?php echo AdminTools::unescapeName(AdminTools::unescapeName($comment->getComment())) ?>&nbsp;
											<?php if($comment->getDelFlag() == 0): ?>
											<?php echo AdminTools::link_to('<i class="icon-trash"></i>', "forum/deletecomment", array("onclick"=>"return confirm('Remove this comment?')","query_string"=>sprintf("cid=%d&pid=%d&a=%s&p=%s",$comment->getId(),$picture->getId(),$appId,$page))) ; ?>
											<?php endif ?>
										</li>
										<?php endforeach ?>
									</ul>

								</div>
							</div>
						</div>
					</div>

					<div class="bottom-article-no-margin">
						<ul class="meta-post">
							<li><i class="icon-calendar"></i><?php echo $picture->getCreatedAt() ?></li>
							<li><i class="icon-folder-open"></i><?php echo $appName ." > " . $forumName ?></li>
							<li><i class="icon-heart"></i><?php echo $picture->getNumberOfLikes() ?></li>
							<li><i class="icon-trash"></i><?php echo AdminTools::link_to("Remove", "forum/deletepost", array("onclick"=>"return confirm('Remove this post?')","query_string"=>sprintf("pid=%d&a=%s&p=%s",$picture->getId(),$appId,$page))) ; ?></li>
						</ul>
					</div>





				</div>
			</div>
		</div>
		<!-- divider -->
		<div class="solidline">
		</div>
		<!-- end divider -->
		<?php endforeach ?>

		<?php else: ?>
		There are no results.
		<?php endif ?>

	</div>
</div>
<!-- end: Right Content -->
