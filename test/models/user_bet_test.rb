# == Schema Information
#
# Table name: user_bets
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :string
#  user_id           :integer
#  challenger_amount :integer
#  gambler_amount    :integer
#  bet_limit         :integer
#  start_date        :datetime
#  end_date          :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class UserBetTest < ActiveSupport::TestCase
  setup do
    @user_bet = user_bets(:one)
    @user = users(:one)
  end

  test 'apuesta valida' do
    assert @user_bet.valid?
  end

  test 'usuario apuesta invalido' do
    numeros_invalidos = [-1, 1.5, 0]
    numeros_invalidos.each do |invalid_numbers|
      @user_bet.gambler_amount = invalid_numbers
      assert_not @user_bet.valid?
    end
  end

  test 'nombre de apuesta invalido' do
    lista_nombres_invalidos = [nil, '', 'partid', 'corto']
    lista_nombres_invalidos.each do |invalid_name|
      @user_bet.name = invalid_name
      assert_not @user_bet.valid?
    end
  end

  test 'no acepta fechas pasadas' do
    @user_bet.start_date = DateTime.current
    5.times do
      assert_not @user_bet.valid?
      @user_bet.start_date -= 1.days
    end
  end

  test 'acepta fechas' do
    5.times do
      @user_bet.start_date += 1.weeks
      @user_bet.end_date += 1.weeks
      assert @user_bet.valid?
    end
  end

  test 'no acepta fechas intercambiadas' do
    tmp = @user_bet.start_date
    @user_bet.start_date = @user_bet.end_date
    @user_bet.end_date = tmp
    assert_not @user_bet.valid?
  end
end
