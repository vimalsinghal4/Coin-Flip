# Coin-Flip
Bid On Your Luck

This is submission for the task Coin-flip.
Main idea about the game:-
1.) Users can participate with coins that they can buy(initially every new user gets 100 points free!).
2.) Minimum bet is 20 points.
3.) Rate of 100 coins=One harmony one token.
4.) Only admin is authorised to start new bidding event(but can't participate) and end it.
5.) There will be only one event running at a time.
6.) Every time admin starts a new event he has to set running time(in seconds) for that event.
7.) Users can make bets only once during the time of events. They can either choose 0(heads) or 1(tails).
8.) After the event ends admin is required to call the endevent function.
9.) Before ending the event admin is required to generate outcome of the event by call generate fuction which uses Harmony vrf to produce random outcome.
10.) Users with right guesses get twice the coins they invested and others loose their all invested coins.
11.) Users can withdraw their coins(in form of Harmony One token) for the same rate that they bought them for, but their overall balance can't be less than 100 coins.
12.)contract address = 0x54dDf26475C90d9F262bBa2c632497A799c68B5d deployed on harmony testnet (1666700000) network.
