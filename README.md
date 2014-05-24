[![Build Status](https://travis-ci.org/gruchanet/snippeter_on_steroids.svg?branch=master)](https://travis-ci.org/gruchanet/snippeter_on_steroids)

##SnippeterOnSteroids
####by JSON team.


><pre>
     {
       "JSON_team": {
         "member": {
           "name": "Dariusz Gafka",
           "github_acc": "<b><a href="https://github.com/dgafka">dgafka</a></b>"
         },
         "member": {
           "name": "Daniel Banecki",
           "github_acc": "<b><a href="https://github.com/Dejniel">Dejniel</a></b>"
         },
         "member": {
           "name": "Dawid Zawadzki",
           "github_acc": "<b><a href="https://github.com/ghost717">ghost717</a></b>"
         },
         "member": {
           "name": "Roman Józwiak",
           "github_acc": "<b><a href="https://github.com/gruchanet">gruchanet</a></b>"
         }
       }
     }
></pre>


* Ruby version: 2.1.1

* Rails ver. 4.1.1


## Used gems
### Previously
* #### Generic syntax highlighter
    gem 'pygments.rb', '0.5.4'

* #### Markdown parser "Redcarpet is Ruby library for Markdown processing that smells like butterflies and popcorn."
    gem 'redcarpet', '3.1.1'
    gem 'sass-rails', '~> 4.0.1'

* #### Bootstrap - front-end framework
    gem 'bootstrap-sass', '~> 3.1.1'

* #### Nice bootstrap template generator
    gem 'bootstrap-generators', '~> 3.1.1'

* #### CSS Animation
    gem 'animate-scss' # gem 'animate-rails'

* #### Paginator
    gem 'will_paginate', '~> 3.0.5'
    gem 'bootstrap-will_paginate', '~> 0.0.10'

* #### Filter scopes
    gem 'has_scope', '~> 0.5.1'

* #### Combobox overlay
    gem 'select2-rails', '~> 3.5.4'

* #### Simplier form syntax
    gem 'simple_form', '~> 3.0.1'

* #### Simplier form syntax
    gem 'simple_form', '~> 3.0.1'

### New gems

* #### Authentication system for GitHub
    gem 'omniauth-github', '1.1.1'

* #### "A thin and fast web server"
    gem 'thin'


#### For testing purposes

* #### Friendly testing framework
    gem 'rspec-rails'

* #### Testing tool for simulating user interaction with website
    gem 'capybara', '~> 2.2.1'

* #### Automatic & easier definition loading
    gem 'factory_girl_rails', '~> 4.4.1'

* #### Database cleaner
    gem 'database_cleaner'

* #### Selenium driver (for automatic tests)
    gem 'selenium-webdriver', '~> 2.41.0'

* #### Helper for Select2 dropdown
    gem 'capybara-select2'


## Features
### Previously

##### CORE FEATURE

* <i>Coloful syntax</i> depending on chosen syntax

##### Except standard features included in gems I added few additional features

* <i>Clickable table rows</i>, which act as a link to certain <b>snippet</b>

* <i>Possibility to input TAB character</i> in snippet form

* <i>Pagination with infinite scrolling</i>

* <i>Simple search engine</i>

* <i>Secured combobox</i>

* <i>Responsive layout</i>

* <i>Snippet preview with smooth scrolling</i>

* <i>Form validation</i>

* <i>My buttons</i> :)

### New features

* <i>Application <b>deeply</b> tested</i> (87 examples)!

* <i>User account system</i> - using a provider authentication, saves some informations to <b>database</b>

* <i>Authentication system</i> - you cannot edit/delete someones else snippet

* EVERYWHERE <i>Avatars from GitHub</i> EVERYWHERE

* <i>Searching snippets by user</i> - Search engine extension

* <i>Still <b>Responsive</b></i><b>!</b>


![Thats all FOLKS!](http://www.soothetube.com/wp-content/uploads/2013/12/all.jpg)
