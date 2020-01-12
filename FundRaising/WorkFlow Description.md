#TokenRaise Workflow :

1)Bidders bid for the token with their maxprice and number of token they want, maxprice is highest Amount bidder is willing to pay for a single token.

2)All bids are stored till enddate is reached.Bidding process can be done between StartDate of bid , till the EndDate .

3)After EndDate is reached a function sorts all the bids and assigns the winning bidder tokens in accordnce with the current price (See NOTE 2).

4) Bids placed earlier(nearest to StartDate) are considered more prominent bid , as they might have to pay less price for token if CurrentPrice does not fluctuate much before the enddate .

5) After the end date tokens are allocated to winning bidders and their data is stored .

6) After enddate winners of tokens can put their owned token on sale with their Askingprice(Askingprice is the minimum price that seller wants from the buyers).

7) Now, if anyone wants to buy tokens after EndDate , they need to buy the tokens from the pool filled with sellers willing to sell tokens as per their AskingPrice.

8) Tokens are sold to the buyer if buyers maxprice satisfy the sellers AskingPrice (i.e, AskingPrice of seller  <= maxprice of buyer).

9) There are other supporting function also , which drives the work flow of the contract .   
    
    
    NOTE 1: Keep in mind if buyer wants to buy several tokens and only limited sellers with limited tokens are there (i.e, number of tokens 
    buyer wants < total number of tokens in pool by all sellers) or buyer wants to buy several tokens and his maxprice only satisfies
    some of the sellers askig price , in these cases partial order is made . partial order here refers to buying and selling of only 
    those tokens which satisfy all the demands irrespective of buyer or seller.

    NOTE 2: Price changes are based on how many tokens are bidded till date , We keep an eye on how many tokens bidding is done and comparing 
    number of tokens bidded till date to total number of tokens . This will determine how much delta(increase in price) is to be added 
    to the intial price , this is how CurrentPrice is calculated.
