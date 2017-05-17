#!/bin/bash
#sex -x
ONLINEUSER=""
ONLINEPWD=""
TESTUSER=""
TESTPWD=""
TODAY=$(date +%Y%m%d_%H%M%S)
ThreeDaysAgo=`date -d "-3 days" +%Y%m%d_`"*"
DelTestFileName="/opt/mysqlbak/atr/atr_test_bak_ATRTest_${ThreeDaysAgo}.sql"
DelOnlineFileName="/opt/mysqlbak/atr/online_atr_bak_${ThreeDaysAgo}.sql"
#echo $TODAY
#echo $DelTestFileName
#echo $DelOnlineFileName

# 1 bak up the test DB

#/opt/mysql-5.5/bin/mysqldump  AccurateTargetRecommend -u$TESTUSER -p$TESTPWD -h 10.100.23.36 -P3307 <<EOF 2> /home/yangzhizhong/mysqllog/$TODAY.txt 1>/opt/mysqlbak/atr/atr_test_bak_AccurateTargetRecommend_$TODAY.sql
#  --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_online --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_offline --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_online_20150828_bak --ignore-table=AccurateTargetRecommend.atr_stats_dementions_offline  --ignore-table=AccurateTargetRecommend.atr_stats_planitem_offline --ignore-table=AccurateTargetRecommend.atr_stats_planitem_detail --ignore-table=AccurateTargetRecommend.atr_stats_planitem_offline_detail --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_offline_detail --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_online_tmp --ignore-table=AccurateTargetRecommend.atr_stats_cps_offline;
#EOF

# 1.1 delete view's definer line replace DEFINER=* as *
# as \* 
#/bin/sed -i 's/DEFINER=[^*]*\*/\*/g' /opt/mysqlbak/atr/atr_test_bak_AccurateTargetRecommend_$TODAY.sql

# 2

/opt/mysql-5.5/bin/mysqldump  AccurateTargetRecommend -u$ONLINEUSER -p$ONLINEPWD -h 10.103.23.161 -P3307 <<EOF 2> /home/yangzhizhong/mysqllog/$TODAY.txt 1>/opt/mysqlbak/atr/online_atr_bak_$TODAY.sql  --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_online --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_offline  --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_online_20150828_bak --ignore-table=AccurateTargetRecommend.atr_stats_dementions_offline  --ignore-table=AccurateTargetRecommend.atr_stats_planitem_offline --ignore-table=AccurateTargetRecommend.atr_stats_planitem_detail --ignore-table=AccurateTargetRecommend.atr_stats_planitem_offline_detail --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_offline_detail --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_online_tmp --ignore-table=AccurateTargetRecommend.atr_stats_cps_offline --ignore-table=AccurateTargetRecommend.atr_stats_recplanitem_online_20160314_bak;
EOF

#2.1
/bin/sed -i 's/DEFINER=[^*]*\*/\*/g' /opt/mysqlbak/atr/online_atr_bak_$TODAY.sql
# 3
/opt/mysql-5.5/bin/mysql -u$TESTUSER -h 10.100.23.36 -P3307 -p$TESTPWD ATRTest < /opt/mysqlbak/atr/online_atr_bak_$TODAY.sql


# 4 delete three days ago *.sql file
/bin/rm -f $DelTestFileName
/bin/rm -f $DelOnlineFileName
