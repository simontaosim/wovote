class Comment
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
  belongs_to :account
  belongs_to :vote
  belongs_to :option
  belongs_to :analysis
  belongs_to :comment
  embeds_many :comments

  # field <name>, :type => <type>, :default => <value>
  field :content, :type => String

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
