class Car < ApplicationRecord
  paginates_per 20

  belongs_to :brand
end
