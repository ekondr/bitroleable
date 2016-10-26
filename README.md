# Bitroleable

Manage user roles. Each user's role is stored as a bit in an integer 
column of database. Also provides user ability to have one role and 
some roles.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitroleable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitroleable

## Usage

Add a column which will store role/roles as integer:

```ruby
add_column :user, :roles, :integer, null: false
```

And then tell a model that you use this gem functionality:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  roleable :roles, [:user, :moderator, :admin], multi: true
end
```

### Options

For now it has only one option:

- `multi` (boolean) - when it equals `true` an entity could have many roles, otherwise only one role

### Example

```ruby
user = User.first
user.admin! # => user becomes an admin
user.admin? # => true
user.role?(:admin) # => true
user.user? # => false
user.role # => [:admin]
user.role = [:user, :moderator]
user.role # => [:user, :moderator]
user.save!

User.where_role(:admin).count # => 0
User.where_role(:user).count # => 1
User.where_role(:moderator).count # => 1
User.roles_list # => [:user, :moderator, :admin]
User.role?(:user) # => true
User.role?(:fake) # => false
```

## Contributing

1. Fork it ( https://github.com/ekondr/bitroleable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
