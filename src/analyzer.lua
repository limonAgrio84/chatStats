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

--agrupar los timestamp en una lista 
local function count_time(chat_data)
    local time_list = {}

    for _, message in ipairs(chat_data.messages) do
        if message.sender_name and message.timestamp_ms then 
            --si el usuario ya tiene una lista agregar el timestamp
            if time_list[message.sender_name] then
                table.insert(time_list[message.sender_name], message.timestamp_ms)
            else
                --darle su propia lista al usuario 
                time_list[message.sender_name] = {message.timestamp_ms}
            end
        end
    end
    return time_list
end

-- Función para redondear a 2 decimales
local function round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end
-- sumar los timestamp de cada usuario
-- Sumar los timestamp de cada usuario y calcular el promedio
-- Sumar los timestamp de cada usuario y calcular el promedio
-- Función para calcular el tiempo promedio de respuesta en la unidad deseada
local function avg_response_time(time_list, unit)
    local avg_times = {}
    local unit_conversion = {s = 1, m = 60, h = 3600} -- 🔹 Conversión de unidades

    if not unit_conversion[unit] then
        error("Unidad no válida. Usa 's' para segundos, 'm' para minutos o 'h' para horas.")
    end

    for user, timestamps in pairs(time_list) do
        table.sort(timestamps) -- 🔹 Ordenar timestamps en orden ascendente

        local total_time = 0
        local count = 0

        -- Recorrer los timestamps para calcular el tiempo entre mensajes
        for i = 2, #timestamps do
            local diff = (timestamps[i] - timestamps[i - 1]) / 1000 -- 🔹 Convertir de ms a s
            total_time = total_time + diff
            count = count + 1
        end

        -- Evitar división por 0
        if count > 0 then
            avg_times[user] = round((total_time / count) / unit_conversion[unit]) -- 🔹 Convertir a la unidad deseada
        else
            avg_times[user] = 0
        end
    end

    return avg_times
end




return {
    count_messages = count_messages,
    count_time = count_time, 
    avg_response_time = avg_response_time
}