# ixxo IdentitySmartContract

@author Sagar Chaurasia 

----------------------------------------------------------------------------------------------

# About

=> Smart contract for storing information regarding users (users of dappbox).

=> Information is stored by owner of contract only.

=> But can be accessed by anyone.

=> For fetching information single but unique attribute can be used.

=> It stores various information regarding users like User name , account address ,Date of regiration , url and shorten url.

--------------------------------------------------------------------------------------------------------------------------

# Module

=> This contract has several modules , which are :

## addUsers()

=> This function can only be invoked by deployer of contract.

=> For this custom build modifier "onlyOwner" is used.

=> Function stores all the information regarding users in array of struct.

=> This array of struct is mapped to an address (public dappbox address).

=> It takes all the information regarding user as parameter.

Note : For registration date , in-build functionality of solidity "now" is used.

## getByAddress()

=> This function is publicly accessable.

=> Function is used for fetching information regarding specific user ,using address.

=> This function takes address as paramter , and uses it as key to fetch all information.


## getByUserName()

=> This function is also publicly accessable. 

=> Function is used for fetching information regarding specific user ,using userame.

=> This function takes username as paramter , and uses it as key to fetch all information.


## getByUrl()

=> This function is also publicly accessable.

=> Function is used for fetching information regarding specific user ,using url.

=> This function takes url(generated at the time of dappbox registration) as paramter , and uses it as key to fetch all information.


## getByShortUrl()

=> This function is publicly accessable. 

=> Function is used for fetching information regarding specific user ,using shorten url.

=> This function takes shorten url as paramter , and uses it as key to fetch other information.

## compareStrings()

=> This function is internal.

=> Function is used for string comparison.

=> We have first use length check and than "keccak256" for camparing , so that gas consumption can be optimized.

=> Link for keccak256 reference -> https://solidity.readthedocs.io/en/v0.4.21/units-and-global-variables.html ->
