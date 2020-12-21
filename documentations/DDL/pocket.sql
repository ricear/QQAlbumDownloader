-- drama
CREATE TABLE `drama`(
`s_id` string, 
`acquisition_time` string, 
`description` string, 
`drama_description` string, 
`drama_url` string, 
`id` string, 
`introduction` string, 
`name` string, 
`play_time` string, 
`sources` string, 
`src` string, 
`type` string, 
`update_time` string)
PARTITIONED BY ( 
`date_id` string)
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
'field.delim'=',', 
'serialization.format'=',') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://192.168.2.205:8020/user/hive/warehouse/pocket.db/drama'
TBLPROPERTIES (
'transient_lastDdlTime'='1581907400')

-- movie
CREATE TABLE `movie`(
`s_id` string, 
`acquisition_time` string, 
`actors` string, 
`description` string, 
`directors` string, 
`duration` string, 
`id` string, 
`language` string, 
`name` string, 
`nickname` string, 
`region` string, 
`release_date` string, 
`score` string, 
`sources` string, 
`src` string, 
`type` string, 
`type2` string, 
`update_status` string, 
`update_time` string)
PARTITIONED BY ( 
`date_id` string)
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
'field.delim'=',', 
'serialization.format'=',') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://192.168.2.205:8020/user/hive/warehouse/pocket.db/movie'
TBLPROPERTIES (
'transient_lastDdlTime'='1581907202')

-- piece
CREATE TABLE `piece`(
`s_id` string, 
`acquisition_time` string, 
`description` string, 
`drama_url` string, 
`name` string, 
`src` string, 
`type` string, 
`type2` string, 
`url` string)
PARTITIONED BY ( 
`date_id` string)
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
'field.delim'=',', 
'serialization.format'=',') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://192.168.2.205:8020/user/hive/warehouse/pocket.db/piece'
TBLPROPERTIES (
'transient_lastDdlTime'='1581907409')

-- tv
CREATE TABLE `tv`(
`s_id` string, 
`acquisition_time` string, 
`introduction` string, 
`name` string, 
`sources` string, 
`src` string, 
`type` string)
PARTITIONED BY ( 
`date_id` string)
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES ( 
'field.delim'=',', 
'serialization.format'=',') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://192.168.2.205:8020/user/hive/warehouse/pocket.db/tv'
TBLPROPERTIES (
'transient_lastDdlTime'='1581907393')

