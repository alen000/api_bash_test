#!/bin/sh
function myfunc()
{
httpCode=$(curl -i -o /dev/null -w "%{http_code}" -H "Accept:application/json" -H "Content-Type:application/json" -H "Authorization: Bearer $TOKEN" -XGET  $HTTPS_URL -L -s)
}

function delete()
{
httpCode=$(curl -i -o /dev/null -w "%{http_code}" -H "Accept:application/json" -H "Authorization: Bearer $TOKEN" -H "Content-Type:application/json" -XDELETE  $HTTPS_URL -s)
}





