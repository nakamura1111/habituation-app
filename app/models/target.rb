class Target < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :content
    validates :point, numericality: { only_integer: true, allow_blank: true }
  end

  belongs_to :user
  
end
