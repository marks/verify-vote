verify-vote
===========
Mock up to verify a voter's ballot choice via SMS

by [Mark Silverberg](http://twitter.com/skram) of [Social Health Insights](http://socialhealthinsights.com/)
for Danny Thiemann of the Indiana University Maurer School of Law

Demonstration
-------------


Data Source
-----------


Steps to recreate
-----------------

1. You will need to have [Ruby](http://www.ruby-lang.org/en/downloads/), [Rubygems](http://docs.rubygems.org/read/chapter/3), [Heroku](http://docs.heroku.com/heroku-command) and [Git](http://book.git-scm.com/2_installing_git.html) installed first.

2. Drop into your command line and run the following commands:
  * `git clone http://github.com/marks/verify-vote.git --depth 1`
  * `cd tropo-sinatra-eldercare`

3. Edit the `config.yml.exmaple` to use your own API username and password and rename the file to `config.yml`

4. Back at the command line, issue:
  * `heroku create`
  * `git push heroku master`

5. Log in or sign up for [Tropo](http://www.tropo.com/) and create a new WebAPI application.
    For the App URL, enter in your Heroku app's URL and append `/index.json` to the end of it.

6. That's it! Call in, use, and tinker with your app!
