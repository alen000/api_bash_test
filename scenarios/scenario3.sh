    #!/bin/bash
    HTTPS_URL="https://gorest.co.in/public/v2/users"
    declare -i br=3;
    k=0;
    json2="Test90"
    destdir=./testCase$br.txt

    source ./files/constants.sh
    source ./files/codes.sh
    source ./files/check.sh

    json=$(curl -X POST ${HTTPS_URL} -H "Accept: application/json" \
          -H "Authorization: Bearer $TOKEN" \
          -H "Content-Type: application/json"  \
          -d '{"name":"Test90", "gender":"male", "email":"Test90@yopmail.com", "status":"active"}' -s)
    json3=$(echo $json | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    json4=$(echo $json | grep id | sed "s/{.*\"id\":\\([^\]*\).*}/\1/g")
    json5=${json4:0:4}
    echo "..................................."
    echo "Scenario $br"
    echo "Description: Check that user $json2 exists"
    echo "..................................."
    echo "User ID is:" $json5

    myfunc httpCode ## httpcode check
    echo ""

    echo "Response is: $httpCode - ${code_response[$httpCode]}"
    if [[ "$httpCode" -ne "200" ]];then echo "Resource is not found"; echo "Test not past";  exit 1; else echo "Resource is found"; fi

    HTTPS_URL_NEW="https://gorest.co.in/public/v2/users/${json5}"
    json10=$(curl -i -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type:application/json" -XDELETE  $HTTPS_URL_NEW -s)
    myfunc httpCode  ## httpcode check
    echo ""
    echo "..................................."
    echo "Response is: $httpCode - ${code_response[$httpCode]}"

    if [[ "$httpCode" -ne "200" ]];then echo "Source is not DELETED"; exit 1; fi


    HTTPS_URL_NEW="https://gorest.co.in/public/v2/users/${json5}"
    json21=$(curl -i -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type:application/json" -XGET  $HTTPS_URL_NEW -s)
    json22=$(echo $json21 | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json23=$(echo $json21 | sed -e 's/^.*"message":"\([^"]*\)".*$/\1/')
    myfunc httpCode  ## httpcode check
    echo ""
    echo "..................................."
    echo "Response is: $httpCode - ${code_response[$httpCode]}"

    if [[ "$httpCode" -ne "200" ]];then echo "Resource is not found"; echo "Test not past"; exit 1; fi
    if [ -n "$json22" ]; then echo ""; else echo "Input is empty"; echo "Test not past"; exit 1; fi
    if [ "$json22" = "$json2" ];then echo "Result is not as expected"; echo "$json22 should not be listed"; exit 1; 
    else echo "Result is as expected"; echo "Test  past"; echo "$tests" > "$destdir"; fi