<!-- export NODE_OPTIONS=--openssl-legacy-provider -->

<div id="top"></div>

# CartoDB tables backup scripts
_scripts used to backup tables stored in cartodb (Based on [Carto SQL API v2 /copyto](https://carto.com/developers/sql-api/guides/copy-queries/#copy-to)  example)_


<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#prerequisites">Prerequisites</a>
    </li>
    <li>
      <a href="#usage">Usage</a>
      <ul><a href="#list">List tables</a></ul>
      <ul><a href="#backup">Backup table</a></ul>
      <ul><a href="#all">Backup all</a></ul>
    </li>
    <li><a href="#authors">Authors</a></li>
  </ol>
</details>  

<div id="prerequisites"></div>

# Prerequisites 📋
* Carto account with privileges (username and master api-key)
* AWS S3 write permissions to opi-trupper/backups/carto/

<p align="right">(<a href="#top">back to top</a>)</p>
<div id="usage"></div>

# Usage
<div id="list"></div>

## List tables
Generates a tables.txt file with names of all _base tables_ (views ignored) found in CartoDB

```sh
bash list-tables.sh [carto-username] [carto-api-key]
```
<div id="backup"></div>

## Backup table
Downloads the table as CSV, compress the file, and uploaded to S3

```sh
bash download-table.sh [table_name] [carto-username] [carto-api-key]
```
<div id="all"></div>

## Backup all
Downloads all tables and uploads them to s3

```sh
bash download-all.sh [carto-username] [carto-api-key]
```
When you run this script, 3 files will be created:
* status.txt _logs of the backup process
* correct-downloads.txt _list of tables succeed to upload_
* fail-downloads.txt _list of tables that fail_

<p align="right">(<a href="#top">back to top</a>)</p>
<div id="authors"></div>

# Authors ✒️

_List of developers involved_
* **Diego Miranda (Gotiko)** - [DiegoMirandaO](https://github.com/DiegoMirandaO)

<p align="right">(<a href="#top">back to top</a>)</p>
<div id="license"></div>

---
⌨️ with ❤️ by [DiegoMirandaO](https://github.com/DiegoMirandaO) 🤪
