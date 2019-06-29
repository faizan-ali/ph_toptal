function sleep(sec)
    local ntime = os.clock() + sec
    repeat until os.clock() > ntime
end

sleep(arg[1])

