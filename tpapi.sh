#!/bin/bash
# Check Point Threat Prevention API implementation in shell
# Based on the work of Martin K
# Updated by Bill N

# Uses jq from /opt/CPshrd-R80.30/bin/jq (make sure jq is in your PATH)

ARG_1=$2

# Define API server
# TE cloud API server is located on te.checkpoint.com, 127.0.0.1:18194 is the local one
TESERVER=
TEAPIKEY=""

query() {
  echo "QUERY"
  [[ -z "$ARG_1" ]] && { echo "No file specified, exiting"; exit 1; }
  [ ! -f "$ARG_1" ] && { echo "$ARG_1 is not a file, exiting"; exit 1; }

  # File to investigate
  TEFILE="$ARG_1"
  filename=$(basename "$TEFILE")
  extension="${filename##*.}"

  echo "Filename: ${filename}"
  echo "Extension: $extension"

  # Calculate hash for TEFILE
  TESHA1=$(sha1sum "$TEFILE" | cut -f1 -d" ")
  echo "file: ${TEFILE} sha1: ${TESHA1}"

  # Build request body
  TEQ=$(jq -c -n --arg sha1 "$TESHA1" --arg filename "$filename" --arg extension "$extension" \
    '{request: [{sha1: $sha1, file_type: $extension, file_name: $filename, features: ["te"], te: {reports: ["pdf","xml", "tar", "full_report"]}}]}')

  # Display the request body formatted via jq
  echo "$TEQ" | jq .

  # Place API request based on the previously constructed body TEQ
  TEQRESP=$(curl -d "$TEQ" -k -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" "https://$TESERVER/tecloud/api/v1/file/query")
  
  # Display response formatted by jq, with error check
  if echo "$TEQRESP" | jq . >/dev/null 2>&1; then
      echo "$TEQRESP" | jq .
  else
      echo "Response is not valid JSON:"
      echo "$TEQRESP"
  fi
}

upload() {
  echo "UPLOAD"
  [[ -z "$ARG_1" ]] && { echo "No file specified, exiting"; exit 1; }
  [ ! -f "$ARG_1" ] && { echo "$ARG_1 is not a file, exiting"; exit 1; }

  # File to upload
  TEFILE="$ARG_1"
  filename=$(basename "$TEFILE")
  extension="${filename##*.}"

  echo "Filename: ${filename}"
  echo "Extension: $extension"

  # Calculate hash for TEFILE
  TESHA1=$(sha1sum "$TEFILE" | cut -f1 -d" ")
  echo "file: ${TEFILE} sha1: ${TESHA1}"

  # Build the upload request body (same as query)
  TEQ=$(jq -c -n --arg sha1 "$TESHA1" --arg filename "$filename" --arg extension "$extension" \
    '{request: [{sha1: $sha1, file_type: $extension, file_name: $filename, features: ["te"], te: {reports: ["pdf","xml", "tar", "full_report"]}}]}')
  
  # Display JSON request for debugging if needed
  echo "JSON Request: $TEQ"
  
  # Perform multipart request with both the API request body and the file
  TEURESP=$(curl -F "request=$TEQ" -F "file=@$TEFILE" -k -s  -H "Authorization: $TEAPIKEY" "https://$TESERVER/tecloud/api/v1/file/upload")
  
  # Format response with jq, with error checking
  if echo "$TEURESP" | jq . >/dev/null 2>&1; then
      echo "$TEURESP" | jq .
  else
      echo "Response is not valid JSON:"
      echo "$TEURESP"
  fi
}

download() {
  echo "DOWNLOAD"
  # Implement download logic as needed
}

quota() {
  echo "QUOTA"
  [[ -z "$TEAPIKEY" ]] && { echo "Empty TEAPIKEY, probably using local TE, exiting"; exit 1; }
  
  TEQRESP=$(curl -k -s -H "Content-type: application/json" -H "Authorization: $TEAPIKEY" "https://$TESERVER/tecloud/api/v1/file/quota")
  
  # Display response formatted by jq, with error checking
  if echo "$TEQRESP" | jq . >/dev/null 2>&1; then
      echo "$TEQRESP" | jq .
  else
      echo "Response is not valid JSON:"
      echo "$TEQRESP"
  fi
}

display_help() {
    echo "Usage: $0 {query|upload|download|quota}" >&2
    echo
    exit 1
}

case "$1" in
  query)
    query
    ;;
  upload)
    upload
    ;;
  download)
    download
    ;;
  quota)
    quota
    ;;
  *)
    display_help
    exit 1
    ;;
esac


