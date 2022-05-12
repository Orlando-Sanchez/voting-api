module Api
    module V1
        class PollsController < ApplicationController
            def index
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

            def poll_params
                params.require(:poll).permit(:subject)
            end
        end
    end
end