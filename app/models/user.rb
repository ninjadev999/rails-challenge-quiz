class User < ApplicationRecord
  has_secure_password

  has_many :calendars
  has_many :events

  # TODO validate the presence of name and email
  ################################################
  # TODO validate the format of the email with
  # this regex
  #
  # /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  #
  # and ensure it is unique and not case sensitive
  ################################################
  # TODO validate that there are at least
  # two words in the name column

  before_validation :format_email, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Email field should not be empty.'}
  validates :name, presence: true, format: { with: /\A[A-z]+(?:\s[A-z]+)+\z/, message: "Name field should have at least two words"}
  validate :validate_agent

  validates_uniqueness_of :email, on: :create

  after_create :create_calendar

  def access_token(user_agent)
    # TODO flesh out the JsonWebToken encode
    # method in the lib/util/json_web_token.rb
    # file
    Util::JsonWebToken.encode(self, user_agent)
  end

  class << self
    def authenticate(email, password)
      # TODO authenticate the user via the email
      # and password passed in
      #
      # If the user exists and the password is
      # valid respond with the user
      #
      # Else respond with nil
      if email.present? && password.present?
        @current_user = User.where(email: email).first
        return @current_user if @current_user && @current_user.authenticate(password)
      end

      nil
    end
  end

  private

  def create_calendar
    Calendar.create!(title: name, user_id: id)
  end

  def format_email
    unless email.present?
      errors.add(:happened_at, 'Email field should not be empty.')
    else
      self.email = email.downcase
    end
  end

  def validate_agent
    self.agent = 'Rails Testing' unless agent.present?
  end
end
