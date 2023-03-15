

if(open(SCHEMAFILE,"<config/schema_org.yml")){
	if(open(OUTFILE,">config/schema.yml")){
		while(<SCHEMAFILE>){
			if(/^  [^ ]+:/){
				if(/^  sf_guard/){
					$skip = 1 ;
				} else {
					$skip = 0 ;
				}
			}
			if(!$skip){
				print(OUTFILE $_) ;
			}
		}
		close(OUTFILE) ;
	}
	close(SCHEMAFILE) ;
}

