# Changelog

## [1.1.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.0.0...v1.1.0) (2023-07-10)


### Features

* documentation, get methods to retrieve current database structure, and full test coverage ([d6c6230](https://github.com/craigulliott/pg_spec_helper/commit/d6c623055d3ac2920bdc4f805973df7f25208329))

## 1.0.0 (2023-07-08)


### Features

* basic first version, extracted from dynamic_migrations gem ([4d4ed01](https://github.com/craigulliott/pg_spec_helper/commit/4d4ed016d1a19394d0db7c39a01c153670a3edfe))

## 1.0.0 (2023-07-05)


### Features

* added table and column comments and column metadata ([84d798a](https://github.com/craigulliott/pg_spec_helper/commit/84d798aae35c259545f73dbbd7d076d8ceaa8739))
* basic representation of schema either configured or loaded from a real database ([7fc9ebb](https://github.com/craigulliott/pg_spec_helper/commit/7fc9ebbe5a8e5faa4e6017deec9bc66f7ba15f16))
* recursively load and builds a representation of current database schema, and find differences between configured and loaded representations of the database structure ([978e122](https://github.com/craigulliott/pg_spec_helper/commit/978e12279760709f1511dc7c6d9fe7ff57b54f3e))
* renaming the current version of constraints to validations, because its a more descriptive name, especially when considering we are going to expose multiple types of postgres constraint ([2f17af6](https://github.com/craigulliott/pg_spec_helper/commit/2f17af665028ed6f49d8bdd9b7ff6a52339206db))
* support for table constraints and added caches for database structure and constraints ([f68bbb2](https://github.com/craigulliott/pg_spec_helper/commit/f68bbb20a25fab149ed4b3b9c591fde1a6ff628e))
* table keys and indexes and a more robust database configured/loaded comparison class ([b4a0925](https://github.com/craigulliott/pg_spec_helper/commit/b4a092535e4e59d0fb9b97efc3d210289346b454))
