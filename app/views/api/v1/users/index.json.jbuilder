
json.users do
  json.href api_v1_users_url
  json.users do
    json.array! @users.each do |user|
      json.id user.id
      json.username user.username
    end
  end
end
