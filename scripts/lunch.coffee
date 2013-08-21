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
		"Ali Baba - Swherma numer 6 takk",
		"Bullan - Tilbod aldarinnar",
		"Supubarinn - Eina franska baunasupu",
		"Icelandic Fish & Chips - alltaf haegt ad ljuga ad sér ad þad sé hollt",
		"Hlöllabatar - Uhmmm, Bacon",
		"Micro barinn - slaum þessu bara upp i kaeruleysi",
		"American Style - Gott tilbod",
		"Pizza Royale - Besta tilbodid",
		"Nonna biti - ferskur og freistandi",
		"Saegreifinn - svona einusinni adur en hann dettur nidur",
		"Kvosin - þeir fa einn séns enn",
		"Kebab husid - klikkar ekki",
		"St. Paul's - Einn Graenlending takk",
		"Rub 23 - Sushi pizza",
		"Ginger - heilsa heilsa heilsa",
		"Austurlandahraðlestin - Tandoori veisla",
		"Nora Magazine - fancy shit",
		"Bergson - bragðlaus heilsa",
		"Geysir - mikið fyrir peninginn",
		"Iða - upphitað shit"
		
	]

	robot.respond /lunch me/i, (msg) ->
		randIndex = Math.floor((Math.random()*places.length)+1)
		msg.send places[randIndex - 1]