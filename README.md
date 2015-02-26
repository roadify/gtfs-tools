# GTFS Command-Line Tools

This suite consists of the following tools for use in consuming GTFS feeds:

 * `gtfs-init`: Initializes a new GTFS feed configuration.
 * `gtfs-update`: Downloads a GTFS feed, extracts it, then imports it into a local SQLite database.

The `gtfs-update` tool is broken down into three components which may be run individually:

 * `gtfs-download`: Downloads a GTFS feed from its URL, or from an alternate URL or file, if given.
 * `gtfs-extract`: Extracts a downloaded GTFS feed.
 * `gtfs-process`: Processes the extracted files from a GTFS feed, saving them into the feed's database.

## Examples

Initializing a GTFS feed:

    $ gtfs-init --name ACME --url http://www.acme.com/gtfs/google_transit.zip

After a GTFS feed has been initialized, it can be updated by running the following command:

    $ gtfs-update --name ACME

The `gtfs-update` tool can also be used to update a feed from a file:

    $ gtfs-update --name ACME --file /path/to/acme/google_transit.zip

You can pass a URL to `gtfs-update` as well:

    $ gtfs-update --name ACME --url http://alternate.acme.com/gtfs/google_transit.zip

## Workspace Layout

These tools, when run, will create the following directory structure within the directory in which the tool is run:

 * `{database_name}/`: This directory holds all data relevant to the named database.
    * `files/`: This directory holds the downloaded GTFS feed and its extracted raw files.
       * `downloading/`: This directory holds GTFS files that are in the process of downloading.
         * `{timestamp}.zip`: The file being downloaded.
       * `downloaded/`: This directory holds GTFS files that have finished downloading, as well as the timestamps and hashes of previously downloaded files.
          * `{timestamp}.zip`: The downloaded file.
          * `{timestamp}.zip.sha1`: The SHA-1 hash of the downloaded file.
       * `extracting/`: This directory holds GTFS files that are in the process of being extracted from a downloaded feed.
       * `extracted/`: This directory holds GTFS files that have finished being extracted.
       * `processing/`: This directory holds GTFS files that are being processed.
       * `processed/`: This directory holds GTFS files that have finished processing.
    * `database`: This file is the raw SQLite database.
    * `database-journal`: This temporary file is the journal for the raw SQLite database.
    * `url`: This file contains the most recently used URL for downloading this feed.

You can specify an alternate workspace location by passing the `--workspace PATH` flag.