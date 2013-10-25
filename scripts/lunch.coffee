# Description:
#   Random lunch place in downtown Reykjavik
#
# Commands:
#   hubot lunch me - Show a random lunch joint
#
# Author:
#   �rn ��r�arson

module.exports = (robot) ->

	places = [
		"Ali Baba - Swherma numer 6 takk",
		"Bullan - Tilbod aldarinnar",
		"Supubarinn - Eina franska baunasupu",
		"Icelandic Fish & Chips - alltaf haegt ad ljuga ad s�r ad �ad s� hollt",
		"Hl�llabatar - Uhmmm, Bacon",
		"Micro barinn - slaum �essu bara upp i kaeruleysi",
		"American Style - Gott tilbod",
		"Pizza Royale - Besta tilbodid",
		"Nonna biti - ferskur og freistandi",
		"Saegreifinn - svona einusinni adur en hann dettur nidur",
		"Kvosin - �eir fa einn s�ns enn",
		"Kebab husid - klikkar ekki",
		"Kebab Grill - besta kebab � Reykjav�k �ri� 2012",
		"Rub 23 - Sushi pizza",
		"Ginger - heilsa heilsa heilsa",
		"Austurlandahra�lestin - Tandoori veisla",
		"Nora Magazine - fancy shit",
		"Bergson - brag�laus heilsa",
		"Geysir - miki� fyrir peninginn",
		"I�a - upphita� shit"
		
	]

	robot.respond /lunch me/i, (msg) ->
		randIndex = Math.floor((Math.random()*places.length)+1)
		msg.send places[randIndex - 1]