<!-- start: Right Content -->
<div class="span9 column">
	<div class="widget-title"><h5 class="widgetheading">Balance</h5></div>

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->

	<div class="element-select">
		Start :
		<select onChange="selectJump(this)">
			<option value="<?php echo url_for(sprintf('%s/%s?a=0&start=0&end=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$end,$sortKind), false) ?>" <?php if(!$yearMonth) echo 'selected' ; ?>>All</option>
			<?php foreach($yearMonths as $workYearMonth => $yearMonthName): ?>
			<option value="<?php echo url_for(sprintf('%s/%s?a=0&start=%d&end=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$workYearMonth,$end,$sortKind), false) ?>" <?php if($start == $workYearMonth) echo 'selected' ; ?>><?php echo AdminTools::unescapeName($yearMonthName) ?></option>
			<?php endforeach ?>
		</select>

		End :
		<select onChange="selectJump(this)">
			<option value="<?php echo url_for(sprintf('%s/%s?a=0&start=%d&end=0&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$start,$sortKind), false) ?>" <?php if(!$end) echo 'selected' ; ?>>All</option>
			<?php foreach($yearMonths as $workYearMonth => $yearMonthName): ?>
			<option value="<?php echo url_for(sprintf('%s/%s?a=0&start=%d&end=%d&p=1&sort=%d',$sf_context->getModuleName(),$sf_context->getActionName(),$start,$workYearMonth,$sortKind), false) ?>" <?php if($end == $workYearMonth) echo 'selected' ; ?>><?php echo AdminTools::unescapeName($yearMonthName) ?></option>
			<?php endforeach ?>
		</select>
		<p style="clear:both" />
	</div>

	<!-- divider -->
	<div class="solidline">
	</div>
	<!-- end divider -->


	<?php if(count($revenueData) > 0): ?>

	<table class="table table-bordered">
		<thead><tr><th>App Name</th><th></th>
			<?php foreach($existYearMonth as $workYearMonth): ?>
			<th><?php echo $workYearMonth ?></th>
			<?php endforeach ?>
		<th>Total</th>
		</tr></thead>
		<tbody>
		<?php foreach($dataApps as $app): 
			$appId = $app->getId() ;
			$revenues = $revenueData[$appId] ;
			if($app){
				$appName = $app->getName() ;
			} else {
				$appName = 'Unknown' ;
			}
			$totalShare = 0 ;
			$totalPayment = 0 ;
			$totalBalance = 0 ;
		?>
			<tr>
				<td rowspan="3"><?php echo $appName ?></td>
				<td>Share</td>
			<?php foreach($existYearMonth as $workYearMonth): 
				$revenue = $revenues[$workYearMonth] ;
				$totalShare += $revenue ;
			?>




				<td><?php echo link_to(sprintf("%.2f",$revenue), "payment/listrevenue", array("target"=>"_blank","query_string"=>sprintf("a=%d&ym=%d",$appId,$workYearMonth))) ?></td>
			<?php endforeach ?>
				<td><?php echo sprintf("%.2f",$totalShare) ?></td>
			</tr>



			<tr>
				<td>Paid</td>
			<?php foreach($existYearMonth as $workYearMonth): 
				$payment = $paymentData[$appId][$workYearMonth] ;
				$totalPayment += $payment ;
			?>
				<td>
					<?php echo sprintf("%.2f",$payment) ?>
					<?php if($payment > 0): ?>
						<br/><?php echo link_to('[Mail]', "payment/mailinputnew", array("target"=>"_blank","query_string"=>sprintf("a=%d&sym=%d&eym=%d",$appId,$workYearMonth,$workYearMonth))) ?>
					<?php endif ?>
				</td>
			<?php endforeach ?>
				<td><?php echo sprintf("%.2f",$totalPayment) ?></td>
			</tr>



			<tr>
				<td style="background:#EFF">Balance</td>
			<?php foreach($existYearMonth as $workYearMonth): 
				$balance = $balanceData[$appId][$workYearMonth] ;
				$totalBalance += $balance ;
			?>
				<td style="background:#EFF"><?php echo sprintf("%.2f",$balance) ?><br><?php echo link_to('[Pay]', "payment/paymentinputnew", array("target"=>"_blank","query_string"=>sprintf("a=%d&ym=%d&amount=%.2f",$appId,$workYearMonth,$balance))) ?></td>
			<?php endforeach ?>
				<td style="background:#EFF"><?php echo sprintf("%.2f",$totalBalance) ?></td>
			</tr>






		<?php endforeach ?>
	</tbody>
	</table>


	<?php else: ?>
	There are no results.
	<?php endif ?>

</div>
<!-- end: Right Content -->
