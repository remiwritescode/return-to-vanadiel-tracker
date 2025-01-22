# Return to Vana'diel Campaign Notifier

I spent way too much time in my youth in the world of Vana'diel and love going back when it's free! However, I always miss the campaigns and have a habit of finding they happened a couple weeks before I go to check if one is coming up. To get around this, I figured I could scrape the page to get the date and notify myself when one is coming!

This script hits the URL that returns the configuration XML that populates the page and notifies you in the event a campaign is coming up from a basic macos system dialogue on whatever the current app is.

Yeah, if I cared more I could make a little web app out of it that accepts emails to send email notifications to people or something, but this works for my needs. It only works on macos because of the osascript alert implementation.

It turns out, crontab is not valid for macos, so this now has a launchctl plist bundled with it that runs the script on login and once a day after.

### Requirements
- MacOS
- Ruby

### launchctl

To enable the launchctl scheduling, add the following to your `~/.launchctl.conf`

```
load /Users/my_username/Library/return-campaign-monitor/local.return-to-vana-diel-monitor.plist
```