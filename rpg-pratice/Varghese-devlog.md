
# Fall 2024 - Intro to Game Design varghesj4@newpaltz.edu

* Name: Jeiss Varghese
* [Trello Board](https://trello.com/b/9qJ1jnDG/game-development-template)
* [Proposal.pdf](Varghese-proposal.pdf-proposal.pdf)
* [Itch.io](https://jeiss3341.itch.io)
* [Itch.io2](https://jeiss3341.itch.io/pratice-project)

## 2024-10-28 4 hrs: Made sweep attack
*Created enemy do a sweep attack following the player position from a certain distance, however the main problem was that it's primarly doing the 'dash' attack over melee since it's not in distance to do melee attack
* following this tutorial, (Parts 12) to have a better understanding of rolling attacks
* https://www.youtube.com/playlist?list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a

## 2024-10-28 4 hrs: Fixed assassin state machines
* Connected all the main functions with state machines so it will flow a lot better since coding it oringially was a lot harder to have the enemy AI work correctly
* following this tutorial, (Parts 11) to have a better understanding of delayed hitboxes
* https://www.youtube.com/playlist?list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a


## 2024-10-23 6 hrs: Fixed assassin AI
* Was able to fix more of the enemy following and attacking mechanic so the timing would flow better
* Added delay and cetain times to hitbox to where enemy could attack
* Fixed camera and map problem where enemies would stop rending in the top 3rd of the map(removed map)
* following this tutorial, (Parts 5, 6, 9, 10) to have a better understanding of State machines
* https://www.youtube.com/playlist?list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a

## 2024-10-22 6 hrs: Fixed assassin 'telporting' and stop rendering in the game
* My main problem was the way I coded the enemy would be very dependant on the player.gd so I had to change it so it's more independent
* Fixed the errors where enemy would stop editing due to being flipped with the the enemy space on sprite and detection range
* changed move and collide to move and slide, change velocity used global position instead of position to fixed assassin positioning




## 2024-10-20 - 6 hrs: Trying to solve issues with game
* Main issue is trying to clean up the code, as of now it's difficult to add attack timers nodes for enemy to the code for some reason but once this is solved the entire project is very easy

## 2024-10-19 - 3 hrs: Fix Camera and couple errors so game looks ok now
* Fixed the camera on the player

## 2024-10-15 - 8hrs: Fixing Errors
* Fixed Y-sort, layers and mask for background, player and enemies
* Fixed basic attack one shotting enemy
* Updated new enemies
* Need to push it to Github ASAP, push itch.io update everything for this class by tomorrow
* Problems: Player leaves screen, Enemies run into each other, Need to show enemy attacks, Develop more complex AI
* (Ideally can finish by this weekend)

## 2024-10-13 - 4hrs: Y-sorting/masking/collision
* Had an error with my collision with player and enemy that crashed the game, unable to fix it
* Pratice with y-sorting and different layers/masks between worlds/players/enemy again
* Had basic AI for following and damage incoming

## 2024-10-6 - 2hrs: Godot Combat pratice and repo update

* Finished with playlist "How to Make an RPG in Godot 4"  by DevWorm on youtube, with working combat and being able to transfer it to my game
* Problem: Need to transfer Previous Github code/work to this new repo
* Updated Repo

## 2024-10-6 - 4hrs: Updated Project Information

* Praticed with playlist "How to Make an RPG in Godot 4"  by DevWorm on youtube on making a basic RPG

## 2024-10-1 - 1.0hrs: Updated Project Information

* Updated Trello Board
* Created Devlog

## 2024-9-30 - 2.0 hrs: Learned about Project

* Learned different ideas for what to do for projets through various youtube videos
* Got to practice basic enemy logic on godot


## 2024-09-24 - 0.5hrs: Made Itch.io, made github repo

* Made Itch.io and Trello Accounts
* Connnected github repo to laptop's SSH key
* Added the intial files that Godot creates
* Added the .gitignore file
* Added the .gitattributes file
