# Org-agenda-radiator

## CRON jobs
Setup cron jobs to download your org files periodically - e.g.
`* 6-22 * * * ~/Dropbox-Uploader/dropbox_uploader.sh download /org/gtd.org ~/org/gtd.org`
`* 6-22 * * * ~/Dropbox-Uploader/dropbox_uploader.sh download /org/tickler.org ~/org/tickler.org`
May also pay to automatically switch on / off screen
`0 0 22 * * * ~/org-agenda-radiator/system-scripts/stop-screen.sh`
`0 0 6 * * * ~/org-agenda-radiator/system-scripts/start-screen.sh`
