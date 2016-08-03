[![Documentation Status](https://readthedocs.org/projects/marketplace/badge/?version=latest)](https://readthedocs.org/projects/marketplace/?badge=latest)

High-level documentation for the Firefox Marketplace. Hosted at
[marketplace.readthedocs.org](https://marketplace.readthedocs.org)

Other Marketplace documentation repositories include:

- [Marketplace high-level documentation](https://github.com/mozilla/marketplace-docs)
- [Marketplace API documentation](https://github.com/mozilla/zamboni/tree/master/docs/api)
- [Marketplace legal documents](https://github.com/mozilla/legal-docs)

# Building the Documentation

To prepare to build this documentation:

    mkvirtualenv marketplace-docs
    pip install -r requirements/dev.txt

To build this documentation:

    make docs

To have changes built as they happen:

    make watch
