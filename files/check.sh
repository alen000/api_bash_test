#!/bin/sh
function myfunc()
{
CURL_CMD="curl -w httpcode=%{http_code}"
# -m, --max-time <seconds> FOR curl operation
CURL_MAX_CONNECTION_TIMEOUT="-m 100"

# perform curl operation
CURL_RETURN_CODE=0
CURL_OUTPUT=`${CURL_CMD} ${CURL_MAX_CONNECTION_TIMEOUT} ${HTTPS_URL} 2> /dev/null` || CURL_RETURN_CODE=$?
httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\httpcode=//')
}

