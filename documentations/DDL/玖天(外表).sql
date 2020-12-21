-- env_lsosurface
CREATE EXTERNAL  TABLE env_lsosurface(  
date string DEFAULT NULL COMMENT '等值面的时间',  
feature string DEFAULT NULL COMMENT '7个大气质量特征',
lsosurface string DEFAULT NULL COMMENT '等值面数据' 
)
PARTITIONED BY (
partid string)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES (
'field.delim'='\t', 
'serialization.format'='\t') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat'  
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'  
LOCATION  
'hdfs://nameservice1/xnyy/ext_data/jiutian/ENV_LSOSURFACE' 
TBLPROPERTIES ( 
'transient_lastDdlTime'='1577278901')

-- env_obs_hor_grid
CREATE EXTERNAL  TABLE env_obs_hor_grid(
point string DEFAULT NULL COMMENT '标识唯一的经纬度点', 
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',  
lon decimal(38,10) DEFAULT NULL COMMENT '经度',  
pm10 decimal(38,10) DEFAULT NULL COMMENT 'pm10',  
pm25 decimal(38,10) DEFAULT NULL COMMENT 'pm2.5', 
co decimal(38,10) DEFAULT NULL COMMENT '一氧化碳', 
no2 decimal(38,10) DEFAULT NULL COMMENT '二氧化氮',
o3 decimal(38,10) DEFAULT NULL COMMENT '臭氧',
so2 decimal(38,10) DEFAULT NULL COMMENT '二氧化硫',
aqi decimal(38,10) DEFAULT NULL COMMENT 'AQI', 
areacode string DEFAULT NULL COMMENT '区划编码',
date string DEFAULT NULL COMMENT '日期（年月日）', 
time string DEFAULT NULL COMMENT '小时' 
)
PARTITIONED BY (
partid string)
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/ENV_OBS_HOR_GRID'  
TBLPROPERTIES ( 
'transient_lastDdlTime'='1577280645')

-- high_surf_fcst_hor_pg
CREATE EXTERNAL  TABLE high_surf_fcst_hor_pg(  
index string DEFAULT NULL COMMENT '序号',  
lat decimal(38,10) DEFAULT NULL COMMENT '电站纬度', 
lon decimal(38,10) DEFAULT NULL COMMENT '电站经度', 
50m_prs decimal(38,10) DEFAULT NULL COMMENT '50m气压(百帕)', 
70m_prs decimal(38,10) DEFAULT NULL COMMENT '70m气压(百帕)', 
100m_prs decimal(38,10) DEFAULT NULL COMMENT '100m气压(百帕)',  
win_d_avg_50m decimal(38,10) DEFAULT NULL COMMENT '50m风向(度360度方位)',  
win_d_avg_70m decimal(38,10) DEFAULT NULL COMMENT '70m风向(度360度方位)',  
win_d_avg_100m decimal(38,10) DEFAULT NULL COMMENT '100m风向(度360度方位)',
win_s_avg_50m decimal(38,10) DEFAULT NULL COMMENT '50m风速(米/秒）',
win_s_avg_70m decimal(38,10) DEFAULT NULL COMMENT '70m风速(米/秒）',
win_s_avg_100m decimal(38,10) DEFAULT NULL COMMENT '100m风速(米/秒）', 
begin_fcst_date string DEFAULT NULL COMMENT '起报日期(年月日)', 
fcst_date string DEFAULT NULL COMMENT '预报日期(年月日时)' 
) 
PARTITIONED BY ( 
partid string) 
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/HIGH_SURF_FCST_HOR_PG' 
TBLPROPERTIES (  
'transient_lastDdlTime'='1577282772')

-- high_surf_hor_pg
CREATE EXTERNAL  TABLE high_surf_hor_pg(
index string DEFAULT NULL,
lat decimal(38,10) DEFAULT NULL,
lon decimal(38,10) DEFAULT NULL,
50m_prs decimal(38,10) DEFAULT NULL,  
70m_prs decimal(38,10) DEFAULT NULL,  
100m_prs decimal(38,10) DEFAULT NULL, 
win_d_avg_50m decimal(38,10) DEFAULT NULL,  
win_d_avg_70m decimal(38,10) DEFAULT NULL,  
win_d_avg_100m decimal(38,10) DEFAULT NULL, 
win_s_avg_50m decimal(38,10) DEFAULT NULL,  
win_s_avg_70m decimal(38,10) DEFAULT NULL,  
win_s_avg_100m decimal(38,10) DEFAULT NULL, 
date string DEFAULT NULL, 
time string DEFAULT NULL  
)
PARTITIONED BY (
partid string)
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/HIGH_SURF_HOR_PG'  
TBLPROPERTIES ( 
'transient_lastDdlTime'='1577283218')

