Publish
=======

## Set Up

Config database.yml

Run the bundle command to install it.

```console
bundle install
```

Create database

```console
rake db:create
```

Run db migrate

```console
rake db:migrate
```

Run seed trask

```console
rake core:seed
```

Run mailcatcher in development

```console
gem install mailcatcher
mailcatcher
```


Run server

```console
rails s
```

Login as Admin User with email="admin@publish-it.com" and password=SYSADMIN
