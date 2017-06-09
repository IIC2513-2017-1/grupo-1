# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  username            :string
#  role                :string
#  email               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  password_digest     :string
#  name                :string
#  lastname            :string
#  description         :string
#  money               :integer
#  birthday            :date
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  email_confirmed     :boolean
#  confirm_token       :string
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

  test 'formato de nombre incorrecto' do
    not_valid_names = %w[Juan,castro Nombre.invalido Malformado9]
    not_valid_names.each do |not_valid_name|
      @user.name = not_valid_name
      assert_not @user.valid?, "#{not_valid_name.inspect} no debiese ser valido"
    end
  end

  test 'formato de apellido correcto' do
    valid_lastnames = ['del Real', 'Castro', 'Ruiz-Tagle']
    valid_lastnames.each do |valid_lastname|
      @user.name = valid_lastname
      assert @user.valid?, "#{valid_lastname.inspect} debiese ser valido"
    end
  end

  test 'largo de nombre correcto' do
    @user.name = 'A'
    assert_not @user.valid?
    @user.name = 'A' + 'a' * 50
    assert_not @user.valid?
  end

  test 'largo de apellido correcto' do
    @user.lastname = 'A'
    assert_not @user.valid?
    @user.lastname = 'A' + 'a' * 50
    assert_not @user.valid?
  end

  test 'dinerin positivo' do
    @user.money = -1
    assert_not @user.valid?
  end
end
