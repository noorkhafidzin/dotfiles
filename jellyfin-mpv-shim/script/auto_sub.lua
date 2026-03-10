-- auto_sub.lua
-- Auto-load subtitle Indonesia, jika tidak ada cycle ke subtitle pertama

local function find_and_set_subtitle()
    local keywords = {"id", "idn", "ind", "indonesian", "indonesia"}
    local track_count = mp.get_property_number("track-list/count", 0)
    local first_sub_id = nil
    local found = false

    for i = 0, track_count - 1 do
        local track_type = mp.get_property(string.format("track-list/%d/type", i))

        if track_type == "sub" then
            local track_id = mp.get_property_number(string.format("track-list/%d/id", i))

            -- Simpan subtitle pertama sebagai fallback
            if first_sub_id == nil then
                first_sub_id = track_id
            end

            -- Cek title dan lang
            local title = mp.get_property(string.format("track-list/%d/title", i)) or ""
            local lang  = mp.get_property(string.format("track-list/%d/lang", i))  or ""

            title = title:lower()
            lang  = lang:lower()

            for _, kw in ipairs(keywords) do
                if title:find(kw) or lang:find(kw) then
                    mp.set_property("sid", tostring(track_id))
                    mp.osd_message("Subtitle: Indonesia ditemukan → Track " .. track_id)
                    found = true
                    break
                end
            end

            if found then break end
        end
    end

    -- Fallback: cycle 1x → load subtitle pertama
    if not found then
        if first_sub_id ~= nil then
            mp.set_property("sid", tostring(first_sub_id))
            mp.osd_message("Subtitle Indonesia tidak ditemukan → Load subtitle pertama (Track " .. first_sub_id .. ")")
        else
            mp.osd_message("Tidak ada subtitle tersedia.")
        end
    end
end

-- Jalankan setelah file selesai di-load
mp.register_event("file-loaded", function()
    -- Delay kecil agar track-list sudah tersedia
    mp.add_timeout(0.5, find_and_set_subtitle)
end)