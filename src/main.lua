local parser = require("parser")
local analyzer = require("analyzer")
local file = "../data/message_1_utf8.json"
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
local count = analyzer.count_messages(chat_data)

print("------------------------------------------")
print("messages send by each one")

for name, quantity in pairs(count) do 
    print("-",name .. ": " .. quantity)
end
