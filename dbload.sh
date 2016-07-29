echo "多表导入"

echo "连接源数据库"
echo "源数据ip地址"
read Connected_ip
echo "用户名"
read DB_user
echo "密码"
read DB_user


IMPORTDIR=$PWD/IMPORTDIR
#导入数据库文件目录
if [ -d $IMPORTDIR ]
then
		echo "the directry IMPORTDIR is exist!"
    rm -r $IMPORTDIR/*
else
	  mkdir -p $IMPORTDIR
fi 

mkdir $IMPORTDIR/log

echo "连接源数据库"

Ctrpath=$PWD
echo $Ctrpath

echo "开始导入数据"   `date "+%Y-%m-%d %H:%M:%S"` >> $Ctrpath/j_out.log
echo "开始导入数据"   `date "+%Y-%m-%d %H:%M:%S"`
for tname in $(<./shandong.unl)
do
echo $tname
echo "select ncols num from systables where tabname='$tname'"|dbaccess $prpdb > $Ctrpath/list.txt
num=`awk 'NR==5{print $0}' $Ctrpath/list.txt`

echo "file /home/picclk/LQH/$tname.unl delimiter '|' $num; 
insert into $tname;
">>j_$tname.ctl
echo "start '$tname': "`date "+%Y-%m-%d %H:%M:%S"` >> $Ctrpath/j_out.log
dbload -d $prpdb -c j_$tname.ctl -n 10000 -l j_$tname.err -e 10000000 >$Ctrpath/j_out.log &
echo "finish '$tname': "`date "+%Y-%m-%d %H:%M:%S"` >> $Ctrpath/j_out.log
done
echo "开始导入数据"   `date "+%Y-%m-%d %H:%M:%S"`
echo "数据导入完成"   `date "+%Y-%m-%d %H:%M:%S"`>> $Ctrpath/j_out.log