class User < ActiveRecord::Base
  roleable :role, [:user, :moderator, :admin]
end
