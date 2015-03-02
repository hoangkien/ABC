class Feedback < ActiveRecord::Base
  belongs_to :traveller
  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("quantiy_service like ?", "%#{query}%")
  end
end
