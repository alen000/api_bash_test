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

    json3=$(echo $json | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    json4=$(echo $json | grep id | sed "s/{.*\"id\":\\([^\]*\).*}/\1/g")
    json5=${json4:0:4}

    echo "..................................."
    echo "Scenario $br"
    echo "Description: Check that user $json2 created and deleted"
    echo "..................................."
    echo "User ID is:" $json5

    echo "Create user"

    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    if [[ "$httpCode" -ne "200" ]];then echo "User not is created"; echo "Test not past";  exit 1; else echo "User is created"; fi

    HTTPS_URL="https://gorest.co.in/public/v2/users/${json5}"
    delete httpCode ## httpcode check
    echo "..................................."
    echo "Delete user"
    echo "Response is: $httpCode - ${code_response[$httpCode]}"

    if [[ "$httpCode" -ne "204" ]];then echo "User is not DELETED"; exit 1; else echo "User is DELETED"; fi
    sleep 1

    HTTPS_URL="https://gorest.co.in/public/v2/users/${json5}"
    json21=$(curl -i -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type:application/json" -XGET  ${HTTPS_URL} -s)
    myfunc httpCode ## httpcode check
    json22=$(echo $json21 | grep name | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json23=$(echo $json21 | grep message | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    echo "..................................."
    echo "Check user"
    echo "Response is: $httpCode - ${code_response[$httpCode]}"

    if [[ "$httpCode" -ne "404" ]];then echo "User is found and it' not OK"; else echo "User is not found as expected"; fi
    if [[ -z "$json22" ]]; then echo "Name input is empty as expected"; fi
    if [[ "$json22" == "$json2" ]];then echo "Result is not as expected"; echo "$json22 should not be listed"; fi
    if [[ "$json23" != "Resource not found" ]];then echo "Resource not found is missing and it' not OK"; else echo "Test  passed"; echo "$tests" > "$destdir"; fi