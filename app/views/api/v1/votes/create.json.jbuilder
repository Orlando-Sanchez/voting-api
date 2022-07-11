json.vote do
    json.id @vote.id
    json.poll_id @vote.poll_id
    json.user_id @vote.user_id
end