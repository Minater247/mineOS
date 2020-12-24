--code written by Minater247
--early alpha version

os.startTimer(1)
local timerStartTime = math.floor(os.clock()+0.5)

--homescreen variables
local currentscreen = "home"
local clockicon = {"b","32768","32768","1","1","1","1","1","32768","32768","b",
"32768","32768","1","1","1","16384","1","1","1","32768","32768",
"32768","1","1","1","1","16384","1","1","1","1","32768",
"1","1","1","1","1","16384","1","1","1","1","1",
"1","1","1","1","1","16384","16384","16384","1","1","1",
"32768","1","1","1","1","1","1","1","1","1","32768",
"32768","32768","1","1","1","1","1","1","1","32768","32768",
"b","32768","32768","1","1","1","1","1","32768","32768","b"
}

local todoicon = {"b","8192","8192","8192","8192","8192","8192","8192","8192","8192","b",
"8192","8192","8192","8192","8192","8192","8192","8192","1","8192","8192",
"8192","8192","8192","8192","8192","8192","8192","1","1","8192","8192",
"8192","8192","1","8192","8192","8192","1","1","8192","8192","8192",
"8192","8192","1","1","8192","1","1","8192","8192","8192","8192",
"8192","8192","8192","1","1","1","8192","8192","8192","8192","8192",
"8192","8192","8192","8192","1","8192","8192","8192","8192","8192","8192",
"b","8192","8192","8192","8192","8192","8192","8192","8192","8192","b"}

local calcicon = {"b","128","128","128","128","128","128","128","128","128","b",
"128","1","2048","2048","2048","2048","2048","2048","8","1","128",
"128","1","2048","2048","2048","2048","2048","2048","2048","1","128",
"128","1","1","1","1","1","1","1","1","1","128",
"128","8192","2","8192","1","1","1024","1","16384","16384","128",
"128","2","8192","2","1","1024","1","1","16384","16384","128",
"128","8192","2","8192","1","1","1024","1","16384","16384","128",
"b","128","128","128","128","128","128","128","128","128","b"
}

local updateicon = {"b","32","32","32","32","32","32","32","32","32","b",
"32","32","32","32","32","1","32","32","32","32","32",
"32","32","32","32","1","32","1","32","32","32","32",
"32","32","32","1","32","1","32","1","32","32","32",
"32","32","32","32","32","1","32","32","32","32","32",
"32","32","32","32","32","1","32","32","32","32","32",
"32","32","32","32","32","1","32","32","32","32","32",
"b","32","32","32","32","32","32","32","32","32","b"
}

local currentpanel = 1

--peripherals
local speaker = peripheral.find("speaker")

--the version of this OS
local version = "zero"

--used for debug messages when iterating
local dbgIter = 0

--timer variables
local timertime = ""
local timeron = false
local timerstart = 0
local timerdiff = 0
local timersound = false

--variables for the todo list
local todolist = {}
local todofile
local todoinput = ""
local todostart = 1

--checks if input is currently being taken and blocks the OS going to the home screen or shutting off if P or H pressed
local ininput = false

--used to allow the doNothing() function
local uselessvariable = 0

--updater variable
local currentversion = ""
local updatestatus = false
local updatepaste

--calculator variables
local calcnum = ""
local currentinp = 1
local calcin1 = 0
local calcopera = ""
local resetstate = false

--pocket is 26x20

--draws clock
function clock()
    local time = textutils.formatTime(os.time(), false)
    local timelen = string.len(time)
    local day = "Day " .. os.day()
    local daylen = string.len(day)
    term.setBackgroundColor(colors.gray)
    term.setCursorPos(1, 1)
    term.write(time)
    for i=1, 26-timelen-daylen, 1 do
        term.write(" ")
    end
    term.write(day)
end

--clears screen to black
function blackout()
    term.setBackgroundColor(colors.black)
    term.clear()
end

