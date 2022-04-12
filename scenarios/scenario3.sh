    #!/bin/bash
    ##
    ##  Author: Alen Blazevic
    ##  Create user and delete user
    ##
    ##
    HTTPS_URL="https://gorest.co.in/public/v2/users"
    declare -i br=3;
    k=0;
    json2="Test"$(date '+%M%S')
    destdir=./testCase$br.txt

    source ./files/constants.sh
    source ./files/codes.sh
    source ./files/check.sh

    json=$(curl -X POST ${HTTPS_URL} -H "Accept: application/json" \
          -H "Authorization: Bearer $TOKEN" \
          -H "Content-Type: application/json"  \
          -d '{"name":"'$json2'", "gender":"male", "email":"'$json2'@yopmail.com", "status":"active"}' -s)

    myfunc httpCode ## httpcode check

    json4=$(echo $json | grep id | sed "s/{.*\"id\":\\([^\]*\).*}/\1/g")
    json5=${json4:0:4}

    echo "..................................."
    echo "Scenario $br"
    echo "Description: Check that user $json2 created and deleted"
    echo "..................................."
    echo "User ID is:" $json5

    echo "Create user"

    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    if [[ "$httpCode" -ne "200" ]];then echo "User not is created ... NOK"; else ((k=k+1)); echo "User is created ... OK"; fi
    if [[ "$k" -lt "1" ]];then echo "Test not passed"; exit 1; fi

    HTTPS_URL="https://gorest.co.in/public/v2/users/${json5}"
    delete httpCode ## httpcode check
    echo "..................................."
    echo "Delete user"
    echo "Response is: $httpCode - ${code_response[$httpCode]}"

    if [[ "$httpCode" -ne "204" ]];then echo "User is not DELETED ... NOK"; else ((k=k+1)); echo "User is DELETED ... OK"; fi
    if [[ "$k" -lt "2" ]];then echo "Test not passed"; exit 1; fi
    sleep 1

    HTTPS_URL="https://gorest.co.in/public/v2/users/${json5}"
    json21=$(curl -i -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type:application/json" -XGET  ${HTTPS_URL} -s)
    myfunc httpCode ## httpcode check
    json22=$(echo $json21 | grep name | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json23=$(echo $json21 | grep message | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    echo "..................................."
    echo "Check user"
    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    
    if [[ -z "$httpCode" ]]; then echo "Http code is empty ...NOK"; echo "Test not passed"; exit 1;else ((k=k+1)); echo "Http code is not empty ...OK"; fi
    if [[ -z "$json22" ]]; then echo "Name input is empty ... OK"; ((k=k+1));else echo "Name input is not empty ... NOK";fi
    if [[ -z "$json23" ]]; then echo "Response 'Not found' is empty ... NOK"; else ((k=k+1)); echo "Response 'Not found' is not empty ... OK"; fi
    if [[ "$httpCode" -ne "404" ]];then echo "User is found and ... NOK"; else ((k=k+1)); echo "User is not found ... OK"; fi
    if [[ "$json22" = "$json2" ]];then echo "$json22 should not be listed ... NOK"; else ((k=k+1)); echo "$json2 is not listed ... OK"; fi
    if [[ "$json23" != "Resource not found" ]];then echo "Response -Resource not found - is missing ... NOK"; else ((k=k+1)); echo "Response -Resource not found - exists ... OK"; fi
    if [[ "$k" == "8" ]];then echo "Test passed"; echo "$tests" > "$destdir"; else echo "Test not passed"; fi