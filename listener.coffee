# ArtNet listener, only fires events when the data has changed

class ArtNetListener
	data: []
	
	constructor: (@cb) ->
		@server = require 'artnet-node'
			.Server.listen 6454, @onPacket
	
	onPacket: (packet, peer) =>
		lastPacketData = @data[packet.universe]
		if not equal(packet.data, lastPacketData)
			for value, slot in packet.data
				if !lastPacketData? or !lastPacketData[slot]? or lastPacketData[slot] isnt value
					@cb packet.universe, slot, value
			@data[packet.universe] = packet.data

equal = (a, b) ->
	return false if !a?.length or !b?.length or a.length isnt b.length
	for x, i in a
		if b[i] isnt x
			return false
	return true

module.exports = ArtNetListener