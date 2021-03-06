# Catalog on Blacklight

A minimal Blacklight Application for exploring Temple University MARC data in preparation for migration to Alma.


## Getting started

### Install the Application
This only needs to happen the first time.

```bash
git clone git@github.com:tulibraries/tul_cob
cd tul_cob
bundle install
cp config/secrets.yml.example config/secrets.yml
bundle exec rails db:migrate
```

We also need to configure the application with our Alma and Primo apikey for development work on the Bento box or User account. Start by copying the example alma and bento config files.

```bash
cp config.alma.yml.example config/alma.yml
cp config/bento.yml.example config/bento.yml
```

Then edit them adding in the apikeys for our application specified in our Ex Libris Developer Network.


### Start the Application

We need to run two commands in separate terminal windows in order to start the application.
* In the first terminal window, start solr with run
```bash
bundle exec solr_wrapper
```
* In the second terminal window, start Puma, the rails application server
```bash
bundle exec rails server
```

### Start the Application with some sample data for Development

If you want to quickly get the application running for development with a minimal
set of example data, you can run

`bundle exec rake server`

It will start up solr_wrapper, ingest a few hundred sample records, and start the rails server.



## Importing from a Data File

Download the 10000 [sample Alma MARCXML data](https://raw.githubusercontent.com/tulibraries/tul_cob/master/sample_data/sample_alma_marcxml.tgz).

Untar the sample data.
```bash
tar xzvf sample_alma_marcxml.tgz
```


### Preparing Alma Data

For marcxml that has been generated by alma and exported by FTP, you'll need to do some data massaging before you can ingest
it into solr. With all XML files you want to ingest in a single directory (and no other XML files), run:

```bash

./scripts/massage.sh path/to/xmlfiles/

```

That will updates the xml files in place.

### Ingest with Traject

Now you are ready to ingest                                        

Import the MARC records with `bundle exec traject -c app/models/traject_indexer.rb PATH/TO/MARC.xml`

## Importing from Alma

In order to import from Alma directly execute the following Rake tasks. Harvest may be supplied with
an optional date/time ranges in ISO8901 format and enclosed in brackets. You may provide `from` and/or `ta`o
date/times. You may not provide only a `to` date/time

```bash
bundle exec rake fortytu:oai:harvest[from,to]
bundle exec rake fortytu:oai:conform_all
bundle exec rake fortytu:oai:ingest_all
```

## Running the Tests


`bundle exec rake ci`

This will spin up a test solr instance, import a few hundred records, and run the test suite.
