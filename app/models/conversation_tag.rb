class ConversationTag < ActiveRecord::Base
  include Owned

  belongs_to :conversation
  belongs_to :tag

  validates :conversation, presence: true, same_owner: true
  validates :tag, presence: true, same_owner: true

  validates :tag, uniqueness: { :scope => :conversation }, allow_blank: true

  delegate :name, to: :tag, prefix: true
end
