class Event < ApplicationRecord
  belongs_to :user
  belongs_to :calendar

  validates :title, :start_time, :end_time, presence: true
  validate :validate_start_before_end

  # TODO see method at the bottom of this page
  validate :validate_calendar_owner, on: :create

  default_scope { where(deleted: false) }

  def validate_start_before_end
    # TODO if the start_time is before the
    # end_time add an error
    errors.add(:happened_at, 'start_time should be before the end_time') unless start_time.present? && end_time.present? && (start_time < end_time)
  end

  def validate_calendar_owner
    # TODO validate that the user_id passed in
    # is the owner of the calendar_id passed in
    errors.add(:happened_at, 'the user_id passed in should be the owner of the calendar_id passed in') unless user.present? && calendar.present? && calendar.user.present? && (user.id == calendar.user.id)
  end

end
