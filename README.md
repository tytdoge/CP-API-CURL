## API Examples

Below are example API calls using **curl** in both Windows CMD and Bash environments.

### Windows CMD Example

```bash
curl -X POST ^
  -H "Authorization: <API Token>" ^
  -H "Content-Type: application/json" ^
  -d "{\"request\":[{\"md5\":\"27b4b0268101fd2836d69ba3c2ada280\",\"file_type\":\"docx\",\"features\":[\"te\",\"extraction\"],\"file_name\":\"Step by step guide using vmkfstools in the CLI.docx\",\"te\":{\"reports\":[\"xml\",\"summary\"]},\"extraction\":{\"method\":\"pdf\"}}]}" ^
  "https://te-api.checkpoint.com/tecloud/api/v1/file/query"
```













# Check Point Threat Prevention API Shell Script

This repository contains a shell script that implements basic operations for interacting with the Check Point Threat Prevention (TE) API. The script supports querying a file, uploading a file for analysis, downloading reports (placeholder), and checking your API quota. The implementation is based on the work of Martin K and has been updated and modified by Bill N.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Script Functions](#script-functions)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Overview

This shell script provides a command-line interface to interact with the Check Point Threat Prevention API. The supported operations are:

- **query:**  
  Generate a JSON request with file details (including SHA1 hash) and send it to the API to check if the file is already analyzed.

- **upload:**  
  Create a multipart form request to upload a file for analysis. The request includes the file along with additional metadata such as MD5, SHA1, SHA256, and file type.

- **download:**  
  A placeholder function for downloading threat analysis reports or data (to be implemented).

- **quota:**  
  Retrieve the API call quota information using the API key for authentication.

The script uses the [jq](https://stedolan.github.io/jq/) tool to build JSON payloads and [curl](https://curl.se/) (or `curl_cli` if available) to issue HTTP requests.

## Prerequisites

Before using this script, make sure you have the following installed and configured on your system:

- **bash or a compatible shell:**  
  The script uses bash-specific constructs. If you need to run it under `/bin/sh`, you might need to modify some features.

- **jq:**  
  JSON processor tool. The script relies on jq for creating and formatting JSON.  
  Installation instructions can be found [here](https://stedolan.github.io/jq/download/).

- **curl or curl_cli:**  
  The script uses either `curl` or `curl_cli` to make HTTP requests. Ensure your API key and the server URL are configured correctly.

- **File hashing utilities:**  
  Tools like `sha1sum`, `md5sum`, and `sha256sum` are used to compute file hashes.

