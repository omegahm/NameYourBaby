class DecidedName < ApplicationRecord
  belongs_to :user
  belongs_to :name

  scope :liked, ->(user) { where(user: user, decision: true).joins(:name).order("names.name") }
  scope :liked_by_all, -> { where(decision: true).group(:name_id).having("COUNT(*) = ?", 2) }
end
