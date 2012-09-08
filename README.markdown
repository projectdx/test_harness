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
    Rails.root/
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

1. Feature steps should be abstract at a level high enough for customer or product manager to easily understand.


### features/some_test.feature

    Feature: Login feature
    Scenario: Login
      Given a user
      When I submit valid credentials
      Then I am logged in


Step definition should also be at a high level void of most details, and easy to follow for the developer.  It is
best to keep each step to few lines of code (3 is a good max).  Notice the syntax of the assertions 'should be_something.


Test Harness provides four objects that you can use in a step definition, three of them you can use here (<strong>given, uid, uiv</strong>), and hopefully the fourth one (mm - for Mental Model) you only need to use within the test harness artifacts.

### features/step_definitions/login_step.rb
    Given /^a user$/ do
      given.a_user
    end

    When /^I submit valid credentials$/ do
      uid.login_form.submit_valid_credentials
    end

    Then /^I am logged in$/ do
      uiv.login_form.should be_logged_in
    end

### test_harness/given/login.rb
    class TestHarness
      class Given
        module Login
          def a_user
            mm.subject = User.create("my@email.com", "password")
          end
        end
      end
    end

### test_harness/ui/login</em>form.rb
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

