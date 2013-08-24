# Next Stop

Next Stop is an iPhone app that alerts you when it's time to hop off at
the right stop. It was built for [Brisbane City Council](http://www.brisbane.qld.gov.au/traffic-transport/public-transport/buses/)
buses and has since been [removed from the App Store](http://tatey.com/2013/04/07/next-stop-is-hopping-off/).
It is now available as an open source project for anyone to learn from.

![](http://f.cl.ly/items/1p3Y3Q1V3W180Q3d2721/NextStop.png)

See a [demo of NextStop](http://nextstop.me) on the marketing website.

## Dependencies

* Xcode 4.6
* iOS 5.X and iOS 6.X

## Setup

Clone the repository, including submodules.

    git clone --recursive git@github.com:tatey/next_stop.git

Download the SQLite database.

    wget http://cl.ly/2B1i0w0i1n1p/download/NextStop.sqlite
    mv NextStop.sqlite NextStop/NextStop.sqlite

Open the project in Xcode.

    open NextStop.xcodeproj

Set the device to "iPhone Simulator" and press "Run".

## Data

At the time NextStop was developed the Queensland Government had
not made public transport data available. To get the data I wrote
a [scraper](https://github.com/tatey/translink) which turned the
website into an SQLite database that conformed to the GTFS.

## Copyright

Following files, directories and their contents are copyright [Tate
Johnson](http://tatey.com). You may not reuse anything therein without
my permission:

* NextStop/Icon.png
* NextStop/Icon@2x.png
* NextStop/IconSettings.png
* NextStop/IconSettings@2x.png

Following files, directories and their contents are copyright [Sensible
World](http://symbolicons.com/). You may not reuse anything therein
without purchasing a license:

* NextStop/About.png
* NextStop/About@2x.png
* NextStop/BusGray.png
* NextStop/BusGray@2x.png
* NextStop/BusGreen.png
* NextStop/BusGreen@2x.png
* NextStop/BusWhite.png
* NextStop/BusWhite@2x.png

All other files and directories are licensed under the GPL v3 license
unless explicitly stated. See LICENSE.
