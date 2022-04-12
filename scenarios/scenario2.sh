    #!/bin/bash
    ##
    ##  Author: Alen Blazevic
    ##  Create user and check that user created correct
    ##
    ##
    HTTPS_URL="https://gorest.co.in/public/v2/users"
    declare -i br=2;
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
    json3=$(echo $json | grep message | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    json4=$(echo $json | grep id | sed "s/{.*\"id\":\\([^\]*\).*}/\1/g")
    json5=${json4:0:4}
    echo "..................................."
    echo "Scenario $br"
    echo "Description: Check that user $json2 exists"
    echo "..................................."
    echo "User ID is:" $json5
    myfunc httpCode ## httpcode check
    echo "Create user"

    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    if [[ "$httpCode" -ne "200" ]];then echo "User is not created... NOK";  else echo "User is created ... OK"; ((k=k+1)); fi
    if [[ "$k" -lt "1" ]];then echo "Test not passed"; exit 1; fi
    echo ".........."
    HTTPS_URL="https://gorest.co.in/public/v2/users/${json5}"
    json10=$(curl -i -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -XGET  $HTTPS_URL -L -s)

    json11=$(echo $json10 | grep name | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json13=$(echo $json10 | grep message | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    myfunc httpCode ## httpcode check
    echo "Check that user exist"

    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    if [ -z "$httpCode" ]; then echo "Http code is empty ...NOK"; echo "Test not passed"; exit 1;else ((k=k+1)); echo "Http code is not empty ...OK"; fi
    if [ -z "$json11" ]; then echo "Name is empty ... NOK"; else  ((k=k+1)); echo "User name is not empty ... OK"; fi
    if [ -z "$json13" ]; then echo "Response - Not found - is empty ... OK";  ((k=k+1)); else echo "Response - Not found - is not empty ... NOK"; fi
    if [[ "$httpCode" -ne "200" ]];then echo "User do not exists ... NOK"; else  ((k=k+1)); echo "User exists ... OK"; fi
    if [[ "$json11" == "$json2" ]];then echo "$json11 is listed.... OK";  ((k=k+1)); else echo "$json2 do not exist ... NOK"; fi
    if [[ "$k" == "6" ]];then echo "Test passed"; echo "$tests" > "$destdir"; else echo "Test not passed"; fi
