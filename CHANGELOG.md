# Changelog

## [1.9.13](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.12...v1.9.13) (2023-10-11)


### Bug Fixes

* adding deferrable and on_delete/on_update options to constraints ([4097c73](https://github.com/craigulliott/pg_spec_helper/commit/4097c7313f01c21cb2af2248a9c065e1cbe14da7))

## [1.9.12](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.11...v1.9.12) (2023-10-09)


### Bug Fixes

* accepting both `database` and `dbname` as the name of the database and both `user` and `username` as the name of the user. This covers the naming conventions from both the PG gem and ActiveRecord. ([2f43555](https://github.com/craigulliott/pg_spec_helper/commit/2f435555e1789ecd002f4c22b4feb6f4d2b8cb56))

## [1.9.11](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.10...v1.9.11) (2023-09-01)


### Bug Fixes

* automatically add the citext extension if a column requires it ([0282269](https://github.com/craigulliott/pg_spec_helper/commit/028226916532ec135c47fe59540f556203d9964f))

## [1.9.10](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.9...v1.9.10) (2023-08-25)


### Bug Fixes

* suppressing warning message about extension already exists ([65a9023](https://github.com/craigulliott/pg_spec_helper/commit/65a9023eecbb6ea8697b80791efd5003e6184fa8))

## [1.9.9](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.8...v1.9.9) (2023-08-24)


### Bug Fixes

* creating model now sets correct null and default values ([2e4634e](https://github.com/craigulliott/pg_spec_helper/commit/2e4634ebac8bf52e7eca497e891e492179f6b98e))

## [1.9.8](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.7...v1.9.8) (2023-08-24)


### Bug Fixes

* auto creating uuid-ossp extension if using create model ([bdc30a9](https://github.com/craigulliott/pg_spec_helper/commit/bdc30a95e4bbd2b5f8f347a10d29d874099997d6))
* only delete functions which were created (to prevent deleting internal functions) ([1c23a36](https://github.com/craigulliott/pg_spec_helper/commit/1c23a36b64992934214c21cdbf6200f74e172511))

## [1.9.7](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.6...v1.9.7) (2023-08-24)


### Bug Fixes

* ensuring uniqueness for primary_keys ([6179b46](https://github.com/craigulliott/pg_spec_helper/commit/6179b46f683adf08836c7193dd63711fe2533778))

## [1.9.6](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.5...v1.9.6) (2023-08-24)


### Bug Fixes

* create columns with default values ([91e05b8](https://github.com/craigulliott/pg_spec_helper/commit/91e05b8b14c38161965ab8e2dc1d7e869e399567))
* fixed mistake in type signatures ([a2e5f1e](https://github.com/craigulliott/pg_spec_helper/commit/a2e5f1ed897dbd7968716126ccd6a675cc7a5641))

## [1.9.5](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.4...v1.9.5) (2023-08-24)


### Bug Fixes

* only deleting types which were created by us to prevent deleting non enums or types required by materialized views ([2ad6ff6](https://github.com/craigulliott/pg_spec_helper/commit/2ad6ff6ab5edff95bceafb5e646dd2b2f4f0729f))

## [1.9.4](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.3...v1.9.4) (2023-08-23)


### Bug Fixes

* deleting enums and triggers instead of removing the public schema because it may have materialized views in it ([d9a4efc](https://github.com/craigulliott/pg_spec_helper/commit/d9a4efc2c56c2971151efffb5fe2b1d079deb75b))

## [1.9.3](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.2...v1.9.3) (2023-08-23)


### Bug Fixes

* deleting enums and triggers instead of removing the public schema, because it may have materialized views in it ([34a8afa](https://github.com/craigulliott/pg_spec_helper/commit/34a8afae9cca995ba8950d7d54ad377869901c19))

## [1.9.2](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.1...v1.9.2) (2023-08-23)


### Bug Fixes

* actually deleting and recreating the public schema as part of the reset, this ensures we remove all functions and enums too ([5dd70c9](https://github.com/craigulliott/pg_spec_helper/commit/5dd70c93eb3754a3e84161dc571e3a39b814f34c))

## [1.9.1](https://github.com/craigulliott/pg_spec_helper/compare/v1.9.0...v1.9.1) (2023-08-23)


### Bug Fixes

* track use of functions, triggers and enums so we erase the database correctly between tests ([c705a0d](https://github.com/craigulliott/pg_spec_helper/commit/c705a0defe011c715de18c10f16861a02308122b))

## [1.9.0](https://github.com/craigulliott/pg_spec_helper/compare/v1.8.5...v1.9.0) (2023-08-21)


### Features

* added support for enums and extensions ([b22f662](https://github.com/craigulliott/pg_spec_helper/commit/b22f662cad22c1220ac6f4bc029ca534348a4bea))

## [1.8.5](https://github.com/craigulliott/pg_spec_helper/compare/v1.8.4...v1.8.5) (2023-08-19)


### Bug Fixes

* removing the sanitization of sql data (it is useless in this gem, and gets in the way of testing some things, which defeats the point of this gem) ([fe6af3b](https://github.com/craigulliott/pg_spec_helper/commit/fe6af3bd4443b140a3136d43f1da61315de4d761))

## [1.8.4](https://github.com/craigulliott/pg_spec_helper/compare/v1.8.3...v1.8.4) (2023-08-18)


### Bug Fixes

* function definitions no longer presume/add their own BEGIN and END, which now allows providing custom SQL such as DEFINE statements ([2ec7d00](https://github.com/craigulliott/pg_spec_helper/commit/2ec7d00bd2ad539860384981586b0bcee98d56a7))

## [1.8.3](https://github.com/craigulliott/pg_spec_helper/compare/v1.8.2...v1.8.3) (2023-08-06)


### Bug Fixes

* stripping whitespace off the end of the method definition ([df63ae9](https://github.com/craigulliott/pg_spec_helper/commit/df63ae96faf090b98220a9e64d87dbaaf89135d0))

## [1.8.2](https://github.com/craigulliott/pg_spec_helper/compare/v1.8.1...v1.8.2) (2023-08-06)


### Bug Fixes

* stripping whitespace off the end of the method definition ([027fbc0](https://github.com/craigulliott/pg_spec_helper/commit/027fbc01cc04e79110a97392a6811371c487bab6))

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
