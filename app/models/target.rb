# 目標に関するデータを管理するためのモデル
class Target < ApplicationRecord
  with_options presence: true do
    validates :name, length: { maximum: 20, allow_blank: true }
    validates :content, length: { maximum: 500, allow_blank: true }
    with_options numericality: { only_integer: true, allow_blank: true } do
      validates :point
      validates :level
      validates :exp
    end
  end

  belongs_to :user
  has_many :habits
end
