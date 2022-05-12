module Api
    module V1
        class PollsController < ApplicationController

            MAX_PAGINATION_LIMIT = 100
            
            def index
                polls = Poll.limit(limit).offset(params[:offset])
        
                render json: PollsRepresenter.new(polls).as_json
            end

            def show
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
            end

            private

            def limit
                [
                  params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i, 
                  MAX_PAGINATION_LIMIT
                ].min
            end

            def poll_params
                params.require(:poll).permit(:subject)
            end
        end
    end
end