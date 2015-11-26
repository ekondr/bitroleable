# Bitroleable

Store user's roles in an integer column of database. Have ability to store multi-roles for users.

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
add_column :user, :role, :integer, null: false
```

And then tell a model that you use this gem functionality:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  roleable :role, [:user, :moderator, :admin], multi: true
end
```

So you can do this:

```ruby
user = User.first
user.admin!
user.admin? # => true
user.user? # => false
user.role # => [:admin]
user.role = [:user, :moderator]
user.role # => [:user, :moderator]
user.save!

User.where_role(:admin).count # => 0
User.where_role(:user).count # => 1
User.where_role(:moderator).count # => 1
```

## Contributing

1. Fork it ( https://github.com/ekondr/bitroleable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