-- high_wind_lsosurface
CREATE EXTERNAL  TABLE high_wind_lsosurface(  
date string DEFAULT NULL COMMENT '等值面的时间(年月/年)',  
feature string DEFAULT NULL COMMENT '风资源特征（50m70m@m风功率密度，50m70m@m平均风速',
lsosurface string DEFAULT NULL COMMENT '等值面数据' 
)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES (
'field.delim'='\t', 
'serialization.format'='\t') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat'  
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'  
LOCATION  
'hdfs://nameservice1/xnyy/ext_data/jiutian/HIGH_WIND_LSOSURFACE' 
TBLPROPERTIES ( 
'transient_lastDdlTime'='1579003495')

--high_wind_resources_month
CREATE EXTERNAL  TABLE high_wind_resources_month( 
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',
lon decimal(38,10) DEFAULT NULL COMMENT '经度',
wind_power_density_50m decimal(38,10) DEFAULT NULL COMMENT '50m风功率密度',  
wind_power_density_70m decimal(38,10) DEFAULT NULL COMMENT '70m风功率密度',  
wind_power_density_100m decimal(38,10) DEFAULT NULL COMMENT '100m风功率密度',
average_wind_speed_50m decimal(38,10) DEFAULT NULL COMMENT '50m平均风速',
average_wind_speed_70m decimal(38,10) DEFAULT NULL COMMENT '70m平均风速',
average_wind_speed_100m decimal(38,10) DEFAULT NULL COMMENT '100m平均风速', 
turbulence_intensity_50m decimal(38,10) DEFAULT NULL COMMENT '50m湍流强度', 
turbulence_intensity_70m decimal(38,10) DEFAULT NULL COMMENT '70m湍流强度', 
turbulence_intensity_100m decimal(38,10) DEFAULT NULL COMMENT '100m湍流强度',  
wind_speed_frequency_50m string DEFAULT NULL COMMENT '50m风速频率（json)',
wind_speed_frequency_70m string DEFAULT NULL COMMENT '70m风速频率(json)',
wind_speed_frequency_100m string DEFAULT NULL COMMENT '100m风速频率(json)', 
wind_direction_frequency_50m string DEFAULT NULL COMMENT '50m风向频率(json)',  
wind_direction_frequency_70m string DEFAULT NULL COMMENT '70m风向频率(json)',  
wind_direction_frequency_100m string DEFAULT NULL COMMENT '100m风向频率(json)',
extreme_wind_speed_50m decimal(38,10) DEFAULT NULL COMMENT '50m风速极值',
extreme_wind_speed_70m decimal(38,10) DEFAULT NULL COMMENT '70m风速极值',
extreme_wind_speed_100m decimal(38,10) DEFAULT NULL COMMENT '100m风速极值', 
areacode string DEFAULT NULL COMMENT '区划编码', 
date string DEFAULT NULL COMMENT '日期（年月）',
point string DEFAULT NULL COMMENT '经纬度点唯一标识' 
) 
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'  
WITH SERDEPROPERTIES ( 
'field.delim'='\t',  
'serialization.format'='\t')  
STORED AS INPUTFORMAT  
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT  
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://nameservice1/xnyy/ext_data/jiutian/HIGH_WIND_RESOURCES_MONTH'
TBLPROPERTIES (  
'transient_lastDdlTime'='1579002171') 

