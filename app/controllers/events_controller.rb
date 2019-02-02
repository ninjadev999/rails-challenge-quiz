class EventsController < ApplicationController
  # before_action :find_event, only: [:show, :update]
  def create
    # TODO create a new event that takes in the
    # params[:event][:title], params[:event][:note],
    # params[:event][:start_time], params[:event][:end_time],
    # user_id: current_user.id, calendar_id: params[:calendar_id]
    #
    # If the event saves respond with the event and
    # a status code of 200
    #
    # Else send a message leveraging the instance_error_message
    # to send the error full message or default message and
    # a status code of 422
    event = Event.new(
        user_id: current_user.id, 
        calendar_id: params[:calendar_id],
        title: params[:event][:title],
        note: params[:event][:note],
        start_time: params[:event][:start_time],
        end_time: params[:event][:end_time]
    )
    
    if event.save
      return render json: { event: event }, status: :ok
    end
    
    render json: {
      message: instance_error_message(
        event,
        'We were unable to save your event'
      )
    }, status: :unprocessable_entity
  end

  def show
    # TODO find the event from the params[:id]
    #
    # Ensure that the belongs to the calendar
    # from the params[:calendar_id] and the
    # current_user id
    #
    # If the event is not found respond with
    # a message and a status code of 404
    #
    # Respond with this event or nil

    return render json: { event: @event }, status: :ok if find_event.present? and check_validation
    render json: {
      message: instance_error_message(
        @event, 
        'We were unable to not found the event'
      )
    }, status: :not_found 
  end

  def update
    # TODO find the event from the params[:id]
    #
    # Ensure that the belongs to the calendar
    # from the params[:calendar_id] and the
    # current_user id
    #
    # If the event is not found respond with
    # a message and a status code of not found
    #
    # If the event is found and valid, update
    # it from the params passed in of
    # :title, :note, :start_time, :end_time
    #
    # If that is successful respond with the
    # event and a status code of ok
    #
    # Else send a message leveraging the
    # instance_error_message to send the error
    # full message or default message and
    # a status code of 422
    if find_event.present? and check_validation
      if @event.update(event_params)
        render json: { event: @event }, status: :ok
      else
        render json: {
          message: instance_error_message(
            @event, 
            'We were unable to process this event'
          )
        }, status: :unprocessable_entity 
      end
    else
      render json: {
        message: instance_error_message(
          @event, 
          'We were unable to not found the event'
        )
      }, status: :not_found  
    end
  end

  def delete
    # TODO find the event from the params[:id]
    # Ensure that the belongs to the calendar
    # from the params[:calendar_id] and
    # the current_user id
    #
    # If the event is not found respond with
    # a message and a status code of not found
    #
    # If the event is found and valid, mark it
    # as deleted with the mark_deleted method
    # from the model concern FlagDeleted
    #
    # If that works, respond with a message
    # and a status code of ok
    #
    # If it fails to mark as deleted, respond
    # with a message leveraging the
    # instance_error_message to send the error
    # full message or default message and
    # a status code of 422
    if find_event.present? and check_validation
      if @event.delete
        render json: { message: 'We deleted this event' }, status: :ok
      else
        render json: {
          message: instance_error_message(
            @event, 
            'We were unable to process this event'
          )
        }, status: :unprocessable_entity 
      end
    else

      render json: {
        message: instance_error_message(
          nil, 
          'We were unable to not found the event'
        )
      }, status: :not_found  
    end
  end

  private

  def create_params
    params.permit(:calendar_id, :event)
  end

  def event_params
    params.require(:event).permit(:title, :note, :start_time, :end_time)
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def check_validation
    !@event.nil? and (@event.user_id == current_user.id) and (@event.calendar_id == params[:calendar_id].to_i)
  end

end
