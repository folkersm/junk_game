extends Node

func click_pile(composition)
	
	
	
	

func roll_metal():
	#each item has a rarity value, the higher the rarity value, the easier it is to draw. 
	#the sum of rarity values is the random range we'll draw from
	#to randomly select a card, we'll radnomly pick a number in the range, each card will be assigned an index,
	# which is the rarity value plus the sum of the rarity values of the previous cards. We round up our random 
	#draw index to the next largest index. 
	#So when i add a card to the game, I simply give it a rarity value in a game file. The pool will be 
	#when i pile is created, a index distribution should be selected based on the data fies for each of the cards, plus
	#there should be a way to modify rarity values. 
	#First, there should be an array of cards and there rarities importaed by the new pile, these are base values.
	#The pile will take in a rarity mod array where it can modify the values of each of the rarities. 
	#
