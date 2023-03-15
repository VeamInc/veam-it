symfony propel:build-schema
mv config/schema.yml config/schema_org.yml
perl fix_schema.pl
symfony propel:build-model
symfony cc
