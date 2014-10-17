ubus = require './ubus'
listener = require './listener'

server = new listener (universe, slot, value) ->
	ubus.send ubus.build ubus.opcodes.ACON1, [0x00, (universe >> 8) + 1, 0x00, slot, value]

