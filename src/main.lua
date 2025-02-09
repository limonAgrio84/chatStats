local parser = require("parser")

local chat_data = parser.read_json("../data/message_1.json")

print("Chat entre:")
for _, person in ipairs(chat_data.participants) do 
    print("-", person.name)
end

print("Message in the conversation:")
for _, message in ipairs(chat_data.messages) do 
    if message.content then
        print(message.sender_name .. ": " .. message.content)
    end
end
    
