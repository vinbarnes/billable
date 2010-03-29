billable
========

Requires
--------

* Sinatra
* one-inch-punch

Config file
-------------------

Configure your own messages.yaml file with your own custom ranges
and messages:

    - :begin: 0.0
      :end: 0.05
      :excl: true
      :message: "Need more hours!"
    - :begin: 0.05
      :end: 0.15
      :excl: true
      :message: "You'll be eating beans next month!"

Run it
-------

    $ ruby app.rb
