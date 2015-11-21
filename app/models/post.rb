class Post < ActiveRecord::Base
  validates :title, :sub_id, :user_id, presence: true

  belongs_to :subreddit,
    class_name: "Sub",
    foreign_key: :sub_id,
    primary_key: :id

  belongs_to :author,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :post_subs,
    foreign_key: :post_id,
    primary_key: :id,
    class_name: "PostSub"

  has_many :subs,
    through: :post_subs,
    source: :sub

end
