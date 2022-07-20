module Api
  module V1
    class VotesController < ApplicationController
      
      before_action :authenticate_user!
      before_action :current_user_voted?
      before_action :poll_closed?

      def create
        ballot = Ballot.new(ballot_params)

        if ballot.save          
          @vote = current_user.votes.build(
            :poll_id => @poll.id
          )
          if @vote.save
            @vote
          else
            render json: vote.errors, status: :unprocessable_entity 
          end
        else
          render json: ballot.errors, status: :unprocessable_entity 
        end
      end

      private

      def ballot_params
        params.permit(:poll_option_id)
      end
    
      def current_user_voted?
        @poll = Poll.find(params[:poll_id])

        if @poll.votes.where(user_id: current_user.id).exists?
          render json: { message: 'User already voted in this poll.' }, status: :unprocessable_entity
        end
      end

      def poll_closed?
        @poll = Poll.find(params[:poll_id])

        if @poll.status_closed?
          render json: { message: 'This poll has closed.' }, status: :unprocessable_entity
        end
      end
    end
  end
end