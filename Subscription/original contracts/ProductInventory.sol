
pragma solidity >=0.4.21 <0.6.0;

contract ProductInventory
{
    event ProductOrAddonCreated(uint256 id,string productName,uint256 price);
    event PriceChanged(uint256 productId,uint256 newPrice);
    
    address CEO;
    constructor () public 
    {
        _createProduct(101,"dappboxFree",0,2,2,0,false);
        _createProduct(102,"dappboxbStart",300,20,4,2,true);
        _createProduct(103,"dappboxPremium",800,200,8,4,true);
        _createAddon(201,"RocketChat",100);
        _createAddon(202,"Taiga Server",100); 
        CEO = msg.sender;
    }

    modifier onlyCEO()
    {
        require(msg.sender == CEO);
        _;
    }
    
    struct Product
    {
        uint256 id;
        string productName;
        uint256 price;
        uint256 hardDrive;
        uint256 maxMemory;
        uint256 maxProcess ;
        bool renewable;
    }

    struct addOnProduct 
    { 
        uint256 addonId;
        string addonName ;
        uint256 addonPrice; // only addon price , base dppbox individual price is not added 
    }

    uint256[] internal allProductIds;
    uint256[] internal allAddonsIds;

    mapping (uint256 => Product) internal products;
    mapping (uint256 => addOnProduct) internal addOnProducts;

    function setProductPrice(uint256 _productId, uint256 _price)public onlyCEO
    {
        products[_productId].price = _price;
        emit PriceChanged(_productId, _price);
    }

    /**
    * @notice setPriceOfAddon - sets the price of a addon
    * @param _AddonId - the addonId id
    * @param _price - the product price
    */
    function setAddonPrice(uint256 _AddonId, uint256 _price)public onlyCEO
    {       
      addOnProducts[_AddonId].addonPrice = _price;
      emit PriceChanged(_AddonId,_price);
    }
      
    function _createProduct(
      uint256 _productId,
      string memory _productName,
      uint256 _hardDrive,
      uint256 _maxMemory,
      uint256 _maxProcess,
      uint256 _initialPrice,
      bool _renewal
      )
      internal
    {
      //require(_productDoesNotExist(_productId));

      Product memory _product = Product({
        id: _productId,
        productName : _productName,
        price: _initialPrice,
        hardDrive: _hardDrive,
        maxMemory: _maxMemory,
        maxProcess: _maxProcess,
        renewable: _renewal 
      });
      products[_productId] = _product;
      allProductIds.push(_productId);

      emit  ProductOrAddonCreated(
        _product.id,
        _product.productName,
        _product.price
        );
    }

  function _createAddon(uint256 _productId,string memory _productName, uint256 _initialPrice)internal
  {
    //require(_addonDoesNotExist(_productId));

    addOnProduct  memory _addOnProduct  = addOnProduct ({
      addonId:_productId,
      addonName:_productName,
      addonPrice:_initialPrice 
    });
    
    addOnProducts[_productId] = _addOnProduct;
    allAddonsIds.push(_productId);

     emit ProductOrAddonCreated(
      _addOnProduct.addonId,
      _addOnProduct.addonName,
      _addOnProduct.addonPrice
      );
  }

  function createAddon(uint256 _productId,string memory _productName,uint256 _initialPrice) public onlyCEO
  {
    _createAddon(_productId,_productName,_initialPrice);
  }
  
  function createProduct(
    uint256 _productId,
    string memory  _productName,
    uint256 _initialPrice,
    uint256 _hardDrive,
    uint256 _maxMemory,
    uint256 _maxProcess,
    bool _renewal)
    public onlyCEO
  {
    _createProduct(
      _productId,
      _productName,
      _initialPrice,
      _hardDrive,
      _maxMemory,
      _maxProcess,
      _renewal);
  }

  function _renewableOf(uint256 _productId) internal view returns (bool) {
    require(_productId != 0,"not a valid product");
    return products[_productId].renewable;
  }
  

  /*
   * @dev returns the current price of requesting addon ,
   * NOTE ; the price is of addon only not te base dappbox individual we are using to serve the addon  
   */
  

    /**
  * @notice The price of a product
  * @param _productId - the product id
  */
  function priceOfProduct(uint256 _productId) internal view returns (uint256) {
    return products[_productId].price;
  }
  /*
   * @dev returns the current price of requesting addon ,
   * NOTE ; the price is of addon only not te base dappbox individual we are using to serve the addon  
   */
  function priceOfAddon (uint256 _addonId) internal view returns(uint256)
  {
    return addOnProducts[_addonId].addonPrice ;
  }

  /**
   * @dev returns the name of addon related to the supplied addonId
   */

  function _getAddonName(uint256 _addonId) internal view returns (string memory)
  {
    return addOnProducts[_addonId].addonName;

  }

  function _getProductName(uint256 _productId) internal view returns (string memory)
  {
    return products[_productId].productName;

  }

    function changeCEO(address newCEO) onlyCEO public returns (bool)
    {
        CEO = newCEO;
        return true;
    }

    function _getAllProducts(uint256 index) public view returns(uint256, string memory,uint256,uint256,uint256,uint256,bool)
    {
        uint256 indexer = allProductIds[index];   
        return (products[indexer].id,
        products[indexer].productName,
        products[indexer]. price,
        products[indexer].hardDrive,
        products[indexer].maxMemory,
        products[indexer].maxProcess,
         products[indexer].renewable);
    }
    
    function _getAllAddons(uint256 index) public view returns(uint256,string memory,uint256)
    {
        uint256 indexer = allAddonsIds[index];
        return (addOnProducts[indexer].addonId,
         addOnProducts[indexer].addonName,
          addOnProducts[indexer].addonPrice);
    }

}
