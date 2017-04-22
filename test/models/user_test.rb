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
  def setup
    @user = User.new(name: 'Usuario',
                     lastname: 'Primero',
                     username: 'uprimero',
                     email: 'uprimero@gmail.com',
                     role: 'gambler',
                     password: 'password',
                     password_confirmation: 'password',
                     description: 'hola',
                     money: 0,
                     birthday: Date.today)
  end

  test 'usuario debiese ser valido' do
    assert @user.valid?
  end

  test 'nombre presente' do
    @user.name = '     '
    assert_not @user.valid?
  end

  test 'apellido presente' do
    @user.lastname = '     '
    assert_not @user.valid?
  end

  test 'email validos' do
    valid_addresses = %w[usuario@ejemplo.com USUARIO@algo.COM
                         A_US-ER@algo.otro.org primero.ultimo@algo.cl
                         juanperez@yahoo.es]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} debiese ser valido"
    end
  end

  test 'formato de nombre correcto' do
    not_valid_names = %w[ramon Juan-castro Nombre.invalido MalFormado]
    not_valid_names.each do |not_valid_name|
      @user.name = not_valid_name
      assert_not @user.valid?, "#{not_valid_name.inspect} no debiese ser valido"
    end
  end

  test 'largo de nombre correcto' do
    @user.name = 'Aa'
    assert_not @user.valid?
    @user.name = 'A' + 'a' * 50
    assert_not @user.valid?
  end

  test 'largo de apellido correcto' do
    @user.lastname = 'Aa'
    assert_not @user.valid?
    @user.lastname = 'A' + 'a' * 50
    assert_not @user.valid?
  end
end
