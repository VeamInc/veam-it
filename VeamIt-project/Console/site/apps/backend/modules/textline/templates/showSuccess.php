<table border="1">
	<tr><td>Id</td><td>AppId</td><td>Title</td><td>Text</td><td>CreatedAt</td><td>Actions</td></tr>
		<tr>
			<td><?php echo $textline->getId() ?></td>
			<td><?php echo $textline->getAppId() ?></td>
			<td><?php echo $textline->getTitle() ?></td>
			<td><?php echo $textline->getText() ?></td>
			<td><?php echo $textline->getCreatedAt() ?></td>
			<td><?php echo link_to('Deploy','textline/confirmdeploy?id=' . $textline->getId()) ?></td>
		</tr>
</table>
<br>
<br>
iTunesConnect 情報
<table border="1">
	<tr><td>参照名</td><td><?php echo $textline->getTitle() ?></td></tr>
	<tr><td>製品ID</td><td><?php echo $textlinePackage->getProduct() ?></td></tr>
	<tr><td>価格</td><td>USD 0.99</td></tr>
	<tr><td>[ローカリゼーション]-[日本語]-[表示名]</td><td><?php echo $textline->getTitle() ?></td></tr>
	<tr><td>[ローカリゼーション]-[日本語]-[説明]</td><td><?php echo $textline->getTitle() ?></td></tr>
</table>

<br />
<br />
