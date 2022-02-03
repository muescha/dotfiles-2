local elgato = {}

function elgato.zoomStart()
    if is_docked == false then
        _log("Not changing light because we are not docked.")
        return
    end

    for _, ip in ipairs(secrets.elgato.ips) do
        local url = "http://" .. ip .. ":9123/elgato/lights"
        local status, body, headers = hs.http.get(url)
        local settings = hs.json.decode(body)
        settings.lights[1].on = 1
        local status, response, header =
            hs.http.doRequest(url, "PUT", hs.json.encode(settings))
    end

    _log("Zoom lighting turned on.")
end

function elgato.zoomEnd()
    if is_docked == false then
        _log("Not changing light because we are not docked.")
        return
    end

    for _, ip in ipairs(secrets.elgato.ips) do
        local url = "http://" .. ip .. ":9123/elgato/lights"
        local status, body, headers = hs.http.get(url)
        local settings = hs.json.decode(body)
        settings.lights[1].on = 0
        local status, response, header =
            hs.http.doRequest(url, "PUT", hs.json.encode(settings))
    end
end

function elgato.init() _log("Elgato module loaded.") end

return elgato