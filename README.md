##### Prerequisites

The setups steps expect following tools installed on the system.

- Git
- Ruby 2.7.1
- Rails 6.0.3

##### 1. Check out the repository

```bash
git clone https://github.com/jedkaryd/avenida-challenge.git
```

##### 2. Create and setup the database

Run the following commands to create and setup the database.

```ruby
rails db:create
rails db:migrate
```

##### 3. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

##### 4. See the API doc

You can get more information about the endpoints through the API Swagger Documentation gettin into the explorer on the address below.

```
http://localhost:3000/api-docs/
```
