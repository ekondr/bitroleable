require 'bitroleable/version'

module Bitroleable
  extend ActiveSupport::Concern

  class_methods do
    def roleable(*attrs)
      column = nil
      roles_list = []
      roles_options = HashWithIndifferentAccess.new({multi: false})
      incorrect_params_message = 'Incorrect number of parameters (ex: roleable :roles, [:admin, :user])'
      incorrect_options_message = 'Incorrect roles options. Possible options: :multi - support multi roles'
      attrs.each_with_index do |attr, index|
        fail StandardError, incorrect_params_message if index > 2
        column = attr.to_sym if index == 0 && (attr.is_a?(String) || attr.is_a?(Symbol))
        roles_list = attr.map(&:to_sym) if index == 1 && attr.is_a?(Array)
        roles_options = roles_options.merge(attr) if index == 2 && attr.is_a?(Hash)
      end
      fail StandardError, incorrect_params_message if column.nil? || roles_list.empty?
      fail StandardError, incorrect_options_message unless roles_options.keys.map(&:to_sym).sort == [:multi]

      roles_list.each do |role|
        define_method("#{role}?".to_sym) do
          self[column] & self.class.role_value(role) > 0
        end

        define_method("#{role}!".to_sym) do
          if roles_options[:multi]
            self[column] |= self.class.role_value(role)
          else
            self[column] = self.class.role_value(role)
          end
          save!
        end

        define_method("#{column}=".to_sym) do |value|
          return self[column] = 0 if value.blank?
          if roles_options[:multi]
            roles = value.is_a?(Array) ? value : [value]
            self[column] = 0
            roles.each do |role_name|
              self[column] |= self.class.role_value(role_name)
            end
          else
            self[column] = self.class.role_value(value)
          end
        end

        define_method("#{column}".to_sym) do
          if roles_options[:multi]
            return [] if self[column].nil? || self[column] == 0
            result = []
            roles_list.each do |role_name|
              result << role_name if self[column] & self.class.role_value(role_name) > 0
            end
            result
          else
            return nil if self[column].nil? || self[column] == 0
            roles_list.each do |role_name|
              return role_name if self[column] == self.class.role_value(role_name)
            end
            nil
          end
        end
      end

      define_singleton_method :role_value do |role|
        index = roles_list.index(role.to_sym)
        fail StandardError, "The role #{role} doesn't exist" if index.nil?
        2**index
      end

      define_singleton_method :where_role do |*roles|
        roles = roles.flatten.compact.map(&:to_sym)
        tbl_column = "#{self.table_name}.#{column}"
        query = roles.map { |role| "(#{tbl_column} & %d > 0)" % role_value(role) }.join(' OR ')
        where(query)
      end
    end
  end
end

ActiveRecord::Base.send(:include, Bitroleable)
