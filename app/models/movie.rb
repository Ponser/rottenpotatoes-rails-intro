class Movie < ActiveRecord::Base
  
  ################################################################################
  # https://github.com/saasbook/hw-rails-intro#part-2-filter-the-list-of-movies-by-rating-15-points
  #
  def self.all_ratings
    return ['G', 'PG', 'PG-13', 'R'] # 'NC-17' and 'X' left out on purpose
  end
end
