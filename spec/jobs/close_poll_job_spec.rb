require 'rails_helper' 
Sidekiq::Testing.fake!

# require 'rails_helper'

RSpec.describe ClosePollJob, :type => :job do
    let!(:first_user) { FactoryBot.create(:user, email: 'first@user.com', password: 'firstuser') }   
    let!(:poll) { FactoryBot.create(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }
    describe "#perform_later" do           
        it "closes the poll" do  
            ActiveJob::Base.queue_adapter = :test
            expect {
                ClosePollJob.set(wait: 1.day, queue: "default").perform_later(Poll.first)
            }.to have_enqueued_job.with(Poll.first).on_queue("default").at(1.day)
        end
    end
end