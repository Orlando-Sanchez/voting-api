module Api
  module V1
    class VotesController < ApplicationController

      before_action :poll

      def create
        vote = current_user.votes.build(
          :poll_id => @_poll.id
        )

        if vote.save
          render json: vote, status: :created
        else
          render json: vote.errors, status: :unprocessable_entity 
        end
      end

      private

      def poll
        @_poll = Poll.find(params[:poll_id])
      end
    end
  end
end