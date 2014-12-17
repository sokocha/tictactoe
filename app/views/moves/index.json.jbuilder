json.array!(@moves) do |move|
  json.extract! move, :id, :user_id, :match_id, :square_id, :value
  json.url move_url(move, format: :json)
end