--draws everything but the top line with the given color
function drawBG(bgc)
    term.setCursorPos(1, 2)
    term.setBackgroundColor(bgc)
    for i=1,19,1 do
        for i=1,26,1 do
            term.write(" ")
        end
        local pos1, pos2 = term.getCursorPos()
        term.setCursorPos(1, pos2+1)
    end
end

--icon drawing
function drawFromListAt(xby, yby, listtodraw, backgroundcolor)
    --hopefully doesn't cause issues, icons will always be 11x8.
    local index = 1
    term.setCursorPos(xby, yby)
    for i=1,8,1 do
        for j=1,11,1 do
            if listtodraw[index] == "b" then
                term.setBackgroundColor(backgroundcolor)
            else
                term.setBackgroundColor(tonumber(listtodraw[index]))
            end
            term.write(" ")
            index = index + 1
        end
        local pos1, pos2 = term.getCursorPos()
        term.setCursorPos(xby, pos2+1)
    end
end

--the spaghetti way to get the timer drawn with proper format
function drawTimer(tinput)
    local tim = tinput
    local timlen = string.len(tim)
    for i=1,6-timlen do
        tim = "0"..tim
    end
    
    local timone = "0"
    local timtwo = "0"
    local timthr = "0"
    local timfou = "0"
    local timfiv = "0"
    local timsix = "0"
    
    for i=6,1,-1 do
        if i <= string.len(tim) then
            if i == 6 then
                timsix = string.sub(tim, 6, 6)
            elseif i == 5 then
                timfiv = string.sub(tim, 5, 5)
            elseif i == 4 then
                timfou = string.sub(tim, 4, 4)
            elseif i == 3 then
                timthr = string.sub(tim, 3, 3)
            elseif i == 2 then
                timtwo = string.sub(tim, 2, 2)
            elseif i == 1 then
                timone = string.sub(tim, 1, 1)
            end
        end
    end
    
    term.setCursorPos(10,10)
    term.setBackgroundColor(colors.lightGray)
    term.write(timone..timtwo)
    term.setBackgroundColor(colors.black)
    term.write(":")
    term.setBackgroundColor(colors.lightGray)
    term.write(timthr..timfou)
    term.setBackgroundColor(colors.black)
    term.write(":")
    term.setBackgroundColor(colors.lightGray)
    term.write(timfiv..timsix)
    
    if timeron == false then
        term.setCursorPos(16, 15)
        term.setBackgroundColor(colors.lightGray)
        term.write("Start")
    else
        term.setCursorPos(16, 15)
        term.setBackgroundColor(colors.lightGray)
        term.write("Pause")
    end

    term.setCursorPos(7, 17)
    if timersound == true then
        term.write("Complete alarm")
    else
        term.setBackgroundColor(colors.black)
        term.write("              ")
        term.setBackgroundColor(colors.lightGray)
    end
    
    term.setCursorPos(7, 15)
    term.setBackgroundColor(colors.lightGray)
    term.write("Reset")
end

--properly calculates and updates the timer
function updateTimer(inp)
    if string.len(timertime) < 6 then
        for i=1,6-string.len(timertime) do
            timertime = "0"..timertime
        end
    end
    
    local secs = tonumber(string.sub(timertime, 5, 6))
    local mins = tonumber(string.sub(timertime, 3, 4))
    local hrs = tonumber(string.sub(timertime, 1, 2))
    local secs = secs - 1
    if secs == -1 then
        mins = mins - 1
        secs = 59
        if mins == -1 then
            mins = 59
            hrs = hrs - 1
        end
    end
    local stringsecs = tostring(secs)
    local stringmins = tostring(mins)
    local stringhrs = tostring(hrs)
    if string.len(stringsecs) < 2 then
       secs = "0"..secs 
    end
    if string.len(stringmins) < 2 then
        mins = "0"..mins
    end
    if string.len(stringhrs) < 2 then
        hrs = "0"..hrs
    end
    timertime = tostring(hrs)..tostring(mins)..tostring(secs)
    if hrs == -1 then
        timeron = false
        timersound = true
        timertime = ""
    end
