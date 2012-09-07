# Description:
#   Random lunch place in downtown Reykjavik
#
# Commands:
#   hubot lunch me - Show a random lunch joint
#
# Author:
#   Örn Þórðarson

module.exports = (robot) ->

	places = [
		"Ali Baba - Swherma númer 6 takk",
		"Búllan - Tilboð aldarinnar",
		"Súpubarinn - Eina franska baunasúpu",
		"Icelandic Fish & Chips - alltaf hægt að ljúga að sér að það sé hollt",
		"Hlöllabátar - Uhmmm, Bacon",
		"Micro barinn - sláum þessu bara upp í kæruleysi",
		"American Style - Gott tilboð",
		"Pizza Royale - Besta tilboðið",
		"Nonna biti - ferskur og freistandi",
		"Sægreifinn - svona einusinni áður en hann dettur niður",
		"Kvosin - þeir fá einn séns enn",
		"Kebab húsið - klikkar ekki",
		"St. Paul's - Einn Grænlending takk",
		"Rub 23 - Sushi pizza"
	]

	robot.respond /lunch me/i, (msg) ->
		randIndex = Math.floor((Math.random()*places.length)+1)
		msg.send places[randIndex - 1]