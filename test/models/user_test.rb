# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'require username' do
    u = User.new
    u.password = 'password'
    u.name = 'name'
    assert_not u.save, 'Saved the user without a username'
    u.username = 'user'
    assert u.save, 'Could not save user with a username'
  end

  test 'require password' do
    u = User.new
    u.name = 'name'
    u.username = 'user'
    assert_not u.save, 'Saved the user without a password'
    u.password = 'password'
    assert u.save, 'Could not save user with a password'
  end

  test 'username uniqueness' do
    u = User.new(username: 'user', password: 'pass', name: 'name')
    u2 = User.new(username: 'user', password: 'pass', name: 'name')
    assert u.save
    assert_not u2.save, 'User saved with non-unique username'
    u2.username = 'user2'
    assert u2.save
  end
end
