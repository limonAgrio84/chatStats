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
-- Función para calcular el tiempo promedio de respuesta en la unidad deseada
local function avg_response_time(time_list, unit, threshold)
    local avg_times = {}
    local unit_conversion = {s = 1, m = 60, h = 3600} -- 🔹 Conversión de unidades
    local default_threshold = 7 * 3600 -- 🔹 7 horas (25,200 segundos)

    -- Si no se proporciona un umbral, usar el predeterminado
    threshold = threshold or default_threshold 

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
            
            -- 🔹 Filtrar tiempos de respuesta atípicos (mayores a 7 horas por defecto)
            if diff <= threshold then
                total_time = total_time + diff
                count = count + 1
            end
        end

        -- Evitar división por 0 y redondear a 2 decimales
        if count > 0 then
            avg_times[user] = round((total_time / count) / unit_conversion[unit], 2)
        else
            avg_times[user] = 0
        end
    end

    return avg_times
end

--mediana 
-- Función para calcular la mediana de tiempos de respuesta por usuario
local function median_response_time(time_list, unit, threshold)
    local median_times = {}
    local unit_conversion = {s = 1, m = 60, h = 3600} -- Conversión de unidades

    if not unit_conversion[unit] then
        error("Unidad no válida. Usa 's' para segundos, 'm' para minutos o 'h' para horas.")
    end

    for user, timestamps in pairs(time_list) do
        table.sort(timestamps) -- Ordenar timestamps en orden ascendente

        local response_times = {}

        -- Calcular tiempos de respuesta
        for i = 2, #timestamps do
            local diff = (timestamps[i] - timestamps[i - 1]) / 1000 -- Convertir de ms a s
            if diff <= threshold then -- Filtrar tiempos atípicos
                table.insert(response_times, diff)
            end
        end

        -- Calcular la mediana
        local count = #response_times
        if count == 0 then
            median_times[user] = 0 -- Si no hay respuestas válidas
        else
            table.sort(response_times) -- Ordenar tiempos de respuesta
            local mid = math.floor(count / 2)

            if count % 2 == 0 then
                median_times[user] = (response_times[mid] + response_times[mid + 1]) / (2 * unit_conversion[unit])
            else
                median_times[user] = response_times[mid + 1] / unit_conversion[unit]
            end
        end
    end

    return median_times
end

-- Función para calcular el tiempo de respuesta más rápido y más lento
local function response_extremes(time_list, min_threshold)
    local extremes = {}
    min_threshold = min_threshold or 1  -- 🔹 Evitar tiempos menores a 1 segundo (puedes ajustarlo)

    for user, timestamps in pairs(time_list) do
        table.sort(timestamps)  -- Ordenar los timestamps

        local min_response_time = math.huge  -- Inicializamos con un valor alto
        local max_response_time = -math.huge -- Inicializamos con un valor bajo

        -- Recorrer los timestamps y calcular las diferencias
        for i = 2, #timestamps do
            local diff = (timestamps[i] - timestamps[i - 1]) / 1000  -- Convertir de ms a s

            -- Aplicar umbral para evitar valores irreales
            if diff >= min_threshold then
                -- Encontrar el tiempo de respuesta más rápido
                if diff < min_response_time then
                    min_response_time = diff
                end

                -- Encontrar el tiempo de respuesta más lento
                if diff > max_response_time then
                    max_response_time = diff
                end
            end
        end

        -- Si no hay valores válidos, asignamos `nil` para evitar errores
        if min_response_time == math.huge then
            min_response_time = nil
        end
        if max_response_time == -math.huge then
            max_response_time = nil
        end

        -- Guardar los resultados para cada usuario
        extremes[user] = {
            fastest = min_response_time or "No data",
            slowest = max_response_time or "No data"
        }
    end

    return extremes
end

return {
    count_messages = count_messages,
    count_time = count_time,
    avg_response_time = avg_response_time,
    median_response_time= median_response_time,
    response_extremes = response_extremes
}
