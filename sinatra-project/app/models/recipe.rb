class Recipe < ActiveRecord::Base
  belongs_to :user

  def slug
    #binding.pry
    self.name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find{|instance| instance.slug == slug}
  end

  # def username
  #   if self.user
  #     user.username
  #   else
  #     ""
  #   end
  # end
  #
  # def user_name=(name)
  #   user = User.find_by(name:username)
  #   if user
  #     self.user = user
  #   else
  #     self.user = User.create(name: username)
  #   end
  # end
end
