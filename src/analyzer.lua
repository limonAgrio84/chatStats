local function count_messages(chat_data)
    local count = {}

    --recorrer mensajes
    for _, message in ipairs(chat_data.messages) do
        if message.sender_name then
            if count[message.sender_name] then
                count[message.sender_name] = count[message.sender_name] + 1
            else 
                count[message.sender_name] = 1
            end
        end
    end
    return count
end

return {count_messages = count_messages}