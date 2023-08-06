# Changelog

## [1.8.1](https://github.com/craigulliott/pg_spec_helper/compare/v1.8.0...v1.8.1) (2023-08-06)


### Bug Fixes

* removing unnecessary line break and white space from function definition ([20f8c53](https://github.com/craigulliott/pg_spec_helper/commit/20f8c539d308bc88fbc04428064febfbbc2c0970))

## [1.8.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.7.0...v1.8.0) (2023-08-06)


### Features

* using function_* instead of routine_* when dealing with functions, because routine_* implies these could be procedures too ([9c5f0c2](https://github.com/craigulliott/pg_spec_helper/commit/9c5f0c267f377731ed82d764a4f866de0b4525ee))


### Bug Fixes

* adding missing error class ([1810743](https://github.com/craigulliott/pg_spec_helper/commit/181074326fbf63eb27760486b4f18e1ea11c86b9))

## [1.7.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.6.0...v1.7.0) (2023-08-06)


### Features

* adding support for "instead of" in triggers ([488b4ab](https://github.com/craigulliott/pg_spec_helper/commit/488b4ab5fb458db2c7e2f60395b12dcfa9559459))

## [1.6.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.5.0...v1.6.0) (2023-08-06)


### Features

* added support for triggers and functions ([f89bf5e](https://github.com/craigulliott/pg_spec_helper/commit/f89bf5e3afa6fc411e9d1f16cb62db74fc8dc987))

## [1.5.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.4.0...v1.5.0) (2023-08-01)


### Features

* adding a new create_model method which yields a block to expose a DSL for easily working with the table structure ([dc28d5e](https://github.com/craigulliott/pg_spec_helper/commit/dc28d5ef599d8306564aa7c29d2220fb22ee6dd6))

## [1.4.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.3.0...v1.4.0) (2023-07-10)


### Features

* made `refresh_all_materialized_views` available as a public method ([dd88ea0](https://github.com/craigulliott/pg_spec_helper/commit/dd88ea0877ba75f5c78ce5083421dd20090be6cb))

## [1.3.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.2.0...v1.3.0) (2023-07-10)


### Features

* Dont delete the public schema, just remove all the tables instead. This is useful if you have materialized views in the public schema ([9f69160](https://github.com/craigulliott/pg_spec_helper/commit/9f691602bc851fbeea0d01a0f8e9a7555f154e35))

## [1.2.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.1.0...v1.2.0) (2023-07-10)


### Features

* refresh materialized views automatically based on changes to structure ([e9a8ce0](https://github.com/craigulliott/pg_spec_helper/commit/e9a8ce011578018b2374612e6d6ce8765e49d4db))

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
