# R reporting for the zqsd slack team

## Files
* ETL.R: code to extract, transform and load messages, user colors etc..
* zqsdReport.Rmd: R markdown file which generates the .html output
* generate.sh: generates the .html file based on the .Rmd file

## Input
* message.xls : containing chat logs (not included)
* scoresHGT2017: hgt scores (not included)
* config.yml: containing the auth token to slack (not included)

## Output
* zqsdReport.html: the report

## Dependencies
1 Slack API for user colors and characteristics
2 Flat files

## Deployment



## Publication
html file can be found here: http://rpubs.com/B3nZ3n/zqsd 