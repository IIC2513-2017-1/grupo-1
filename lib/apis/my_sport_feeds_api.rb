class MySportsFeedApi
  include HTTParty

  def initialize(season = '2016-regular', league = 'mlb')
    @api_key = ENV['API_KEY']
    @base_uri = 'https://www.mysportsfeeds.com/api/feed/pull/'
    @season = season
    @league = league
  end

  def daily_game_schedule(date)
    self.class.get("#{@base_uri}#{@league}/#{@season}/daily_game_schedule.json?fordate=#{date}",
                   headers: { Authorization: "Basic #{@api_key}" })['dailygameschedule']['gameentry']
  end

  def game_result(game_id)
    info = self.class.get("#{@base_uri}#{@league}/#{@season}/game_boxscore.json?gameid=#{game_id}",
                          headers: { Authorization: "Basic #{@api_key}" })
    home = info['gameboxscore']['inningSummary']['inningTotals']['homeScore']
    away = info['gameboxscore']['inningSummary']['inningTotals']['awayScore']
    home = home.to_i
    away = away.to_i
    if home > away
      1
    elsif away > home
      2
    else
      0
    end
  end

  def get_teams
    self.class.get("https://www.mysportsfeeds.com/api/feed/pull/mlb/2016-regular/overall_team_standings.json",
                   headers: { Authorization: "Basic #{@api_key}" })['overallteamstandings']['teamstandingsentry']
  end
end
