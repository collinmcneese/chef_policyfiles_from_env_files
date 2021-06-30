# policyfiles_from_env_files

Cookbook with a `Rakefile` that will create discreet policy files from environmentfiles, useful when migrating to policyfile-based cookbooks from Berkshelf as Test Kitchen does not support environments when using policyfiles.

This example cookbook repository has legacy environment files located under `test/environments` which were used for Test Kitchen integration tests.

## Usage

The primary function of this repository is to show the usage of the scripting within the `Rakefile` which will convert legacy `environment` files to discreet policy files within the cookbook repository.

* View available rake tasks
  ```plain
  $ chef exec rake -T
  rake policyfiles_from_environment_files  # Creates policy files from environment files
  $
  ```
* Execute the rake task for migrating to policy files:
  ```plain
  $ chef exec rake policyfiles_from_environment_files
    ======> Processing environment env1 from test/environments/env1.json
    ======> Created policy_env1.rb
    ======> Populated policy_env1.rb with attributes from test/environments/env1.json
    ======> Processing environment env2 from test/environments/env2.json
    ======> Created policy_env2.rb
    ======> Populated policy_env2.rb with attributes from test/environments/env2.json
  ```
* Populate Test Kitchen suites with `policyfile_path` provisioner options for suites, allowing to test from different source data files.
  ```yaml
  suites:
  - name: default
    verifier:
      inspec_tests:
        - test/integration/default
    attributes:
  - name: env1
    provisioner:
      policyfile_path: policy_env1.rb
    verifier:
      inspec_tests:
        - test/integration/default
    attributes:
  - name: env2
    provisioner:
      policyfile_path: policy_env2.rb
    verifier:
      inspec_tests:
        - test/integration/default
    attributes:
  ```
