local parser = require("parser")
local analizer = require("analizer")
local file = "../data/your_instagram_activity/messages/inbox/ksenia_1007825067465099/message_1.json"
local chat_data = parser.read_json(file)

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
    
--contar mensajes
local count = analizer.count_messages(chat_data)

print("messages send by each one")

for name, quantity in pairs(count) do 
    print(name .. ": " .. quantity)
end
