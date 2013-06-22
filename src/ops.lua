local ops = {}

ops.money = {}
ops.money.server = function(clientid,data)
  return 1337
end
ops.money.client = function(data)
  client._money = data
end
ops.money.validate = function(data)
  return true -- no args to parse
end

return ops
