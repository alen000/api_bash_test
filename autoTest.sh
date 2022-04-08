#!/bin/sh
HTTPS_URL="https://gorest.co.in/public/v2/users"
CURL_CMD="curl -w httpcode=%{http_code}"
log_file="logs/test_result.log"
source ./files/codes.sh
# -m, --max-time <seconds> FOR curl operation
CURL_MAX_CONNECTION_TIMEOUT="-m 100"

# perform curl operation
CURL_RETURN_CODE=0
CURL_OUTPUT=`${CURL_CMD} ${CURL_MAX_CONNECTION_TIMEOUT} ${HTTPS_URL} 2> /dev/null` || CURL_RETURN_CODE=$?
httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\httpcode=//')


if [ ${CURL_RETURN_CODE} -ne 0 ]; then  
    echo "Curl connection failed with return code - ${CURL_RETURN_CODE}"
    
else
    echo "Curl connection is success with ${httpCode} - ${code_response[$httpCode]}"
    cd scenarios
    t=$(ls 2>/dev/null -Ubad1 -- scenario* | wc -l)
    echo "number_of_tests= " $t
    cd -

    declare -i i=1;
    declare -i zero=0;
    while [ $i -le $t ]
    do
       sh ./scenarios/scenario$i.sh
       i=i+1
    done

    echo "-----------------------------------------------------" | tee -a "$log_file"
    echo "                   Test report                       " | tee -a "$log_file"
    echo "-----------------------------------------------------" | tee -a "$log_file"
    echo $(date '+%Y-%m-%d %H:%M:%S')                            | tee -a "$log_file"
    echo "-----------------------------------------------------" | tee -a "$log_file"
    
       a=$(ls 2>/dev/null -Ubad1 -- testC* | wc -l)
       if [ $a -eq $zero ]; then
          echo "All test cases not past, sorry"                  | tee -a "$log_file"
       else
       echo "Listed past test cases"                             | tee -a "$log_file"
          ls testC* | sed -e 's/\.txt$//'                        | tee -a "$log_file"
       fi
    echo "-----------------------------------------------------" | tee -a "$log_file"
    a=$(ls 2>/dev/null -Ubad1 -- testC* | wc -l)
    echo "Statistics :" $a "/" $t "."                            | tee -a "$log_file"
    echo "-----------------------------------------------------" | tee -a "$log_file"
    find . -maxdepth 1 -name 'testC*.txt' -delete
    ## user can receive email with message
    ## if ["$a" -eq "$t"]; then 
    ##     sendmail -s "Test past succsessfuly" "blazevicalen@gmail.com";
    ## else 
    ##    sendmail -s "Test not past succsessfuly" "blazevicalen@gmail.com";
    ## fi

    # Check http code for curl operation/response in  CURL_OUTPUT
    httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\httpcode=//')
    if [ ${httpCode} -ne 200 ]; then
        echo "Curl operation/command failed due to server return code - ${httpCode} - ${code_response[$httpCode]}"
    fi
fi