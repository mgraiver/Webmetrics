#!/bin/bash 

FILE=$1
FILEPATH=$(find ~ -name $FILE)
if [[ $# ==  0 ]];
then 
	echo "Error: No log file given."
	echo "./webmetrics.sh <logfile>"
	exit 1
fi

if [[ ! -e  $FILEPATH ]];
then 
	echo "Error: File 'this_file_does_not_exist' does not exist."
        echo "Usage: ./webmetrics.sh <logfile>"
	exit 2
fi

#PART 1, NO. REQUESTS PER WEB BROWSER
Safari_count=$(grep -wc "Safari" $FILEPATH )
Firefox_count=$(grep -wc "Firefox" $FILEPATH)
Chrome_count=$(grep -wc "Chrome" $FILEPATH)

echo "Number of requests per web browser"
echo "Safari,$Safari_count "
echo "Firefox,$Firefox_count"
echo "Chrome,$Chrome_count "

#PART 2, NO. DISTINCT USERS P/DAY
echo " "
echo "Number of distinct users per day"
for day in $(awk '{ print substr ( $4,2,11 ) }'< $FILEPATH | sort -u)
do
	usersperday=$(grep $day $FILEPATH | sort -t ' ' -k 1,1 -u | wc -l)
	echo "$day,$usersperday "

	done

#PART 3, TOP 20 POPULAR REQUESTS
echo " "
echo "Top 20 popular product requests"
grep 'GET /product/' $FILEPATH | awk 'BEGIN { FS="/" }
{for (i=1;i<+5;i++)
	if($i =="product" && $(i+1) ~ /^[0-9]*$/) print $(i+1)}' | sort | uniq -c | sort -nr | head -n20 | awk '{ print ($2 "," $1) }'
exit 0
