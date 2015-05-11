# stock-dashboard

#Ruby version
2.1.2 

#System dependencies (gems):

rails 4.1.4 - Ruby on Rails framework


pg - Postgresql; databasing


sass-rails: Sass stylesheet language


uglifier: Javascript compressor


coffee-rails - Coffeescript adaptor in rails


coffee-script-source 1.8.0 - coffeescript rails


highcharts-rails 3.0.0 - Interactive chart creation in rails pipeline


bower-rails 0.9.2 - bower support in rails


therubyracer - V8 javascript interpreter


less-rails - Less stylesheet language for rails


twitter-bootstrap-rails - Twitter bootstrap in rails


morrisjs-rails - Morris.js for rails pipeline


raphael-rails - Raphael JS for rails


faraday - HTTP client lib that provides a common interface over many adapters and embraces the concept of Rack middleware when processing the request/response cycle


devise - authentication


omniauth-facebook 1.5.1 - Authentication for Facebook


koala 2.0 - Koala integration in rails


tzinfo-data - Timezone database


figaro - Configuration and security


jquery-rails - Jquery in rails


turbolinks - Rails optimization


jbuilder 2.0 - JSON building in rails


sdoc 0.4.0 -  RDoc generator


spring - Rails preloader


rails_12factor - Simplification of Rails running



#Database creation


Database creation is handled through Rake.  Type in this command:


	rake db::migrate

#Database initialization


Database initialization is handled through Rake.  Type in this command:


	rake db::seed

#How to run the test suite


Run this command


	rspec selenium.rb

	
From the test directory (/stock-dashboard/test/selenium)

#Deployment instructions


Deployment is handled on Heroku.  Type in this command:


	git push heroku master

	
to push to deployment environment