-- high_wind_resources_year
CREATE EXTERNAL  TABLE high_wind_resources_year(  
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',
lon decimal(38,10) DEFAULT NULL COMMENT '经度',
wind_power_density_50m decimal(38,10) DEFAULT NULL COMMENT '50m风功率密度',  
wind_power_density_70m decimal(38,10) DEFAULT NULL COMMENT '70m风功率密度',  
wind_power_density_100m decimal(38,10) DEFAULT NULL COMMENT '100m风功率密度',
average_wind_speed_50m decimal(38,10) DEFAULT NULL COMMENT '50m平均风速',
average_wind_speed_70m decimal(38,10) DEFAULT NULL COMMENT '70m平均风速',
average_wind_speed_100m decimal(38,10) DEFAULT NULL COMMENT '100m平均风速', 
turbulence_intensity_50m decimal(38,10) DEFAULT NULL COMMENT '50m湍流强度', 
turbulence_intensity_70m decimal(38,10) DEFAULT NULL COMMENT '70m湍流强度', 
turbulence_intensity_100m decimal(38,10) DEFAULT NULL COMMENT '100m湍流强度',  
wind_speed_frequency_50m string DEFAULT NULL COMMENT '50m风速频率（json)',
wind_speed_frequency_70m string DEFAULT NULL COMMENT '70m风速频率(json)',
wind_speed_frequency_100m string DEFAULT NULL COMMENT '100m风速频率(json)', 
wind_direction_frequency_50m string DEFAULT NULL COMMENT '50m风向频率(json)',  
wind_direction_frequency_70m string DEFAULT NULL COMMENT '70m风向频率(json)',  
wind_direction_frequency_100m string DEFAULT NULL COMMENT '100m风向频率(json)',
extreme_wind_speed_50m decimal(38,10) DEFAULT NULL COMMENT '50m风速极值',
extreme_wind_speed_70m decimal(38,10) DEFAULT NULL COMMENT '70m风速极值',
extreme_wind_speed_100m decimal(38,10) DEFAULT NULL COMMENT '100m风速极值', 
areacode string DEFAULT NULL COMMENT '区划编码', 
date string DEFAULT NULL COMMENT '日期（年）', 
point string DEFAULT NULL COMMENT '经纬度点唯一标识' 
) 
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'  
WITH SERDEPROPERTIES ( 
'field.delim'='\t',  
'serialization.format'='\t')  
STORED AS INPUTFORMAT  
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT  
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://nameservice1/xnyy/ext_data/jiutian/HIGH_WIND_RESOURCES_YEAR' 
TBLPROPERTIES (  
'transient_lastDdlTime'='1579050704')

-- rad_huabei_30years_avg
CREATE EXTERNAL  TABLE rad_huabei_30years_avg( 
total_rad decimal(38,10) DEFAULT NULL COMMENT '水平总辐射',
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',
lon decimal(38,10) DEFAULT NULL COMMENT '经度',
areacode string DEFAULT NULL COMMENT '省市区划编码'
) 
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/RAD_HUABEI_30YEARS_AVG '  
TBLPROPERTIES (  
'transient_lastDdlTime'='1577511845')

-- rad_wind_huabei_30years_avg_lsosurface
CREATE EXTERNAL  TABLE rad_wind_huabei_30years_avg_lsosurface(
feature string DEFAULT NULL COMMENT '光和风资源特征',  
lsosurface string DEFAULT NULL COMMENT '等值面数据'  
) 
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'  
WITH SERDEPROPERTIES ( 
'field.delim'='\t',  
'serialization.format'='\t')  
STORED AS INPUTFORMAT  
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT  
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://nameservice1/xnyy/ext_data/jiutian/RAD_WIND_HUABEI_30YEARS_AVG_LSOSURFACE'  
TBLPROPERTIES (  
'transient_lastDdlTime'='1577355786')

-- radi_hor_pg
CREATE EXTERNAL  TABLE radi_hor_pg(  
index string DEFAULT NULL,
lat decimal(38,10) DEFAULT NULL,
lon decimal(38,10) DEFAULT NULL,
global_rad decimal(38,10) DEFAULT NULL,  
date string DEFAULT NULL, 
time string DEFAULT NULL  
)
PARTITIONED BY (
partid string)
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/RADI_HOR_PG' 
TBLPROPERTIES ( 
'transient_lastDdlTime'='1577279434')

-- raid_resources_month
CREATE EXTERNAL  TABLE raid_resources_month(
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',
lon decimal(38,10) DEFAULT NULL COMMENT '经度',
total_rad decimal(38,10) DEFAULT NULL COMMENT '总辐照量', 
normal_direct_rad decimal(38,10) DEFAULT NULL COMMENT '法向直射辐射辐照量',
direct_rad decimal(38,10) DEFAULT NULL COMMENT '直接辐射',
scattered_rad decimal(38,10) DEFAULT NULL COMMENT '散射辐射',
areacode string DEFAULT NULL COMMENT '区划编码', 
date string DEFAULT NULL COMMENT '日期(年月）',
point string DEFAULT NULL COMMENT '经纬度唯一标识'  
) 
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'  
WITH SERDEPROPERTIES ( 
'field.delim'='\t',  
'serialization.format'='\t')  
STORED AS INPUTFORMAT  
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT  
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://nameservice1/xnyy/ext_data/jiutian/RAID_RESOURCES_MONTH'  
TBLPROPERTIES (  
'transient_lastDdlTime'='1579050998')

