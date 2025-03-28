class Name < ApplicationRecord
  validates_presence_of :name, :gender
  validates_uniqueness_of :name

  GENDER = { male: "male", female: "female", unisex: "unisex" }.freeze
  enum :gender, GENDER
  validates :gender, inclusion: { in: GENDER.values }

  scope :i_havent_seen_yet, ->(user) {
    where.not(id: user.decided_names.select(:name_id))
  }

  scope :agreed, -> do
    # Get total number of users
    user_count = User.count

    # Find names that have been liked by all users
    liked_by_all = DecidedName.where(decision: true)
                             .group(:name_id)
                             .having("COUNT(DISTINCT user_id) = ?", user_count)
                             .select(:name_id)

    where(id: liked_by_all)
  end

  class << self
    def random
      Name.order("RANDOM()").first
    end
  end

  def gender_symbol
    {
      "male" => "♂️",
      "female" => "♀️",
      "unisex" => "⚥"
    }.fetch(gender)
  end

  def gender_color
    {
      "male" => "info",
      "female" => "secondary-content",
      "unisex" => "accent"
    }.fetch(gender)
  end
end
