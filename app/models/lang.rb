class Lang < ActiveRecord::Base
  has_many :snippets

  validates :name, :value, presence: true, allow_nil: false
end
