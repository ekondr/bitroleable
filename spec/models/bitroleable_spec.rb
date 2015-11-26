require 'rails_helper'

RSpec.describe Bitroleable, type: :model do
  context 'given a single role model' do
    let!(:user) { User.create(name: 'test', role: :admin) }

    it 'should be only admin' do
      expect(user.admin?).to be true
      expect(user.user?).to be false
      expect(user.moderator?).to be false

      expect(user.role).to eq :admin

      expect(User.where_role(:user).count).to eq 0
      expect(User.where_role(:admin).first).to eq user
      expect(User.where_role(:moderator).count).to eq 0
    end

    context 'when a role is changed' do
      before { user.moderator! }

      it 'should be only moderator' do
        expect(user.admin?).to be false
        expect(user.user?).to be false
        expect(user.moderator?).to be true

        expect(user.role).to eq :moderator

        expect(User.where_role(:user).count).to eq 0
        expect(User.where_role(:admin).count).to eq 0
        expect(User.where_role(:moderator).first).to eq user
      end
    end
  end

  context 'given a multi role model' do
    let!(:customer) { Customer.create(name: 'test', role: [:admin, :moderator]) }

    it 'should be only admin' do
      expect(customer.admin?).to be true
      expect(customer.user?).to be false
      expect(customer.moderator?).to be true

      expect(customer.role.sort).to eq [:admin, :moderator]

      expect(Customer.where_role(:user).count).to eq 0
      expect(Customer.where_role(:admin).count).to eq 1
      expect(Customer.where_role(:moderator).count).to eq 1

      expect(Customer.where_role(:admin).first).to eq customer
      expect(Customer.where_role(:moderator).first).to eq customer
    end

    context 'when a role is changed' do
      before { customer.role = [:admin, :user]; customer.save! }

      it 'should be only moderator' do
        expect(customer.admin?).to be true
        expect(customer.user?).to be true
        expect(customer.moderator?).to be false

        expect(customer.role.sort).to eq [:admin, :user]

        expect(Customer.where_role(:user).count).to eq 1
        expect(Customer.where_role(:admin).count).to eq 1
        expect(Customer.where_role(:moderator).count).to eq 0

        expect(Customer.where_role(:user).first).to eq customer
        expect(Customer.where_role(:admin).first).to eq customer
        expect(Customer.where_role(:admin, :user).first).to eq customer
      end
    end
  end
end
