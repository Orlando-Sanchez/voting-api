module Api
  module V1
    class PollsController < ApplicationController

      skip_before_action :authenticate_user!, only: [:index, :show]
      
      def index
        @pagy, @polls = pagy(Poll.all)
      end

      def show
        @poll = Poll.find(params[:id])
      end

      def create
        @poll = current_user.polls.build(
          poll_params
        )

        if @poll.save
          ClosePollJob.set(wait_until: @poll.created_at + 1.day).perform_later(@poll.id)
          @poll
        else
          render json: @poll.errors, status: :unprocessable_entity 
        end
      end

      def user_created_polls
        @pagy, @polls = pagy(current_user.polls)
      end

      def user_voted_polls
        @pagy, @polls = pagy(Poll.joins(:votes).where(votes: { user_id: current_user.id }))
      end

      private

      def poll_params
        params.require(:poll).permit(
          :subject,
          poll_options_attributes: [ :title ]      
        )
      end
    end
  end
end