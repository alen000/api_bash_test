    #!/bin/bash
    declare -i br=8;
    destdir=./testCase$br.txt
    k=0;
    json=$(curl -i -H "Accept:application/json" -H "Content-Type:application/json" -XGET "https://gorest.co.in/public/v2/users" -s)
    json1=$(echo $json | sed -e 's/^.*"name":"\([^"]*\)".*$/\1/')
    json2="Dhruv Pothuvaal JD"
    echo ""
    echo "..................................."
    echo "Scenario $br"
    echo "Description: Check that user $json2 exists "
    echo "..................................."
 

    if [[ "$json1" == *"message"* ]];then echo "Resource is not found"; echo "Test not past"; exit 1; fi
    if [ -n "$json1" ]; then echo ""; else echo "Input is empty"; echo "Test not past"; exit 1; fi
    if [ "$json1" = "$json2" ];then echo "Test past"; ((tests= tests+1)); echo "$tests" > "$destdir"; else echo "Data do not match"; echo "Test not past"; exit 1; fi