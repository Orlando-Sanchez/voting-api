module Api
    module V1
        class PollsController < ApplicationController

            MAX_PAGINATION_LIMIT = 100

            before_action :authenticate_user!
            
            def index
                polls = Poll.limit(limit).offset(params[:offset])
        
                render json: PollsRepresenter.new(polls).as_json
            end

            def show
                poll = Poll.find(params[:id])

                render json: PollRepresenter.new(poll).as_json
            end

            def create
                poll = Poll.new(poll_params)

                if poll.save
                    render json: PollRepresenter.new(poll).as_json, status: :created
                else
                    render json: poll.errors, status: :unprocessable_entity 
                end
            end

            def destroy
                Poll.find(params[:id]).destroy!

                head :no_content
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