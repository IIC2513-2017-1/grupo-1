module Api::V1
  class BetsController < ApiController
    before_action :authenticate

    def index
      @bets = Bet.current_bets.order(:start_date).includes(
        :competitors, :selections, :competitors_per_bet
      )
      @contents = get_contents(@bets)
    end

    private

    def empate?(bet)
      sport = bet.sport
      return 1 if sport == 'football'
      0
    end

    def get_percentage(bet, competitor)
      total = bet.selections.length
      total = 1 if total.zero?
      participate = bet.selections.where(selection: competitor).length
      if competitor == -1
        multiplicator = bet.pay_per_tie
      else
        multiplicator = bet.competitors_per_bet.find_by_competitor_id(
          competitor
        ).multiplicator
      end
      "#{participate * 100 / total}% - x#{multiplicator}"
    end

    def get_contents(bets)
      contents = {}
      bets.each do |bet|
        content = []
        if empate?(bet) == 1
          content << ["Empate #{get_percentage(bet, -1)}", -1]
        end
        bet.competitors.each do |competitor|
          content << [
            "#{competitor.name} #{get_percentage(bet, competitor.id)}",
            competitor.id
          ]
        end
        contents[bet.id] = content
      end
      contents
    end
  end
end
