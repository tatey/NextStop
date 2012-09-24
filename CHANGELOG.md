# CHANGELOG

## Current

* [Change] Default to keypad with numbers when adding new route.

## 0.4.0 / 2012-09-23

* [New] Search for a destination by address. The closest stop is automatically selected by line of sight.
* [New] Remember last viewed region on map in "Route Scene".
* [New] Notification is displayed when enabling monitoring for the first time in "Route Scene".
* [New] Tapping tracking button twice in "Route Scene" switches to compass mode.
* [Change] Tap "Add" to add route and use searchbar to filter. Opens automatically when there are no routes.
* [Change] Substantially reduce binary size. Uncompressed database is 2MB, down from 32MB.
* [Change] Show transport type (Eg: Bus) and two lines for long name in "Routes Scene".
* [Change] Use relative date formatting for last monitored date in "Route Scene".
* [Change] Support for iOS 6 and iPhone 5.
* [Change] Update data as of 2012-09-24. Missing TX2, 700, 702, 703, 706, 707, 709, 745 and 705 because Translink page returned 500.
* [Fix] Actually, actually conserve battery. Was not switching to "Cellular towers" when entering background.

## 0.3.1 / 2012-09-11

* [Fix] Actually conserve battery.

## 0.3.0 / 2012-09-10

* [Fix] Conserve battery by switching to "Cellular towers" when greater than 5KM from targeted stop.
* [New] Change style of toolbar on "Route Scene".
* [New] Change animation to crossfade when switching directions in "Route Scene".

## 0.2.0 / 2012-09-02

* [New] Remember routes and monitored stops, even after the application is quit.
* [New] Sort routes by last used on the "Routes Scene".
* [New] Show if targeted stop in route is being monitored on "Routes" scene.
* [New] Target and monitor stop by tapping stop on "Route Scene".
* [New] "Tracking button" lets you toggle between tracking the current location and targeted stop on "Route Scene".
* [New] Directions (Eg: Inbound) are independent of each other on "Route Scene".

## 0.0.1 / 2012-07-10

* Initial release.
