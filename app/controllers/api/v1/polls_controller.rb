module Api
  module V1
    class PollsController < ApplicationController

      MAX_PAGINATION_LIMIT = 100

      before_action :authenticate_user!
      
      def index
        @polls = Poll.limit(limit).offset(params[:offset])
      end

      def show
        @poll = Poll.find(params[:id])
      end

      def create
        @poll = current_user.polls.build(
          poll_params
        )

        if @poll.save
          @poll
        else
          render json: @poll.errors, status: :unprocessable_entity 
        end
      end

      def user_created_polls
        @polls = current_user.polls
      end

      def user_voted_polls
        @polls = Poll.joins(:votes).where(votes: { user_id: current_user.id })
      end

      private

      def limit
        [
          params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i, 
          MAX_PAGINATION_LIMIT
        ].min
      end

      def poll_params
        params.require(:poll).permit(
          :subject,
          poll_options_attributes: [ :title ]      
        )
      end
    end
  end
end