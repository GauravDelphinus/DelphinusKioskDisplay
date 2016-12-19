ABOUT:
This is the source of a sample Kiosk-based Display Application that is based on Powerpoint.
The application is programmed using VBA as well as Perl Scripts, and currently supports the following features:
- Live RSS Feeds (news, etc.)
- Live Comic Strips (Dilbert, PCWeenies, etc.)
- Live Stock Quote (configurable)
- Live Images and Photos from various sources such as NatGeo, Nasa, etc.
- Randomized displays of images (picked from a local folder)
- Word of the Day
- Puzzle of the day
- Quote of the day
- Reminders about Birthdays, Wedding Anniversaries and Work Anniversaries for a team/group of people (data configurable)
- Calendar of events (data configurable)

For more, refer the Slides.pptm deck

REQUIREMENTS:
- Microsoft Powerpoint with MACROS Enabled
- Perl on Windows (Squirrel Perl will do)
- All associated Perl Modules (install via cpan <module name>) - refer the perl scripts under scripts folder

SETUP:
1. Install Perl and all associated modules
2. Enable PowerPoint macros
3. Configure the settings.config file to set the dataPath variable to a local folder that contains images (in JPG or PNG format)
4. In the settings.config file, add a line similar to companyStockSymbol=ABCD where ABCD represents a company stock symbol on NASDAQ
4. Enter team member details such as birthday, anniversary, work anniversary dates into the data/dynamic/team_members.csv file
5. Enter events into the data/dynamic/team_calendar.csv file
6. Create a 'log' folder under the project root to make sure log files can get created

HOW TO RUN:
1. Open Slides.pptm (ensure macros are enabled)
2. Go to Developer Tab
3. Click on Macros
4. Select InitiatilizeApp() and click on Run
5. Start slide show

TROUBLESHOOTING:
Problem and Error logs are written to the <base>/log folder.

LICENSE NOTES ON CONTRIBUTING:
This is an open source project.  I really appreciate your contributions to make this more useful.  When you do so, please try to make sure that the content remains configurable and generic, so it is useful in any application.  

CONTACT:
Feel free to ping me @GauravDelphinus on twitter :)