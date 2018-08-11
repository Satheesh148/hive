add /root/jar hive-hcatalog-core-0.13.0.jar;

--user and following are reserved words \\ use backticks `columnName`  ex:calling select `user`.id from tableName

--Creating temporary table for twitter json

create external table tmp_tweet(created_at String,id String,id_str String,text String,source String,truncated String,in_reply_to_status_id String,in_reply_to_status_id_str String,in_reply_to_user_id String,	in_reply_to_user_id_str String,	in_reply_to_screen_name String,`user` Struct<id:String,id_str:String,name:String,screen_name:String,location:String,url:String,description:String,translator_type:String,protected:String,verified:String,followers_count:String,friends_count:String,listed_count:String,favourites_count:String,statuses_count:String,created_at:String,utc_offset:String,	time_zone:String,geo_enabled:String,lang:String,contributors_enabled:String,is_translator:String,profile_background_color:String,profile_background_image_url:String,profile_background_image_url_https:String,profile_background_tile:String,profile_link_color:String,profile_sidebar_border_color:String,profile_sidebar_fill_color:String,profile_text_color:String,profile_use_background_image:String,profile_image_url:String,profile_image_url_https:String,profile_banner_url:String,default_profile:String,default_profile_image:String,`following`:String,follow_request_sent:String,notifications:String>,geo String,coordinates String,place String,contributors String,is_quote_status String,quote_count String,	reply_count String,	retweet_count String,favorite_count String,entities Struct<hashtags:Array<String>,urls:Array<Struct<url:String,expanded_url:String,display_url:String,indices:Array<String>>>,user_mentions:Array<Struct<screen_name:String,name:String,id:String,id_str:String,indices:Array<String>>>,symbols:Array<String>>,favorited String,retweeted String,possibly_sensitive String,filter_level String,lang String,timestamp_ms String) ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' STORED AS TEXTFILE LOCATION '/user/satz/tmp_tweet'; 


Load data local inpath '/root/twitter.json' into table tmp_tweet;

--Creating Control table for twitter json

create external table ctrl_tweet(topic_name String,start_timestamp timestamp,end_timestamp timestamp)Row format delimited fields terminated by ',' Stored as textfile location '/user/satz/ctrl_tweet';

--watermark
insert into table ctrl_tweet values('SaturdayMotivation','2018-08-11 02:12:27',null); 

--Creating target table for twitter json

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=1000;

create external table tgt_tweet(created_at timestamp,id bigint,id_str bigint,text String,source String,`user` Struct<id:bigint,id_str:bigint,name:String,screen_name:String,location:String,url:String,description:String,translator_type:String,protected:boolean,verified:boolean,followers_count:int,friends_count:int,listed_count:int,favourites_count:int,statuses_count:int,created_at:timestamp,utc_offset:String,time_zone:String,geo_enabled:boolean,lang:char(10),contributors_enabled:boolean,is_translator:boolean,`following`:String,follow_request_sent:String,notifications:String>,quote_count int,reply_count int,	retweet_count int,favorite_count int,favorited boolean,retweeted boolean,possibly_sensitive String,filter_level String,lang char(10),timestamp_ms bigint)ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/satz/tgt_tweet'; 


--insert data
insert into table tgt_tweet select created_at,id,id_str,text,source,`user`.id,`user`.id_str,`user`.name,`user`.screen_name,`user`.location,`user`.url,`user`.description,`user`.translator_type,`user`.protected,`user`.verified,`user`.followers_count,`user`.friends_count,`user`.listed_count,`user`.favourites_count,`user`.statuses_count,`user`.created_at,`user`.utc_offset,`user`.time_zone,`user`.geo_enabled,lang,`user`.contributors_enabled,`user`.is_translator,`user`.`following`,`user`.follow_request_sent,`user`.notifications,quote_count,reply_count,retweet_count,favorite_count,favorited,retweeted,possibly_sensitive,filter_level,lang,timestamp_ms from tmp_tweet;



create external table tgt_tweet(created_at timestamp,id bigint,id_str bigint,text String,source String,user_id  bigint,user_id_str  bigint,name  String,screen_name  String,location  String,url  String,description  String,translator_type  String,protected  boolean,verified  boolean,followers_count  int,friends_count  int,listed_count  int,favourites_count  int,statuses_count  int,created_at  timestamp,utc_offset  String,time_zone  String,geo_enabled  boolean,language  char(10),contributors_enabled  boolean,is_translator  boolean,`following`  String,follow_request_sent  String,notifications  String,quote_count int,reply_count int,	retweet_count int,favorite_count int,favorited boolean,retweeted boolean,possibly_sensitive String,filter_level String,lang char(10),timestamp_ms bigint)ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION '/user/satz/tgt_tweet'; 

