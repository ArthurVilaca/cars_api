# Introduction

change database connection on `config/database.yml`

run:
  ```
    rake db:create
    rake db:migrate
    rake db:seed
  ```

should be run at GET `http://localhost:3000/cars?user_id=1`

the required params should be working


# development

- added rubocop for linter

# notes

- added `active_model_serializers` for model serialization
- added `kaminari` for pagination

# tests

run:
  ```
    RAILS_ENV=test && bundle exec rspec
  ```