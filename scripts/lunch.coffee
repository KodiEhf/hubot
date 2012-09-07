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
		"Ali Baba - Swherma n�mer 6 takk",
		"B�llan - Tilbo� aldarinnar",
		"S�pubarinn - Eina franska baunas�pu",
		"Icelandic Fish & Chips - alltaf h�gt a� lj�ga a� s�r a� �a� s� hollt",
		"Hl�llab�tar - Uhmmm, Bacon",
		"Micro barinn - sl�um �essu bara upp � k�ruleysi",
		"American Style - Gott tilbo�",
		"Pizza Royale - Besta tilbo�i�",
		"Nonna biti - ferskur og freistandi",
		"S�greifinn - svona einusinni ��ur en hann dettur ni�ur",
		"Kvosin - �eir f� einn s�ns enn",
		"Kebab h�si� - klikkar ekki",
		"St. Paul's - Einn Gr�nlending takk",
		"Rub 23 - Sushi pizza"
	]

	robot.respond /lunch me/i, (msg) ->
		randIndex = Math.floor((Math.random()*places.length)+1)
		msg.send places[randIndex - 1]