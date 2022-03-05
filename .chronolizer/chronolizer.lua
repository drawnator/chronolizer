function sleep(n)
  local t0 = os.clock()
  while os.clock() - t0 <= n do
  end
end

function readChrono()
  local lines = {}
  for line in io.lines("chronoapi.txt") do
    lines[#lines + 1] = line
  end
  return tonumber(string.sub(lines[1], 11,-2))
end

function getChrono(site,port,timeF,RtimeF)
  local siteCurl = io.popen("curl --silent http://"..site..":"..port.."/"..timeF.."/")
  for time in siteCurl:lines() do
    return tonumber(string.sub(time,11,-2))
  end
end

function readServer()
  local lines = {}
  local text  = io.open("server.functionality",'r')
  lines.port  = io.input(text):read("l")
  lines.site1 = io.input(text):read("l")
  lines.site2 = io.input(text):read("l")
  lines.site3 = io.input(text):read("l")
  lines.time  = io.input(text):read("l")
  lines.Rtime = io.input(text):read("l")
  return lines
end

function listMarkdowns()
  local fileObject = io.popen('dir  ..\\*.md /b')
  local fileList,indexer = {}, 0
  for file in fileObject:lines() do
    indexer = indexer + 1
    fileList[indexer] = file
  end
  return fileList
end

function listVizualizer()
  local fileObject = io.popen('dir  ..\\vizualizer\\*.md /b')
  local fileList,indexer = {}, 0
  for file in fileObject:lines() do
    indexer = indexer + 1
    fileList[indexer] = file
  end
  return fileList
end

function separateName(name)
  local formating = '([(])(.-)(-)(.-)([)])(.-).md'
  _,_,par1,born,hyphen,die,par2,name = string.find(name,formating)
  if born == "!" then
    born = time
  end
  if die == "!" then
    die = time
  end
  out = {tonumber(born),tonumber(die),name}
  return out
end

function checkFile(file)
  local file = io.open(file, 'r')
  if file ~= nil then io.close(file) return true else return false end
end

function selectText(filename)
  local fileViz = "../"..filename
  local outViz = io.open(fileViz,"r")
  out = io.input(outViz):read('a')
  io.close(outViz)
  return out
end

function decidirEditar(listNames)
  for i,filename in pairs(listNames) do
    local infoFile = separateName(filename)
    local fileViz = "../vizualizer/"..infoFile[3]..".md"
    if debugmode then print(infoFile[1],infoFile[2],infoFile[3]) end
    if checkInterval(infoFile[1],infoFile[2],time) then
      _adicionareEditar(filename,infoFile,fileViz)
    else
      _removereEditar(fileViz)
    end
  end
end

function _adicionareEditar(filename,infoFile,fileViz) --TODO: usar lista
  if not checkFile(fileViz) then
    if debugmode then print(filename) end
    local outViz = io.open(fileViz,"w")
    io.output(outViz):write(selectText(filename))
    io.close(outViz)
  end
end

function _removereEditar(filename) --TODO: usar lista
  local fileViz = "../vizualizer/"..filename
  if checkFile(fileViz) then
    os.remove(filename)
  end
end

function checkInterval (startTime,endTime,actual)
  return (actual >= startTime) and (actual <= endTime)
end

function createMarkdownsDebugger()
  --for i in list do
  for i=1,100 do
    mdTexto = ''
    for j=1,math.random(1,3) do
      mdTexto = mdTexto..'[[teste'..(math.random(1,i))..']]'..'\n'
    end
    local teste = io.open('../vizualizer/teste'..i..'.md',"w")
    io.output(teste):write(mdTexto)
    io.close(teste)
  end
end

function createDebugger()
  local teste = io.open('../teste.txt', 'w')
  io.output(teste):write(math.random(1,65600))
  io.close(teste)
end


-- GLOBAL VARIABLES
time = 0
debugmode = false
serverMode = true

infoSite = readServer()
site = infoSite.site2
port = infoSite.port
timeF = infoSite.time
RtimeF = infoSite.Rtime

math.randomseed(os.time())
os.execute("curl --silent http://"..site..":"..port.."/"..RtimeF.."/")
markdowns = listMarkdowns()
vizualizer = listVizualizer()

while 1 do
  time = getChrono(site,port,timeF,RtimeF)
  os.execute("cls")
  print(time)
  decidirEditar(listMarkdowns())
end
