json.poll do
    json.id @poll.id
    json.subject @poll.subject
    json.status @poll.status
    json.options @poll.poll_options.map {
        |o| o.slice(:id, :title, :ballots_count)
    }
    json.created_at @poll.created_at
end