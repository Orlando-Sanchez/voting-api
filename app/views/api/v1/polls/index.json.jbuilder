json.array! @polls do |poll|
    json.id poll.id
    json.status poll.status
    json.subject poll.subject
    json.options poll.poll_options.map {
        |o| o.slice(:id, :title)
    }
    json.created_at poll.created_at
end