echo "�����"

echo "����Դ���ݿ�"
echo "Դ����ip��ַ"
read Connected_ip
echo "�û���"
read DB_user
echo "����"
read DB_user


IMPORTDIR=$PWD/IMPORTDIR
#�������ݿ��ļ�Ŀ¼
if [ -d $IMPORTDIR ]
then
		echo "the directry IMPORTDIR is exist!"
    rm -r $IMPORTDIR/*
else
	  mkdir -p $IMPORTDIR
fi 

mkdir $IMPORTDIR/log

echo "����Դ���ݿ�"

Ctrpath=$PWD
echo $Ctrpath

echo "��ʼ��������"   `date "+%Y-%m-%d %H:%M:%S"` >> $Ctrpath/j_out.log
echo "��ʼ��������"   `date "+%Y-%m-%d %H:%M:%S"`
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
echo "��ʼ��������"   `date "+%Y-%m-%d %H:%M:%S"`
echo "���ݵ������"   `date "+%Y-%m-%d %H:%M:%S"`>> $Ctrpath/j_out.log