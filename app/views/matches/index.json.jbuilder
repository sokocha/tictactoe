json.array!(@matches) do |match|
  json.extract! match, :id, :player_x, :player_o
  json.url match_url(match, format: :json)
end
