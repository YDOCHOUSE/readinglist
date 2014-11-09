class Book < ActiveRecord::Base
  
  scope :finished, ->{ where.not(finished_on: nil)}
  scope :recent, ->{ where('finished_on > ?', 2.days.ago)}
  #advanced search method. LIKE is a sql query, the ? signifies an unknown
  #we then serach through the keywords string the percentage signs on either side
  #mean search for this anywhere in the entire string. if the % was left of at the end
  #it would only query for this at the end of the string and vice versa
  scope :search, ->(keyword){ where('keywords LIKE ?', "%#{keyword.downcase}%") if keyword.present? }
  
  before_save :set_keywords

  def finished?
  	finished_on.present?
  end

  protected #we don't want to call this from public api
  def set_keywords
  	self.keywords = [title, author, description].map(&:downcase).join(' ')
  end

end
