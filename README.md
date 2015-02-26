# GTFS Command-Line Tools

This suite consists of the following tools for use in consuming GTFS feeds:

 * `gtfs-init`: Initializes a new GTFS feed configuration.
 * `gtfs-update`: Downloads a GTFS feed, extracts it, then imports it into a local SQLite database.
 * `gtfs-continue`: Continues a previously started GTFS feed update.

For best results, add this project's **bin** directory to your *PATH*. This is best done in your **~/.bash_profile**
or similar, and looks something like this:

    export PATH="/path/to/gtfs-tools/bin:${PATH}"

## Examples

Initializing a GTFS feed:

    $ gtfs-init --name Example --url http://www.example.com/gtfs/google_transit.zip

After a GTFS feed has been initialized, it can be updated by running the following command:

    $ gtfs-update --name Example

The `gtfs-update` tool can also be used to update a feed from a file:

    $ gtfs-update --name Example --file /path/to/acme/google_transit.zip

You can pass a URL to `gtfs-update` as well:

    $ gtfs-update --name Example --url http://alternate.example.com/gtfs/google_transit.zip

If feed processing fails or is aborted for whatever reason, it can be continued like this:

    $ gtfs-continue

If you are processing multiple feeds within the same workspace and want to restrict which feeds
get continued, you may specify a `--name NAME` parameter:

    $ gtfs-continue --name Example

## Output

The end result of processing a GTFS feed is a SQLite database containing the GTFS feed data. This
database can then be imported into a mobile application, used as a data source for your own transit API,
or queried by any standard SQL tools capable of connecting to a SQLite database.

The database can be found in the workspace, at `{feed_name}/database`.

## Workspace Layout

These tools, when run, will create the following directory structure within the directory in which the tool is run:

 * `{feed_name}/`: This directory holds all data relevant to the named feed.
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
    * `database`: This file is a raw SQLite database containing the feed's data.
    * `database-journal`: This temporary file is created by SQLite while the database is open.
    * `url`: This file contains the most recently used URL for downloading this feed.

You can specify an alternate workspace location by passing the `--workspace PATH` flag.
