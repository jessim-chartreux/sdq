Console = {}

Console.Log = function (...)
    print("^2[Outro]^0 ", table.concat({...}, " "))
end

Console.Error = function (...)
    print("^1[Outro Error]^0 ", table.concat({...}, " "))
end

Console.Warning = function (...)
    print("^3[Outro Warning]^0 ", table.concat({...}, " "))
end
