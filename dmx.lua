if _G.DMX_CLEANUP then pcall(_G.DMX_CLEANUP) end

local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
local UIS         = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local TAU = math.pi * 2

local function cl(x, a, b) return math.min(b or 1, math.max(a or 0, x)) end
local function jcopy(t) return HttpService:JSONDecode(HttpService:JSONEncode(t)) end

local TYPES = {
    clara = { name = "Clara S 14R", ch = 16, pos = true, ds = { dim = true },
        shut = { key = "strobe", open = 208 / 255, closed = 0 },
        loc = { pan = .5, tilt = .5, strobe = 208 / 255 }, p = {
        { "dim", "Dimmer", 8, 0 }, { "strobe", "Strobe", 7, 208 / 255 }, { "pan", "Pan", 1, .5, 3 }, { "tilt", "Tilt", 2, .5, 4 },
        { "speed", "XY Speed", 5, 0 }, { "color", "Color", 9, 0 }, { "frost", "Frost", 6, 0 }, { "gobo", "Gobo", 10, 0 },
        { "gobor", "Gobo Rot", 11, 0 }, { "prism", "Prism", 12, 0 }, { "prism2", "Prism 2", 14, 0 }, { "prot", "Prism Rot", 15, 0 },
        { "focus", "Focus", 13, .5 }, { "ctrl", "Control", 16, 0 } } },

    strobe = { name = "Strobe 1000W", ch = 8, pos = false, ds = { int = true }, p = {
        { "int", "Int", 1, 0 }, { "shutter", "Shutter", 2, 0 }, { "macro1", "Macro 1", 3, 0 }, { "macro2", "Macro 2", 4, 0 },
        { "cont2", "Cont 2", 5, 0 }, { "fx2", "FX 2", 6, 0 }, { "pos6", "Pos 6", 7, 0 }, { "col1", "Col 1", 8, 0 } } },

    mapple = { name = "3M Apple Leaf", ch = 16, pos = false, ds = { adim = true, rdim = true, bdim = true },
        loc = { astrobe = 0, rstrobe = 0, amac = 0, rmac = 0, bmac = 0 }, p = {
        { "mpos", "Motor Pos", 1, 0 }, { "mmode", "Motor Mode", 2, 0 },
        { "adim", "Amber Dim", 3, 0 }, { "astrobe", "Amber Strobe", 4, 0 }, { "acol", "Amber Seg", 5, 240 / 255 },
        { "rdim", "RGB Dim", 6, 0 }, { "rstrobe", "RGB Strobe", 7, 0 },
        { "rc1", "RGB 1", 8, 240 / 255 }, { "rc2", "RGB 2", 9, 240 / 255 }, { "rc3", "RGB 3", 10, 240 / 255 },
        { "bdim", "Beam Dim", 11, 0 }, { "bcol", "Beam Color", 12, 230 / 255 },
        { "amac", "Amber Macro", 13, 0 }, { "rmac", "RGB Macro", 14, 0 }, { "bmac", "Beam Macro", 15, 0 } } },

    parled = { name = "Parled", ch = 6, pos = false, ds = { dim = true },
        loc = { r = 1, g = 1, b = 1, w = 0, strobe = 0 }, p = {
        { "dim", "Dimmer", 1, 0 }, { "r", "Red", 2, 1 }, { "g", "Green", 3, 1 }, { "b", "Blue", 4, 1 },
        { "w", "White", 5, 0 }, { "strobe", "Strobe", 6, 0 } } },

    fogger = { name = "Fogger 900W", ch = 1, pos = false, ds = {}, p = {
        { "fog", "Fog", 1, 0 } } },

    blinder = { name = "Blinder 4x100", ch = 4, pos = false, ds = { d1 = true, d2 = true, d3 = true, d4 = true }, p = {
        { "d1", "LED 1", 1, 0 }, { "d2", "LED 2", 2, 0 }, { "d3", "LED 3", 3, 0 }, { "d4", "LED 4", 4, 0 } } },

    flower = { name = "Flower 180W", ch = 18, pos = false, ds = { d1 = true, d2 = true }, loc = { str = 0 }, p = {
        { "d1", "LED1 Dim", 1, 0 }, { "r1", "LED1 Red", 2, 1 }, { "g1", "LED1 Green", 3, 1 }, { "b1", "LED1 Blue", 4, 1 },
        { "m1", "LED1 Mode", 5, 0 }, { "s1", "LED1 Speed", 6, .5 }, { "mo1", "Motor1 Mode", 7, 0 }, { "ms1", "Motor1 Speed", 8, 0 },
        { "d2", "LED2 Dim", 9, 0 }, { "r2", "LED2 Red", 10, 1 }, { "g2", "LED2 Green", 11, 1 }, { "b2", "LED2 Blue", 12, 1 },
        { "m2", "LED2 Mode", 13, 0 }, { "s2", "LED2 Speed", 14, .5 }, { "mo2", "Motor2 Mode", 15, 0 }, { "ms2", "Motor2 Speed", 16, 0 },
        { "str", "Strobe", 17, 0 } } },

    pixel = { name = "Pixel Beam Bar 12x60W", ch = 20, pos = true, ds = { mdim = true, adim = true },
        loc = { tilt = .5, mstrb = 0, astrb = 0, mmac = 0, meff = 0 }, p = {
        { "tilt", "Tilt", 1, .5, 2 }, { "tspd", "Tilt Speed", 3, .5 }, { "teff", "Tilt Effect", 4, 0 }, { "tsprd", "Tilt Spread", 5, 0 },
        { "mdim", "Main Dim", 6, 0 }, { "mstrb", "Main Strobe", 7, 0 }, { "mstat", "Main Pola", 8, 0 },
        { "mr", "Main Red", 9, 1 }, { "mg", "Main Green", 10, 1 }, { "mb", "Main Blue", 11, 1 },
        { "mmac", "Main Macro", 12, 0 }, { "meff", "Main Efek", 13, 0 }, { "mespd", "Main Efek Spd", 14, .5 },
        { "adim", "Amber Dim", 15, 0 }, { "astat", "Amber Pola", 16, 0 }, { "aeff", "Amber Efek", 17, 0 },
        { "aespd", "Amber Efek Spd", 18, .5 }, { "astrb", "Amber Strobe", 19, 0 }, { "zoom", "Zoom", 20, 0 } } },

    retro = { name = "RetroHex", ch = 11, pos = false, ds = { dring = true, dref = true, dins = true }, loc = { str = 0 }, p = {
        { "dring", "Ring Dim", 1, 0 }, { "dref", "Reflector Dim", 2, 0 }, { "dins", "Inside Dim", 3, 0 }, { "str", "Strobe", 4, 0 },
        { "ering", "Ring Efek", 5, 0 }, { "eref", "Reflector Efek", 6, 0 },
        { "r", "Red", 7, 0 }, { "g", "Green", 8, 0 }, { "b", "Blue", 9, 0 },
        { "mring", "Ring MTXI", 10, 0 }, { "mref", "Reflector MTXI", 11, 0 } } },

    wall = { name = "Wallwasher 24x3W", ch = 8, pos = false, ds = { dim = true }, loc = { strobe = 0, r = 1, g = 1, b = 1 }, p = {
        { "dim", "Dimmer", 1, 0 }, { "strobe", "Strobe", 2, 0 },
        { "r", "Red", 3, 1 }, { "g", "Green", 4, 1 }, { "b", "Blue", 5, 1 },
        { "eff", "Efek", 6, 0 }, { "spd", "Speed", 8, .5 } } },

    windmill = { name = "Windmill", ch = 8, pos = false, ds = { dim = true }, loc = { str = 0 }, p = {
        { "dim", "Dimmer", 1, 0 }, { "str", "Strobe", 2, 0 }, { "rot", "Rotate", 3, 0 },
        { "ei", "Efek Inner", 4, 0 }, { "eo", "Efek Outer", 5, 0 },
        { "r", "Red", 6, 0 }, { "g", "Green", 7, 0 }, { "b", "Blue", 8, 0 } } },
}
local TYPE_ORDER = { "clara", "strobe", "mapple", "parled", "fogger", "blinder", "flower", "pixel", "retro", "wall", "windmill" }
local TYPE_IDX = {}
for n, t in ipairs(TYPE_ORDER) do TYPE_IDX[t] = n end
local SHORT = { clara = "Clara", strobe = "Strobe", mapple = "Apple", parled = "Par", fogger = "Fog", blinder = "Blind",
    flower = "Flower", pixel = "Pixel", retro = "Retro", wall = "Wall", windmill = "Wind" }
local TYPE_COL = {
    clara = Color3.fromRGB(91, 155, 213), strobe = Color3.fromRGB(205, 205, 210), mapple = Color3.fromRGB(232, 163, 61),
    parled = Color3.fromRGB(217, 83, 79), fogger = Color3.fromRGB(150, 155, 165), blinder = Color3.fromRGB(240, 220, 120),
    flower = Color3.fromRGB(230, 120, 180), pixel = Color3.fromRGB(76, 175, 125), retro = Color3.fromRGB(160, 120, 220),
    wall = Color3.fromRGB(90, 200, 210), windmill = Color3.fromRGB(200, 140, 90),
}

local COLORS = { { "Putih", 1 }, { "Merah", 31 }, { "Pink", 77 }, { "Magenta", 79 }, { "Hijau", 105 }, { "Kuning", 186 } }

local MCOL = { { "Merah", 20 }, { "Hijau", 60 }, { "Biru", 95 }, { "Kuning", 130 }, { "Magenta", 165 }, { "Cyan", 200 }, { "Putih", 240 } }
local BCOL = { { "Merah", 20 }, { "Hijau", 42 }, { "Biru", 65 }, { "Kuning", 128 }, { "Magenta", 160 }, { "Cyan", 192 }, { "Putih", 230 } }
local ACOL = { { "Seg 1", 20 }, { "Seg 2", 60 }, { "Seg 3", 95 }, { "1+2", 130 }, { "1+3", 165 }, { "2+3", 200 }, { "Semua", 240 } }
local PCOL = { { "Putih", 1, 1, 1, 0 }, { "Merah", 1, 0, 0, 0 }, { "Hijau", 0, 1, 0, 0 }, { "Biru", 0, 0, 1, 0 },
    { "Kuning", 1, 1, 0, 0 }, { "Magenta", 1, 0, 1, 0 }, { "Cyan", 0, 1, 1, 0 } }
local RGBP = { { "Putih", 1, 1, 1 }, { "Merah", 1, 0, 0 }, { "Hijau", 0, 1, 0 }, { "Biru", 0, 0, 1 },
    { "Kuning", 1, 1, 0 }, { "Magenta", 1, 0, 1 }, { "Cyan", 0, 1, 1 } }

local LAYER_ORDER = { "pos", "mov", "dim", "beam" }
local LAYERS = {
    pos = { name = "Posisi", c = Color3.fromRGB(91, 155, 213), slots = {}, keys = {
        clara = { "pan", "tilt", "speed" },
        mapple = { "mpos", "mmode" },
        pixel = { "tilt", "tspd", "teff", "tsprd" },
        flower = { "mo1", "ms1", "mo2", "ms2" },
        windmill = { "rot" } } },
    mov = { name = "Gerak FX", c = Color3.fromRGB(150, 110, 205), slots = { 1, 2 }, keys = {} },
    dim = { name = "Dimmer", c = Color3.fromRGB(232, 163, 61), slots = { 3, 4 }, keys = {
        clara = { "dim", "strobe" },
        strobe = { "int", "shutter", "macro1", "macro2", "cont2", "fx2", "pos6", "col1" },
        mapple = { "adim", "astrobe", "rdim", "rstrobe", "bdim" },
        parled = { "dim", "strobe" },
        fogger = { "fog" },
        blinder = { "d1", "d2", "d3", "d4" },
        flower = { "d1", "d2", "str" },
        pixel = { "mdim", "mstrb", "adim", "astrb" },
        retro = { "dring", "dref", "dins", "str" },
        wall = { "dim", "strobe" },
        windmill = { "dim", "str" } } },
    beam = { name = "Beam", c = Color3.fromRGB(76, 175, 125), slots = {}, keys = {
        clara = { "color", "frost", "gobo", "gobor", "prism", "prism2", "prot", "focus" },
        mapple = { "acol", "rc1", "rc2", "rc3", "bcol", "amac", "rmac", "bmac" },
        parled = { "r", "g", "b", "w" },
        flower = { "r1", "g1", "b1", "m1", "s1", "r2", "g2", "b2", "m2", "s2" },
        pixel = { "mstat", "mr", "mg", "mb", "mmac", "meff", "mespd", "astat", "aeff", "aespd", "zoom" },
        retro = { "ering", "eref", "r", "g", "b", "mring", "mref" },
        wall = { "r", "g", "b", "eff", "spd" },
        windmill = { "ei", "eo", "r", "g", "b" } } },
}

local CONT = { dim = true, pan = true, tilt = true, int = true, focus = true, frost = true,
    adim = true, rdim = true, bdim = true, r = true, g = true, b = true, w = true, fog = true, mpos = true,
    d1 = true, d2 = true, d3 = true, d4 = true, r1 = true, g1 = true, b1 = true, r2 = true, g2 = true, b2 = true,
    mdim = true, mr = true, mg = true, mb = true, dring = true, dref = true, dins = true }
local NCUE = 24
local SHAPES = { "circle", "fig8", "sine", "tri", "square", "saw", "rand" }
local SHAPE_NAME = { circle = "Circle", fig8 = "Fig 8", sine = "Sine", tri = "Triangle", square = "Square", saw = "Saw", rand = "Random" }
local DIRS = { ">", "<", "<>" }
local DIR_NAME = { [">"] = "Maju", ["<"] = "Mundur", ["<>"] = "Bounce" }

local F_SET, F_SHOWS, F_WORK = "dmx_ui_settings.json", "dmx_ui_shows.json", "dmx_ui_work.json"
local canSave = (writefile ~= nil) and (readfile ~= nil) and (isfile ~= nil)
local function readJ(f)
    if not canSave then return nil end
    local ok, d = pcall(function() if isfile(f) then return HttpService:JSONDecode(readfile(f)) end end)
    if ok then return d end
end
local function writeJ(f, d)
    if not canSave then return false end
    return (pcall(function() writefile(f, HttpService:JSONEncode(d)) end))
end

local cfg = { remoteName = "Data", vehiclesFolder = "Vehicles", keepalive = 0.25, sendHz = 40, output = true, keysOn = true,
    universes = { { u = 1, owner = "" } }, keys = {} }
do
    local d = readJ(F_SET)
    if type(d) == "table" then for k, v in pairs(d) do cfg[k] = v end end
    if type(cfg.universes) ~= "table" or #cfg.universes == 0 then cfg.universes = { { u = 1, owner = "" } } end
    if type(cfg.keys) ~= "table" then cfg.keys = {} end
end
local function saveSettings() writeJ(F_SET, cfg) end

local alive = true
local fx, sel = {}, {}
local selGroups = {}
local gm, bo, fadeSec = 1, false, 2
local cues = {}
local active = { pos = false, mov = false, dim = false, beam = false }
local cur = 1
local UI = {}
local flash = { blind = {}, fog = {} }
local FLASH_B = {
    blinder = { d1 = 1, d2 = 1, d3 = 1, d4 = 1 },
    clara = { dim = 0 },
    mapple = { rdim = 1, rstrobe = 0, rc1 = 240 / 255, rc2 = 240 / 255, rc3 = 240 / 255, rmac = 0, bdim = 0 },
    parled = { dim = 1, r = 1, g = 1, b = 1, w = 0, strobe = 0 },
    wall = { dim = 1, strobe = 0, r = 1, g = 1, b = 1, eff = 0 },
    flower = { d1 = 1, d2 = 1, r1 = 1, g1 = 1, b1 = 1, r2 = 1, g2 = 1, b2 = 1, m1 = 0, m2 = 0, str = 0 },
    pixel = { mdim = 1, mstrb = 0, mstat = 0, mr = 1, mg = 1, mb = 1, mmac = 0, meff = 0 },
    retro = { dring = 1, dref = 1, dins = 1, str = 0, ering = 0, eref = 0, r = 1, g = 1, b = 1, mring = 0, mref = 0 },
    windmill = { dim = 1, str = 0, ei = 0, eo = 0, r = 1, g = 1, b = 1 },
}
local function hasType(t)
    for _, f in ipairs(fx) do if f.t == t then return true end end
    return false
