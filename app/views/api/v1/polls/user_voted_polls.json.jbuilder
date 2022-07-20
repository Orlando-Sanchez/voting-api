json.array! @polls do |poll|
    json.id poll.id
    json.subject poll.subject
    json.status poll.status
end