-- raid_resources_year
CREATE EXTERNAL  TABLE raid_resources_year( 
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',
lon decimal(38,10) DEFAULT NULL COMMENT '经度',
total_rad decimal(38,10) DEFAULT NULL COMMENT '总辐照量', 
normal_direct_rad decimal(38,10) DEFAULT NULL COMMENT '法向直射辐射辐照量',
direct_rad decimal(38,10) DEFAULT NULL COMMENT '直接辐射',
scattered_rad decimal(38,10) DEFAULT NULL COMMENT '散射辐射',
solar_stability decimal(38,10) DEFAULT NULL COMMENT '太阳能稳定度',  
areacode string DEFAULT NULL COMMENT '区划编码', 
date string DEFAULT NULL COMMENT '日期(年）', 
point string DEFAULT NULL COMMENT '经纬度唯一标识'  
) 
ROW FORMAT SERDE 
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'  
WITH SERDEPROPERTIES ( 
'field.delim'='\t',  
'serialization.format'='\t')  
STORED AS INPUTFORMAT  
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT  
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
'hdfs://nameservice1/xnyy/ext_data/jiutian/RAID_RESOURCES_YEAR'
TBLPROPERTIES (  
'transient_lastDdlTime'='1579051194') 

-- surf_fcst_hor_pg
CREATE EXTERNAL  TABLE surf_fcst_hor_pg(  
index string DEFAULT NULL COMMENT '序号', 
lat decimal(38,10) DEFAULT NULL COMMENT '电站纬度',  
lon decimal(38,10) DEFAULT NULL COMMENT '电站经度',  
tem decimal(38,10) DEFAULT NULL COMMENT '气温(摄氏度)',  
prs decimal(38,10) DEFAULT NULL COMMENT '气压(百帕)',
rhu decimal(38,10) DEFAULT NULL COMMENT '相对湿度(百分率)',
win_d_avg_2mi decimal(38,10) DEFAULT NULL COMMENT '风向(度360度方位)',
win_s_avg_2mi decimal(38,10) DEFAULT NULL COMMENT '风速(米/秒）', 
pre_1h decimal(38,10) DEFAULT NULL COMMENT '过去1小时累计降雨量（毫米）', 
vis_min decimal(38,10) DEFAULT NULL COMMENT '最小水平能见度（米）', 
clo_cov decimal(38,10) DEFAULT NULL COMMENT '总云量（百分率）',
wep_now string DEFAULT NULL COMMENT '天气现象',
global_rad decimal(38,10) DEFAULT NULL COMMENT '总辐射辐照度（W.m-2）', 
begin_fcst_date string DEFAULT NULL COMMENT '起报日期(年月日)',  
fcst_date string DEFAULT NULL COMMENT '预报日期(年月日时)'  
)  
PARTITIONED BY (  
partid string)  
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/SURF_FCST_HOR_PG' 
TBLPROPERTIES (
'transient_lastDdlTime'='1577283082')

-- surf_hor_pg
CREATE EXTERNAL  TABLE surf_hor_pg(  
index string DEFAULT NULL,
lat decimal(38,10) DEFAULT NULL,
lon decimal(38,10) DEFAULT NULL,
tem decimal(38,10) DEFAULT NULL,
prs decimal(38,10) DEFAULT NULL,
rhu decimal(38,10) DEFAULT NULL,
pre_1h decimal(38,10) DEFAULT NULL,
win_d_avg_2mi decimal(38,10) DEFAULT NULL,  
win_s_avg_2mi decimal(38,10) DEFAULT NULL,  
clo_cov decimal(38,10) DEFAULT NULL,  
vis_min decimal(38,10) DEFAULT NULL,  
wep_now string DEFAULT NULL, 
date string DEFAULT NULL, 
time string DEFAULT NULL  
)
PARTITIONED BY (
partid string)
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/SURF_HOR_PG' 
TBLPROPERTIES ( 
'transient_lastDdlTime'='1577279862')

-- surf_mon_pg
CREATE EXTERNAL  TABLE surf_mon_pg(  
areacode decimal(38,10) DEFAULT NULL, 
thund decimal(38,10) DEFAULT NULL, 
ice decimal(38,10) DEFAULT NULL,
win_s_2mi_avg decimal(38,10) DEFAULT NULL,  
date string DEFAULT NULL  
)
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/SURF_MON_PG' 
TBLPROPERTIES ( 
'transient_lastDdlTime'='1577280170')

