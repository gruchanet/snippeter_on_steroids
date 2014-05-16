class Snippet < ActiveRecord::Base
  belongs_to :lang

  validates :snippet, :lang_id, presence: true, allow_nil: false
  validates_length_of :description, maximum: 100

  module SearchScope
    def self.included(base)
      base.has_scope :snippet
      base.has_scope :lang_id
      base.has_scope :description
      # base.has_scope :created_at
      # base.has_scope :updated_at
    end
  end

  scope :snippet, ->(snippet) { where('snippet LIKE ?', "%#{snippet}%") }
  scope :lang_id, ->(lang_id) { where('lang_id = ?', lang_id) }
  scope :description, ->(description) { where('description LIKE ?', "%#{description}%") }
  # scope :created_at, ->(created_at) { where('created_at LIKE ', "%#{created_at}%") }
  # scope :updated_at, ->(updated_at) { where('updated_at LIKE ', "%#{updated_at}%") }
end