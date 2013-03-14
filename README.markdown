Voice/SMS Eldercare Resource Locator app
========================================

Demonstration
-------------
<table>
  <tr>
    <th>Service</th>
    <th>Number/Name</th>
    <th>Voice/Text</th>
  </tr>
  <tr>
    <th>Call/SMS</th>
    <td>(202) 738-5220</td>
    <td>Both</td>
  </tr>
  <tr>
    <th>Skype</th>
    <td>+990009369996192374</td>
    <td>Voice only</td>
  </tr>
  <tr>
    <th>SIP</th>
    <td>sip:9996192374@sip.tropo.com</td>
    <td>Voice only</td>
  </tr>
  <tr>
    <th>iNum</th>
    <td>+883510001357413</td>
    <td>Voice only</td>
  </tr>
  <tr>
    <th>Jabber</th>
    <td>eldercare@tropo.im</td>
    <td>Text only</td>
  </tr>
</table>

Data Source
-----------
This app uses data from the ElderCare Locator API. More information is available on [ProgrammableWeb](http://www.programmableweb.com/api/eldercare-locator) and at the [ElderCare.gov](http://www.eldercare.gov/Eldercare.NET/Public/Site_Utilities/API_Reg/API_Registration.aspx) website.

Steps to recreate
-----------------

1. You will need to have [Ruby](http://www.ruby-lang.org/en/downloads/), [Rubygems](http://docs.rubygems.org/read/chapter/3), [Heroku](http://docs.heroku.com/heroku-command) and [Git](http://book.git-scm.com/2_installing_git.html) installed first.

2. Drop into your command line and run the following commands:
  * `git clone http://github.com/marks/tropo-sinatra-eldercare.git --depth 1`
  * `cd tropo-sinatra-eldercare`

3. Edit the `config.yml.exmaple` to use your own API username and password and rename the file to `config.yml`

4. Back at the command line, issue:
  * `heroku create`
  * `git push heroku master`

5. Log in or sign up for [Tropo](http://www.tropo.com/) and create a new WebAPI application.
    For the App URL, enter in your Heroku app's URL and append `/index.json` to the end of it.

6. That's it! Call in, use, and tinker with your app!
