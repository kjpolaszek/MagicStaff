Dummy API server
=======================

About this project
------------------

This project is supposed to be a simple read-only dummy JSON REST API. The served data is random.

Accessible URLs:
- `http://localhost:8080/api/v1/documents`
- `http://localhost:8080/api/v1/documents/{documentId}` where `documentId` is an integer between 0 and 195

Dependencies
------------

Dependencies are specified in `requirements.txt` and can be installed by:

    pip install -r requirements.txt

There is also a "soft" dependency on lorempixel.com to provide random images.

Running the project
-------------------

    pip install -r requirements.txt # do this just once
    ./api.py
