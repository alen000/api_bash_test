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
    json3=$(echo $json | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
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
    if [[ "$httpCode" -ne "200" ]];then echo "User is not created"; echo "Test not past";  exit 1; else echo "User is created"; fi
    echo ".........."
    HTTPS_URL="https://gorest.co.in/public/v2/users/${json5}"
    json10=$(curl -i -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -XGET  $HTTPS_URL -L -s)

    json11=$(echo $json10 | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json13=$(echo $json10 | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    myfunc httpCode ## httpcode check
    echo "Check that user exist"

    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    if [[ "$httpCode" -ne "200" ]];then echo "User do not exist"; echo "Test is not OK"; else echo "User exist"; fi
    if [ -n "$json11" ]; then echo "Input is empty"; echo "Test not passed"; exit 1; fi
    if [[ "$json11" == "$json2" && -n "$json13" ]];then echo "$json11 is listed"; echo "Test passed"; echo "$tests" > "$destdir"; 
    else echo "User do not exist"; echo "Test not passed"; exit 1; fi
