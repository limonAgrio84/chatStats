-- parser.lua
local dkjson = require("dkjson")  -- Importar dkjson

local function read_json(filename)
    local file = io.open(filename, "r")  -- Abrir el archivo
    if not file then
        error("No se pudo abrir el archivo: " .. filename)
    end

    local content = file:read("*all")  -- Leer todo el contenido del archivo
    file:close()  -- Cerrar el archivo

    -- Decodificar el JSON
    local data, pos, err = dkjson.decode(content, 1, nil)
    if err then
        error("Error al leer el JSON: " .. err)
    end

    return data  -- Devolver los datos decodificados
end

return { read_json = read_json }