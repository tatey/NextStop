# CHANGELOG

## 0.6.2 / 2012-11-11

* [New] Attach diagnotics when using "Contact Us". Diagnostics contains location information for troubleshooting. You can opt-out of diagnostics at any time.
* [Fix] Fixed crashing when deleting a route with a monitored stop.
* [Change] Slight tweak to app icon.

## 0.6.1 / 2012-11-04

* [Change] App icon.
* [Change] Change switching from cellular tower to GPS based on distance between previous stop. Previously set at fixed distance of 2KM.

## 0.6.0 / 2012-10-29

* [Change] Next stop notification is sent shortly after leaving the previous stop. Previously set at a fixed distance of 500m. Maximum is 1KM.
* [Change] Opening Next Stop for the first time prompts you to add the route you are travelling on.
* [Change] Improve reading route codes when scrolling fast by changing positioning of icon.
* [Change] Error messages are meaningful sentences, not obscure code numbers.
* [New] "More Info" page. Contains "FAQ", "About" and built-in support.

## 0.5.2 / 2012-10-09

* [Fix] Fixed the positioning of a pin's callout bubble after the map region changed.
* [Fix] The callout bubble for the pin representing the destination would be behind pin representing the monitored stop.
* [Fix] Fixed another case where the pin for the monitored stop could appear be "stuck".

## 0.5.1 / 2012-10-08

* [Fix] "Sticky pins" when opening previously used route.
* [New] Added routes TX2, 700, 702, 703, 706, 707, 709, 745 and 705.

## 0.5.0 / 2012-10-08

* [New] Search for stops in route and direction.
* [New] Launching from local notification goes straight to stop in "Route Scene" instead of previously loaded scene.
* [New] Show error message when map fails to load or fails to find user's location.
* [Change] Default to keypad with numbers when adding new route.
* [Change] "New Route" scene lists all routes.
* [Change] Change previously monitored route pin color to grey/white to stop confusion with destination pin.
* [Change] Show callout over target when switching from compass to normal after tapping tracking button in "Route Scene".
* [Change] Formatted stop names for easier reading.
* [Change] Formatted destination address for easier reading.
* [Change] Show network activity indicator when loading map titles.
* [Change] Delete animation changes depending on number of visible cells in "Routes" scene.
* [Change] Switch from "Cellular towers" to region monitoring.

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
