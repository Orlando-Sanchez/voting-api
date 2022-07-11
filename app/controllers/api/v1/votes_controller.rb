module Api
  module V1
    class VotesController < ApplicationController
      
      before_action :authenticate_user!
      before_action :current_user_voted?

      def create
        @vote = current_user.votes.build(
          :poll_id => @poll.id
        )

        if @vote.save
          @vote
        else
          render json: vote.errors, status: :unprocessable_entity 
        end
      end

      private
    
      def current_user_voted?
        @poll = Poll.find(params[:poll_id])

        if @poll.votes.where(user_id: current_user.id).exists?
          render json: { message: 'User already voted in this poll.' }, status: :unprocessable_entity
        end
      end
    end
  end
end