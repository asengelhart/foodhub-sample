# Foodhub Sample Site

This web application currently allows users to store and display items that they produce, including a name, inventory count and price, and allows for editing and deletion of items.  Items are persisted via ActiveRecord, which at this time connects to a SQLite database file.  Future versions of this app will allow consumers to browse and purchase items as well (maybe for real if this turns out to be a solution for the Riverton Local Food Hub's future online marketplace), and will allow producers to include detailed descriptions and keywords for their inventory.


# Installation

- Clone this repository to your machine.
- Run `bundle install` from the app's root directory (i.e. `foodhub-sample/`).
- Run `rake db:migrate` to initialize the database.
- Run the app from the web server of your choice.

# Usage

At this time, accessing the home page will redirect you to the producers' dashboard, where you will (once signed up and logged in) be able to create, edit and delete items from your inventory.  Prices are assumed to be USD.

# License
Copyright © 2020, Alex S. Engelhart

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://mit_license.org
