# GitHub_ForkView

This is a PowerShell script to aid in navigating the forks of a given repository. One thing I'm often interested in when browsing through a repository is what kinds of things other users have done with the forks they've taken off of the main repository. I've noticed that whenever I look at trending repositories, if I try to look at the Forks on the web page, the Network Graph won't populate because there are far too many forks to display and the Members graph appears to sort them by age as far as I can tell. 

The purpose of this script is to use the GitHub API to sort through the forks and display them to the user by the most watches and forks. The user can navigate through the tree of forks to find one they're interested in, and open the repository in their default web browser.

## Initiating the Script

This script requires an initial user input of the full name of the repository in the format, "<User>/<RepositoryName>". For example, once this repository inevitably goes viral and has thousands of forks, I will want to use this script by passing in the parameter, "mjohn174/GitHub_ForkView". This can be done by entering the command directly after calling the script from PowerShell as seen below, or by entering it when prompted.

####PS C:\Projects> GitHub_ForkView.ps1 mjohn174/GitHub_ForkView

Once the script has been initiated, a brief description of the repository will be displayed as well as the statistics of the top 10 forks of that repository, ranked by the number of stars. The user will then be prompted with the options they have throughout the remainder of the script.

## Authentication

The api methods being called by this script do not inherently require authentication unless the user would like to use this script enough to exceed the quota of calls to GitHub's api (50 calls/hr). If a user needs authentication, they can [acquire a personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) set an environment variable at the command line with the following command. 

####PS C:\Projects> [Environment]::SetEnvironmentVariable('GITHUB_OAUTH_TOKEN', <TOKEN>, 'User')
