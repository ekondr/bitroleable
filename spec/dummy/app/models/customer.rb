class Customer < ActiveRecord::Base
  roleable :role, [:user, :moderator, :admin], multi: true
end
