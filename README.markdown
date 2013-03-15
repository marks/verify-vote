verify-vote
===========
Mock up to verify a voter's ballot choice via SMS

by [Mark Silverberg](http://twitter.com/skram) of [Social Health Insights](http://socialhealthinsights.com/)
for Danny Thiemann of the Indiana University Maurer School of Law

Data Source
-----------
Publicly accessible Google spreadsheet at [https://docs.google.com/a/gwmail.gwu.edu/spreadsheet/ccc?key=0AvEbeLXW2uw0dHFmbUU1cHZIWVlzZk1PT2hDNnZWX0E#gid=0](https://docs.google.com/a/gwmail.gwu.edu/spreadsheet/ccc?key=0AvEbeLXW2uw0dHFmbUU1cHZIWVlzZk1PT2hDNnZWX0E#gid=0)


Demonstration
-------------
* You can interact with this app by calling/texting one of the endpoints below.
<table>
  <tr>
    <th>Service</th>
    <th>Number/Name</th>
    <th>Voice/Text</th>
  </tr>
  <tr>
    <th>Call/SMS</th>
    <td>(260) 207-4235</td>
    <td>Both</td>
  </tr>
  <tr>
    <th>Skype</th>
    <td>+990009369990065278</td>
    <td>Voice only</td>
  </tr>
  <tr>
    <th>SIP</th>
    <td>sip:9990065278@sip.tropo.com</td>
    <td>Voice only</td>
  </tr>
  <tr>
    <th>iNum</th>
    <td>+883510001392933</td>
    <td>Voice only</td>
  </tr>
  <tr>
    <th>Jabber</th>
    <td>verifyvote@tropo.im</td>
    <td>Text only</td>
  </tr>
</table>


* You can also see the data source (details above) by visting one of the following web endpoints in your browser
  * [/ballots](http://verify-vote.socialhealthinsights.com/ballots) show all ballots in JSON format
  * [/ballot/321](http://verify-vote.socialhealthinsights.com/ballot/321) show the details for a specific ballot in JSON format


Steps to recreate
-----------------

1. You will need to have [the Heroku Toolbelt](https://toolbelt.herokuapp.com/) installed first.

2. Drop into your command line and run the following commands:
  * `git clone http://github.com/marks/verify-vote.git --depth 1`
  * `cd verify-vote`

3. Edit the `config.yml.exmaple` to use your own API username and password and rename the file to `config.yml`

4. Back at the command line, issue:
  * `heroku create`
  * `git push heroku master`

5. Log in or sign up for [Tropo](http://www.tropo.com/) and create a new WebAPI application.
    For the App URL, enter in your Heroku app's URL and append `/index.json` to the end of it.

6. That's it! Call in, use, and tinker with your app!

Dev Notes
---------
* Create tunnel for local development (local sinatra port = 4567), more information available at https://www.tropo.com/docs/webapi/using_tunnlr_reverse_ssh.htm
  * `ssh  -nNt -g -R :12748:0.0.0.0:4567 tunnlr3492@ssh1.tunnlr.com`
  * Set tropo endpoint to `http://web1.tunnlr.com:12748/index.json`
