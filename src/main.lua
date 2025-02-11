local parser = require("parser")
local analyzer = require("analyzer")
local file = "../data/message_1.json"
local chat_data = parser.read_json(file)

print("Chat entre:")
for _, person in ipairs(chat_data.participants) do 
    print("-", person.name)
end


--print("Message in the conversation:")
--for _, message in ipairs(chat_data.messages) do 
--    if message.content then
--        print(message.sender_name .. ": " .. message.content)
--    end
--end
    
--contar mensajes
local count = analyzer.count_messages(chat_data)

print("------------------------------------------")
print("messages send by each one")

for name, quantity in pairs(count) do 
    print("-",name .. ": " .. quantity)
end


--test tiempo 
local time_list = analyzer.count_time(chat_data)
--print("------------------------------------------")
--print("Timestamps por usuario:")

--for name, timestamps in pairs(time_list) do
--    print(name .. ":")
--    local max_print = math.min(#timestamps, 20) -- Limita a 20 o menos si hay menos de 20 elementos
--    for i = 1, max_print do
--        print("   - " .. timestamps[i])
--    end
--end

print("------------------------------------------------")
local avg_times = analyzer.avg_response_time(time_list, "m")

for user, avg in pairs(avg_times) do
    print(user .. " tarda en responder en promedio: " .. avg .. " minutos")
end