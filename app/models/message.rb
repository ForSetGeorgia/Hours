class Message
  include ActiveAttr::Model
  include ActiveModel::Validations

  attribute :email
  attribute :subject
  attribute :message
  attribute :bcc
  attribute :locale, :default => I18n.locale

  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :message, :maximum => 500

end
