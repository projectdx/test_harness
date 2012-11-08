# Test Harness

Test Harness is a testing framework which allows for clean separation of test responsibilities.

## Installation
Test Harness is available as a rubygem from rubygems.org

    gem install test-harness

Or add to your Gemfile:
    group :development, :test do
      gem 'test-harness'
    end

## Structure
    /
      test_harness/
         /given
         /ui

Using Test Harness with Cucumber and Rspec allows you to isolate and DRY both setup code (GIVEN) and your
UI driver and observer (UI) from the actual tests.  This allows you to focus on testing and removes the
cluter of details communicating with the database (for setup), and communicating with the browser (for
verification).

Test Harness will autoload the files in /given and /ui folders, where it expects specific patterns for filenames
and defined classes as discussed below.

## Cucumber DSL Example


### 1. features/some_test.feature
Feature steps should be abstract at a level high enough for customer or product manager to easily understand.

    Feature: Login feature
    Scenario: Login
      Given a user
      When I submit valid credentials
      Then I am logged in



### 2. features/step_definitions/login_step.rb
Step definition should also be at a high level void of most details, and easy to follow for the developer.  It is
best to keep each step to few lines of code (3 is a good max).  Notice the syntax of the assertions 'should be_something.

Test Harness provides four objects that you can use in a step definition, three of them you can use here (**given, uid, uiv**), and hopefully the fourth one (**mm** - for Mental Model) you only need to use within the test harness artifacts.

    Given /^a user$/ do
      given.a_user
    end

    When /^I submit valid credentials$/ do
      uid.login_form.submit_valid_credentials
    end

    Then /^I am logged in$/ do
      uiv.login_form.should be_logged_in
    end

### 3. test_harness/given/login.rb
The **given/** folder holds the objects which performs the setup for the test.  It is preferred that
you assign a single responsibility for each file to make it easy to follow and understand.

Notice that the file name is significant in this folder where the file name is used to autoload a class
of the camlized format (file_name looks for class FileName)

#### Mental Model
The **mm** object is visible through out the test components, and is used to hold objects needed during the test.  Typically,
the **given** drive sets up the database or any other required setup, and assigns needed objects into the Mental Model **mm** 
object.  Since the **mm** object is an OpenStruct, you can freely add any new attributes by simply assigning them values.
(e.g., mm.whatever = WhatEver.create 'somethng', 'or', 'another')

The **mm.subject** is a special attribute of the Mental Model (**mm**).  It's attribute (e.g., _id_) are used to 
build the (url's) path of the component under test.  You can assign 

    class TestHarness
      class Given
        module Login
          def a_user
            mm.subject = User.create("my@email.com", "password")
          end
        end
      end
    end

### 4. test_harness/ui/login_form.rb
The UI drivers are used to communicate with the browser.  The UID (UI Driver) is used for driving the browser
(*Do the clicking*) and the UIV (UI View) driver does the inspection (*Do the looking*).  This separation of
responsibilities  makes it easier to figure out where to expect code.  

Notice that the file name is significant in this folder where the file name is used to autoload a class
of the camlized format (file_name looks for class FileName).  The filename is further used in the step 
definition file to refer to this component under test.

Ideally, a single web page could be divided into multiple UI components.  For example, on a login page, there
is a form which could be a single component, and there could be a header which could be a separate component, and
a footer would be a separate component.

#### I. component block
This block allows you to group constants, procs, and whatever else you might need for testing this component.  You
can assign any attributes to the component block which will be available in the UIDriver and UIView classes below.

The **path, within** attributes are special:  

1. **path**: is used by the uid#show method to automatically show that path.  You can have symbols within this string,
  e.g., c.path = "/application/:group/:id".  The :group and :id symbols will be replaced from the special **mm.subject**
  object, and hence, the **mm.subject** must respond to mm.subject.id, and mm.subject.group.

2. **within**: is used to limit the search for any CSS elements to the children of this css identifier.

#### II. UIView block
UIView objects **Do the looking**.  Use this block to define methods used by the **uiv** object in the step definitions.  These typically 
respond with a true/false for a **should** assertion (e.g., uiv.login_form.should be_logged_in, will corropsond to method 
UIView#logged_in? in the ui/login_form.rb)

#### III. UIDriver block
UIDriver objects **Do the clicking**.  Use this block to define methods used by the **uid** object in the step definitions.  These typically are verbs
which perfom actions in the browser.  

    require "ui_component"
    class TestHarness
      class LoginForm &lt; TestHarness::UIComponent
        component do |c|
          c.path = '/login'
          c.within = 'form'
          c.username = 'username'
          c.password = 'password'
          c.submit = 'input[name=commit]'
        end

        class UIView
          def logged_in?
            browser.current_url == index_url # check truth about being logged in
          end
        end

        class UIDriver
          def submit_valid_credentials
            fill_in component.username, :with => mm.subject.username
            fill_in component.password, :with => mm.subject.password
            submit
          end

          def submit
            find(:css, component.submit).click
          end
        end
      end
    end  


## Cucumber Setup
In the **feature/support/setup_test_harness.rb**

    require 'thwait'
    require 'test_harness'
    require 'spec/factories'  # if you use factories

**autoload_path**: Allows you to set the path where test_harness files are found.  Putting them in the
Rails.root/app folder proves problematic as they get autoloaded in production.  However, depending on how
you setup you Gemfile, the test-harness gem might be excluded, and the server will fail to load.  Defaults to 'test_harness'.

**namespace**: Sets the class namespace for your test_harness files.  Specify
this as a string, not a constant.  Defaults to 'TestHarness'.

    TestHarness.configure do |c|
      c.browser = Capybara
      c.autoload_path = Rails.root.join('test_harness')
      c.namespace = 'MyHarness'
    end

    World(TestHarness::TestHelper)

    Capybara.server_port = 33399
    Capybara.run_server = false
    Capybara.default_host = 'http://localhost'

    # This is supposed to allow Selenium to wait until ajax requests are finished
    Before do
      page.driver.options[:resynchronize] = true
    end

    @rack_server_pid = fork do
      Capybara::Server.new(Hummingbird::Application).boot
      ThreadsWait.all_waits(Thread.list)
    end

    at_exit do
      Process.kill(9, @rack_server_pid)
      Process.wait
    end

## Contributing to test_harness


Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
Fork the project.
Start a feature/bugfix branch.
Commit and push until you are happy with your contribution.
Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Maher Hawash. See LICENSE.txt for
further details.

