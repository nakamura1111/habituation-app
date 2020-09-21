class Habit < ApplicationRecord
  with_options presence: true do
    validates :name
    with_options numericality: { only_integer: true, allow_blank: true } do
      validates :difficulty_grade
      validates :achieved_or_not_binary
      validates :achieved_days
    end
    validates :is_active
  end

  belongs_to :target

  # ActiveHashによるアソシエーション
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :difficulty
end