-- wind_huabei_30years_avg
CREATE EXTERNAL  TABLE wind_huabei_30years_avg(
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',
lon decimal(38,10) DEFAULT NULL COMMENT '经度',
average_wind_speed_70m decimal(38,10) DEFAULT NULL COMMENT '70m平均风速',
wind_power_density_70m decimal(38,10) DEFAULT NULL COMMENT '80m平均风速',
areacode string DEFAULT NULL COMMENT '省市区划编码'
) 
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
'hdfs://nameservice1/xnyy/ext_data/jiutian/WIND_HUABEI_30YEARS_AVG'  
TBLPROPERTIES (  
'transient_lastDdlTime'='1577511879') 

-- wind_rad_lsosurface
CREATE EXTERNAL  TABLE wind_rad_lsosurface(
date string DEFAULT NULL COMMENT '等值面的时间(年月/年)',  
feature string DEFAULT NULL COMMENT '风光资源特征',  
lsosurface string DEFAULT NULL COMMENT '等值面数据' 
)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES (
'field.delim'='\t', 
'serialization.format'='\t') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat'  
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'  
LOCATION  
'hdfs://nameservice1/xnyy/ext_data/jiutian/WIND_RAD_LSOSURFACE'  
TBLPROPERTIES ( 
'transient_lastDdlTime'='1579051366')

-- wind_resources_month
CREATE EXTERNAL  TABLE wind_resources_month(  
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',  
lon decimal(38,10) DEFAULT NULL COMMENT '经度',  
wind_power_density decimal(38,10) DEFAULT NULL COMMENT '风功率密度',  
average_wind_speed decimal(38,10) DEFAULT NULL COMMENT '平均风速(米/秒)', 
turbulence_intensity decimal(38,10) DEFAULT NULL COMMENT '湍流强度', 
wind_shear_index decimal(38,10) DEFAULT NULL COMMENT '风切变指数', 
wind_speed_frequency string DEFAULT NULL COMMENT '风速频率（json格式）', 
wind_direction_frequency string DEFAULT NULL COMMENT '风向频率（json格式）',
extreme_wind_speed decimal(38,10) DEFAULT NULL COMMENT '风速极值（米/秒）', 
areacode string DEFAULT NULL COMMENT '区划编码',
date string DEFAULT NULL COMMENT '日期（年月）',  
point string DEFAULT NULL COMMENT '经纬度点唯一标识'
)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES (
'field.delim'='\t', 
'serialization.format'='\t') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat'  
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'  
LOCATION  
'hdfs://nameservice1/xnyy/ext_data/jiutian/WIND_RESOURCES_MONTH' 
TBLPROPERTIES ( 
'transient_lastDdlTime'='1578998407')

-- wind_resources_year
CREATE EXTERNAL  TABLE wind_resources_year(
lat decimal(38,10) DEFAULT NULL COMMENT '纬度',  
lon decimal(38,10) DEFAULT NULL COMMENT '经度',  
wind_power_density decimal(38,10) DEFAULT NULL COMMENT '风功率密度',  
average_wind_speed decimal(38,10) DEFAULT NULL COMMENT '平均风速(米/秒)', 
turbulence_intensity decimal(38,10) DEFAULT NULL COMMENT '湍流强度', 
wind_shear_index decimal(38,10) DEFAULT NULL COMMENT '风切变指数', 
wind_speed_frequency string DEFAULT NULL COMMENT '风速频率（json格式）', 
wind_direction_frequency string DEFAULT NULL COMMENT '风向频率（json格式）',
extreme_wind_speed decimal(38,10) DEFAULT NULL COMMENT '风速极值（米/秒）', 
areacode string DEFAULT NULL COMMENT '区划编码',
date string DEFAULT NULL COMMENT '日期（年）',
point string DEFAULT NULL COMMENT '经纬度点唯一标识'
)
ROW FORMAT SERDE
'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES (
'field.delim'='\t', 
'serialization.format'='\t') 
STORED AS INPUTFORMAT 
'org.apache.hadoop.mapred.TextInputFormat'  
OUTPUTFORMAT 
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'  
LOCATION  
'hdfs://nameservice1/xnyy/ext_data/jiutian/WIND_RESOURCES_YEAR'  
TBLPROPERTIES ( 
'transient_lastDdlTime'='1579051689')
