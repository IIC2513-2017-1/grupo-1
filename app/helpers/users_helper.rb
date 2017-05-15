module UsersHelper
  def full_name(user)
    user.name + ' ' + user.lastname
  end
end
