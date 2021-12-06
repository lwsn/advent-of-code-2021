local input = {}
for line in io.lines './input' do
   local data = {}
   for str in line:gmatch '(%d+)' do
      table.insert(data, tonumber(str))
   end
   table.insert(input, data)
end

local function generateOutput()
   local output = {}
   local xmax, ymax = 0, 0
   for _, v in pairs(input) do
      xmax = xmax > v[1] and xmax or v[1]
      xmax = xmax > v[3] and xmax or v[3]
      ymax = ymax > v[2] and ymax or v[2]
      ymax = ymax > v[4] and ymax or v[4]
   end
   for y = 0, ymax, 1 do
      output[y] = {}
      for x = 0, xmax, 1 do
         output[y][x] = 0
      end
   end

   return output
end

local resA = generateOutput()

for _, t in pairs(input) do
   local xdir = t[3] - t[1]
   xdir = math.floor(xdir == 0 and xdir or xdir / math.abs(xdir))
   local ydir = t[4] - t[2]
   ydir = math.floor(ydir == 0 and ydir or ydir / math.abs(ydir))

   local x = t[1]
   local y = t[2]

   if xdir == 0 or ydir == 0 then
      resA[y][x] = resA[y][x] + 1
      repeat
         x = x + xdir
         y = y + ydir
         resA[y][x] = resA[y][x] + 1
      until x == t[3] and y == t[4]
   end
end

local count = 0
for _, y in pairs(resA) do
   for _, v in pairs(y) do
      if v > 1 then
         count = count + 1
      end
   end
end

print(count)

local resB = generateOutput()

for _, t in pairs(input) do
   local xdir = t[3] - t[1]
   xdir = math.floor(xdir == 0 and xdir or xdir / math.abs(xdir))
   local ydir = t[4] - t[2]
   ydir = math.floor(ydir == 0 and ydir or ydir / math.abs(ydir))

   local x = t[1]
   local y = t[2]

   resB[y][x] = resB[y][x] + 1
   repeat
      x = x + xdir
      y = y + ydir
      resB[y][x] = resB[y][x] + 1
   until x == t[3] and y == t[4]
end

count = 0
for _, y in pairs(resB) do
   for _, v in pairs(y) do
      if v > 1 then
         count = count + 1
      end
   end
end

print(count)