end

local function defV(t) local v = {}; for _, p in ipairs(TYPES[t].p) do v[p[1]] = p[4] end; return v end
local function mkFx(t, a) return { t = t, addr = a, v = defV(t), fade = nil, holdT = nil } end
local function defL(i)
    local dimSlot = i > 2
    return { on = false, target = dimSlot and "dim" or "pos", shape = dimSlot and "square" or "circle", rate = .4,
        sx = .3, sy = .3, phase = dimSlot and 360 or 90, groups = 0, block = 1, wing = 0, wmir = true,
        dty = .5, dep = 1, soft = 0, wax = "x", useShut = true, dir = ">", members = {}, amt = 0, ph = 0 }
end
local function newL() local l = {}; for i = 1, 4 do l[i] = defL(i) end; return l end
local L = newL()
local function defRig() return { mkFx("clara", 1), mkFx("strobe", 17) } end
fx = defRig()

local function selIdx() local r = {}; for i = 1, #fx do if sel[i] then r[#r + 1] = i end end; return r end

-- ===== tata letak (posisi fixture di panggung, 0..1) =====
local function arrange(mode)
    local idx = selIdx()
    if #idx == 0 then for i = 1, #fx do idx[i] = i end end
    local n = #idx
    if n == 0 then return end
    local function put(j, x, y)
        local f = fx[idx[j]]
        f.x, f.y = cl(x, .05, .95), cl(y, .08, .92)
    end
    local function spread(c, m) return m <= 1 and .5 or .07 + .86 * (c - 1) / (m - 1) end
    if mode == "row" then
        for j = 1, n do put(j, spread(j, n), .5) end
    elseif mode == "rows" then
        local a = math.ceil(n / 2)
        for j = 1, n do
            if j <= a then put(j, spread(j, a), .32) else put(j, spread(j - a, n - a), .68) end
        end
    elseif mode == "arc" then
        for j = 1, n do
            local t = n == 1 and .5 or (j - 1) / (n - 1)
            local th = math.pi * (1 - t)
            put(j, .5 + .43 * math.cos(th), .86 - .70 * math.sin(th))
        end
    elseif mode == "grid" then
        local cols = math.max(1, math.ceil(math.sqrt(n * 1.7)))
        local rows = math.ceil(n / cols)
        for j = 1, n do
            local c, r = (j - 1) % cols, (j - 1) // cols
            put(j, cols == 1 and .5 or .08 + .84 * c / (cols - 1), rows == 1 and .5 or .15 + .70 * r / (rows - 1))
        end
    else
        local byT, order = {}, {}
        for j = 1, n do
            local t = fx[idx[j]].t
            if not byT[t] then byT[t] = {}; order[#order + 1] = t end
            table.insert(byT[t], j)
        end
        table.sort(order, function(a, b) return (TYPE_IDX[a] or 99) < (TYPE_IDX[b] or 99) end)
        for r, t in ipairs(order) do
            local lst = byT[t]
            for c, j in ipairs(lst) do
                put(j, spread(c, #lst), #order == 1 and .5 or .13 + .74 * (r - 1) / (#order - 1))
            end
        end
    end
end
local function freeSpot()
    for r = 0, 7 do
        for c = 0, 11 do
            local x, y = .07 + c * .0786, .12 + r * .105
            local ok = true
            for _, f in ipairs(fx) do
                if f.x and f.y and math.abs(f.x - x) < .07 and math.abs(f.y - y) < .09 then ok = false; break end
            end
            if ok then return x, y end
        end
    end
    return .5, .5
end
local function ensurePos()
    local un, placed = {}, 0
    for i, f in ipairs(fx) do
        if f.x == nil or f.y == nil then un[#un + 1] = i else placed += 1 end
    end
    if #un == 0 then return end
    if placed == 0 then
        local keep = sel
        sel = {}
        arrange(#fx > 8 and "grid" or "row")
        sel = keep
    else
        for _, i in ipairs(un) do fx[i].x, fx[i].y = freeSpot() end
    end
end

local function fitAddr(addr, ch)
    addr = math.max(1, math.floor(addr))
    if ((addr - 1) % 512) + ch > 512 then addr = ((addr - 1) // 512 + 1) * 512 + 1 end
    return addr
end

local workDirty = false
local function touch() workDirty = true end
local function toast(t) if UI.toast then UI.toast(t) end end
local function refresh(...) for _, k in ipairs({ ... }) do if UI[k] then pcall(UI[k]) end end end

-- ===== mesin efek =====
local function wave(s, a)
    local t = (a / TAU) % 1
    if s == "tri" then return t < .25 and 4 * t or (t < .75 and 2 - 4 * t or 4 * t - 4) end
    if s == "square" then return t < .5 and 1 or -1 end
    if s == "saw" then return 2 * t - 1 end
    return math.sin(a)
end
local function hash(n)
    local x = math.sin(n * 12.9898 + 78.233) * 43758.5453
    return x - math.floor(x)
end
local function smooth(x)
    x = math.min(1, math.max(0, x))
    return x * x * (3 - 2 * x)
end

-- u = posisi dalam siklus (1.0 = satu putaran). wrap=false: di luar 0..1 dianggap mati (dipakai bounce)
-- dty = lebar pulsa, soft = kehalusan tepi
local function lvlOf(s, u, dty, soft, k, wrap)
    if s == "rand" then return hash(math.floor(u) * 31 + k) < dty and 1 or 0 end
    local t = u
    if wrap then t = u % 1 elseif t < 0 or t >= 1 then return 0 end
    soft = soft or 0
    local m
    if s == "square" then
        if t >= dty then return 0 end
        local e = soft * .5 * math.min(dty, 1 - dty)
        if e <= .0005 then return 1 end
        return smooth(t / e) * smooth((dty - t) / e)
    elseif s == "saw" then
        m = 1 - t
        if dty < .999 then m = cl((m - (1 - dty)) / math.max(.001, dty)) end
        if soft > 0 then m = m * smooth(t / (soft * .3 + .001)) end
        return m
    elseif s == "tri" then
        m = t < .5 and t * 2 or 2 - t * 2
    else
        m = (1 - math.cos(t * TAU)) / 2
    end
    if dty < .999 then m = cl((m - (1 - dty)) / math.max(.001, dty)) end
    return m
end
local function moveXY(s, a, k)
    if s == "circle" then return math.cos(a), math.sin(a) end
    if s == "fig8" then return math.sin(a), math.sin(2 * a) end
    if s == "rand" then
        local c = math.floor(a / TAU)
        local f = a / TAU - c
        f = f * f * (3 - 2 * f)
        local function r(n, z) return hash(n * 31 + k * 7 + z) * 2 - 1 end
        return r(c, 1) + (r(c + 1, 1) - r(c, 1)) * f, r(c, 2) + (r(c + 1, 2) - r(c, 2)) * f
    end
    return wave(s, a), wave(s, a + TAU / 4)
end

-- Fase tiap fixture di dalam slot.
-- Hasil: nomor fase g (0-based), jumlah fase Gn, apakah jalur dicerminkan.
-- Gn dihitung dari jalur terpanjang supaya semua sisi/jalur memakai skala fase yang sama.
local function slotPhase(l, k, n)
    local W = math.floor(l.wing or 0)
    local aw = math.min(math.abs(W), n)
    local pidx, cnt, mir = k - 1, n, false
    local maxCnt = n
    if aw >= 2 and n > 1 then
        local w
        if W > 0 then
            local base, extra = n // aw, n % aw
            local first = 0
            for s = 0, aw - 1 do
                local sz = base + (s < extra and 1 or 0)
                if k - 1 < first + sz then w = s; pidx = k - 1 - first; cnt = sz; break end
                first += sz
            end
            maxCnt = base + (extra > 0 and 1 or 0)
        else
            w = (k - 1) % aw
            pidx = (k - 1) // aw
            cnt = (n - w + aw - 1) // aw
            maxCnt = (n + aw - 1) // aw
        end
        if w % 2 == 1 and l.wmir ~= false then pidx = cnt - 1 - pidx; mir = true end
    end
    local B = math.max(1, math.floor(l.block or 1))
    local G = math.floor(l.groups or 0)
    local Gn = G > 0 and G or math.max(1, math.ceil(maxCnt / B))
    return (pidx // B) % Gn, Gn, mir
end
-- posisi siklus (bounce = bolak-balik 0..1)
local function ang(l)
    local t = l.ph or 0
    if l.dir == "<>" then
        local m = t % 2
        return m < 1 and m or 2 - m
    end
    return t
end
local function mirXY(l, x, y)
    local ax = l.wax or "x"
    if ax ~= "y" then x = -x end
    if ax ~= "x" then y = -y end
    return x, y
end

local function applyFx(i, o)
    local T = TYPES[fx[i].t]
    local gate, shut = false, false
    for _, l in ipairs(L) do
        if l.amt > .001 then
            local k = table.find(l.members, i)
            if k then
                local g, Gn, mir = slotPhase(l, k, #l.members)
                local w = l.amt
                local pf = (l.phase or 0) / 360
                local gf = (g / Gn) * pf
                local rnd = l.shape == "rand"
                local u0 = rnd and (l.ph or 0) or ang(l)
                if l.target == "dim" then
                    local dty = l.dty or .5
                    local span = ((Gn - 1) / Gn) * pf
                    if l.dir == "<" then gf = span - gf end
                    local lvl
                    if l.dir == "<>" and not rnd then
                        local wd = (l.shape == "square" or l.shape == "saw") and dty or 1
                        lvl = lvlOf(l.shape, u0 * (span + wd) - gf, dty, l.soft, k, false)
                    else
                        lvl = lvlOf(l.shape, u0 - gf, dty, l.soft, k, true)
                    end
                    if T.shut and l.useShut ~= false then
                        gate = true
                        if w > .5 and (l.dep or 1) > .05 and lvl < .5 then shut = true end
                    else
                        local d = w * (l.dep or 1) * (1 - lvl)
                        for dk in pairs(T.ds) do
                            if o[dk] then o[dk] = o[dk] * (1 - d) end
                        end
                    end
                elseif T.pos then
                    local x, y = moveXY(l.shape, (u0 - gf) * TAU, k)
                    if mir then x, y = mirXY(l, x, y) end
                    local ax, ay = (l.sx or 0) * .5 * w, (l.sy or 0) * .5 * w
                    if o.pan then ay = ay * 2 end
                    -- bentuk dikecilkan seragam kalau mentok batas, supaya tidak gepeng
                    local f = 1
                    if o.pan and ax > 0 then f = math.min(f, math.min(o.pan, 1 - o.pan) / ax) end
                    if o.tilt and ay > 0 then f = math.min(f, math.min(o.tilt, 1 - o.tilt) / ay) end
                    f = math.max(0, f)
                    if o.pan then o.pan = o.pan + x * ax * f end
                    if o.tilt then o.tilt = o.tilt + y * ay * f end
                end
            end
        end
    end
    if gate then
        local sk, base = T.shut.key, fx[i].v[T.shut.key]
        if shut then o[sk] = T.shut.closed
        elseif base <= T.shut.closed + .01 then o[sk] = T.shut.open end
    end
end
local function out(i)
    local o = {}
    for k, v in pairs(fx[i].v) do o[k] = v end
    applyFx(i, o)
    local ft = fx[i].t
    if next(flash.blind) then
        local ov = FLASH_B[ft]
        if ov then for k, v in pairs(ov) do o[k] = v end end
    end
    if ft == "fogger" and next(flash.fog) then o.fog = 1 end
    for k, v in pairs(o) do o[k] = cl(v) end
    return o
end

local function liveLevel(i)
    local f = fx[i]
    if not f then return 0 end
    local T, o = TYPES[f.t], out(i)
    local lv = 0
    if T.shut then
        if o[T.shut.key] > T.shut.closed + .02 then lv = o.dim or 0 end
    else
        for dk in pairs(T.ds) do lv = math.max(lv, o[dk] or 0) end
    end
    if next(T.ds) then lv = bo and 0 or lv * gm else lv = o.fog or 0 end
    return cl(lv)
end

local function step(dt, now)
    for _, l in ipairs(L) do
        if l.on or l.amt > 0 then
            -- dimmer: arah mundur dibalik lewat urutan fase, bukan lewat waktu mundur
            local sgn = (l.dir == "<" and l.target ~= "dim") and -1 or 1
            l.ph = ((l.ph or 0) + dt * l.rate * sgn) % 4096
            local ramp = l.target == "dim" and 12 or 2
            l.amt = cl(l.amt + (l.on and 1 or -1) * dt * ramp)
        end
    end
    for _, f in ipairs(fx) do
        if f.fade then
            local any = false
            for k, a in pairs(f.fade) do
                local p = a.dur <= 0 and 1 or math.min(1, (now - a.t0) / a.dur)
                f.v[k] = a.from + (a.to - a.from) * p
                if p >= 1 then f.fade[k] = nil else any = true end
            end
            if not any then f.fade = nil end
        end
        if f.holdT and now > f.holdT then f.v.ctrl = 0; f.holdT = nil end
    end
end

local function buildUniverses()
    local uni = {}
    for i, f in ipairs(fx) do
        local T, o = TYPES[f.t], out(i)
        local function put(c, v)
            if c > 0 then
                local a = f.addr + c - 1
                local u, ch = (a - 1) // 512 + 1, (a - 1) % 512 + 1
                uni[u] = uni[u] or table.create(512, 0)
                uni[u][ch] = cl(math.floor(v + .5), 0, 255)
            end
        end
        for _, p in ipairs(T.p) do
            local v = o[p[1]]
            if T.ds[p[1]] then v = bo and 0 or v * gm end
            if p[5] then
                local n = math.floor(v * 65535 + .5)
                put(p[3], n // 256); put(p[5], n % 256)
            else
                put(p[3], v * 255)
            end
        end
    end
    return uni
end

local function cfx(c, i) return c.fx[tostring(i)] or c.fx[i] end
local function setTarget(f, k, to, t0, dur)
    if not CONT[k] or dur <= 0 then
        f.v[k] = to
        if f.fade then f.fade[k] = nil end
        return
    end
    f.fade = f.fade or {}
    f.fade[k] = { from = f.v[k], to = to, t0 = t0, dur = dur }
end
local function storeCue(n, ly, onlySel)
    local Ly = LAYERS[ly]
    local c = { layer = ly, fx = {}, eff = {}, part = onlySel or nil }
    for i, f in ipairs(fx) do
        if not onlySel or sel[i] then
            local v = {}
            for _, k in ipairs(Ly.keys[f.t] or {}) do v[k] = f.v[k] end
            c.fx[tostring(i)] = { t = f.t, v = v }
        end
    end
    for j, si in ipairs(Ly.slots) do
        local e = jcopy(L[si]); e.amt = 0; e.ph = 0
        c.eff[j] = e
    end
    cues[tostring(n)] = c
    touch()
end
local function applyCue(n)
    local c = cues[tostring(n)]
    if not c then return end
    local Ly, t0, dur = LAYERS[c.layer], os.clock(), math.max(0, fadeSec)
    if not Ly then return end
    for i, f in ipairs(fx) do
        local s = cfx(c, i)
        if s and s.t == f.t then for k, v in pairs(s.v) do setTarget(f, k, v, t0, dur) end end
    end
    for j, si in ipairs(Ly.slots) do
        local q = c.eff[j]
        if q then
            local keepAmt, keepPh = L[si].amt, L[si].ph
            local e = jcopy(q); e.amt = keepAmt; e.ph = keepPh
            for k, v in pairs(defL(si)) do if e[k] == nil then e[k] = v end end
            L[si] = e
        else
            L[si].on = false
        end
    end
    active[c.layer] = n
    refresh("syncEff", "drawCues")
end
local function releaseLayer(ly)
    local Ly, t0, dur = LAYERS[ly], os.clock(), math.max(0, fadeSec)
    local ac = active[ly] and cues[tostring(active[ly])]
    for i, f in ipairs(fx) do
        if not ac or cfx(ac, i) then
            local d = defV(f.t)
            for _, k in ipairs(Ly.keys[f.t] or {}) do setTarget(f, k, d[k], t0, dur) end
        end
    end
    for _, si in ipairs(Ly.slots) do L[si].on = false end
    active[ly] = false
    refresh("syncEff", "drawCues")
end
local function pressCue(n)
    local c = cues[tostring(n)]
    if not c or not LAYERS[c.layer] then return end
    if active[c.layer] == n then releaseLayer(c.layer); toast("Cue " .. n .. " mati")
    else applyCue(n); toast("Cue " .. n .. " aktif (" .. LAYERS[c.layer].name .. ")") end
end
local function allOff() for _, ly in ipairs(LAYER_ORDER) do if active[ly] then releaseLayer(ly) end end end

local function snapshot()
    local d = { v = 3, rig = {}, cues = jcopy(cues), eff = {}, fade = fadeSec, gm = math.floor(gm * 100 + .5), keys = jcopy(cfg.keys), sg = {} }
    for _, f in ipairs(fx) do d.rig[#d.rig + 1] = { t = f.t, a = f.addr, v = jcopy(f.v), x = f.x, y = f.y } end
    for i, l in ipairs(L) do local e = jcopy(l); e.amt = 0; e.ph = 0; d.eff[i] = e end
    for g, lst in pairs(selGroups) do d.sg[tostring(g)] = lst end
    return d
end
local function loadSnap(d)
    assert(type(d) == "table" and type(d.rig) == "table", "format save tidak dikenal")
    local nf = {}
    for _, r in ipairs(d.rig) do
        if TYPES[r.t] then
            local f = mkFx(r.t, math.max(1, math.floor(tonumber(r.a) or 1)))
            f.x, f.y = tonumber(r.x), tonumber(r.y)
            for k, v in pairs(r.v or {}) do f.v[k] = v end
            nf[#nf + 1] = f
        end
    end
    fx = #nf > 0 and nf or defRig()
    sel = {}; cur = 1
    cues = type(d.cues) == "table" and d.cues or {}
    L = newL()
    for i, q in ipairs(d.eff or {}) do
        if L[i] then
            for k, v in pairs(q) do L[i][k] = v end
            L[i].on = false; L[i].amt = 0; L[i].ph = 0
            local m = {}
            for _, x in ipairs(L[i].members or {}) do if x <= #fx then m[#m + 1] = x end end
            L[i].members = m
        end
    end
    selGroups = {}
    if type(d.sg) == "table" then
        for k, v in pairs(d.sg) do
            local g = tonumber(k)
            if g and type(v) == "table" then selGroups[g] = v end
        end
    end
    active = { pos = false, mov = false, dim = false, beam = false }
    gm = cl((d.gm or 100) / 100); fadeSec = tonumber(d.fade) or 2
    if type(d.keys) == "table" then cfg.keys = d.keys; saveSettings() end
    ensurePos()
    touch()
    refresh("drawFx", "drawSel", "drawProg", "syncEff", "drawCues", "syncHeader")
end

local remotes = {}
local fired = {}
local function ownerName(o)
    if o == nil or o == "" then return LocalPlayer and LocalPlayer.Name or "" end
    return o
end
local function scanOnce()
    local root = workspace:FindFirstChild(cfg.vehiclesFolder) or workspace
    local found, n = {}, 0
    for _, d in ipairs(root:GetDescendants()) do
        n += 1
        if n % 3000 == 0 then task.wait() end
        if d:IsA("RemoteEvent") and d.Name == cfg.remoteName then found[#found + 1] = d end
    end
    local missing = false
    for _, row in ipairs(cfg.universes) do
        local u = tonumber(row.u)
        if u then
            local owner = ownerName(row.owner)
            local lo = owner:lower()
            local list = {}
            for _, d in ipairs(found) do
                if owner == "*" then
                    list[#list + 1] = d
                else
                    local p = d.Parent
                    while p and p ~= workspace do
                        if p.Name:lower():find(lo, 1, true) then list[#list + 1] = d; break end
                        p = p.Parent
                    end
                end
            end
            if #list == 0 then missing = true end
            remotes[math.floor(u)] = list
        end
    end
    return missing
end
task.spawn(function()
    while alive do
        local missing = scanOnce()
        for _ = 1, (missing and 6 or 40) do if not alive then return end; task.wait(.5) end
    end
end)

local function toBuf(arr)
    local b = buffer.create(512)
    for i = 1, 512 do local v = arr[i]; if v and v > 0 then buffer.writeu8(b, i - 1, v) end end
    return b
end

local acc, lastT = 0, os.clock()
local lastSend, sentArr, sentBuf = {}, {}, {}
local hb = RunService.Heartbeat:Connect(function()
    local now = os.clock()
    local dt = math.min(.25, now - lastT); lastT = now
    step(dt, now)
    acc += dt
    local iv = 1 / cl(tonumber(cfg.sendHz) or 40, 10, 60)
    if acc < iv - .004 then return end
    acc = math.min(acc - iv, iv)
    if not cfg.output then return end
    for u, arr in pairs(buildUniverses()) do
        local list = remotes[u]
        if list and #list > 0 then
            local prev, changed = sentArr[u], false
            if not prev then changed = true else
                for i = 1, 512 do if prev[i] ~= arr[i] then changed = true; break end end
            end
            if changed or now - (lastSend[u] or 0) >= cfg.keepalive then
                if changed then sentBuf[u] = toBuf(arr); sentArr[u] = arr end
                for _, r in ipairs(list) do if r.Parent then pcall(r.FireServer, r, sentBuf[u]) end end
                lastSend[u] = now; fired[u] = (fired[u] or 0) + 1
            end
        end
    end
end)

local C = {
    bg = Color3.fromRGB(21, 23, 26), p = Color3.fromRGB(29, 32, 36), p2 = Color3.fromRGB(38, 42, 47),
    ln = Color3.fromRGB(52, 57, 63), tx = Color3.fromRGB(228, 230, 232), mu = Color3.fromRGB(139, 146, 153),
    ac = Color3.fromRGB(91, 155, 213), ok = Color3.fromRGB(76, 175, 125), er = Color3.fromRGB(217, 83, 79),
    selbg = Color3.fromRGB(34, 48, 61), warn = Color3.fromRGB(232, 163, 61),
}
local DARK = Color3.fromRGB(18, 20, 23)
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end
local function corner(o, r) new("UICorner", { CornerRadius = UDim.new(0, r or 5) }, o) end
local function stroke(o, col) new("UIStroke", { Color = col or C.ln, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o) end
local function pad(o, n) new("UIPadding", { PaddingLeft = UDim.new(0, n), PaddingRight = UDim.new(0, n), PaddingTop = UDim.new(0, n), PaddingBottom = UDim.new(0, n) }, o) end
local function clear(f) for _, c in ipairs(f:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end end

local function label(parent, text, o)
    o = o or {}
    local l = new("TextLabel", {
        BackgroundTransparency = 1, Text = text, TextColor3 = o.color or C.tx, Font = o.font or Enum.Font.Gotham, TextSize = o.size or 13,
        TextXAlignment = o.align or Enum.TextXAlignment.Left, TextWrapped = o.wrap or false,
        Size = o.sz or UDim2.new(1, 0, 0, 18), Position = o.pos or UDim2.new(), LayoutOrder = o.order or 0,
    }, parent)
    return l
end
local function button(parent, text, cb, o)
    o = o or {}
    local b = new("TextButton", {
        Text = text, Font = Enum.Font.GothamMedium, TextSize = o.size or 13, TextColor3 = o.color or C.tx,
        BackgroundColor3 = o.bg or C.p2, AutoButtonColor = true, BorderSizePixel = 0,
        Size = o.sz or UDim2.new(0, 90, 0, 28), Position = o.pos or UDim2.new(), LayoutOrder = o.order or 0,
    }, parent)
    corner(b); stroke(b, o.stroke or C.ln)
    if cb then b.Activated:Connect(cb) end
    return b
end
local function box(parent, text, ph, o)
    o = o or {}
    local t = new("TextBox", {
        Text = text or "", PlaceholderText = ph or "", PlaceholderColor3 = C.mu, ClearTextOnFocus = false, Font = Enum.Font.Gotham,
        TextSize = 13, TextColor3 = C.tx, BackgroundColor3 = C.bg, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left,
        Size = o.sz or UDim2.new(1, 0, 0, 28), Position = o.pos or UDim2.new(), LayoutOrder = o.order or 0,
    }, parent)
    corner(t); stroke(t)
    new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, t)
    return t
end
local function scroll(parent, o)
    o = o or {}
    local sc = new("ScrollingFrame", {
        Size = o.sz or UDim2.fromScale(1, 1), Position = o.pos or UDim2.new(), BackgroundTransparency = o.bg and 0 or 1,
        BackgroundColor3 = o.bg or C.p, BorderSizePixel = 0, ScrollBarThickness = 4, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, parent)
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, sc)
    if o.bg then corner(sc); stroke(sc); pad(sc, 6) end
    return sc
end
local function rowF(parent, h)
    return new("Frame", { Size = UDim2.new(1, -8, 0, h), BackgroundTransparency = 1, LayoutOrder = #parent:GetChildren() }, parent)
end
local function hlist(parent, h, wraps)
    local f = new("Frame", { Size = UDim2.new(1, -8, 0, h), BackgroundTransparency = 1, LayoutOrder = #parent:GetChildren() }, parent)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5), Wraps = wraps or false, SortOrder = Enum.SortOrder.LayoutOrder }, f)
    return f
end

local function qrow(parent, lbl, items, w)
    w = w or 60
    local total = lbl and 62 or 0
    for _, it in ipairs(items) do total = total + (it.w or w) + 5 end
    local rows = math.max(1, math.ceil(total / 420))
    local r = hlist(parent, rows * 33 - 5, true)
    if lbl then label(r, lbl, { sz = UDim2.fromOffset(56, 28), color = C.mu, size = 12 }) end
    for _, it in ipairs(items) do
        button(r, it[1], it[2], { sz = UDim2.fromOffset(it.w or w, 28), size = 11, color = it.c })
    end
    return r
end

local function confirmBtn(b, text, fn)
    local base, token = b.Text, 0
    b.Activated:Connect(function()
        if b.Text == base then
            b.Text = text; token += 1
            local my = token
            task.delay(3, function() if token == my and b.Parent then b.Text = base end end)
        else
            token += 1; b.Text = base; fn()
        end
    end)
end

local conns = {}
local function track(c) conns[#conns + 1] = c; return c end

local drag, dragEnd = nil, nil
track(UIS.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then drag(i.Position) end
end))
track(UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = nil
        if dragEnd then
            local f = dragEnd
            dragEnd = nil
            pcall(f)
        end
    end
end))
local function isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end

local function slider(parent, o)
    local f = new("Frame", { Size = o.size or UDim2.new(1, 0, 0, 24), Position = o.pos or UDim2.new(), BackgroundTransparency = 1 }, parent)
    local tr = new("Frame", { Position = UDim2.new(0, 0, .5, -4), Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = C.p2, BorderSizePixel = 0 }, f)
    corner(tr, 4)
    local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = o.color or C.ac, BorderSizePixel = 0 }, tr)
    corner(fill, 4)
    local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, f)
    local mn, mx = o.min or 0, o.max or 1
    local obj = { frame = f }
    function obj.set(v) fill.Size = UDim2.fromScale(cl((v - mn) / (mx - mn)), 1) end
    local function from(pos)
        local rel = cl((pos.X - tr.AbsolutePosition.X) / math.max(1, tr.AbsoluteSize.X))
        local v = mn + rel * (mx - mn)
        if o.step then v = math.floor(v / o.step + .5) * o.step end
        obj.set(v)
        if o.onChange then o.onChange(v) end
    end
    hit.InputBegan:Connect(function(i) if isPress(i) then drag = from; dragEnd = nil; from(i.Position) end end)
    return obj
end

local function pad2d(parent, size, onChange)
    local f = new("Frame", { Size = UDim2.fromOffset(size, size), BackgroundColor3 = C.bg, BorderSizePixel = 0, LayoutOrder = #parent:GetChildren() }, parent)
    corner(f); stroke(f)
    new("Frame", { Position = UDim2.new(.5, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = C.ln, BorderSizePixel = 0 }, f)
    new("Frame", { Position = UDim2.new(0, 0, .5, 0), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.ln, BorderSizePixel = 0 }, f)
    local m = new("Frame", { Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), BackgroundColor3 = C.ac, BorderSizePixel = 0 }, f)
    corner(m, 6)
    local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, f)
    local function from(pos)
        local x = cl((pos.X - f.AbsolutePosition.X) / math.max(1, f.AbsoluteSize.X))
        local y = cl(1 - (pos.Y - f.AbsolutePosition.Y) / math.max(1, f.AbsoluteSize.Y))
        m.Position = UDim2.fromScale(x, 1 - y)
        onChange(x, y)
    end
    hit.InputBegan:Connect(function(i) if isPress(i) then drag = from; dragEnd = nil; from(i.Position) end end)
    return { frame = f, mark = function(x, y) if drag == nil then m.Position = UDim2.fromScale(x, 1 - y) end end }
end

local function guiParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local gui = new("ScreenGui", { Name = "DMXConsoleUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999 })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
if not pcall(function() gui.Parent = guiParent() end) or not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
local WIN_W, WIN_H = math.min(540, vp.X - 16), math.min(560, vp.Y - 16)
local win = new("Frame", { Size = UDim2.fromOffset(WIN_W, WIN_H), Position = UDim2.fromOffset(8, 8), BackgroundColor3 = C.bg, BorderSizePixel = 0, Active = true }, gui)
corner(win, 8); stroke(win)
local title = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.p, BorderSizePixel = 0, Active = true }, win)
corner(title, 8)
label(title, "DMX Console", { size = 14, font = Enum.Font.GothamBold, sz = UDim2.new(1, -150, 1, 0), pos = UDim2.fromOffset(12, 0) })
local dot = new("Frame", { Size = UDim2.fromOffset(9, 9), Position = UDim2.new(1, -112, .5, -4), BackgroundColor3 = C.er, BorderSizePixel = 0 }, title)
corner(dot, 5)
local body = new("Frame", { Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 1, -32), BackgroundTransparency = 1 }, win)
local minimized = false
button(title, "-", function()
    minimized = not minimized
    body.Visible = not minimized
    win.Size = minimized and UDim2.fromOffset(WIN_W, 32) or UDim2.fromOffset(WIN_W, WIN_H)
end, { sz = UDim2.fromOffset(26, 22), pos = UDim2.new(1, -92, .5, -11) })
do
    local start, startPos
    track(title.InputBegan:Connect(function(i)
        if isPress(i) then
            start, startPos = i.Position, win.Position
            dragEnd = nil
            drag = function(p)
                local d = p - start
                win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end))
    track(UIS.InputBegan:Connect(function(i, gp)
        if not gp and i.KeyCode == Enum.KeyCode.RightControl then gui.Enabled = not gui.Enabled end
    end))
end

local header = new("Frame", { Position = UDim2.fromOffset(8, 4), Size = UDim2.new(1, -16, 0, 28), BackgroundTransparency = 1 }, body)
local mLbl = label(header, "Master 100%", { sz = UDim2.fromOffset(84, 28), size = 12 })
local masterSl = slider(header, { pos = UDim2.fromOffset(86, 2), size = UDim2.new(1, -330, 0, 24), onChange = function(v) gm = v; mLbl.Text = ("Master %d%%"):format(math.floor(v * 100 + .5)) end })
local boBtn = button(header, "Blackout", function() bo = not bo; UI.syncHeader() end, { sz = UDim2.fromOffset(78, 28), pos = UDim2.new(1, -240, 0, 0), color = C.er, stroke = C.er, size = 12 })
button(header, "Off semua", function() allOff() end, { sz = UDim2.fromOffset(74, 28), pos = UDim2.new(1, -158, 0, 0), size = 12 })
label(header, "Fade", { sz = UDim2.fromOffset(28, 28), pos = UDim2.new(1, -80, 0, 0), size = 12, color = C.mu })
local fadeBox = box(header, "2", "dtk", { sz = UDim2.fromOffset(46, 28), pos = UDim2.new(1, -48, 0, 0) })
fadeBox.FocusLost:Connect(function() local v = tonumber(fadeBox.Text); if v then fadeSec = math.max(0, v); touch() end; fadeBox.Text = tostring(fadeSec) end)
UI.syncHeader = function()
    masterSl.set(gm); mLbl.Text = ("Master %d%%"):format(math.floor(gm * 100 + .5))
    boBtn.BackgroundColor3 = bo and C.er or C.p2
    boBtn.TextColor3 = bo and Color3.new(1, 1, 1) or C.er
    if not fadeBox:IsFocused() then fadeBox.Text = tostring(fadeSec) end
end

local TABS = { { "fx", "Fixture" }, { "ly", "Layout" }, { "pg", "Program" }, { "ef", "Effect" }, { "cu", "Cue" }, { "sv", "Save" }, { "su", "Setup" } }
local pages, tabBtns, currentTab = {}, {}, "cu"
local tabBar = new("Frame", { Size = UDim2.new(1, -16, 0, 26), Position = UDim2.fromOffset(8, 36), BackgroundTransparency = 1 }, body)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 3) }, tabBar)

local selBar = new("ScrollingFrame", { Position = UDim2.fromOffset(8, 66), Size = UDim2.new(1, -16, 0, 32), BackgroundTransparency = 1,
    BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X,
    ScrollingDirection = Enum.ScrollingDirection.X, Visible = false }, body)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, selBar)
local selChips, saveBtn, saveGrp = {}, nil, false
local function copySel() local s = {}; for k, v in pairs(sel) do s[k] = v end; return s end
local dirty = {}
local function setSel(s)
    sel = s
    dirty.fx, dirty.pg, dirty.ef = true, true, true
    refresh("paintSel", "paintLay")
    local id = currentTab
    if dirty[id] then
        dirty[id] = nil
        refresh(id == "fx" and "drawFx" or id == "pg" and "drawProg" or "syncEff")
    end
end
local function stepSolo(d)
    local n = #fx
    if n == 0 then return end
    local idxs, c = selIdx(), 0
    if #idxs > 0 then c = d > 0 and idxs[#idxs] or idxs[1] end
    local nx
    if c == 0 then nx = d > 0 and 1 or n else nx = ((c - 1 + d) % n) + 1 end
    setSel({ [nx] = true })
end
UI.paintSel = function()
    for i, b in pairs(selChips) do
        local f = fx[i]
        if f and b.Parent then
            local col = TYPE_COL[f.t] or C.ac
            local on = sel[i]
            b.BackgroundColor3 = on and col or C.p2
            b.TextColor3 = on and DARK or C.tx
            local st = b:FindFirstChildOfClass("UIStroke")
            if st then st.Color = col end
        end
    end
    if saveBtn and saveBtn.Parent then
        saveBtn.BackgroundColor3 = saveGrp and C.warn or C.p2
        saveBtn.TextColor3 = saveGrp and DARK or C.tx
    end
end
UI.drawSel = function()
    local keep = selBar.CanvasPosition
    clear(selBar); selChips = {}
    local order = 0
    local function chip(text, cb, w, o)
        order += 1
        o = o or {}
        o.sz = UDim2.fromOffset(w or 34, 26); o.order = order; o.size = 12
        return button(selBar, text, cb, o)
    end
    chip("<", function() stepSolo(-1) end, 28)
    chip(">", function() stepSolo(1) end, 28)
    for i = 1, #fx do
        selChips[i] = chip(tostring(i), function() local s = copySel(); s[i] = not s[i] or nil; setSel(s) end, 32)
    end
    chip("Semua", function() local s = {}; for i = 1, #fx do s[i] = true end; setSel(s) end, 54)
    chip("Kosong", function() setSel({}) end, 54)
    chip("Ganjil", function() local s = {}; for i = 1, #fx, 2 do s[i] = true end; setSel(s) end, 54)
    chip("Genap", function() local s = {}; for i = 2, #fx, 2 do s[i] = true end; setSel(s) end, 54)
    chip("Balik", function() local s = {}; for i = 1, #fx do if not sel[i] then s[i] = true end end; setSel(s) end, 48)
    for _, t in ipairs(TYPE_ORDER) do
        for _, f in ipairs(fx) do
            if f.t == t then
                chip(SHORT[t], function()
                    local s = {}
                    for i, g in ipairs(fx) do if g.t == t then s[i] = true end end
                    setSel(s)
                end, 56, { stroke = TYPE_COL[t] })
                break
            end
        end
    end
    for g = 1, 4 do
        local has = selGroups[g] and #selGroups[g] > 0
        chip("G" .. g, function()
            if saveGrp then
                local idxs = selIdx()
                if #idxs == 0 then toast("Pilih fixture dulu"); return end
                selGroups[g] = idxs; saveGrp = false; touch()
                toast("Grup G" .. g .. " disimpan (" .. #idxs .. " fixture)")
                UI.drawSel()
            else
                local lst = selGroups[g]
                if not lst or #lst == 0 then toast("G" .. g .. " kosong - tekan Simpan lalu G" .. g); return end
                local s = {}
                for _, i in ipairs(lst) do if fx[i] then s[i] = true end end
                setSel(s)
            end
        end, 36, { color = has and C.tx or C.mu })
    end
    saveBtn = chip("Simpan", function() saveGrp = not saveGrp; UI.paintSel(); if saveGrp then toast("Pilih fixture, lalu tekan G1-G4 untuk menyimpan") end end, 58)
    task.defer(function() selBar.CanvasPosition = keep end)
    UI.paintSel()
    if UI.drawLay then pcall(UI.drawLay) end
end

local function layoutPages(showBar)
    local y = showBar and 100 or 66
    for _, p in pairs(pages) do
        p.Position = UDim2.fromOffset(8, y)
        p.Size = UDim2.new(1, -16, 1, -(y + 22))
    end
end
local function showTab(id)
    currentTab = id
    local bar = (id == "fx" or id == "ly" or id == "pg" or id == "ef")
    selBar.Visible = bar
    layoutPages(bar)
    for k, p in pairs(pages) do p.Visible = (k == id) end
    for k, b in pairs(tabBtns) do b.BackgroundColor3 = (k == id) and C.ac or C.p2 end
    if dirty[id] then
        dirty[id] = nil
        refresh(id == "fx" and "drawFx" or id == "pg" and "drawProg" or "syncEff")
    end
    if id == "ly" then refresh("paintLay") end
end
for _, t in ipairs(TABS) do
    tabBtns[t[1]] = button(tabBar, t[2], function() showTab(t[1]) end, { sz = UDim2.new(1 / #TABS, -3, 1, 0), size = 12 })
    pages[t[1]] = new("Frame", { Position = UDim2.fromOffset(8, 66), Size = UDim2.new(1, -16, 1, -88), BackgroundTransparency = 1, Visible = false }, body)
end
local toastLbl = label(body, "", { color = C.mu, size = 12, sz = UDim2.new(1, -16, 0, 18), pos = UDim2.new(0, 8, 1, -20) })
local toastTok = 0
UI.toast = function(t) toastTok += 1; local my = toastTok; toastLbl.Text = t; task.delay(3, function() if toastTok == my then toastLbl.Text = "" end end) end

do
    local P = pages.fx
    local list = scroll(P, { sz = UDim2.new(1, 0, 1, -34), bg = C.p })
    local bar = new("Frame", { Position = UDim2.new(0, 0, 1, -28), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, P)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5) }, bar)
    local addT = 1
    local tBtn = button(bar, TYPES[TYPE_ORDER[1]].name, nil, { sz = UDim2.fromOffset(170, 28), size = 12 })
    tBtn.Activated:Connect(function() addT = addT % #TYPE_ORDER + 1; tBtn.Text = TYPES[TYPE_ORDER[addT]].name end)
    button(bar, "Tambah", function()
        local t, last = TYPE_ORDER[addT], fx[#fx]
        local a = last and last.addr + TYPES[last.t].ch or 1
        fx[#fx + 1] = mkFx(t, fitAddr(a, TYPES[t].ch))
        touch(); refresh("drawFx", "drawSel", "drawCues")
    end, { sz = UDim2.fromOffset(70, 28), size = 12 })

    UI.drawFx = function()
        clear(list)
        for i, f in ipairs(fx) do
            local col = TYPE_COL[f.t] or C.ac
            local b = button(list, "  " .. i .. ". " .. TYPES[f.t].name, function()
                local s = copySel(); s[i] = not s[i] or nil; setSel(s)
            end, { sz = UDim2.new(1, -8, 0, 36), bg = sel[i] and C.selbg or C.p2, stroke = sel[i] and col or C.ln, order = i })
            b.TextXAlignment = Enum.TextXAlignment.Left
            label(b, "DMX", { sz = UDim2.fromOffset(30, 36), pos = UDim2.new(1, -150, 0, 0), size = 11, color = C.mu })
            local ab = box(b, tostring(f.addr), "1", { sz = UDim2.fromOffset(60, 26), pos = UDim2.new(1, -118, .5, -13) })
            ab.FocusLost:Connect(function()
                f.addr = fitAddr(tonumber(ab.Text) or f.addr, TYPES[f.t].ch); ab.Text = tostring(f.addr); touch()
            end)
            button(b, "x", function()
                if #fx < 2 then toast("Minimal 1 fixture"); return end
                fx[i].fade = nil; table.remove(fx, i); sel = {}
                for _, l in ipairs(L) do l.members = {} end
                touch(); refresh("drawFx", "drawSel", "drawProg", "syncEff", "drawCues")
            end, { sz = UDim2.fromOffset(28, 26), pos = UDim2.new(1, -34, .5, -13), color = C.er })
        end
        if #fx == 0 then label(list, "Belum ada fixture.", { color = C.mu }) end
    end
end

local progRows, padObj = {}, nil
do
    local P = pages.pg
    local list = scroll(P)
    local function setV(t, k, v)
        for _, i in ipairs(selIdx()) do
            local f = fx[i]
            if f.t == t then if f.fade then f.fade[k] = nil end; f.v[k] = v end
        end
        touch()
    end
    local function fmtV(t, k, v)
        if k == "pan" then return math.floor((v - .5) * 540 + .5) .. "°" end
        if k == "tilt" then return math.floor((v - .5) * (t == "pixel" and 180 or 270) + .5) .. "°" end
        return tostring(math.floor(v * 255 + .5))
    end

    local function setMany(t, keys, v) for _, k in ipairs(keys) do setV(t, k, v) end end
    local function to255(t, keys, n) return function() setMany(t, keys, n / 255) end end
    local function rgbRow(lst, t, groups)
        local items = {}
        for _, c in ipairs(RGBP) do
            items[#items + 1] = { c[1], function()
                for _, g in ipairs(groups) do setV(t, g[1], c[2]); setV(t, g[2], c[3]); setV(t, g[3], c[4]) end
            end }
        end
        qrow(lst, "Warna:", items)
    end

    local function stepIdx(t, keys, N, d, lbl)
        local curv
        for _, i in ipairs(selIdx()) do if fx[i].t == t then curv = fx[i].v[keys[1]]; break end end
        if not curv then return end
        local idx = math.floor(math.floor(curv * 255 + .5) * N / 256) + 1
        local nx = (idx - 1 + d) % N + 1
        setMany(t, keys, math.floor((nx - .5) * 256 / N) / 255)
        toast(lbl .. " " .. nx .. "/" .. N)
    end
    local function stepper(t, keys, N, lbl)
        return { { lbl .. " -", function() stepIdx(t, keys, N, -1, lbl) end, w = 70 },
                 { lbl .. " +", function() stepIdx(t, keys, N, 1, lbl) end, w = 70 } }
    end

    UI.drawProg = function()
        clear(list); progRows = {}; padObj = nil
        local idxs = selIdx()
        if #idxs == 0 then label(list, "Pilih fixture di bar atas (angka = nomor fixture).", { color = C.mu }); return end
        local present, anyPos = {}, false
        for _, i in ipairs(idxs) do present[fx[i].t] = true; if TYPES[fx[i].t].pos then anyPos = true end end
        local bar = hlist(list, 28, true)
        button(bar, "Locate", function()
            for _, i in ipairs(selIdx()) do
                local f, T = fx[i], TYPES[fx[i].t]
                f.fade = nil
                for dk in pairs(T.ds) do f.v[dk] = 1 end
                for k, v in pairs(T.loc or {}) do f.v[k] = v end
            end
            touch()
        end, { sz = UDim2.fromOffset(70, 28) })
        button(bar, "Reset pilihan", function()
            for _, i in ipairs(selIdx()) do fx[i].fade = nil; fx[i].holdT = nil; fx[i].v = defV(fx[i].t) end
            touch()
        end, { sz = UDim2.fromOffset(100, 28), color = C.er, stroke = C.er })
        for _, t in ipairs(TYPE_ORDER) do
            if present[t] then
                label(list, TYPES[t].name, { color = TYPE_COL[t], font = Enum.Font.GothamBold, order = #list:GetChildren() })

                if t == "clara" then
                    local items = {}
                    for _, c in ipairs(COLORS) do items[#items + 1] = { c[1], to255("clara", { "color" }, c[2]) } end
                    items[#items + 1] = { "Strobe tutup", to255("clara", { "strobe" }, 0), w = 92 }
                    items[#items + 1] = { "Strobe buka", to255("clara", { "strobe" }, 208), w = 92 }
                    qrow(list, nil, items)
                    local lr = hlist(list, 28)
                    label(lr, "Lamp:", { sz = UDim2.fromOffset(40, 28), color = C.mu })
                    for _, q in ipairs({ { "On", 200 }, { "Off", 100 }, { "Reset", 250 } }) do
                        button(lr, q[1], function()
                            for _, i in ipairs(selIdx()) do
                                local f = fx[i]
                                if f.t == "clara" then f.v.ctrl = q[2] / 255; f.holdT = os.clock() + 4 end
                            end
                        end, { sz = UDim2.fromOffset(60, 28), color = q[1] == "Reset" and C.er or C.tx })
                    end

                elseif t == "strobe" then
                    qrow(list, nil, { { "Int penuh", to255("strobe", { "int" }, 255), w = 90 }, { "Int 0", to255("strobe", { "int" }, 0), w = 70 } })

                elseif t == "mapple" then
                    local function colItems(opts, keys)
                        local it = {}
                        for _, c in ipairs(opts) do it[#it + 1] = { c[1], to255("mapple", keys, c[2]), w = 56 } end
                        return it
                    end
                    qrow(list, "Amber:", colItems(ACOL, { "acol" }))
                    qrow(list, "RGB:", colItems(MCOL, { "rc1", "rc2", "rc3" }))
                    qrow(list, "Beam:", colItems(BCOL, { "bcol" }))
                    qrow(list, "Motor:", {
                        { "Posisi", to255("mapple", { "mmode" }, 0), w = 64 }, { "Putar >", to255("mapple", { "mmode" }, 100), w = 64 },
                        { "Putar <", to255("mapple", { "mmode" }, 200), w = 64 }, { "Stop", to255("mapple", { "mmode" }, 152), w = 54 },
                        { "Macro off", function() setMany("mapple", { "amac", "rmac", "bmac" }, 0) end, w = 80 } })

                elseif t == "parled" then
                    local items = {}
                    for _, c in ipairs(PCOL) do
                        items[#items + 1] = { c[1], function()
                            setV("parled", "r", c[2]); setV("parled", "g", c[3]); setV("parled", "b", c[4]); setV("parled", "w", c[5])
                        end }
                    end
                    qrow(list, "Warna:", items)
                    qrow(list, "Strobe:", { { "Off", to255("parled", { "strobe" }, 0) }, { "Sedang", to255("parled", { "strobe" }, 120) },
                        { "Cepat", to255("parled", { "strobe" }, 200) } })

                elseif t == "fogger" then
                    qrow(list, "Fog:", { { "Off", to255("fogger", { "fog" }, 0) }, { "Pelan", to255("fogger", { "fog" }, 60) },
                        { "Sedang", to255("fogger", { "fog" }, 130) }, { "Penuh", to255("fogger", { "fog" }, 255) } })

                elseif t == "blinder" then
                    local all = { "d1", "d2", "d3", "d4" }
                    local function pat(on, off) return function() setMany("blinder", on, 1); setMany("blinder", off, 0) end end
                    qrow(list, "LED:", {
                        { "Semua", to255("blinder", all, 255) }, { "Mati", to255("blinder", all, 0) },
                        { "1+3", pat({ "d1", "d3" }, { "d2", "d4" }) }, { "2+4", pat({ "d2", "d4" }, { "d1", "d3" }) },
                        { "1+2", pat({ "d1", "d2" }, { "d3", "d4" }) }, { "3+4", pat({ "d3", "d4" }, { "d1", "d2" }) } })

                elseif t == "flower" then
                    rgbRow(list, "flower", { { "r1", "g1", "b1" }, { "r2", "g2", "b2" } })
                    local items = stepper("flower", { "m1", "m2" }, 9, "Visual")
                    items[#items + 1] = { "Speed 50%", to255("flower", { "s1", "s2" }, 128), w = 76 }
                    items[#items + 1] = { "Speed 100%", to255("flower", { "s1", "s2" }, 255), w = 84 }
                    qrow(list, "Visual:", items)
                    qrow(list, "Motor:", {
                        { "Putar >", function() setMany("flower", { "mo1", "mo2" }, 40 / 255); setMany("flower", { "ms1", "ms2" }, .5) end, w = 64 },
                        { "Putar <", function() setMany("flower", { "mo1", "mo2" }, 130 / 255); setMany("flower", { "ms1", "ms2" }, .5) end, w = 64 },
                        { "Bolak-balik", function() setMany("flower", { "mo1", "mo2" }, 210 / 255); setMany("flower", { "ms1", "ms2" }, .5) end, w = 86 },
                        { "Stop", to255("flower", { "ms1", "ms2" }, 0), w = 54 } })
                    qrow(list, "Strobe:", { { "Off", to255("flower", { "str" }, 0) }, { "Sedang", to255("flower", { "str" }, 100) },
                        { "Cepat", to255("flower", { "str" }, 220) } })

                elseif t == "pixel" then
                    rgbRow(list, "pixel", { { "mr", "mg", "mb" } })
                    qrow(list, "Macro:", {
                        { "Off", to255("pixel", { "mmac" }, 0), w = 46 }, { "Putih", to255("pixel", { "mmac" }, 30), w = 54 },
                        { "R/B", to255("pixel", { "mmac" }, 77), w = 46 }, { "B/R", to255("pixel", { "mmac" }, 128), w = 46 },
                        { "RGB", to255("pixel", { "mmac" }, 179), w = 46 }, { "CMY", to255("pixel", { "mmac" }, 230), w = 46 } })
                    local ei = stepper("pixel", { "meff" }, 13, "Efek")
                    ei[#ei + 1] = { "Efek off", to255("pixel", { "meff" }, 0), w = 70 }
                    for _, x in ipairs(stepper("pixel", { "mstat" }, 22, "Pola")) do ei[#ei + 1] = x end
                    qrow(list, "Main:", ei)
                    qrow(list, "Tilt FX:", {
                        { "Off", to255("pixel", { "teff" }, 0), w = 46 }, { "Sine", to255("pixel", { "teff" }, 80), w = 54 },
                        { "Triangle", to255("pixel", { "teff" }, 140), w = 70 }, { "Square", to255("pixel", { "teff" }, 200), w = 64 } })
                    qrow(list, "Strobe:", { { "Off", to255("pixel", { "mstrb" }, 0) }, { "Sedang", to255("pixel", { "mstrb" }, 100) },
                        { "Cepat", to255("pixel", { "mstrb" }, 200) } })
                    qrow(list, "Amber:", { { "Penuh", to255("pixel", { "adim" }, 255) }, { "Mati", to255("pixel", { "adim" }, 0) } })

                elseif t == "retro" then
                    rgbRow(list, "retro", { { "r", "g", "b" } })
                    local function fxItems(keys)
                        return { { "Statis", to255("retro", keys, 0) }, { "Pulse", to255("retro", keys, 40) }, { "Seq", to255("retro", keys, 70) },
                            { "Trail", to255("retro", keys, 100) }, { "Vertikal", to255("retro", keys, 170), w = 66 } }
                    end
                    qrow(list, "Efek:", fxItems({ "ering", "eref" }))
                    qrow(list, "MTXI:", { { "Off", to255("retro", { "mring", "mref" }, 0) }, { "Pelan", to255("retro", { "mring", "mref" }, 60) },
                        { "Cepat", to255("retro", { "mring", "mref" }, 200) } })
                    qrow(list, "Strobe:", { { "Off", to255("retro", { "str" }, 0) }, { "Sedang", to255("retro", { "str" }, 100) },
                        { "Cepat", to255("retro", { "str" }, 190) } })

                elseif t == "wall" then
                    rgbRow(list, "wall", { { "r", "g", "b" } })
                    local items = stepper("wall", { "eff" }, 41, "Efek")
                    items[#items + 1] = { "Efek 1", to255("wall", { "eff" }, 3), w = 60 }
                    qrow(list, "Efek:", items)
                    qrow(list, "Speed:", { { "Stop", to255("wall", { "spd" }, 0) }, { "Pelan", to255("wall", { "spd" }, 64) },
                        { "Normal", to255("wall", { "spd" }, 128) }, { "Cepat", to255("wall", { "spd" }, 220) } })
                    qrow(list, "Strobe:", { { "Off", to255("wall", { "strobe" }, 0) }, { "Sedang", to255("wall", { "strobe" }, 100) },
                        { "Cepat", to255("wall", { "strobe" }, 200) } })

                elseif t == "windmill" then
                    rgbRow(list, "windmill", { { "r", "g", "b" } })
                    local keys = { "ei", "eo" }
                    qrow(list, "Efek:", {
                        { "Putih", to255("windmill", keys, 10) }, { "RGB", to255("windmill", keys, 50) }, { "Move", to255("windmill", keys, 110) },
                        { "Loop", to255("windmill", keys, 160) }, { "Expand", to255("windmill", keys, 200) }, { "Zoom", to255("windmill", keys, 240) } })
                    qrow(list, "Rotate:", { { "Stop", to255("windmill", { "rot" }, 0) }, { "Pelan", to255("windmill", { "rot" }, 40) },
                        { "Cepat", to255("windmill", { "rot" }, 200) } })
                    qrow(list, "Strobe:", { { "Off", to255("windmill", { "str" }, 0) }, { "Pelan", to255("windmill", { "str" }, 30) },
                        { "Cepat", to255("windmill", { "str" }, 90) } })
                end

                for _, p in ipairs(TYPES[t].p) do
                    if p[1] ~= "ctrl" then
                        local r = rowF(list, 26)
                        label(r, p[2], { sz = UDim2.fromOffset(78, 26), size = 12 })
                        local vl = label(r, "0", { sz = UDim2.fromOffset(44, 26), pos = UDim2.new(1, -44, 0, 0), size = 12, color = C.mu, align = Enum.TextXAlignment.Right })
                        local key = p[1]
                        local sl = slider(r, { pos = UDim2.fromOffset(80, 1), size = UDim2.new(1, -128, 0, 24),
                            onChange = function(v) setV(t, key, v); vl.Text = fmtV(t, key, v) end })
                        progRows[#progRows + 1] = { t = t, k = key, sl = sl, vl = vl }
                    end
                end
            end
        end
        if anyPos then
            label(list, "Posisi - seret untuk Pan/Tilt (Pixel Bar: hanya Tilt/vertikal)", { color = C.mu, order = #list:GetChildren() })
            padObj = pad2d(list, 160, function(x, y)
                for _, i in ipairs(selIdx()) do
                    local f = fx[i]
                    if TYPES[f.t].pos then
                        if f.fade then f.fade.pan = nil; f.fade.tilt = nil end
                        if f.v.pan ~= nil then f.v.pan = x end
                        if f.v.tilt ~= nil then f.v.tilt = y end
                    end
                end
                touch()
            end)
        end
    end
    task.spawn(function()
        while alive do
            if currentTab == "pg" and drag == nil then
                local idxs = selIdx()
                for _, r in ipairs(progRows) do
                    for _, i in ipairs(idxs) do
                        if fx[i] and fx[i].t == r.t then
                            local v = fx[i].v[r.k]
                            if v then r.sl.set(v); r.vl.Text = fmtV(r.t, r.k, v) end
                            break
                        end
                    end
                end
                if padObj then
                    for _, i in ipairs(idxs) do
                        if fx[i] and TYPES[fx[i].t].pos then padObj.mark(fx[i].v.pan or .5, fx[i].v.tilt or .5); break end
                    end
                end
            end
            task.wait(.1)
        end
    end)
end

-- ===================== TAB LAYOUT =====================
do
    local P = pages.ly
    local top = hlist(P, 28)
    local lblMode, snapOn = 1, true
    local LBL = { "Tipe", "DMX", "Nomor" }
    local icons = {}
    local legendBase = ""

    local function arrBtn(txt, mode, w)
        button(top, txt, function()
            arrange(mode); touch(); UI.drawLay()
            toast(#selIdx() > 0 and "Ditata: fixture terpilih" or "Ditata: semua fixture")
        end, { sz = UDim2.fromOffset(w, 28), size = 11 })
    end
    arrBtn("Baris", "row", 52)
    arrBtn("2 Baris", "rows", 58)
    arrBtn("Busur", "arc", 52)
    arrBtn("Grid", "grid", 48)
    arrBtn("Per tipe", "type", 62)
    local lblBtn = button(top, "", function() lblMode = lblMode % #LBL + 1; UI.drawLay() end, { sz = UDim2.fromOffset(100, 28), size = 11 })
    local snapBtn = button(top, "", function() snapOn = not snapOn; UI.drawLay() end, { sz = UDim2.fromOffset(78, 28), size = 11 })

    local stage = new("Frame", { Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -56), BackgroundColor3 = C.bg,
        BorderSizePixel = 0, ClipsDescendants = true }, P)
    corner(stage, 6); stroke(stage)
    for n = 1, 9 do
        local col = n == 5 and C.ln or C.p
        new("Frame", { Position = UDim2.fromScale(n / 10, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = col, BorderSizePixel = 0 }, stage)
        new("Frame", { Position = UDim2.fromScale(0, n / 10), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = col, BorderSizePixel = 0 }, stage)
    end
    label(stage, "BELAKANG", { sz = UDim2.new(1, 0, 0, 14), pos = UDim2.fromOffset(0, 3), size = 10, color = C.mu, align = Enum.TextXAlignment.Center })
    label(stage, "DEPAN / PENONTON", { sz = UDim2.new(1, 0, 0, 14), pos = UDim2.new(0, 0, 1, -17), size = 10, color = C.mu, align = Enum.TextXAlignment.Center })

    local bgHit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, stage)
    local iconLayer = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, stage)
    local rect = new("Frame", { BackgroundColor3 = C.ac, BackgroundTransparency = .8, BorderSizePixel = 0, Visible = false, ZIndex = 5 }, stage)
    new("UIStroke", { Color = C.ac, Thickness = 1 }, rect)
    local legend = label(P, "", { color = C.mu, size = 11, sz = UDim2.new(1, 0, 0, 16), pos = UDim2.new(0, 0, 1, -18) })

    -- pilih dengan kotak (seret area kosong), klik area kosong = batal pilih
    bgHit.InputBegan:Connect(function(inp)
        if not isPress(inp) then return end
        local p0 = inp.Position
        local ox, oy = stage.AbsolutePosition.X, stage.AbsolutePosition.Y
        local moved = false
        local x1, y1, x2, y2 = 0, 0, 0, 0
        drag = function(p)
            if not moved and (p - p0).Magnitude < 5 then return end
            moved = true
            x1, y1 = math.min(p0.X, p.X) - ox, math.min(p0.Y, p.Y) - oy
            x2, y2 = math.max(p0.X, p.X) - ox, math.max(p0.Y, p.Y) - oy
            rect.Position = UDim2.fromOffset(x1, y1)
            rect.Size = UDim2.fromOffset(x2 - x1, y2 - y1)
            rect.Visible = true
        end
        dragEnd = function()
            rect.Visible = false
            if not moved then setSel({}); return end
            local W, H = stage.AbsoluteSize.X, stage.AbsoluteSize.Y
            local s = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and copySel() or {}
            for i, f in ipairs(fx) do
                local cx, cy = (f.x or .5) * W, (f.y or .5) * H
                if cx >= x1 and cx <= x2 and cy >= y1 and cy <= y2 then s[i] = true end
            end
            setSel(s)
        end
    end)

    local function iconText(i)
        local f = fx[i]
        if lblMode == 1 then return i .. "\n" .. SHORT[f.t] end
        if lblMode == 2 then return i .. "\n" .. f.addr end
        return tostring(i)
    end

    local function mkIcon(i)
        local f = fx[i]
        local b = new("TextButton", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(f.x, f.y), Size = UDim2.fromOffset(42, 36),
            BackgroundColor3 = C.p2, BorderSizePixel = 0, AutoButtonColor = false, Text = iconText(i), Font = Enum.Font.GothamMedium,
            TextSize = 11, TextColor3 = C.tx }, iconLayer)
        corner(b, 5)
        new("UIStroke", { Color = TYPE_COL[f.t], Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, b)
        b.InputBegan:Connect(function(inp)
            if not isPress(inp) then return end
            local p0 = inp.Position
            local movers = sel[i] and selIdx() or { i }
            local st = {}
            for _, j in ipairs(movers) do st[j] = { fx[j].x, fx[j].y } end
            local grp = #movers > 1
            local moved = false
            drag = function(p)
                local dx, dy = p.X - p0.X, p.Y - p0.Y
                if not moved and dx * dx + dy * dy < 25 then return end
                moved = true
                local W, H = math.max(1, stage.AbsoluteSize.X), math.max(1, stage.AbsoluteSize.Y)
                local ddx, ddy = dx / W, dy / H
                local loX, hiX, loY, hiY = -1, 1, -1, 1
                for _, s0 in pairs(st) do
                    loX = math.max(loX, .04 - s0[1]); hiX = math.min(hiX, .96 - s0[1])
                    loY = math.max(loY, .07 - s0[2]); hiY = math.min(hiY, .93 - s0[2])
                end
                ddx, ddy = cl(ddx, loX, hiX), cl(ddy, loY, hiY)
                if snapOn and grp then
                    ddx = math.floor(ddx / .025 + .5) * .025
                    ddy = math.floor(ddy / .025 + .5) * .025
                end
                for j, s0 in pairs(st) do
                    local nx, ny = s0[1] + ddx, s0[2] + ddy
                    if snapOn and not grp then
                        nx = math.floor(nx / .025 + .5) * .025
                        ny = math.floor(ny / .025 + .5) * .025
                    end
                    fx[j].x, fx[j].y = nx, ny
                    if icons[j] then icons[j].Position = UDim2.fromScale(nx, ny) end
                end
            end
            dragEnd = function()
                if moved then
                    touch()
                else
                    local s = copySel(); s[i] = not s[i] or nil; setSel(s)
                end
            end
        end)
        icons[i] = b
    end

    local COLK = { parled = { "r", "g", "b" }, wall = { "r", "g", "b" }, windmill = { "r", "g", "b" }, retro = { "r", "g", "b" },
        pixel = { "mr", "mg", "mb" }, flower = { "r1", "g1", "b1" } }

    UI.paintLay = function()
        for i, b in pairs(icons) do
            local f = fx[i]
            if f and b.Parent then
                local base = TYPE_COL[f.t] or C.ac
                local lv = liveLevel(i)
                local col = base
                local ck = COLK[f.t]
                if ck then
                    local o = out(i)
                    local r, g, bl = o[ck[1]] or 0, o[ck[2]] or 0, o[ck[3]] or 0
                    if r + g + bl > .08 then col = Color3.new(r, g, bl) end
                end
                b.BackgroundColor3 = C.p2:Lerp(col, lv * .9)
                b.TextColor3 = lv > .5 and DARK or C.tx
                local st = b:FindFirstChildOfClass("UIStroke")
                if st then
                    st.Color = sel[i] and Color3.new(1, 1, 1) or base
                    st.Thickness = sel[i] and 2.5 or 1.5
                end
            end
        end
        local n = #selIdx()
        legend.Text = legendBase .. (n > 0 and ("   |   terpilih " .. n) or "")
    end

    UI.drawLay = function()
        ensurePos()
        clear(iconLayer); icons = {}
        lblBtn.Text = "Label: " .. LBL[lblMode]
        snapBtn.Text = "Snap: " .. (snapOn and "ON" or "OFF")
        local cnt, parts = {}, {}
        for i, f in ipairs(fx) do mkIcon(i); cnt[f.t] = (cnt[f.t] or 0) + 1 end
        for _, t in ipairs(TYPE_ORDER) do
            if cnt[t] then parts[#parts + 1] = SHORT[t] .. " " .. cnt[t] end
        end
        legendBase = #fx .. " fixture:  " .. table.concat(parts, "  ")
        UI.paintLay()
    end

    task.spawn(function()
        while alive do
            if currentTab == "ly" and drag == nil then pcall(UI.paintLay) end
            task.wait(.1)
        end
    end)
end

-- ===================== TAB EFFECT =====================
do
    local P = pages.ef
    local list = scroll(P)

    local PRESETS = {
        dim = {
            { "Chase", { shape = "saw", groups = 0, block = 1, wing = 0, phase = 360, dty = .55, dep = 1, dir = ">", rate = .5, soft = .25 } },
            { "Chase balik", { shape = "saw", groups = 0, block = 1, wing = 0, phase = 360, dty = .55, dep = 1, dir = "<", rate = .5, soft = .25 } },
            { "Ping-pong", { shape = "square", groups = 0, block = 1, wing = 0, phase = 360, dty = .15, dep = 1, dir = "<>", rate = .35, soft = .3 } },
            { "Ganjil/Genap", { shape = "square", groups = 2, block = 1, wing = 0, phase = 180, dty = .5, dep = 1, dir = ">", rate = 1, soft = 0 } },
            { "Block 4", { shape = "square", groups = 2, block = 4, wing = 0, phase = 180, dty = .5, dep = 1, dir = ">", rate = 1, soft = 0 } },
            { "Sisi > tengah", { shape = "saw", groups = 0, block = 1, wing = 2, phase = 360, dty = .55, dep = 1, dir = ">", rate = .5, soft = .25 } },
            { "Tengah > sisi", { shape = "saw", groups = 0, block = 1, wing = 2, phase = 360, dty = .55, dep = 1, dir = "<", rate = .5, soft = .25 } },
            { "Silang", { shape = "saw", groups = 0, block = 1, wing = -2, phase = 360, dty = .55, dep = 1, dir = ">", rate = .5, soft = .25 } },
            { "Wave", { shape = "sine", groups = 0, block = 1, wing = 0, phase = 360, dty = 1, dep = 1, dir = ">", rate = .3, soft = 0 } },
            { "Acak", { shape = "rand", groups = 0, block = 1, wing = 0, phase = 360, dty = .5, dep = 1, dir = ">", rate = 2, soft = 0 } },
            { "Flash", { shape = "square", groups = 1, block = 1, wing = 0, phase = 0, dty = .5, dep = 1, dir = ">", rate = 4, soft = 0 } },
        },
        pos = {
            { "Circle", { shape = "circle", groups = 1, block = 1, wing = 0, phase = 0, sx = .3, sy = .3, dir = ">", rate = .3 } },
            { "Circle fan", { shape = "circle", groups = 0, block = 1, wing = 0, phase = 360, sx = .3, sy = .3, dir = ">", rate = .3 } },
            { "Circle cermin", { shape = "circle", groups = 1, block = 1, wing = 2, phase = 0, sx = .3, sy = .3, dir = ">", rate = .3, wax = "x" } },
            { "Fig 8", { shape = "fig8", groups = 0, block = 1, wing = 0, phase = 90, sx = .35, sy = .25, dir = ">", rate = .3 } },
            { "Sapu", { shape = "sine", groups = 1, block = 1, wing = 0, phase = 0, sx = .5, sy = 0, dir = ">", rate = .25 } },
            { "Cermin", { shape = "sine", groups = 1, block = 1, wing = 2, phase = 0, sx = .5, sy = 0, dir = ">", rate = .25, wax = "x" } },
            { "Silang", { shape = "sine", groups = 1, block = 1, wing = -2, phase = 0, sx = .5, sy = 0, dir = ">", rate = .25, wax = "x" } },
            { "Kipas", { shape = "sine", groups = 0, block = 1, wing = 0, phase = 180, sx = .5, sy = 0, dir = ">", rate = .25 } },
            { "Tilt wave", { shape = "sine", groups = 0, block = 1, wing = 0, phase = 360, sx = 0, sy = .4, dir = ">", rate = .3 } },
            { "Tilt cermin", { shape = "sine", groups = 1, block = 1, wing = 2, phase = 0, sx = 0, sy = .4, dir = ">", rate = .3, wax = "y" } },
            { "Acak", { shape = "rand", groups = 0, block = 1, wing = 0, phase = 360, sx = .4, sy = .3, dir = ">", rate = .25 } },
        },
    }

    local function card(title, col, order)
        local f = new("Frame", { Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = C.p, BorderSizePixel = 0, LayoutOrder = order }, list)
        corner(f, 6); stroke(f); pad(f, 6)
        new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, f)
        label(f, title, { size = 11, font = Enum.Font.GothamBold, color = col or C.mu, sz = UDim2.new(1, 0, 0, 14), order = 0 })
        return f
    end
    local function wrap(parent, order)
        local f = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = order }, parent)
        new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), Wraps = true,
            SortOrder = Enum.SortOrder.LayoutOrder }, f)
        return f
    end
    local function note(parent, text, order)
        return label(parent, text, { color = C.mu, wrap = true, size = 11, sz = UDim2.new(1, 0, 0, 28), order = order })
    end
    local function rangeStr(m)
        local o, i = {}, 1
        while i <= #m do
            local j = i
            while j < #m and m[j + 1] == m[j] + 1 do j += 1 end
            o[#o + 1] = j > i and (m[i] .. "-" .. m[j]) or tostring(m[i])
            i = j + 1
        end
        return table.concat(o, ", ")
    end
    local function phaseCol(g, Gn) return Color3.fromHSV((g / math.max(1, Gn)) * .85, .55, .92) end

    local updPat, updPv

    -- ---- monitor live ----
    local cMon = card("MONITOR LIVE", C.mu, 1)
    local monMode, monSig, monSq = "stage", "", {}
    local monBtn = button(cMon, "", function() monMode = monMode == "stage" and "list" or "stage"; monSig = "" end,
        { sz = UDim2.fromOffset(130, 24), size = 11, order = 1 })
    local monStage = new("Frame", { Size = UDim2.new(1, 0, 0, 112), BackgroundColor3 = C.bg, BorderSizePixel = 0, LayoutOrder = 2,
        ClipsDescendants = true }, cMon)
    corner(monStage); stroke(monStage)
    local monList = wrap(cMon, 3)
    local function rebuildMon()
        clear(monStage); clear(monList); monSq = {}
        monStage.Visible = monMode == "stage"
        monList.Visible = monMode == "list"
        monBtn.Text = monMode == "stage" and "Tampilan: Layout" or "Tampilan: Urut"
        for i, f in ipairs(fx) do
            local s = new("TextLabel", { Size = UDim2.fromOffset(22, 22), BackgroundColor3 = C.p2, BorderSizePixel = 0, Text = tostring(i),
                Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.mu, LayoutOrder = i }, monMode == "stage" and monStage or monList)
            if monMode == "stage" then
                s.AnchorPoint = Vector2.new(.5, .5)
                s.Position = UDim2.fromScale(f.x or .5, f.y or .5)
            end
            corner(s, 4)
            local st = new("UIStroke", { Color = TYPE_COL[f.t], Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, s)
            monSq[i] = { s = s, st = st }
        end
    end
    local function tickMon()
        local l = L[cur]
        local m = #l.members > 0 and l.members or selIdx()
        local info = {}
        for k, i in ipairs(m) do
            local g, Gn = slotPhase(l, k, #m)
            info[i] = phaseCol(g, Gn)
        end
        for i, q in ipairs(monSq) do
            local lv = liveLevel(i)
            q.s.BackgroundColor3 = C.p2:Lerp(Color3.fromRGB(255, 246, 215), lv)
            q.s.TextColor3 = lv > .55 and DARK or C.mu
            local c = info[i]
            q.st.Color = c or TYPE_COL[fx[i].t]
            q.st.Thickness = c and 2 or 1
        end
    end

    -- ---- slot ----
    local cCtl = card("SLOT", C.ac, 2)
    local tabRow = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 1 }, cCtl)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, tabRow)
    local slotBtns, slotDots = {}, {}
    for i = 1, 4 do
        slotBtns[i] = button(tabRow, "", function() cur = i; UI.syncEff() end, { sz = UDim2.new(.25, -3, 1, 0), size = 12 })
        slotDots[i] = new("Frame", { Size = UDim2.fromOffset(6, 6), Position = UDim2.new(1, -11, 0, 5), BackgroundColor3 = C.ok,
            BorderSizePixel = 0, Visible = false }, slotBtns[i])
        corner(slotDots[i], 3)
    end
    local ctlRow = wrap(cCtl, 2)
    local onBtn = button(ctlRow, "", nil, { sz = UDim2.fromOffset(120, 34), size = 13, order = 1 })
    onBtn.Activated:Connect(function()
        local l = L[cur]
        if l.on then
            l.on = false
        else
            local idxs = selIdx()
            if #idxs > 0 then l.members = idxs end
            if #l.members == 0 then toast("Pilih fixture dulu di bar atas"); return end
            l.on = true
        end
        UI.syncEff(); touch()
    end)
    button(ctlRow, "Ambil pilihan", function()
        local idxs = selIdx()
        if #idxs == 0 then toast("Pilih fixture dulu"); return end
        L[cur].members = idxs; UI.syncEff(); touch(); toast("Slot " .. cur .. ": " .. #idxs .. " fixture")
    end, { sz = UDim2.fromOffset(104, 34), size = 12, order = 2 })
    local taps = {}
    button(ctlRow, "Tap tempo", function()
        local n = os.clock()
        local nt = {}
        for _, t in ipairs(taps) do if n - t < 2.5 then nt[#nt + 1] = t end end
        nt[#nt + 1] = n; taps = nt
        if #taps > 1 then L[cur].rate = cl(1 / ((taps[#taps] - taps[1]) / (#taps - 1)), .01, 6); UI.syncEff(); touch() end
    end, { sz = UDim2.fromOffset(80, 34), size = 12, order = 3 })
    local rstSlot = button(ctlRow, "Reset slot", nil, { sz = UDim2.fromOffset(80, 34), size = 12, color = C.er, stroke = C.er, order = 4 })
    confirmBtn(rstSlot, "Yakin?", function()
        local keep = L[cur]
        L[cur] = defL(cur); L[cur].ph = keep.ph
        UI.syncEff(); touch()
    end)
    local memLbl = label(cCtl, "", { color = C.mu, size = 11, wrap = true, sz = UDim2.new(1, 0, 0, 14), order = 3 })

    -- ---- preset ----
    local cPre = card("PRESET  (langsung aktif di fixture terpilih)", C.warn, 3)
    local presetWrap = wrap(cPre, 1)
    local builtFor
    local PKEYS = { "shape", "rate", "sx", "sy", "phase", "groups", "block", "wing", "wmir", "dty", "dep", "dir", "soft", "wax" }
    local function applyPreset(p)
        local l = L[cur]
        local base = defL(cur)
        for _, k in ipairs(PKEYS) do l[k] = base[k] end
        for k, v in pairs(p[2]) do l[k] = v end
        local idxs = selIdx()
        if #idxs > 0 then l.members = idxs; l.on = true end
        UI.syncEff(); touch()
        toast(p[1] .. (#idxs > 0 and " aktif" or " - pilih fixture lalu tekan NYALA"))
    end
    local function buildPresets(target)
        clear(presetWrap); builtFor = target
        for n, p in ipairs(PRESETS[target] or {}) do
            button(presetWrap, p[1], function() applyPreset(p) end,
                { sz = UDim2.fromOffset(math.max(66, 7 * #p[1] + 20), 28), size = 11, order = n })
        end
    end

    -- ---- pratinjau ----
    local cPv = card("PRATINJAU", C.ac, 4)
    local NB = 64
    local pvWave = new("Frame", { Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = C.bg, BorderSizePixel = 0, LayoutOrder = 1 }, cPv)
    corner(pvWave); stroke(pvWave)
    local bars = {}
    for j = 1, NB do
        bars[j] = new("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((j - 1) / NB, 1, 1, -2), Size = UDim2.new(1 / NB, -1, .5, 0),
            BackgroundColor3 = C.warn, BorderSizePixel = 0 }, pvWave)
    end
    local head = new("Frame", { Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 2 }, pvWave)
    local pvRow = new("Frame", { Size = UDim2.new(1, 0, 0, 132), BackgroundTransparency = 1, LayoutOrder = 2 }, cPv)
    local pvXY = new("Frame", { Size = UDim2.fromOffset(130, 130), BackgroundColor3 = C.bg, BorderSizePixel = 0 }, pvRow)
    corner(pvXY); stroke(pvXY)
    new("Frame", { Position = UDim2.new(.5, 0, 0, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = C.ln, BorderSizePixel = 0 }, pvXY)
    new("Frame", { Position = UDim2.new(0, 0, .5, 0), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.ln, BorderSizePixel = 0 }, pvXY)
    local pathDots, fxDots = {}, {}
    for j = 1, 48 do
        pathDots[j] = new("Frame", { Size = UDim2.fromOffset(2, 2), AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = C.mu, BorderSizePixel = 0 }, pvXY)
    end
    for j = 1, 16 do
        local d = new("Frame", { Size = UDim2.fromOffset(9, 9), AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = C.ac, BorderSizePixel = 0,
            Visible = false, ZIndex = 3 }, pvXY)
        corner(d, 5)
        fxDots[j] = d
    end
    local pvInfo = label(pvRow, "", { pos = UDim2.fromOffset(140, 0), sz = UDim2.new(1, -140, 1, 0), wrap = true, size = 11, color = C.mu })
    pvInfo.TextYAlignment = Enum.TextYAlignment.Top

    updPv = function()
        local l = L[cur]
        local isPos = l.target == "pos"
        pvWave.Visible = not isPos
        pvRow.Visible = isPos
        if isPos then
            local rnd = l.shape == "rand"
            for j, d in ipairs(pathDots) do
                d.Visible = not rnd
                if not rnd then
                    local x, y = moveXY(l.shape, TAU * (j - 1) / #pathDots, 1)
                    d.Position = UDim2.fromScale(.5 + x * (l.sx or 0) * .5, .5 - y * (l.sy or 0) * .5)
                end
            end
            pvInfo.Text = ("Pan  +-%d deg\nTilt +-%d deg\n\nBentuk diperkecil otomatis kalau pan/tilt mentok batas, supaya tidak gepeng.\n\nTitik warna = fase tiap fixture, sama dengan chip di SUSUNAN.")
                :format(math.floor((l.sx or 0) * 270 + .5), math.floor((l.sy or 0) * 270 + .5))
        else
            for j = 1, NB do
                local lv = lvlOf(l.shape, l.shape == "rand" and (j - 1) or (j - 1) / NB, l.dty or .5, l.soft or 0, 1, true)
                local v = 1 - (l.dep or 1) * (1 - lv)
                bars[j].Size = UDim2.new(1 / NB, -1, math.max(.03, v) * .92, 0)
            end
        end
    end
    local function tickPv()
        local l = L[cur]
        local u0 = ang(l)
        if l.target == "pos" then
            local m = #l.members > 0 and l.members or selIdx()
            local n = #m
            for j, d in ipairs(fxDots) do
                if m[j] then
                    local g, Gn, mir = slotPhase(l, j, n)
                    local gf = (g / Gn) * (l.phase or 0) / 360
                    local x, y = moveXY(l.shape, ((l.shape == "rand" and (l.ph or 0) or u0) - gf) * TAU, j)
                    if mir then x, y = mirXY(l, x, y) end
                    d.Position = UDim2.fromScale(cl(.5 + x * (l.sx or 0) * .5, 0, 1), cl(.5 - y * (l.sy or 0) * .5, 0, 1))
                    d.BackgroundColor3 = phaseCol(g, Gn)
                    d.Visible = true
                else
                    d.Visible = false
                end
            end
        else
            head.Position = UDim2.new(l.dir == "<>" and u0 or (u0 % 1), 0, 0, 0)
        end
    end

    -- ---- bentuk & arah ----
    local cShape = card("BENTUK & ARAH", C.ac, 5)
    local shapeWrap = wrap(cShape, 1)
    local shapeBtns = {}
    for n, s in ipairs(SHAPES) do
        shapeBtns[s] = button(shapeWrap, SHAPE_NAME[s], function() L[cur].shape = s; UI.syncEff(); touch() end,
            { sz = UDim2.fromOffset(s == "saw" and 70 or 74, 28), size = 11, order = n })
    end
    local dirWrap = wrap(cShape, 2)
    local dirBtns = {}
    for n, d in ipairs(DIRS) do
        dirBtns[d] = button(dirWrap, DIR_NAME[d], function() L[cur].dir = d; UI.syncEff(); touch() end,
            { sz = UDim2.fromOffset(74, 28), size = 11, order = n })
    end

    -- ---- slider ----
    local rowsSP = {}
    local function pct(v) return math.floor((v or 0) * 100 + .5) .. "%" end
    local SP = {
        rate = { key = "rate", name = "Rate", min = .01, max = 6, step = .01, nudge = .05, def = .4,
            fmt = function(l) return ("%.2f Hz  %d bpm"):format(l.rate or .4, math.floor((l.rate or .4) * 60 + .5)) end },
        phase = { key = "phase", name = "Phase", min = 0, max = 360, step = 1, nudge = 15, def = 90,
            fmt = function(l) return math.floor(l.phase or 0) .. " deg" end },
        sx = { key = "sx", name = "Pan", min = 0, max = 1, step = .01, nudge = .05, def = .3,
            fmt = function(l) return "+-" .. math.floor((l.sx or 0) * 270 + .5) .. " deg" end },
        sy = { key = "sy", name = "Tilt", min = 0, max = 1, step = .01, nudge = .05, def = .3,
            fmt = function(l) return "+-" .. math.floor((l.sy or 0) * 270 + .5) .. " deg" end },
        dty = { key = "dty", name = "Lebar", min = .05, max = 1, step = .01, nudge = .05, def = .5, fmt = function(l) return pct(l.dty) end },
        dep = { key = "dep", name = "Depth", min = 0, max = 1, step = .01, nudge = .05, def = 1, fmt = function(l) return pct(l.dep) end },
        soft = { key = "soft", name = "Halus", min = 0, max = 1, step = .01, nudge = .05, def = 0, fmt = function(l) return pct(l.soft) end },
        groups = { key = "groups", name = "Group", min = 0, max = 8, step = 1, nudge = 1, def = 0,
            fmt = function(l) return (l.groups or 0) == 0 and "Auto" or tostring(l.groups) end },
        block = { key = "block", name = "Block", min = 1, max = 8, step = 1, nudge = 1, def = 1, fmt = function(l) return tostring(l.block or 1) end },
        wing = { key = "wing", name = "Wing", min = -4, max = 4, step = 1, nudge = 1, def = 0, fmt = function(l)
            local w = math.floor(l.wing or 0)
            if math.abs(w) < 2 then return "Off" end
            return w > 0 and (w .. " sisi") or (-w .. " selang")
        end },
    }
    local function sliderRow(parent, order, s)
        local r = new("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = order }, parent)
        label(r, s.name, { sz = UDim2.fromOffset(50, 28), size = 12 })
        local vl = label(r, "", { sz = UDim2.fromOffset(92, 28), pos = UDim2.new(1, -92, 0, 0), size = 12,
            align = Enum.TextXAlignment.Right, font = Enum.Font.GothamMedium })
        local sl = slider(r, { pos = UDim2.fromOffset(110, 2), size = UDim2.new(1, -208, 0, 24), min = s.min, max = s.max, step = s.step,
            onChange = function(v) L[cur][s.key] = v; vl.Text = s.fmt(L[cur]); updPat(); updPv(); touch() end })
        local function nudge(d)
            local l = L[cur]
            local v = cl((l[s.key] ~= nil and l[s.key] or s.def) + d * s.nudge, s.min, s.max)
            v = math.floor(v * 1000 + .5) / 1000
            l[s.key] = v; sl.set(v); vl.Text = s.fmt(l); updPat(); updPv(); touch()
        end
        button(r, "-", function() nudge(-1) end, { sz = UDim2.fromOffset(24, 26), pos = UDim2.fromOffset(52, 1), size = 14 })
        button(r, "+", function() nudge(1) end, { sz = UDim2.fromOffset(24, 26), pos = UDim2.fromOffset(80, 1), size = 14 })
        rowsSP[#rowsSP + 1] = { key = s.key, sl = sl, vl = vl, fmt = s.fmt, def = s.def }
    end

    local cTime = card("WAKTU", C.ac, 6)
    sliderRow(cTime, 1, SP.rate)
    sliderRow(cTime, 2, SP.phase)

    local cSize = card("UKURAN GERAK", C.ac, 7)
    sliderRow(cSize, 1, SP.sx)
    sliderRow(cSize, 2, SP.sy)

    local cLvl = card("LEVEL DIMMER", C.warn, 8)
    sliderRow(cLvl, 1, SP.dty)
    sliderRow(cLvl, 2, SP.dep)
    sliderRow(cLvl, 3, SP.soft)
    local shutBtn = button(cLvl, "", function() L[cur].useShut = not (L[cur].useShut ~= false); UI.syncEff(); touch() end,
        { sz = UDim2.new(1, 0, 0, 30), size = 12, order = 4 })
    local shutNote = note(cLvl, "", 5)

    -- ---- susunan ----
    local cLay = card("SUSUNAN FIXTURE", C.ok, 9)
    local patWrap = wrap(cLay, 1)
    local patInfo = label(cLay, "", { color = C.mu, size = 11, sz = UDim2.new(1, 0, 0, 14), order = 2 })
    sliderRow(cLay, 3, SP.groups)
    sliderRow(cLay, 4, SP.block)
    sliderRow(cLay, 5, SP.wing)
    local mirWrap = wrap(cLay, 6)
    local wmirBtn = button(mirWrap, "", function() L[cur].wmir = not (L[cur].wmir ~= false); UI.syncEff(); touch() end,
        { sz = UDim2.fromOffset(130, 28), size = 11, order = 1 })
    local waxBtn = button(mirWrap, "", function()
        local l = L[cur]
        local nx = { x = "y", y = "xy", xy = "x" }
        l.wax = nx[l.wax or "x"] or "x"
        UI.syncEff(); touch()
    end, { sz = UDim2.fromOffset(120, 28), size = 11, order = 2 })
    note(cLay, "Group = jumlah fase. Block = fixture per fase. Wing +N = N sisi simetris, Wing -N = N jalur selang-seling. Garis putih = jalur dicerminkan.", 7)

    local patSig = ""
    updPat = function()
        local l = L[cur]
        local m = #l.members > 0 and l.members or selIdx()
        local preview = #l.members == 0
        local sig = table.concat(m, ",") .. "|" .. tostring(preview) .. "|" .. (l.groups or 0) .. "|" .. (l.block or 1)
            .. "|" .. (l.wing or 0) .. "|" .. tostring(l.wmir) .. "|" .. cur
        if sig == patSig then return end
        patSig = sig
        clear(patWrap)
        local n = #m
        if n == 0 then
            patInfo.Text = ""
            label(patWrap, "Belum ada fixture. Pilih di bar atas, lalu tekan NYALA.", { color = C.mu, size = 12, sz = UDim2.new(1, 0, 0, 20) })
            return
        end
        local gmax = 1
        for k = 1, n do
            local g, Gn, mir = slotPhase(l, k, n)
            gmax = Gn
            local s = new("TextLabel", { Size = UDim2.fromOffset(30, 30), BackgroundColor3 = phaseCol(g, Gn),
                BackgroundTransparency = preview and .55 or 0, BorderSizePixel = 0, Text = tostring(m[k]), Font = Enum.Font.GothamBold,
                TextSize = 12, TextColor3 = DARK, LayoutOrder = k }, patWrap)
            corner(s, 5)
            if mir then new("UIStroke", { Color = Color3.new(1, 1, 1), Thickness = 2 }, s) end
        end
        patInfo.Text = n .. " fixture, " .. gmax .. " fase" .. (preview and "  (pratinjau pilihan)" or "")
    end

    UI.syncEff = function()
        local l = L[cur]
        local isPos = l.target == "pos"
        for i = 1, 4 do
            local b = slotBtns[i]
            local col = i <= 2 and LAYERS.mov.c or LAYERS.dim.c
            b.Text = i .. (i <= 2 and "  Gerak" or "  Dimmer")
            b.BackgroundColor3 = i == cur and col or C.p2
            b.TextColor3 = i == cur and DARK or C.tx
            slotDots[i].Visible = L[i].on
            slotDots[i].BackgroundColor3 = i == cur and DARK or C.ok
            local st = b:FindFirstChildOfClass("UIStroke")
            if st then st.Color = col end
        end
        onBtn.Text = l.on and "NYALA" or "MATI"
        onBtn.BackgroundColor3 = l.on and C.ok or C.p2
        onBtn.TextColor3 = l.on and DARK or C.tx
        memLbl.Text = #l.members > 0 and ("Fixture: " .. rangeStr(l.members)) or "Fixture: belum ada"

        for s, b in pairs(shapeBtns) do
            b.Visible = isPos or (s ~= "circle" and s ~= "fig8")
            b.Text = (s == "saw" and not isPos) and "Chase" or SHAPE_NAME[s]
            b.BackgroundColor3 = l.shape == s and C.ac or C.p2
            b.TextColor3 = l.shape == s and DARK or C.tx
        end
        for d, b in pairs(dirBtns) do
            b.BackgroundColor3 = l.dir == d and C.ac or C.p2
            b.TextColor3 = l.dir == d and DARK or C.tx
        end
        wmirBtn.Text = "Cermin jalur: " .. (l.wmir ~= false and "ON" or "OFF")
        wmirBtn.BackgroundColor3 = l.wmir ~= false and C.selbg or C.p2
        waxBtn.Visible = isPos
        waxBtn.Text = "Sumbu: " .. string.upper(l.wax or "x")

        cSize.Visible = isPos
        cLvl.Visible = not isPos
        local gate = l.useShut ~= false
        shutBtn.Text = gate and "Clara S: gate shutter (instan)" or "Clara S: dimmer halus (ada fade)"
        shutBtn.BackgroundColor3 = gate and C.warn or C.p2
        shutBtn.TextColor3 = gate and DARK or C.tx
        shutNote.Text = gate and "Level di bawah 50% = shutter tertutup, tanpa delay. Lebar/Depth tetap berlaku. Fixture lain pakai dimmer."
            or "Clara S ikut channel Dimmer, jadi ada fade-in/out."

        for _, s in ipairs(rowsSP) do
            local v = l[s.key]
            if v == nil then v = s.def end
            s.sl.set(v); s.vl.Text = s.fmt(l)
        end
        if builtFor ~= l.target then buildPresets(l.target) end
        patSig = ""
        updPat()
        updPv()
    end

    task.spawn(function()
        while alive do
            if currentTab == "ef" then
                local sig = monMode .. #fx .. ":"
                for _, f in ipairs(fx) do
                    sig = sig .. f.t:sub(1, 2) .. math.floor((f.x or 0) * 100) .. "," .. math.floor((f.y or 0) * 100) .. ";"
                end
                if sig ~= monSig then monSig = sig; rebuildMon() end
                tickMon(); updPat(); tickPv()
            end
            task.wait(.08)
        end
    end)
end

local cueMode, cueBind, storeLayer, selOnly = nil, nil, "dim", false
local touchOnly = UIS.TouchEnabled and not UIS.KeyboardEnabled
local SPECIAL = {
    { id = "blind", text = "BLINDER", t = "blinder", col = TYPE_COL.blinder },
    { id = "fog", text = "FOG", t = "fogger", col = TYPE_COL.fogger },
}
local function setFlash(kind, src, on)
    flash[kind][src] = on or nil
    refresh("paintSpecial")
end
do
    local P = pages.cu
    local bar = hlist(P, 64, true)
    bar.Size = UDim2.new(1, 0, 0, 62)
    local layerBtn = button(bar, "", function()
        local n = table.find(LAYER_ORDER, storeLayer) or 1
        storeLayer = LAYER_ORDER[n % #LAYER_ORDER + 1]; UI.drawCues()
    end, { sz = UDim2.fromOffset(150, 28) })
    local btnStore = button(bar, "Store", function() cueMode = (cueMode ~= "store") and "store" or nil; cueBind = nil; UI.drawCues() end, { sz = UDim2.fromOffset(64, 28) })
    local btnDel = button(bar, "Hapus", function() cueMode = (cueMode ~= "del") and "del" or nil; cueBind = nil; UI.drawCues() end, { sz = UDim2.fromOffset(64, 28), color = C.er, stroke = C.er })
    local btnOff = button(bar, "Off semua", function() allOff() end, { sz = UDim2.fromOffset(80, 28) })
    local btnSel = button(bar, "", function() selOnly = not selOnly; UI.drawCues() end, { sz = UDim2.fromOffset(150, 28), size = 12 })
    local btnKey = button(bar, "Atur keybind", function() cueMode = (cueMode ~= "key") and "key" or nil; cueBind = nil; UI.drawCues() end, { sz = UDim2.fromOffset(100, 28) })
    local btnKeyOn = button(bar, "", function() cfg.keysOn = not cfg.keysOn; saveSettings(); UI.drawCues() end, { sz = UDim2.fromOffset(100, 28) })
    if touchOnly then btnKey.Visible = false; btnKeyOn.Visible = false end
    local hint = label(P, "", { color = C.mu, size = 12, wrap = true, sz = UDim2.new(1, 0, 0, 30), pos = UDim2.fromOffset(0, 66) })

    local spRow = new("Frame", { Position = UDim2.fromOffset(0, 98), Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1 }, P)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, spRow)
    local gridWrap = scroll(P, { pos = UDim2.fromOffset(0, 98), sz = UDim2.new(1, 0, 1, -98), bg = C.p })
    local grid = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, gridWrap)
    new("UIGridLayout", { CellSize = UDim2.fromOffset(78, 48), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder }, grid)

    local spBtns = {}
    for n, sp in ipairs(SPECIAL) do
        local b = button(spRow, "", nil, { sz = UDim2.fromOffset(170, 40), size = 13, order = n, stroke = sp.col })
        spBtns[sp.id] = b
        b.InputBegan:Connect(function(i)
            if not isPress(i) then return end
            if cueMode == "key" then cueBind = sp.id; UI.drawCues(); return end
            setFlash(sp.id, "ptr", true)
        end)
        b.InputEnded:Connect(function(i) if isPress(i) then setFlash(sp.id, "ptr", false) end end)
    end
    track(UIS.InputEnded:Connect(function(i)
        if isPress(i) then
            local any = false
            for _, t in pairs(flash) do if t.ptr then t.ptr = nil; any = true end end
            if any then refresh("paintSpecial") end
        end
    end))

    UI.paintSpecial = function()
        for _, sp in ipairs(SPECIAL) do
            local b = spBtns[sp.id]
            local on = next(flash[sp.id]) ~= nil
            local kn = cfg.keysOn and cfg.keys[sp.id]
            b.Text = sp.text .. (kn and ("  [" .. kn:gsub("^Numpad", "N") .. "]") or "")
            b.BackgroundColor3 = on and sp.col or (cueBind == sp.id and C.selbg or C.p2)
            b.TextColor3 = on and DARK or C.tx
        end
    end
    local function layoutCue()
        local vis = 0
        for _, sp in ipairs(SPECIAL) do
            local has = hasType(sp.t)
            spBtns[sp.id].Visible = has
            if has then vis += 1 end
        end
        spRow.Visible = vis > 0
        local y = 98 + (vis > 0 and 46 or 0)
        gridWrap.Position = UDim2.fromOffset(0, y)
        gridWrap.Size = UDim2.new(1, 0, 1, -y)
    end

    UI.drawCues = function()
        layerBtn.Text = "Simpan ke: " .. LAYERS[storeLayer].name
        layerBtn.BackgroundColor3 = LAYERS[storeLayer].c
        btnStore.BackgroundColor3 = cueMode == "store" and C.ac or C.p2
        btnDel.BackgroundColor3 = cueMode == "del" and C.er or C.p2
        btnKey.BackgroundColor3 = cueMode == "key" and C.ac or C.p2
        btnSel.Text = "Hanya terpilih: " .. (selOnly and "ON" or "OFF")
        btnSel.BackgroundColor3 = selOnly and C.warn or C.p2
        btnSel.TextColor3 = selOnly and DARK or C.tx
        btnKeyOn.Text = cfg.keysOn and "Keybind: ON" or "Keybind: OFF"
        local bindName = type(cueBind) == "number" and ("Cue " .. cueBind) or (cueBind == "blind" and "BLINDER" or "FOG")
        hint.Text = cueMode == "store" and ("Mode Store: tekan slot untuk menyimpan ke layer " .. LAYERS[storeLayer].name .. (selOnly and " (hanya fixture terpilih)." or " (semua fixture)."))
            or cueMode == "del" and "Mode Hapus: tekan cue yang mau dihapus."
            or cueMode == "key" and (cueBind and ("Tekan tombol keyboard untuk " .. bindName .. " (Esc batal, Delete kosongkan).") or "Pilih cue / BLINDER / FOG, lalu tekan tombol keyboard. Hindari tombol yang dipakai game (WASD).")
            or "Tekan cue = main, tekan lagi = mati. Satu cue aktif per layer. * = sebagian fixture. BLINDER / FOG: tahan = nyala, lepas = mati."
        clear(grid)
        for n = 1, NCUE do
            local c = cues[tostring(n)]
            local ly = c and LAYERS[c.layer]
            local on = c and ly and active[c.layer] == n
            local kn = cfg.keys[tostring(n)]
            local txt = "Cue " .. n .. (kn and cfg.keysOn and ("  [" .. kn:gsub("^Numpad", "N") .. "]") or "") .. "\n"
                .. ((c and ly) and (ly.name .. (c.part and " *" or "")) or "kosong")
            local selBind = cueBind == n
            local b = button(grid, txt, function()
                if cueMode == "store" then
                    if selOnly and #selIdx() == 0 then toast("Pilih fixture dulu (atau matikan 'Hanya terpilih')"); return end
                    storeCue(n, storeLayer, selOnly); cueMode = nil; toast("Cue " .. n .. " disimpan (" .. LAYERS[storeLayer].name .. ")"); UI.drawCues()
                elseif cueMode == "del" then
                    if c then
                        if ly and active[c.layer] == n then releaseLayer(c.layer) end
                        cues[tostring(n)] = nil; touch(); toast("Cue " .. n .. " dihapus")
                    end
                    cueMode = nil; UI.drawCues()
                elseif cueMode == "key" then cueBind = n; UI.drawCues()
                else pressCue(n) end
            end, { sz = UDim2.fromOffset(78, 48), size = 12, order = n,
                bg = on and ly.c or (selBind and C.selbg or C.p2), stroke = ly and ly.c or (selBind and C.ac or C.ln) })
            b.TextColor3 = on and Color3.new(1, 1, 1) or C.tx
        end
        layoutCue()
        UI.paintSpecial()
        UI.syncEff()
    end
end

track(UIS.InputBegan:Connect(function(i, gp)
    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local name = i.KeyCode.Name
    if cueMode == "key" and cueBind then
        if name:find("Shift") or name:find("Control") or name:find("Alt") or name:find("Meta") then return end
        if name == "Delete" or name == "Backspace" then cfg.keys[tostring(cueBind)] = nil
        elseif name ~= "Escape" then
            for k, v in pairs(cfg.keys) do if v == name then cfg.keys[k] = nil end end
            cfg.keys[tostring(cueBind)] = name
        end
        cueBind = nil; saveSettings(); UI.drawCues()
        return
    end
    if gp or not cfg.keysOn or UIS:GetFocusedTextBox() then return end
    for k, v in pairs(cfg.keys) do
        if v == name then
            local sp
            for _, x in ipairs(SPECIAL) do if x.id == k then sp = x end end
            if sp then
                if hasType(sp.t) then setFlash(k, "key", true) end
            elseif cues[k] then
                pressCue(tonumber(k))
            end
            return
        end
    end
end))
track(UIS.InputEnded:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local name = i.KeyCode.Name
    for k, v in pairs(cfg.keys) do
        if v == name and flash[k] and flash[k].key then setFlash(k, "key", false) end
    end
end))

local shows, selShow = readJ(F_SHOWS) or {}, nil
do
    local P = pages.sv
    local top = new("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, P)
    local nameBox = box(top, "", "Nama save (mis. Show Sabtu)", { sz = UDim2.new(1, -70, 0, 28) })
    local list = scroll(P, { pos = UDim2.fromOffset(0, 34), sz = UDim2.new(1, 0, 1, -100), bg = C.p })
    local note = label(P, canSave and "Tersimpan di file executor (dmx_ui_shows.json)." or "Executor tidak mendukung writefile: save hanya hidup selama sesi ini.",
        { color = canSave and C.mu or C.warn, size = 12, sz = UDim2.new(1, 0, 0, 18), pos = UDim2.new(0, 0, 1, -62) })
    local bar = new("Frame", { Position = UDim2.new(0, 0, 1, -34), Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, P)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5) }, bar)
    button(top, "Save", function()
        local n = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if n == "" then n = selShow or "" end
        if n == "" then toast("Isi nama save dulu"); return end
        shows[n] = { ts = os.time(), data = snapshot() }
        writeJ(F_SHOWS, shows); selShow = n; nameBox.Text = ""; UI.drawSaves(); toast("Disimpan: " .. n)
    end, { sz = UDim2.fromOffset(64, 28), pos = UDim2.new(1, -64, 0, 0), bg = C.ac })
    button(bar, "Load", function()
        local e = selShow and shows[selShow]
        if not e then toast("Pilih save dulu"); return end
        local ok, err = pcall(loadSnap, e.data)
        toast(ok and ("Dimuat: " .. selShow) or ("Gagal load: " .. tostring(err)))
    end, { sz = UDim2.fromOffset(70, 28) })
    local del = button(bar, "Delete", nil, { sz = UDim2.fromOffset(90, 28), color = C.er, stroke = C.er })
    confirmBtn(del, "Yakin? tekan lagi", function()
        if selShow and shows[selShow] then shows[selShow] = nil; writeJ(F_SHOWS, shows); toast("Dihapus: " .. selShow); selShow = nil; UI.drawSaves() end
    end)
    local rst = button(bar, "Reset All", nil, { sz = UDim2.fromOffset(110, 28), color = C.er, stroke = C.er })
    confirmBtn(rst, "Yakin? tekan lagi", function()
        for _, f in ipairs(fx) do f.fade = nil end
        loadSnap({ rig = { { t = "clara", a = 1 }, { t = "strobe", a = 17 } }, cues = {}, eff = {}, fade = 2, gm = 100, keys = cfg.keys })
        bo = false; refresh("syncHeader"); toast("Semua direset")
    end)
    UI.drawSaves = function()
        clear(list)
        local names = {}
        for n in pairs(shows) do names[#names + 1] = n end
        table.sort(names)
        for i, n in ipairs(names) do
            local b = button(list, "  " .. n .. "   (" .. os.date("%d/%m %H:%M", shows[n].ts or 0) .. ")", function() selShow = n; UI.drawSaves() end,
                { sz = UDim2.new(1, -8, 0, 30), bg = selShow == n and C.selbg or C.p2, stroke = selShow == n and C.ac or C.ln, order = i })
            b.TextXAlignment = Enum.TextXAlignment.Left
        end
        if #names == 0 then label(list, "Belum ada save.", { color = C.mu }) end
    end
end

local fieldBoxes, uniRows = {}, {}
do
    local P = pages.su
    local sc = scroll(P)
    local function field(lbl, key, val)
        local r = rowF(sc, 28)
        label(r, lbl, { sz = UDim2.fromOffset(140, 28), color = C.mu })
        fieldBoxes[key] = box(r, val, "", { sz = UDim2.new(1, -146, 1, 0), pos = UDim2.fromOffset(146, 0) })
    end
    field("Nama RemoteEvent", "remoteName", cfg.remoteName)
    field("Folder mobil", "vehiclesFolder", cfg.vehiclesFolder)
    field("Keepalive (ms)", "keepalive", tostring(math.floor(cfg.keepalive * 1000 + .5)))
    field("Rate kirim (Hz)", "sendHz", tostring(math.floor((tonumber(cfg.sendHz) or 40) + .5)))
    local outBtn
    outBtn = button(rowF(sc, 28), "", function() cfg.output = not cfg.output; UI.syncSetup() end, { sz = UDim2.fromOffset(160, 28) })
    label(sc, "Universe  →  pemilik mobil  (kosong = mobilku, * = semua)", { color = C.mu, sz = UDim2.new(1, -8, 0, 18), order = #sc:GetChildren() })
    local uc = new("Frame", { Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = #sc:GetChildren() }, sc)
    new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, uc)
    local function readUni()
        local o = {}
        for _, r in ipairs(uniRows) do
            local u = tonumber(r.u.Text)
            if u then o[#o + 1] = { u = math.floor(u), owner = (r.o.Text:gsub("^%s+", ""):gsub("%s+$", "")) } end
        end
        return o
    end
    local function rebuild()
        clear(uc); uniRows = {}
        for i, row in ipairs(cfg.universes) do
            local f = new("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = i }, uc)
            local ub = box(f, tostring(row.u), "U", { sz = UDim2.fromOffset(46, 28) })
            local ob = box(f, row.owner or "", "kosong = mobilku", { sz = UDim2.new(1, -86, 1, 0), pos = UDim2.fromOffset(52, 0) })
            button(f, "x", function() cfg.universes = readUni(); table.remove(cfg.universes, i); rebuild() end,
                { sz = UDim2.fromOffset(28, 28), pos = UDim2.new(1, -28, 0, 0), color = C.er })
            uniRows[#uniRows + 1] = { u = ub, o = ob }
        end
    end
    rebuild()
    local br = hlist(sc, 30, true)
    button(br, "+ Universe", function()
        cfg.universes = readUni()
        local nu = 1
        for _, r in ipairs(cfg.universes) do if r.u >= nu then nu = r.u + 1 end end
        cfg.universes[#cfg.universes + 1] = { u = nu, owner = "" }
        rebuild()
    end, { sz = UDim2.fromOffset(100, 30) })
    button(br, "Semua mobil", function()
        cfg.universes = readUni()
        for _, r in ipairs(cfg.universes) do r.owner = "*" end
        rebuild()
    end, { sz = UDim2.fromOffset(100, 30) })
    button(br, "Terapkan & simpan", function()
        cfg.remoteName = fieldBoxes.remoteName.Text ~= "" and fieldBoxes.remoteName.Text or "Data"
        cfg.vehiclesFolder = fieldBoxes.vehiclesFolder.Text
        cfg.keepalive = cl((tonumber(fieldBoxes.keepalive.Text) or 250) / 1000, .05, 5)
        cfg.sendHz = cl(tonumber(fieldBoxes.sendHz.Text) or 40, 10, 60)
        fieldBoxes.sendHz.Text = tostring(math.floor(cfg.sendHz + .5))
        local u = readUni()
        if #u == 0 then toast("Isi minimal satu universe"); return end
        cfg.universes = u; remotes = {}; saveSettings()
        task.spawn(scanOnce)
        toast(canSave and "Diterapkan & disimpan" or "Diterapkan (tanpa file)")
    end, { sz = UDim2.fromOffset(150, 30), bg = C.ac })
    local info = new("TextLabel", { Size = UDim2.new(1, -8, 0, 70), BackgroundColor3 = C.p, BorderSizePixel = 0, Font = Enum.Font.Code, TextSize = 12,
        TextColor3 = C.tx, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Text = "",
        LayoutOrder = #sc:GetChildren() }, sc)
    corner(info); stroke(info); pad(info, 6)
    UI.syncSetup = function()
        outBtn.Text = cfg.output and "Output: ON" or "Output: OFF"
        outBtn.BackgroundColor3 = cfg.output and C.ok or C.er
        saveSettings()
    end
    task.spawn(function()
        while alive do
            local lines, anyR = {}, false
            for _, row in ipairs(cfg.universes) do
                local u = tonumber(row.u)
                if u then
                    u = math.floor(u)
                    local n = remotes[u] and #remotes[u] or 0
                    if n > 0 then anyR = true end
                    lines[#lines + 1] = ("U%d [%s] mobil=%d kirim=%d"):format(u, row.owner == "*" and "SEMUA" or ownerName(row.owner), n, fired[u] or 0)
                end
            end
            info.Text = table.concat(lines, "\n")
            dot.BackgroundColor3 = (not cfg.output) and C.er or (anyR and C.ok or C.warn)
            task.wait(.5)
        end
    end)
end

task.spawn(function()
    while alive do
        task.wait(2)
        if workDirty then workDirty = false; writeJ(F_WORK, snapshot()) end
    end
end)

local function cleanup()
    alive = false
    if canSave then pcall(function() writeJ(F_WORK, snapshot()) end) end
    pcall(function() hb:Disconnect() end)
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    pcall(function() gui:Destroy() end)
    _G.DMX_CLEANUP = nil
end
_G.DMX_CLEANUP = cleanup
button(title, "x", cleanup, { sz = UDim2.fromOffset(26, 22), pos = UDim2.new(1, -60, .5, -11), color = C.er })

do
    local w = readJ(F_WORK)
    if type(w) == "table" then pcall(loadSnap, w) end
end
ensurePos()
refresh("drawFx", "drawSel", "drawProg", "syncEff", "drawCues", "drawSaves", "syncHeader", "syncSetup")
showTab("cu")
if _G.DMX_TEST then _G.DMX_TEST({ fx = function() return fx end, L = function() return L end, cues = function() return cues end,
    active = function() return active end, press = pressCue, store = storeCue, build = buildUniverses, step = step, snap = snapshot, load = loadSnap,
    setGm = function(v) gm = v end, setBo = function(v) bo = v end, setFade = function(v) fadeSec = v end, out = out, allOff = allOff }) end