end

--draws everything needed for the todo list
function drawTodo()
    term.setCursorPos(21, 2)
    term.setBackgroundColor(colors.lightGray)
    term.write(" Save ")

    term.setCursorPos(21, 3)
    term.write(" Load ")
    
    term.setCursorPos(1, 2)
    term.setBackgroundColor(colors.green)
    term.write(" + ")
    
    term.setCursorPos(4, 2)
    term.setBackgroundColor(colors.red)
    term.write(" - ")

    if ininput == true then
        term.setCursorPos(3, 10)
        term.setBackgroundColor(colors.lightGray)
        term.write(todoinput)
    end
end

--does nothing but increase a useless variable. used for debug.
function doNothing()
    uselessvariable = uselessvariable + 1
end

--draws out the items in the todo list
function drawTodoItems(startpos)
    drawBG(colors.white)
    for i=todostart,#todolist do
        term.setCursorPos(2, 3+((i-todostart+1)*2))
        term.setTextColor(colors.black)
        term.write(i)
        term.setCursorPos(5, 3+((i-todostart+1)*2))
        term.setBackgroundColor(colors.white)
        term.write(todolist[i])
        term.setTextColor(colors.white)
    end
    
end

--depending on if there's an update, says so and provides paste or says no update available
function drawUpdateScreen()
    if updatestatus == true then
        term.setBackgroundColor(colors.lightGray)
        term.setCursorPos(4, 9)
        term.write(" There is an update ")
        term.setCursorPos(4, 10)
        term.write("     available!     ")
        term.setCursorPos(4, 13)
        term.write("  Update: "..updatepaste.."  ")
    else
        term.setBackgroundColor(colors.lightGray)
        term.setCursorPos(4, 9)
        term.write("There are no updates")
        term.setCursorPos(4, 10)
        term.write("currently available.")
    end
end

--checks for updates. since this is run on a server this doesn't need an "online" check
function checkForUpdates()
    currentversion = http.get("https://pastebin.com/raw/2arCMyau").readAll()
    if currentversion == version then
        updatestatus = false
    else
        updatestatus = true
        updatepaste = http.get("https://pastebin.com/raw/eSAMKSrv").readAll()
    end
end

--draws the calculator out
function drawCalculator()
    term.setBackgroundColor(colors.blue)
    term.setCursorPos(3, 3)
    term.write("                      ")
    term.setCursorPos(3, 4)
    term.write("                      ")
    term.setCursorPos(3, 5)
    term.write("                      ")

    --handly little thing I wrote to draw a checkerboard of boxes :)
    local boxx = 3
    local boxy = 7
    local boxful = 0
    for i=1,3 do
        for j=1,3 do
            if boxful % 2 == 0 then
                drawBox(boxx, boxy, 4, 3, colors.gray)
            else
                drawBox(boxx, boxy, 4, 3, colors.white)
            end
            boxx = boxx + 4
            boxful = boxful + 1
        end
        boxy = boxy + 3
        boxx = 3
    end
    --end of checkerboard drawing thing, in case I need it later

    drawBox(3, 16, 4, 3, colors.red)
    term.setCursorPos(4, 17)
    term.write("AC")
    drawBox(7, 16, 4, 3, colors.gray)
    term.setCursorPos(8, 17)
    term.write("0")
    drawBox(11, 16, 4, 3, colors.green)
    term.setCursorPos(12, 17)
    term.write(".")

    drawBox(16, 7, 4, 3, colors.gray)
    drawBox(16, 10, 4, 3, colors.white)
    drawBox(16, 13, 4, 3, colors.gray)
    drawBox(16, 16, 4, 3, colors.white)
    term.setCursorPos(17, 8)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.gray)
    term.write("+")
    term.setCursorPos(17, 11)
    term.setTextColor(colors.gray)
    term.setBackgroundColor(colors.white)
    term.write("-")
    term.setCursorPos(17, 14)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.gray)
    term.write("x")
    term.setCursorPos(17, 17)
    term.setTextColor(colors.gray)
    term.setBackgroundColor(colors.white)
    term.write("/")
    term.setTextColor(colors.white)

    drawBox(21, 7, 4, 11, colors.lightBlue)
    term.setCursorPos(22, 12)
    term.write("=")

    local textx = 4
    local texty = 8
    local textiter = 0
    for i=1,3 do
        for j=1,3 do
            if textiter % 2 == 0 then
                term.setBackgroundColor(colors.gray)
                term.setTextColor(colors.white)
            else
                term.setBackgroundColor(colors.white)
                term.setTextColor(colors.gray)
            end
            term.setCursorPos(textx, texty)
            term.write(textiter + 1)
            textiter = textiter + 1
            textx = textx + 4
        end
        textx = 4
        texty = texty + 3
    end
