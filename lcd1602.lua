local M = {}

local OFF = 0x00
local ON  = 0x08

local id = 0
local deviceAddress = 0x27

local bitwiseAND, bitwiseOR, bitwiseLShift = bit.band, bit.bor, bit.lshift
local i2c = i2c
local tmr, delay = tmr, tmr.delay

local colMax = 16
local control = 0x08
local _offsets = { [0] = 0x80, 0xC0, 0x90, 0xD0 }

local write = function(b, mode)
  i2c.start(id)
  i2c.address(id, deviceAddress, i2c.TRANSMITTER)
  local bitHigh = bitwiseAND(b, 0xF0) + control + mode
  local bitLow = bitwiseLShift(bitwiseAND(b, 0x0F), 4) + control + mode
  i2c.write(id, bitHigh + 4, bitHigh, bitLow + 4, bitLow)
  i2c.stop(id)
end
-- backgroundLight on/off
local backgroundLight = function(onoff)
  -- bitwiseOR(bitwiseAND(bitwiseLShift(1, 3), 0x08), 0x00) is off
  -- bitwiseOR(bitwiseAND(bitwiseLShift(1, 3), 0x08), 0x00) is on
  control = onoff
  write(0x00, 0)
end

local clear = function()
  write(0x01, 0)
end

local locate = function(row, col)
  return (col + _offsets[row])
end

local put = function(...)
  for _, x in ipairs({...}) do
    if type(x) == "number" then
      write(x, 0)
    elseif type(x) == "string" then
      for i = 1, #x do write(x:byte(i), 1) end
    end
    delay(800)
  end
end

local scrollToRight = function(row, colStart, colEnd, s, interval, timer)
  local i = colStart

  tmr.alarm(timer, interval, tmr.ALARM_AUTO, function()
    local col = i < #s + colStart and colStart or i - #s
    put(
      locate(row, col),
      (i < #s + colStart and s:sub(#s - i + colStart, #s - (i - colEnd)) or " " .. s:sub(1, #s - (i - colEnd)))
    )
    if i == #s + colEnd then
      i = colStart
    else
      i = i + 1
    end
  end)
end

local scrollToLeft = function(row, colStart, colEnd, s, interval, timer)
  if colStart < colEnd  or colStart >= colMax or colEnd < 0 then
    colStart, colEnd = colMax - 1, 0
  end

  local i = colStart

  tmr.alarm(timer, interval, tmr.ALARM_AUTO, function()
    put(
      locate(row, i >= colEnd and i or colEnd),
      (i >= colEnd and s:sub(1, colStart + 1 - i) or s:sub(colEnd + 1 - i, colStart + 1 - i)) .. " "
    )
    if i == -#s + colEnd then
      i = colStart
    else
      i = i - 1
    end
  end)
end

-- start lcd
local start = function(deviceAddress, sda, scl)
  deviceAddress = deviceAddress or 0x27
  sda = sda or 5
  scl = scl or 6
  i2c.setup(0, sda, scl, i2c.SLOW)

  write(0x33, 0)
  write(0x32, 0)
  write(0x28, 0)
  write(0x0C, 0)
  write(0x06, 0)
  write(0x01, 0)
  write(0x02, 0)
end

local init = function()
  return {
    ON = ON,
    OFF = OFF,
    deviceAddress = deviceAddress,
    backgroundLight = backgroundLight,
    clear = clear,
    locate = locate,
    put = put,
    scrollToRight = scrollToRight,
    scrollToLeft = scrollToLeft,
    start = start
  }
end

M = init

return M
