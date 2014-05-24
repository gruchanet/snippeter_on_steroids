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
    <pre>gem 'pygments.rb', '0.5.4'</pre>

* #### Markdown parser "Redcarpet is Ruby library for Markdown processing that smells like butterflies and popcorn."
    <pre>gem 'redcarpet', '3.1.1'</pre>

* #### Rails integration with Sass"
    <pre>gem 'sass-rails', '~> 4.0.1'</pre>

* #### Bootstrap - front-end framework
    <pre>gem 'bootstrap-sass', '~> 3.1.1'</pre>

* #### Nice bootstrap template generator
    <pre>gem 'bootstrap-generators', '~> 3.1.1'</pre>

* #### CSS Animation
    <pre>gem 'animate-scss' # gem 'animate-rails'</pre>

* #### Paginator
    <pre>gem 'will_paginate', '~> 3.0.5'</pre>
    <pre>gem 'bootstrap-will_paginate', '~> 0.0.10'</pre>

* #### Filter scopes
    <pre>gem 'has_scope', '~> 0.5.1'</pre>

* #### Combobox overlay
    <pre>gem 'select2-rails', '~> 3.5.4'</pre>

* #### Simplier form syntax
    <pre>gem 'simple_form', '~> 3.0.1'</pre>

### New gems

* #### Authentication system for GitHub
    <pre>gem 'omniauth-github', '1.1.1'</pre>

* #### "A thin and fast web server"
    <pre>gem 'thin'</pre>


### For testing purposes

* #### Friendly testing framework
    <pre>gem 'rspec-rails'</pre>

* #### Testing tool for simulating user interaction with website
    <pre>gem 'capybara', '~> 2.2.1'</pre>

* #### Automatic & easier definition loading
    <pre>gem 'factory_girl_rails', '~> 4.4.1'</pre>

* #### Database cleaner
    <pre>gem 'database_cleaner'</pre>

* #### Selenium driver (for automatic tests)
    <pre>gem 'selenium-webdriver', '~> 2.41.0'</pre>

* #### Helper for Select2 dropdown
    <pre>gem 'capybara-select2'</pre>


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
