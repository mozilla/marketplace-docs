Docs for the Firefox Marketplace. Please see https://marketplace.readthedocs.org/

If you looking for legal docs, please see https://github.com/mozilla/legal-docs

Building the Documentation
--------------------------

To prepare to build this documentation:

    mkvirtualenv marketplace-docs
    pip install -r requirements/docs.txt

To build this documentation:

    make docs

To have changes built as they happen:

    make watch
