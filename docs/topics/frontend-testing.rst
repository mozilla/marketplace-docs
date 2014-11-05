Frontend Testing
================

Across the marketplace projects we are using a combination of unittests and casperjs
for higher-level "flow" integration tests.

Most of the time we tend to focus on tests that cover a flow. These enable use to ensure
a user journey works as expected. We also look to cover new code with tests and write
regression tests for things that have broken so we are providing cover for the next time
they fail.


Writing tests for CasperJS
--------------------------

The best way to write a test for Casper is to take a test from an existing project
and use that as a template.

Taking a Fireplace test as an example let's build up a test file.

First we add the helpers script. This contains utility functions and helpful
wrappers to casper functionality just so we don't have to repeat lots of boilerplate
code all over the place.

.. code-block:: javascript

  var helpers = require('../helpers');

This next line starts casper. If you pass in an object and set the path, this will modify
where casper starts. In this case this will start us off at the homepage of our app.

.. code-block:: javascript

  helpers.startCasper();

Here's an alternative that will send casper to '/app/foo'

.. code-block:: javascript

  helpers.startCasper({path: '/app/foo'});

Now let's look at the most important block. We generally use this object-based
syntax for casper.test.begin.

This object contains a test method with our test code, along with a setUp and tearDown
method. Thes last two are optional if you don't need them you can exclude them.

.. code-block:: javascript

  casper.test.begin('Test system date dialogue', {

      setUp: function() {
        // Setup here
      },

      tearDown: function() {
        // Teardown here
      },

      test: function(test) {

          casper.waitForSelector('#splash-overlay.hide', function() {
              // Run an assertion here e.g:
              test.assertVisible('.date-error', 'Check date error message is shown');
          });

          casper.run(function() {
              test.done();
          });
      },
  });

The last block that contains `test.done()` is very important. Without this your test won't run.

Testing Tips
------------

When to write a test
____________________

If you're adding a feature to a project that support front-end tests (Fireplace/Spartacus etc) then
always look to cover your feature with a test.

If you're fixing a bug then this can be a great chance to start with a failing test first,
and then work on the fix until the test passes. This will also cover you should something
cause this bug to re-occur in the future.

When to write a unitest vs a casperjs flow test
_______________________________________________

If you're adding something that has defined input/output or can be tested at a low level easily
then a unittest can be the best place to test it. If your code is more involved e.g. it does UI
changes or affects multiple pages/URLS then a casper test is going to be the best approach.


Using `waitFor` to wait for conditions
______________________________________

`waitFor <http://docs.casperjs.org/en/latest/modules/casper.html#waitfor>`_ methods are very useful for making casper wait until a condition is met before trying
to test something. Generally you should never need to use a timeout or `casper.wait`

Here's a list of some of the commonly used `waitFor` methods we use:

* `waitForSelector <http://docs.casperjs.org/en/latest/modules/casper.html#waitforselector>`_ - waits for a selector to exist in the DOM.
* `waitWhileVisible <http://docs.casperjs.org/en/latest/modules/casper.html#waitwhilevisible>`_ - used to wait until a selector dissappears.
* `waitUntilVisible <http://docs.casperjs.org/en/latest/modules/casper.html#waituntilvisible>`_ - use to wait until a selector is visible.
* `waitForUrl <http://docs.casperjs.org/en/latest/modules/casper.html#waitforurl>`_ - Wait until casper has moved to the desired or matching url.

Most things are catered for. Always check the API docs to see if what you want is there.

If it's not then you can always use `waitFor <http://docs.casperjs.org/en/latest/modules/casper.html#waitfor>`_ and define your own function that returns
true when your custom condition is met.

If you use a custom condition a lot then consider adding it to `helpers.js`


Avoid testing for specific strings
__________________________________

We do it in a few places but generally it's good to try and avoid string checking
as it's likely to break when strings are updated.


Check casper's API for existing methods that will do what you want
__________________________________________________________________

There's lots and lots of stuff in the API already. Always take a look before
rolling your own function.

`Casper Test module <http://docs.casperjs.org/en/latest/modules/tester.html>`_


Understand the different environments
_____________________________________

The code in tests doesn't run in the browser environment. When you use casper's API
it's talking to Phantom (or a.n.other backend).

If you want to run something on the browser environment you can use `casper.evaluate`
which then runs the code on the client.

Here's a simple example:

.. code-block:: javascript

    casper.evaluate(function(arg) {
        console.log(arg);
    }, 'test');

See the casper docs for more info.


setUp not running early enough
______________________________

Sometimes we need to do things in setUp to modify a page to test specific functionality.
One problem that you might find is that setUp fires too early and changes made there don't work
To work around this you can look for the `page.initialized` event.

Here's an example:

.. code-block:: javascript

    setUp: function() {
        casper.once('page.initialized', function() {
            casper.evaluate(function() {
              // Evalaute some JS in the page.
            });
        });
    },