end

--draws a box at the desired position
function drawBox(xp, yp, wid, hei, col)
    term.setBackgroundColor(col)
    for i=1,hei do
        term.setCursorPos(xp, yp+i-1)
        for i=1,wid do
            term.write(" ")
        end
    end
end

--draws calculator screen
function drawCalcScreen(screeninfo)
    term.setBackgroundColor(colors.blue)
    term.setCursorPos(3, 4)
    term.write("                      ")
    term.setCursorPos(4, 4)
    term.write(screeninfo)
end

--init
drawBG(colors.lightGray)
x = 0
y = 0

--run OS
while true do
    event, button, x, y = os.pullEvent()
    clock()
    --stops OS
    if button == "p" and not ininput == true then
        --clears screen before quitting out
        blackout()
        term.setCursorPos(1, 1)
        do return end
    elseif button == "h" and ininput == false and currentscreen ~= "home" then
        currentscreen = "home"
        drawBG(colors.lightGray)
    end


    --handles mouse click events
    if button == 1 and event == "mouse_click" then
        if currentscreen == "home" then
            if x > 1 and x < 13 and y > 2 and y < 11 and currentscreen == "home" then  --top left icon boundaries
                currentscreen = "clock"
                drawBG(colors.black)
            elseif x > 15 and x < 26 and y > 2 and y < 11 and currentscreen == "home" then
                currentscreen = "todo"
                drawBG(colors.white)
                drawTodoItems(1)
                todostart = 1
            elseif x > 1 and x < 13 and y > 11 and y < 20 and currentscreen == "home" then
                currentscreen = "update"
                checkForUpdates()
                ininput = false
                drawBG(colors.black)
            elseif x>15 and x < 26 and y > 11 and y < 20 and currentscreen == "home" then
                currentscreen = "calculator"
                drawBG(colors.lightGray)
                drawCalculator()
            end
        elseif currentscreen == "clock" then
            if x > 6 and x < 12 and y == 15 then
                timeron = false
                timertime = ""
            elseif x > 15 and x < 21 and y == 15 then
                if timeron == false then
                    timeron = true
                    timerstart = math.floor(os.clock()+0.5)
                else
                    timeron = false
                end
            elseif x > 6 and x < 21 and y == 17 then
                timersound = false
            end
        elseif currentscreen == "todo" then
            if x > 20 and x < 27 and y == 2 then
                if fs.exists("todo") then
                    fs.delete("todo")
                end
                todofile = fs.open("todo", "w")
                todofile.write(textutils.serialize(todolist))
                todofile.close()
            elseif x > 20 and x < 27 and y == 3 then
                if fs.exists("todo") then
                    todofile = fs.open("todo", "r")
                    todolist = textutils.unserialise(todofile.readAll())
                    drawTodoItems()
                end
            elseif x > 0 and x < 4 and y == 2 and ininput == false then
                term.setCursorPos(1, 9)
                term.setBackgroundColor(colors.gray)
                term.write("      Add todo item:      ")
                term.setCursorPos(1, 10)
                term.setBackgroundColor(colors.lightGray)
                term.write("                          ")
                ininput = true
                inputtype = "addtodo"
            elseif x > 3 and x < 7 and y == 2 and ininput == false then
                term.setCursorPos(1, 9)
                term.setBackgroundColor(colors.gray)
                term.write("    Remove todo item:     ")
                term.setCursorPos(1, 10)
                term.setBackgroundColor(colors.lightGray)
                term.write("                          ")
                ininput = true
                inputtype = "remtodo"
            end
        elseif currentscreen == "calculator" then
            if button == 1 then
                if #calcnum < 20 then
                    local mousmaxx = 6
                    local mousmaxy = 9
                    local mousminx = 3
                    local mousminy = 7
                    local mousiter = 1
                    for i=1,3 do
                        for j=1,3 do
                            if x >= mousminx and x <= mousmaxx and y >= mousminy and y <= mousmaxy then
                                if resetstate == true then
                                    calcnum = ""
                                    resetstate = false
                                end
                                calcnum = calcnum..mousiter
                            end
                            mousiter = mousiter + 1
                            mousminx = mousminx + 4
                            mousmaxx = mousmaxx + 4
                        end
                        mousminy = mousminy + 3
                        mousmaxy = mousmaxy + 3
                        mousminx = 3
                        mousmaxx = 6
                    end
                    if x >= 7 and x <= 11 and y >= 16 and y <= 19 then
                        if resetstate == true then
                            calcnum = ""
                            resetstate = false
                        end
                        calcnum = calcnum.."0"
                    elseif x >= 11 and x <= 15 and y >= 16 and y <= 19 then
                        if string.find(calcnum, "%.") == nil then
                            calcnum = calcnum.."."
                        end
                    elseif x >= 3 and x <= 7 and y >= 16 and y <= 19 then
                        calcnum = ""
                        currentinp = 1
                        calcin1 = 0
                        calcopera = ""
                        resetstate = false
                    end 
                end
                if x > 15 and x < 20 and y > 6 and y < 10 then
                    if currentinp == 1 and #calcnum > 0 then
                        resetstate = false
                        calcopera = "+"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    elseif currentinp == 2 and #calcnum > 0 then
                        if calcopera == "+" then
                            calcnum = tostring(calcin1 + calcnum)
                            currentinp = 1
                        elseif calcopera == "-" then
                            calcnum = tostring(calcin1 - calcnum)
                            currentinp = 1
                        elseif calcopera == "*" then
                            calcnum = tostring(calcin1 * calcnum)
                            currentinp = 1
                        elseif calcopera == "/" then
                            calcnum = tostring(calcin1 / calcnum)
                            currentinp = 1
                        end
                        currentinp = 1
                        calcopera = "+"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    end
                elseif x > 15 and x < 20 and y > 9 and y < 13 then
                    if currentinp == 1 and #calcnum > 0 then
                        resetstate = false
                        calcopera = "-"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    elseif currentinp == 2 and #calcnum > 0 then
                        if calcopera == "+" then
                            calcnum = tostring(calcin1 + calcnum)
                            currentinp = 1
                        elseif calcopera == "-" then
                            calcnum = tostring(calcin1 - calcnum)
                            currentinp = 1
                        elseif calcopera == "*" then
                            calcnum = tostring(calcin1 * calcnum)
                            currentinp = 1
                        elseif calcopera == "/" then
                            calcnum = tostring(calcin1 / calcnum)
                            currentinp = 1
                        end
                        currentinp = 1
                        calcopera = "-"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    end
                elseif x > 15 and x < 20 and y > 12 and y < 16 then
                    if currentinp == 1 and #calcnum > 0 then
                        resetstate = false
                        calcopera = "*"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    elseif currentinp == 2 and #calcnum > 0 then
                        if calcopera == "+" then
                            calcnum = tostring(calcin1 + calcnum)
                            currentinp = 1
                        elseif calcopera == "-" then
                            calcnum = tostring(calcin1 - calcnum)
                            currentinp = 1
                        elseif calcopera == "*" then
                            calcnum = tostring(calcin1 * calcnum)
                            currentinp = 1
                        elseif calcopera == "/" then
                            calcnum = tostring(calcin1 / calcnum)
                            currentinp = 1
                        end
                        currentinp = 1
                        calcopera = "*"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    end
                elseif x > 15 and x < 20 and y > 15 and y < 19 then
                    if currentinp == 1 and #calcnum > 0 then
                        resetstate = false
                        calcopera = "/"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    elseif currentinp == 2 and #calcnum > 0 then
                        if calcopera == "+" then
                            calcnum = tostring(calcin1 + calcnum)
                            currentinp = 1
                        elseif calcopera == "-" then
                            calcnum = tostring(calcin1 - calcnum)
                            currentinp = 1
                        elseif calcopera == "*" then
                            calcnum = tostring(calcin1 * calcnum)
                            currentinp = 1
                        elseif calcopera == "/" then
                            calcnum = tostring(calcin1 / calcnum)
                            currentinp = 1
                        end
                        currentinp = 1
                        calcopera = "/"
                        calcin1 = calcnum
                        resetstate = true
                        currentinp = 2
                    end
                elseif x > 20 and x < 25 and y > 6 and y < 21 then
                    if currentinp == 2 then
                        if calcopera == "+" then
                            calcnum = tostring(calcin1 + calcnum)
                            currentinp = 1
                        elseif calcopera == "-" then
                            calcnum = tostring(calcin1 - calcnum)
                            currentinp = 1
                        elseif calcopera == "*" then
                            calcnum = tostring(calcin1 * calcnum)
                            currentinp = 1
                        elseif calcopera == "/" then
                            calcnum = tostring(calcin1 / calcnum)
                            currentinp = 1
                        end
                        if currentinp == 1 then
                            resetstate = true
                        end
                    end
                end
            end
        end
    end
    --end of click events

    --idle clock events and keyboard input
    if currentscreen == "home" then
        if currentpanel == 1 then
            drawFromListAt(2, 3, clockicon, colors.lightGray)
            drawFromListAt(15, 3, todoicon, colors.lightGray)
            drawFromListAt(2, 12, updateicon, colors.lightGray)
            drawFromListAt(15, 12, calcicon, colors.lightGray)
        end
        ininput = false
    elseif currentscreen == "clock" then
        drawTimer(timertime)
        if timeron == false then
            if button == 14 and event == "key" then
                timertime = string.sub(timertime, 1, -2)
            end
            if event == "key" and string.len(timertime) < 6 then
                if button > 1 and button < 11 then
                    timertime = timertime..tostring(button - 1)
                elseif button == 11 then
                    timertime = timertime.."0"
                elseif button == 28 then
                    if timeron == false then
                        timeron = true
                        timerstart = math.floor(os.clock()+0.5)
                    end
                end
            end
        end
    elseif currentscreen == "todo" then
        drawTodo()

        --input manager, fixed spaghetti with read()
        --now it stops the clock (and timer) but it's better than a bunch of if-else so i'm okay with it.
        if ininput == true then
            term.setCursorPos(1, 10)
            term.setBackgroundColor(colors.lightGray)
            term.write("                          ")
            term.setCursorPos(3, 10)
            todoinput = read()
            if #todoinput < 22 then
                if inputtype == "addtodo" then
                    if #todoinput > 0 then
                        table.insert(todolist, todoinput)
                        todoinput = ""
                    end
                    term.setCursorPos(2, 9)
                    term.setBackgroundColor(colors.white)
                    term.write("                        ")
                    term.setCursorPos(2, 10)
                    term.write("                        ")

                    if #todolist - 7 > 1 then
                        term.setCursorPos(27, 2)
                        term.setBackgroundColor(colors.black)
                        term.write(#todolist-7)
                        todostart = #todolist - 7
                    end

                    drawTodoItems(todostart)
                    ininput = false
                else
                    table.remove(todolist, tonumber(todoinput))
                    term.setCursorPos(2, 9)
                    term.setBackgroundColor(colors.white)
                    term.write("                        ")
                    term.setCursorPos(2, 10)
                    term.write("                        ")
                    drawTodoItems(todostart)
                    ininput = false
                    todoinput = ""
                end
            else
                term.setCursorPos(3, 11)
                term.setBackgroundColor(colors.red)
                term.write("Input must be 21 chars")
                term.setCursorPos(10, 12)
                term.write("or less")
            end
        end
        
        if button == 200 and event == "key" then
            if todostart > 1 then
                todostart = todostart - 1
                drawTodoItems(todostart)
            end
        elseif button == 208  and event == "key" then
            if todostart < #todolist - 7 then
                todostart = todostart + 1
                drawTodoItems(todostart)
            end
        end

        if event == "mouse_scroll" then
            if button == -1 then
                if todostart > 1 then
                    todostart = todostart - 1
                    drawTodoItems(todostart)
                end
            elseif button == 1 then
                if todostart < #todolist - 7 then
                    todostart = todostart + 1
                    drawTodoItems(todostart)
                end
            end
        end

        if button == 14 and event == "key" then
            if string.len(todoinput) > 0 then
                local todx, tody = term.getCursorPos()
                term.setCursorPos(2, 10)
                term.write("                        ")
                term.setCursorPos(todx, tody)
                todoinput = string.sub(todoinput, 1, -2)
            end
        end
    elseif currentscreen == "update" then
        drawUpdateScreen()
    elseif currentscreen == "calculator" then
        if event == "key" then
            if #calcnum < 20 then
                if button > 1 and button < 11 then
                    if resetstate == true then
                        calcnum = ""
                        resetstate = false
                    end
                    calcnum = calcnum..(button - 1)
                elseif button == 11 then
                    if resetstate == true then
                        calcnum = ""
                        resetstate = false
                    end
                    calcnum = calcnum.."."
                elseif button == 14 and #calcnum > 0 then
                    calcnum = string.sub(calcnum, 1, -2)
                elseif button == 28 and currentinp == 2 and #calcnum > 0 then
                    if calcopera == "+" then
                        calcnum = tostring(calcin1 + calcnum)
                        currentinp = 1
                    elseif calcopera == "-" then
                        calcnum = tostring(calcin1 - calcnum)
                        currentinp = 1
                    elseif calcopera == "*" then
                        calcnum = tostring(calcin1 * calcnum)
                        currentinp = 1
                    elseif calcopera == "/" then
                        calcnum = tostring(calcin1 / calcnum)
                        currentinp = 1
                    end
                    if currentinp == 1 then
                        resetstate = true
                    end
                elseif button == 52 and string.find(calcnum, "%.") == nil then
                    calcnum = calcnum.."."
                end
            end
        end
        drawCalcScreen(calcnum)
    end
    --end of idle/keyboard events
    
    if timeron == true then
        timerdiff = math.floor(os.clock()+0.5) - timerstart
        if timerdiff > 0 then
            timerstart = timerstart + timerdiff
            updateTimer(timertime)
        end
    end

    --if I don't have this check that a second has passed, it floods the OS with timer inputs and locks up the computer
    --im so glad it works, finally. weird bug
    --makes the time jump around a little though, unable to fix without breaking more stuff. will come back to this
    if math.floor(os.clock()+0.5) - timerStartTime > 0 then
        os.startTimer(1)
        timerStartTime = math.floor(os.clock()+0.5)
        if timersound == true and speaker ~= nil then
            speaker.playNote("bell")
        end
    end
end