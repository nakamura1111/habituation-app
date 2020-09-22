class Habit < ApplicationRecord
  validates :content, length: { maximum: 500 }
  with_options presence: true do
    validates :name, length: { maximum: 50 }
    with_options numericality: { only_integer: true, allow_blank: true } do
      validates :difficulty_grade 
      validates :achieved_or_not_binary 
      validates :achieved_days, numericality: { less_than: 1_000_000_000, allow_blank: true } 
    end
  end
  validates :is_active, inclusion: { in: [true, false]}
  
  belongs_to :target

  # ActiveHashによるアソシエーション
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :difficulty
end
