class Recipe < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :cook_time, :description
  validates_uniqueness_of :name

  def slug
  #  binding.pry
    self.name.downcase.gsub(" ", "-") if self.name
  end

  def self.find_by_slug(slug)
    self.all.find{|instance| instance.slug == slug}
  end
end
