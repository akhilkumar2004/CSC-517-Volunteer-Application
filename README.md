# Volunteer Management System

## Setup

1. Install Ruby 2.6+ and Bundler.
2. Run `bundle install`.
3. Run `bin/rails db:create db:migrate db:seed`.
4. Start the server with `bin/rails server`.

## Admin Credentials

- Username: admin
- Password: Password123!
- Email: admin@example.com

## Volunteer Workflow

- Sign up: click "Volunteer Sign Up" on the home page.
- Log in: click "Volunteer Login" on the home page.
- View events: click "Events" in the top navigation.
- Sign up for an event: click "Sign Up" in the events table.
- Withdraw from an event: go to "Assignments" and click "Withdraw".
- View history and total hours: click "History" in the top navigation.
- Edit profile: click "Dashboard" then "Edit Profile".

## Admin Workflow

- Log in: click "Admin Login" on the home page.
- Edit profile: click "Dashboard" then "Edit Profile".
- Create an event: click "Events" then "New Event".
- Manage volunteers: click "Volunteers" and use view/edit/delete options.
- Approve/reject/complete assignments: click "Assignments" then "Edit".
- Log volunteer hours: on the assignment edit screen, set status to "completed" and enter hours/date.
- View analytics: click "Analytics" and optionally filter.

## Tests

- Run `brew services start postgresql`
- Run `bundle exec rspec`.

## LLM Conversation

https://docs.google.com/document/d/1tYrmwC93ipwJpYaxxvKBLe7qmvBEZ1cOlCP55v5EDPU/edit?usp=sharing 

Link to hosted website: https://csc-517-volunteer-application.onrender.com

If the application gives you a Render loading screen, wait until the application loads. Unfortunately the application doesn't have always-on availability as we are using the free tier version of Render. 
