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
    json1=$(echo $json | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json3=$(echo $json | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')

    json2="Dhruv Pothuvaal JD"
    myfunc httpCode
    echo ""
    echo "..................................."
    echo "Scenario $br"
    echo "Description: Check that user with id 3342 do not exists"
    echo "..................................."
    echo "Response is: $httpCode - ${code_response[$httpCode]}"

    if [[ "$httpCode" -ne "404" && "$json3" -ne "Resource not found" ]];then echo "Resource is found, not OK"; else echo "$tests" > "$destdir"; echo "404 is received"; fi
    if [ -n "$json1" ]; then echo ""; else echo "Input is empty"; echo "Test not passed"; exit 1; fi
    if [ "$json1" = "$json2" ];then echo "Result is not as expected"; echo "$json2 should not be listed"; echo "Test not passed"; exit 1; 
    else echo "Result is not as expected"; echo "$json1 should not be listed"; echo "Test not passed"; exit 1; fi
