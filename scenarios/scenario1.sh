    #!/bin/bash
    ##
    ##  Author: Alen Blazevic
    ##  Check that user not exist
    ##
    ##
    HTTPS_URL="https://gorest.co.in/public/v2/users/3342"
    declare -i br=1;
    destdir=./testCase$br.txt

    source ./files/constants.sh
    source ./files/codes.sh
    source ./files/check.sh

    json=$(curl -i -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type:application/json" -XGET $HTTPS_URL -s)
    myfunc httpCode ## httpcode check
    json1=$(echo $json | grep name | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json3=$(echo $json | grep message | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')

    json2="Dhruv Pothuvaal JD"
    myfunc httpCode
    echo ""
    echo "..................................."
    echo "Scenario $br"
    echo "Description: Check that user with id 3342 do not exists"
    echo "..................................."
    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    
    if [[ -z "$httpCode" ]]; then echo "Http code is empty ...NOK"; echo "Test not passed"; exit 1;else ((k=k+1)); echo "Http code is not empty ...OK"; fi
    if [ -z "$json1" ]; then echo "Name is empty ... OK";  ((k=k+1)); else echo "Name exists ... NOK"; fi
    if [ -z "$json3" ]; then echo "Response -Not found - is empty ... NOK"; else  ((k=k+1)); echo "Response  -Not found - exists ... OK"; fi
    if [[ "$httpCode" -ne "404" && "$json3" -ne "Resource not found" ]];then echo "User is found ... NOK"; else ((k=k+1));echo "404 is received and user is not found ... OK";fi
    if [[ "$k" == "4" ]];then echo "Test passed"; echo "$tests" > "$destdir"; else echo "Test not passed"; fi

