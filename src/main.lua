local parser = require("parser")
local analyzer = require("analyzer")
local file = "../data/message_1_utf8.json"
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
local avg_times = analyzer.avg_response_time(time_list,"m",24*3600)

for user, avg in pairs(avg_times) do
    print(user .. " takes on average to respond: " .. avg .. " minutes")
end

print("------------------------------------------------")
local threshold_seconds = 34 * 3600 -- Filtrar tiempos mayores a 7 horas

local median_times = analyzer.median_response_time(time_list, "s", threshold_seconds)

for user, median in pairs(median_times) do
    print(user .. " tarda en responder en mediana: " .. median .. " segundos")
end

print("------------------------------------------------")
-- Llamar a la nueva función para obtener el tiempo más rápido y más lento
local min_threshold = 2  -- Solo contar tiempos mayores a 2 segundos
local extremes = analyzer.response_extremes(time_list, min_threshold)

for user, times in pairs(extremes) do
    print(user .. " - Fastest response: " .. (times.fastest or "No data") .. " seconds")
    print(user .. " - Slowest response: " .. (times.slowest or "No data") .. " seconds")
end
