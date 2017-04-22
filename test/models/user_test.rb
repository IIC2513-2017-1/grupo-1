# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  role            :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  name            :string
#  lastname        :string
#  description     :string
#  money           :integer
#  birthday        :date
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'usuario invalido' do
    user = User.new
    assert_not user.save
    user = User.new(name: 'Usuario',
                    lastname: 'Primero',
                    username: 'uprimero',
                    email: 'uprimero',
                    role: 'gambler',
                    password: 'password',
                    password_confirmation: 'password',
                    description: 'hola',
                    money: 0,
                    birthday: Date.today)
    assert_not user.save
  end

  test 'usuario valido' do
    user = User.new(name: 'Usuario',
                    lastname: 'Primero',
                    username: 'uprimero',
                    email: 'uprimero@gmail.com',
                    role: 'gambler',
                    password: 'password',
                    password_confirmation: 'password',
                    description: 'hola',
                    money: 0,
                    birthday: Date.today)
    assert user.save
  end
end
