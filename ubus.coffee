# simple ubus wrapper
# protocol details: http://wiki.rocrail.net/doku.php?id=cbus:protocol
dgram = require 'dgram'

opcodes =
	NONE: 0x00 # no result
	ACON: 0x90 # accessory on
	ACOF: 0x91 # accessory off
	ASON: 0x98 # short accessory on
	ASOF: 0x99 # short accessory off
	ACON1: 0xB0 # accessory on + 1 byte data
	ARSS3O: 0xE8 # short accessory event with bytes


udpBroadcast = (data) ->
	console.log "-> udp: #{data}"
	data = new Buffer data
	client = dgram.createSocket 'udp4'
	client.bind()
	client.on 'listening', ->
		client.setBroadcast true
		client.send data, 0, data.length, 5550, '255.255.255.255', (err, bytes) ->
		  client.close()

# example packet: :SBFE0N9000010203;
makePacket = (opcode, data) ->
	bytes = for byte in data
		toHex byte
	":SBFE0N#{toHex opcode}#{bytes.join ''};"
	
# convert ints etc to hex
toHex = (d) ->
	d = Number d
	"0#{d.toString 16}"
		.slice -2
		.toUpperCase()

module.exports = 
	opcodes: opcodes
	send: udpBroadcast
	build: makePacket
	hexify: toHex