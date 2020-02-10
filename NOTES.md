Functionality (what should the site/pages look like?)
Database (which informs models), then TEST database/relations
Actual coding
  Follow user experience order - "I'm the end user, what do I want to see/experience"

Homepage
___
Login/signup links
Displays inventory list when logged in
List items show count, price and links
Links go to individual item page
New item button at the bottom of the page

Signup
___
Takes name, email and password
Name and email should be unique
Displays error message if not unique

Login
___
Uses email as username

Item page
___
Item page should be an edit page (?)
Should show count, price, description
Should include submit button and delete button


Producers model
___
Name, password_digest, email
Name and email must be unique
Has many items

Items model
___
Name, count, price
Belongs to producer