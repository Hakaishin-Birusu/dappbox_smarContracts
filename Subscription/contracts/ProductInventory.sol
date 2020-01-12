pragma solidity >=0.4.21 <0.6.0;

contract ProductInventory
{
    function setProductPrice(uint256 _productId, uint256 _price)public
    {}
    function setAddonPrice(uint256 _AddonId, uint256 _price)public
    {}
    function createProduct(uint256 _productId,string memory _productName,uint256 _hardDrive,uint256 _maxMemory,uint256 _maxProcess,uint256 _initialPrice,bool _renewal)internal
    {}
    function createAddon(uint256 _productId,string memory _productName,uint256 _initialPrice) public 
    {}
    function _renewableOf(uint256 _productId) internal view returns (bool) 
    {}
    function priceOfProduct(uint256 _productId) internal view returns (uint256)
    {}
    function priceOfAddon (uint256 _addonId) internal view returns(uint256)
    {}
    function _getAddonName(uint256 _addonId) internal view returns (string memory)
    {}
    function _getProductName(uint256 _productId) internal view returns (string memory)
    {}
    function getAllProducts(uint256 index) public view returns(uint256, string memory,uint256,uint256,uint256,uint256,bool)
    {}
    function getAllAddons(uin256 index) public view returns(uint256,string memory,uint256)
}