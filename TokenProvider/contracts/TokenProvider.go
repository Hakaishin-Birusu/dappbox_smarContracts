// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package contract

import (
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = abi.U256
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// TokenProviderABI is the input ABI used to generate the binding from.
const TokenProviderABI = "[{\"constant\":false,\"inputs\":[{\"internalType\":\"string\",\"name\":\"_url\",\"type\":\"string\"},{\"internalType\":\"addresspayable\",\"name\":\"_address\",\"type\":\"address\"},{\"internalType\":\"bytes32\",\"name\":\"_rawhash\",\"type\":\"bytes32\"},{\"internalType\":\"bytes\",\"name\":\"_signedMesaage\",\"type\":\"bytes\"}],\"name\":\"addDeviceTempAccountInfo\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"address\",\"name\":\"dAppBoxAddress\",\"type\":\"address\"}],\"name\":\"addOrChangeMasterDappboxAddress\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"}],\"name\":\"getAllPreviousTransaction\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"string\",\"name\":\"user\",\"type\":\"string\"},{\"internalType\":\"uint256\",\"name\":\"index\",\"type\":\"uint256\"}],\"name\":\"getAllPreviousTransactionOfUser\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"string\",\"name\":\"url\",\"type\":\"string\"}],\"name\":\"getDappBoxPermanentAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"string\",\"name\":\"_url\",\"type\":\"string\"}],\"name\":\"getUsersTempInfo\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"},{\"internalType\":\"bytes\",\"name\":\"\",\"type\":\"bytes\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"masterDappbox\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"string\",\"name\":\"url\",\"type\":\"string\"},{\"internalType\":\"addresspayable\",\"name\":\"reciever\",\"type\":\"address\"}],\"name\":\"sendToken\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"string\",\"name\":\"url\",\"type\":\"string\"},{\"internalType\":\"address\",\"name\":\"userAddresss\",\"type\":\"address\"}],\"name\":\"setDappboxPermanentAddress\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"string\",\"name\":\"_url\",\"type\":\"string\"}],\"name\":\"verifyAndSend\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"}]"

// TokenProviderFuncSigs maps the 4-byte function signature to its string representation.
var TokenProviderFuncSigs = map[string]string{
	"16241ae0": "addDeviceTempAccountInfo(string,address,bytes32,bytes)",
	"56f27fa1": "addOrChangeMasterDappboxAddress(address)",
	"fdc5f671": "getAllPreviousTransaction(uint256)",
	"079c1f6b": "getAllPreviousTransactionOfUser(string,uint256)",
	"246787b0": "getDappBoxPermanentAddress(string)",
	"a64a7f52": "getUsersTempInfo(string)",
	"590cf88b": "masterDappbox()",
	"8da5cb5b": "owner()",
	"9c4bd505": "sendToken(string,address)",
	"1b078be3": "setDappboxPermanentAddress(string,address)",
	"27b3318d": "verifyAndSend(string)",
}

// TokenProviderBin is the compiled bytecode used for deploying new contracts.
var TokenProviderBin = "0x6080604052600280546001600160a01b0319163317905534801561002257600080fd5b506119b4806100326000396000f3fe60806040526004361061009c5760003560e01c806356f27fa11161006457806356f27fa1146104e7578063590cf88b1461051a5780638da5cb5b1461052f5780639c4bd50514610544578063a64a7f52146105f3578063fdc5f6711461073c5761009c565b8063079c1f6b146100a157806316241ae01461018f5780631b078be3146102dc578063246787b0146103ac57806327b3318d14610479575b600080fd5b3480156100ad57600080fd5b50610154600480360360408110156100c457600080fd5b810190602081018135600160201b8111156100de57600080fd5b8201836020820111156100f057600080fd5b803590602001918460018302840111600160201b8311171561011157600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295505091359250610766915050565b604080516001600160a01b03968716815294909516602085015283850192909252151560608301521515608082015290519081900360a00190f35b34801561019b57600080fd5b506102da600480360360808110156101b257600080fd5b810190602081018135600160201b8111156101cc57600080fd5b8201836020820111156101de57600080fd5b803590602001918460018302840111600160201b831117156101ff57600080fd5b91908080601f01602080910402602001604051908101604052809392919081815260200183838082843760009201919091525092956001600160a01b0385351695602086013595919450925060608101915060400135600160201b81111561026657600080fd5b82018360208201111561027857600080fd5b803590602001918460018302840111600160201b8311171561029957600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550610aa7945050505050565b005b3480156102e857600080fd5b50610398600480360360408110156102ff57600080fd5b810190602081018135600160201b81111561031957600080fd5b82018360208201111561032b57600080fd5b803590602001918460018302840111600160201b8311171561034c57600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550505090356001600160a01b03169150610b759050565b604080519115158252519081900360200190f35b3480156103b857600080fd5b5061045d600480360360208110156103cf57600080fd5b810190602081018135600160201b8111156103e957600080fd5b8201836020820111156103fb57600080fd5b803590602001918460018302840111600160201b8311171561041c57600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550610c01945050505050565b604080516001600160a01b039092168252519081900360200190f35b6103986004803603602081101561048f57600080fd5b810190602081018135600160201b8111156104a957600080fd5b8201836020820111156104bb57600080fd5b803590602001918460018302840111600160201b831117156104dc57600080fd5b509092509050610c72565b3480156104f357600080fd5b506103986004803603602081101561050a57600080fd5b50356001600160a01b0316611100565b34801561052657600080fd5b5061045d611177565b34801561053b57600080fd5b5061045d611186565b6103986004803603604081101561055a57600080fd5b810190602081018135600160201b81111561057457600080fd5b82018360208201111561058657600080fd5b803590602001918460018302840111600160201b831117156105a757600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550505090356001600160a01b031691506111959050565b3480156105ff57600080fd5b506106a46004803603602081101561061657600080fd5b810190602081018135600160201b81111561063057600080fd5b82018360208201111561064257600080fd5b803590602001918460018302840111600160201b8311171561066357600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295506114ae945050505050565b60405180846001600160a01b03166001600160a01b0316815260200183815260200180602001828103825283818151815260200191508051906020019080838360005b838110156106ff5781810151838201526020016106e7565b50505050905090810190601f16801561072c5780820380516001836020036101000a031916815260200191505b5094505050505060405180910390f35b34801561074857600080fd5b506101546004803603602081101561075f57600080fd5b5035611681565b6000806000806000856005886040518082805190602001908083835b602083106107a15780518252601f199092019160209182019101610782565b51815160209384036101000a600019018019909216911617905292019485525060405193849003019092205492909211159150610a9d90505760006005886040518082805190602001908083835b6020831061080e5780518252601f1990920191602091820191016107ef565b51815160209384036101000a600019018019909216911617905292019485525060405193849003019092208054909250899150811061084957fe5b600091825260208083206004909202909101546040518b516001600160a01b0390921694506005928c9282918401908083835b6020831061089b5780518252601f19909201916020918201910161087c565b51815160209384036101000a6000190180199092169116179052920194855250604051938490030190922080549092508a915081106108d657fe5b906000526020600020906004020160010160009054906101000a90046001600160a01b03169050600060058a6040518082805190602001908083835b602083106109315780518252601f199092019160209182019101610912565b51815160209384036101000a6000190180199092169116179052920194855250604051938490030190922080549092508b9150811061096c57fe5b9060005260206000209060040201600201549050600060058b6040518082805190602001908083835b602083106109b45780518252601f199092019160209182019101610995565b51815160209384036101000a6000190180199092169116179052920194855250604051938490030190922080549092508c915081106109ef57fe5b6000918252602091829020600360049092020101546040518d5160019d909d019c60ff90921693506005928e9282918401908083835b60208310610a445780518252601f199092019160209182019101610a25565b51815160209384036101000a60001901801990921691161790529201948552506040519384900301909220548c10159150610a8e9050579297509095509350915060019050610a9d565b92975090955093509150600090505b9295509295909350565b610aaf61184d565b6001600160a01b0384168152602080820184905260408083018490525186518392600492899290918291908401908083835b60208310610b005780518252601f199092019160209182019101610ae1565b51815160209384036101000a600019018019909216911617905292019485525060408051948590038201909420855181546001600160a01b0319166001600160a01b03909116178155858201516001820155938501518051610b6b945060028601935091019061186c565b5050505050505050565b6000816001846040518082805190602001908083835b60208310610baa5780518252601f199092019160209182019101610b8b565b51815160209384036101000a6000190180199092169116179052920194855250604051938490030190922080546001600160a01b0319166001600160a01b0394909416939093179092555060019150505b92915050565b60006001826040518082805190602001908083835b60208310610c355780518252601f199092019160209182019101610c16565b51815160209384036101000a60001901801990921691161790529201948552506040519384900301909220546001600160a01b0316949350505050565b60025460009081906001600160a01b0316331480610c9a57506003546001600160a01b031633145b9050600181151514610cea576040805162461bcd60e51b8152602060048201526014602482015273185d5d1a1bdc9a5e985d1a5bdb8819985a5b195960621b604482015290519081900360640190fd5b60006004858560405180838380828437919091019485525050604051928390036020018320546001600160a01b03169350600092600492508891508790808383808284378083019250505092505050908152602001604051809103902060010154905060606004878760405180838380828437919091019485525050604080516020948190038501812060029081018054600181161561010002600019011691909104601f81018790048702830187019093528282529094909350909150830182828015610df95780601f10610dce57610100808354040283529160200191610df9565b820191906000526020600020905b815481529060010190602001808311610ddc57829003601f168201915b50939450505050506001600160a01b038316610e4d576040805162461bcd60e51b815260206004820152600e60248201526d155cd95c881b9bdd08199bdd5b9960921b604482015290519081900360640190fd5b6000610e59838361177c565b90506000610e656118ea565b3381526001600160a01b0386811660208301819052346040840152908416148015610eb8575060008a8a60405180838380828437919091019485525050604051928390036020019092205460ff16159150505b15610f4257604051600192506001600160a01b038716903480156108fc02916000818181858888f19350505050158015610ef6573d6000803e3d6000fd5b50811515606082015260405182906000908c908c908083838082843791909101948552505060405192839003602001909220805493151560ff199094169390931790925550610f889050565b600091508160008b8b6040518083838082843791909101948552505060405192839003602001909220805493151560ff1990941693909317909255505081151560608201525b60058a8a60405180838380828437919091019485525050604080516020948190038501902080546001808201835560009283528683208851600493840290910180546001600160a01b03199081166001600160a01b03938416178255988a01805182850180548c16918516919091179055958a018051600283015560608b0180516003909301805460ff1990811694151594909417905560068054958601815590965299517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f9390940292830180548a169483169490941790935593517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d408201805490981694169390931790955594517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d4182015593517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d4290940180549093169315159390931790915550909998505050505050505050565b6002546000906001600160a01b03163314611152576040805162461bcd60e51b815260206004820152600d60248201526c2737ba103a34329037bbb732b960991b604482015290519081900360640190fd5b50600380546001600160a01b0383166001600160a01b03199091161790556001919050565b6003546001600160a01b031681565b6002546001600160a01b031681565b60025460009081906001600160a01b03163314806111bd57506003546001600160a01b031633145b905060018115151461120d576040805162461bcd60e51b8152602060048201526014602482015273185d5d1a1bdc9a5e985d1a5bdb8819985a5b195960621b604482015290519081900360640190fd5b336001600160a01b03841614156112555760405162461bcd60e51b815260040180806020018281038252602b81526020018061192f602b913960400191505060405180910390fd5b6001600160a01b0383166112a1576040805162461bcd60e51b815260206004820152600e60248201526d155cd95c881b9bdd08199bdd5b9960921b604482015290519081900360640190fd5b6112a96118ea565b6040516001600160a01b038516903480156108fc02916000818181858888f193505050501580156112de573d6000803e3d6000fd5b503381526001600160a01b038416602080830191909152346040808401919091526001606084015251865160059288929182918401908083835b602083106113375780518252601f199092019160209182019101611318565b51815160209384036101000a60001901801990921691161790529201948552506040805194859003820190942080546001808201835560009283528383208851600493840290910180546001600160a01b03199081166001600160a01b03938416178255958a01805182850180548916918516919091179055988a018051600283015560608b0180516003909301805460ff1990811694151594909417905560068054808701825597529a517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f96909502958601805488169584169590951790945597517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d4085018054909616911617909355517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d4182015594517ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d42909501805490941694151594909417909255509095945050505050565b60008060606004846040518082805190602001908083835b602083106114e55780518252601f1990920191602091820191016114c6565b51815160209384036101000a600019018019909216911617905292019485525060405193849003810184205488516001600160a01b039091169460049450899350918291908401908083835b602083106115505780518252601f199092019160209182019101611531565b51815160209384036101000a600019018019909216911617905292019485525060405193849003810184206001015489519094600494508a9350918291908401908083835b602083106115b45780518252601f199092019160209182019101611595565b518151600019602094850361010090810a8201928316921993909316919091179092529490920196875260408051978890038201882060029081018054601f600182161590980290950190941604948501829004820288018201905283875290959450859350840190508282801561166d5780601f106116425761010080835404028352916020019161166d565b820191906000526020600020905b81548152906001019060200180831161165057829003601f168201915b505050505090509250925092509193909250565b60008060008060008560016006805490500310611773576000600687815481106116a757fe5b60009182526020822060049091020154600680546001600160a01b03909216935090899081106116d357fe5b60009182526020822060016004909202010154600680546001600160a01b039092169350908a90811061170257fe5b9060005260206000209060040201600201549050600060068a8154811061172557fe5b600091825260209091206003600490920201015460065460019b909b019a60ff90911691508a1015611764579297509095509350915060019050611773565b92975090955093509150600090505b91939590929450565b60008060008084516041146117975760009350505050610bfb565b50505060208201516040830151606084015160001a601b8110156117b957601b015b8060ff16601b141580156117d157508060ff16601c14155b156117e25760009350505050610bfb565b6040805160008152602080820180845289905260ff8416828401526060820186905260808201859052915160019260a0808401939192601f1981019281900390910190855afa158015611839573d6000803e3d6000fd5b505050602060405103519350505050610bfb565b6040805160608082018352600080835260208301529181019190915290565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106118ad57805160ff19168380011785556118da565b828001600101855582156118da579182015b828111156118da5782518255916020019190600101906118bf565b506118e6929150611911565b5090565b60408051608081018252600080825260208201819052918101829052606081019190915290565b61192b91905b808211156118e65760008155600101611917565b9056fe6d61737465722064417070426f782063616e6e6f742073656e6420746f6b656e7320746f20697473656c66a265627a7a72315820c47d0fe44bad3bc438aadca5b05cb3dc2d0c01b390c7375c695b3a89da35ff8a64736f6c637828302e352e31332d646576656c6f702e323031392e31302e352b636f6d6d69742e36636263633337390058"

// DeployTokenProvider deploys a new Ethereum contract, binding an instance of TokenProvider to it.
func DeployTokenProvider(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *TokenProvider, error) {
	parsed, err := abi.JSON(strings.NewReader(TokenProviderABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}

	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(TokenProviderBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &TokenProvider{TokenProviderCaller: TokenProviderCaller{contract: contract}, TokenProviderTransactor: TokenProviderTransactor{contract: contract}, TokenProviderFilterer: TokenProviderFilterer{contract: contract}}, nil
}

// TokenProvider is an auto generated Go binding around an Ethereum contract.
type TokenProvider struct {
	TokenProviderCaller     // Read-only binding to the contract
	TokenProviderTransactor // Write-only binding to the contract
	TokenProviderFilterer   // Log filterer for contract events
}

// TokenProviderCaller is an auto generated read-only Go binding around an Ethereum contract.
type TokenProviderCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TokenProviderTransactor is an auto generated write-only Go binding around an Ethereum contract.
type TokenProviderTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TokenProviderFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type TokenProviderFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TokenProviderSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type TokenProviderSession struct {
	Contract     *TokenProvider    // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// TokenProviderCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type TokenProviderCallerSession struct {
	Contract *TokenProviderCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts        // Call options to use throughout this session
}

// TokenProviderTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type TokenProviderTransactorSession struct {
	Contract     *TokenProviderTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts        // Transaction auth options to use throughout this session
}

// TokenProviderRaw is an auto generated low-level Go binding around an Ethereum contract.
type TokenProviderRaw struct {
	Contract *TokenProvider // Generic contract binding to access the raw methods on
}

// TokenProviderCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type TokenProviderCallerRaw struct {
	Contract *TokenProviderCaller // Generic read-only contract binding to access the raw methods on
}

// TokenProviderTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type TokenProviderTransactorRaw struct {
	Contract *TokenProviderTransactor // Generic write-only contract binding to access the raw methods on
}

// NewTokenProvider creates a new instance of TokenProvider, bound to a specific deployed contract.
func NewTokenProvider(address common.Address, backend bind.ContractBackend) (*TokenProvider, error) {
	contract, err := bindTokenProvider(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &TokenProvider{TokenProviderCaller: TokenProviderCaller{contract: contract}, TokenProviderTransactor: TokenProviderTransactor{contract: contract}, TokenProviderFilterer: TokenProviderFilterer{contract: contract}}, nil
}

// NewTokenProviderCaller creates a new read-only instance of TokenProvider, bound to a specific deployed contract.
func NewTokenProviderCaller(address common.Address, caller bind.ContractCaller) (*TokenProviderCaller, error) {
	contract, err := bindTokenProvider(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &TokenProviderCaller{contract: contract}, nil
}

// NewTokenProviderTransactor creates a new write-only instance of TokenProvider, bound to a specific deployed contract.
func NewTokenProviderTransactor(address common.Address, transactor bind.ContractTransactor) (*TokenProviderTransactor, error) {
	contract, err := bindTokenProvider(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &TokenProviderTransactor{contract: contract}, nil
}

// NewTokenProviderFilterer creates a new log filterer instance of TokenProvider, bound to a specific deployed contract.
func NewTokenProviderFilterer(address common.Address, filterer bind.ContractFilterer) (*TokenProviderFilterer, error) {
	contract, err := bindTokenProvider(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &TokenProviderFilterer{contract: contract}, nil
}

// bindTokenProvider binds a generic wrapper to an already deployed contract.
func bindTokenProvider(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(TokenProviderABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_TokenProvider *TokenProviderRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _TokenProvider.Contract.TokenProviderCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_TokenProvider *TokenProviderRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _TokenProvider.Contract.TokenProviderTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_TokenProvider *TokenProviderRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _TokenProvider.Contract.TokenProviderTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_TokenProvider *TokenProviderCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _TokenProvider.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_TokenProvider *TokenProviderTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _TokenProvider.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_TokenProvider *TokenProviderTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _TokenProvider.Contract.contract.Transact(opts, method, params...)
}

// GetAllPreviousTransaction is a free data retrieval call binding the contract method 0xfdc5f671.
//
// Solidity: function getAllPreviousTransaction(uint256 index) constant returns(address, address, uint256, bool, bool)
func (_TokenProvider *TokenProviderCaller) GetAllPreviousTransaction(opts *bind.CallOpts, index *big.Int) (common.Address, common.Address, *big.Int, bool, bool, error) {
	var (
		ret0 = new(common.Address)
		ret1 = new(common.Address)
		ret2 = new(*big.Int)
		ret3 = new(bool)
		ret4 = new(bool)
	)
	out := &[]interface{}{
		ret0,
		ret1,
		ret2,
		ret3,
		ret4,
	}
	err := _TokenProvider.contract.Call(opts, out, "getAllPreviousTransaction", index)
	return *ret0, *ret1, *ret2, *ret3, *ret4, err
}

// GetAllPreviousTransaction is a free data retrieval call binding the contract method 0xfdc5f671.
//
// Solidity: function getAllPreviousTransaction(uint256 index) constant returns(address, address, uint256, bool, bool)
func (_TokenProvider *TokenProviderSession) GetAllPreviousTransaction(index *big.Int) (common.Address, common.Address, *big.Int, bool, bool, error) {
	return _TokenProvider.Contract.GetAllPreviousTransaction(&_TokenProvider.CallOpts, index)
}

// GetAllPreviousTransaction is a free data retrieval call binding the contract method 0xfdc5f671.
//
// Solidity: function getAllPreviousTransaction(uint256 index) constant returns(address, address, uint256, bool, bool)
func (_TokenProvider *TokenProviderCallerSession) GetAllPreviousTransaction(index *big.Int) (common.Address, common.Address, *big.Int, bool, bool, error) {
	return _TokenProvider.Contract.GetAllPreviousTransaction(&_TokenProvider.CallOpts, index)
}

// GetAllPreviousTransactionOfUser is a free data retrieval call binding the contract method 0x079c1f6b.
//
// Solidity: function getAllPreviousTransactionOfUser(string user, uint256 index) constant returns(address, address, uint256, bool, bool)
func (_TokenProvider *TokenProviderCaller) GetAllPreviousTransactionOfUser(opts *bind.CallOpts, user string, index *big.Int) (common.Address, common.Address, *big.Int, bool, bool, error) {
	var (
		ret0 = new(common.Address)
		ret1 = new(common.Address)
		ret2 = new(*big.Int)
		ret3 = new(bool)
		ret4 = new(bool)
	)
	out := &[]interface{}{
		ret0,
		ret1,
		ret2,
		ret3,
		ret4,
	}
	err := _TokenProvider.contract.Call(opts, out, "getAllPreviousTransactionOfUser", user, index)
	return *ret0, *ret1, *ret2, *ret3, *ret4, err
}

// GetAllPreviousTransactionOfUser is a free data retrieval call binding the contract method 0x079c1f6b.
//
// Solidity: function getAllPreviousTransactionOfUser(string user, uint256 index) constant returns(address, address, uint256, bool, bool)
func (_TokenProvider *TokenProviderSession) GetAllPreviousTransactionOfUser(user string, index *big.Int) (common.Address, common.Address, *big.Int, bool, bool, error) {
	return _TokenProvider.Contract.GetAllPreviousTransactionOfUser(&_TokenProvider.CallOpts, user, index)
}

// GetAllPreviousTransactionOfUser is a free data retrieval call binding the contract method 0x079c1f6b.
//
// Solidity: function getAllPreviousTransactionOfUser(string user, uint256 index) constant returns(address, address, uint256, bool, bool)
func (_TokenProvider *TokenProviderCallerSession) GetAllPreviousTransactionOfUser(user string, index *big.Int) (common.Address, common.Address, *big.Int, bool, bool, error) {
	return _TokenProvider.Contract.GetAllPreviousTransactionOfUser(&_TokenProvider.CallOpts, user, index)
}

// GetDappBoxPermanentAddress is a free data retrieval call binding the contract method 0x246787b0.
//
// Solidity: function getDappBoxPermanentAddress(string url) constant returns(address)
func (_TokenProvider *TokenProviderCaller) GetDappBoxPermanentAddress(opts *bind.CallOpts, url string) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _TokenProvider.contract.Call(opts, out, "getDappBoxPermanentAddress", url)
	return *ret0, err
}

// GetDappBoxPermanentAddress is a free data retrieval call binding the contract method 0x246787b0.
//
// Solidity: function getDappBoxPermanentAddress(string url) constant returns(address)
func (_TokenProvider *TokenProviderSession) GetDappBoxPermanentAddress(url string) (common.Address, error) {
	return _TokenProvider.Contract.GetDappBoxPermanentAddress(&_TokenProvider.CallOpts, url)
}

// GetDappBoxPermanentAddress is a free data retrieval call binding the contract method 0x246787b0.
//
// Solidity: function getDappBoxPermanentAddress(string url) constant returns(address)
func (_TokenProvider *TokenProviderCallerSession) GetDappBoxPermanentAddress(url string) (common.Address, error) {
	return _TokenProvider.Contract.GetDappBoxPermanentAddress(&_TokenProvider.CallOpts, url)
}

// GetUsersTempInfo is a free data retrieval call binding the contract method 0xa64a7f52.
//
// Solidity: function getUsersTempInfo(string _url) constant returns(address, bytes32, bytes)
func (_TokenProvider *TokenProviderCaller) GetUsersTempInfo(opts *bind.CallOpts, _url string) (common.Address, [32]byte, []byte, error) {
	var (
		ret0 = new(common.Address)
		ret1 = new([32]byte)
		ret2 = new([]byte)
	)
	out := &[]interface{}{
		ret0,
		ret1,
		ret2,
	}
	err := _TokenProvider.contract.Call(opts, out, "getUsersTempInfo", _url)
	return *ret0, *ret1, *ret2, err
}

// GetUsersTempInfo is a free data retrieval call binding the contract method 0xa64a7f52.
//
// Solidity: function getUsersTempInfo(string _url) constant returns(address, bytes32, bytes)
func (_TokenProvider *TokenProviderSession) GetUsersTempInfo(_url string) (common.Address, [32]byte, []byte, error) {
	return _TokenProvider.Contract.GetUsersTempInfo(&_TokenProvider.CallOpts, _url)
}

// GetUsersTempInfo is a free data retrieval call binding the contract method 0xa64a7f52.
//
// Solidity: function getUsersTempInfo(string _url) constant returns(address, bytes32, bytes)
func (_TokenProvider *TokenProviderCallerSession) GetUsersTempInfo(_url string) (common.Address, [32]byte, []byte, error) {
	return _TokenProvider.Contract.GetUsersTempInfo(&_TokenProvider.CallOpts, _url)
}

// MasterDappbox is a free data retrieval call binding the contract method 0x590cf88b.
//
// Solidity: function masterDappbox() constant returns(address)
func (_TokenProvider *TokenProviderCaller) MasterDappbox(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _TokenProvider.contract.Call(opts, out, "masterDappbox")
	return *ret0, err
}

// MasterDappbox is a free data retrieval call binding the contract method 0x590cf88b.
//
// Solidity: function masterDappbox() constant returns(address)
func (_TokenProvider *TokenProviderSession) MasterDappbox() (common.Address, error) {
	return _TokenProvider.Contract.MasterDappbox(&_TokenProvider.CallOpts)
}

// MasterDappbox is a free data retrieval call binding the contract method 0x590cf88b.
//
// Solidity: function masterDappbox() constant returns(address)
func (_TokenProvider *TokenProviderCallerSession) MasterDappbox() (common.Address, error) {
	return _TokenProvider.Contract.MasterDappbox(&_TokenProvider.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() constant returns(address)
func (_TokenProvider *TokenProviderCaller) Owner(opts *bind.CallOpts) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _TokenProvider.contract.Call(opts, out, "owner")
	return *ret0, err
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() constant returns(address)
func (_TokenProvider *TokenProviderSession) Owner() (common.Address, error) {
	return _TokenProvider.Contract.Owner(&_TokenProvider.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() constant returns(address)
func (_TokenProvider *TokenProviderCallerSession) Owner() (common.Address, error) {
	return _TokenProvider.Contract.Owner(&_TokenProvider.CallOpts)
}

// AddDeviceTempAccountInfo is a paid mutator transaction binding the contract method 0x16241ae0.
//
// Solidity: function addDeviceTempAccountInfo(string _url, address _address, bytes32 _rawhash, bytes _signedMesaage) returns()
func (_TokenProvider *TokenProviderTransactor) AddDeviceTempAccountInfo(opts *bind.TransactOpts, _url string, _address common.Address, _rawhash [32]byte, _signedMesaage []byte) (*types.Transaction, error) {
	return _TokenProvider.contract.Transact(opts, "addDeviceTempAccountInfo", _url, _address, _rawhash, _signedMesaage)
}

// AddDeviceTempAccountInfo is a paid mutator transaction binding the contract method 0x16241ae0.
//
// Solidity: function addDeviceTempAccountInfo(string _url, address _address, bytes32 _rawhash, bytes _signedMesaage) returns()
func (_TokenProvider *TokenProviderSession) AddDeviceTempAccountInfo(_url string, _address common.Address, _rawhash [32]byte, _signedMesaage []byte) (*types.Transaction, error) {
	return _TokenProvider.Contract.AddDeviceTempAccountInfo(&_TokenProvider.TransactOpts, _url, _address, _rawhash, _signedMesaage)
}

// AddDeviceTempAccountInfo is a paid mutator transaction binding the contract method 0x16241ae0.
//
// Solidity: function addDeviceTempAccountInfo(string _url, address _address, bytes32 _rawhash, bytes _signedMesaage) returns()
func (_TokenProvider *TokenProviderTransactorSession) AddDeviceTempAccountInfo(_url string, _address common.Address, _rawhash [32]byte, _signedMesaage []byte) (*types.Transaction, error) {
	return _TokenProvider.Contract.AddDeviceTempAccountInfo(&_TokenProvider.TransactOpts, _url, _address, _rawhash, _signedMesaage)
}

// AddOrChangeMasterDappboxAddress is a paid mutator transaction binding the contract method 0x56f27fa1.
//
// Solidity: function addOrChangeMasterDappboxAddress(address dAppBoxAddress) returns(bool)
func (_TokenProvider *TokenProviderTransactor) AddOrChangeMasterDappboxAddress(opts *bind.TransactOpts, dAppBoxAddress common.Address) (*types.Transaction, error) {
	return _TokenProvider.contract.Transact(opts, "addOrChangeMasterDappboxAddress", dAppBoxAddress)
}

// AddOrChangeMasterDappboxAddress is a paid mutator transaction binding the contract method 0x56f27fa1.
//
// Solidity: function addOrChangeMasterDappboxAddress(address dAppBoxAddress) returns(bool)
func (_TokenProvider *TokenProviderSession) AddOrChangeMasterDappboxAddress(dAppBoxAddress common.Address) (*types.Transaction, error) {
	return _TokenProvider.Contract.AddOrChangeMasterDappboxAddress(&_TokenProvider.TransactOpts, dAppBoxAddress)
}

// AddOrChangeMasterDappboxAddress is a paid mutator transaction binding the contract method 0x56f27fa1.
//
// Solidity: function addOrChangeMasterDappboxAddress(address dAppBoxAddress) returns(bool)
func (_TokenProvider *TokenProviderTransactorSession) AddOrChangeMasterDappboxAddress(dAppBoxAddress common.Address) (*types.Transaction, error) {
	return _TokenProvider.Contract.AddOrChangeMasterDappboxAddress(&_TokenProvider.TransactOpts, dAppBoxAddress)
}

// SendToken is a paid mutator transaction binding the contract method 0x9c4bd505.
//
// Solidity: function sendToken(string url, address reciever) returns(bool)
func (_TokenProvider *TokenProviderTransactor) SendToken(opts *bind.TransactOpts, url string, reciever common.Address) (*types.Transaction, error) {
	return _TokenProvider.contract.Transact(opts, "sendToken", url, reciever)
}

// SendToken is a paid mutator transaction binding the contract method 0x9c4bd505.
//
// Solidity: function sendToken(string url, address reciever) returns(bool)
func (_TokenProvider *TokenProviderSession) SendToken(url string, reciever common.Address) (*types.Transaction, error) {
	return _TokenProvider.Contract.SendToken(&_TokenProvider.TransactOpts, url, reciever)
}

// SendToken is a paid mutator transaction binding the contract method 0x9c4bd505.
//
// Solidity: function sendToken(string url, address reciever) returns(bool)
func (_TokenProvider *TokenProviderTransactorSession) SendToken(url string, reciever common.Address) (*types.Transaction, error) {
	return _TokenProvider.Contract.SendToken(&_TokenProvider.TransactOpts, url, reciever)
}

// SetDappboxPermanentAddress is a paid mutator transaction binding the contract method 0x1b078be3.
//
// Solidity: function setDappboxPermanentAddress(string url, address userAddresss) returns(bool)
func (_TokenProvider *TokenProviderTransactor) SetDappboxPermanentAddress(opts *bind.TransactOpts, url string, userAddresss common.Address) (*types.Transaction, error) {
	return _TokenProvider.contract.Transact(opts, "setDappboxPermanentAddress", url, userAddresss)
}

// SetDappboxPermanentAddress is a paid mutator transaction binding the contract method 0x1b078be3.
//
// Solidity: function setDappboxPermanentAddress(string url, address userAddresss) returns(bool)
func (_TokenProvider *TokenProviderSession) SetDappboxPermanentAddress(url string, userAddresss common.Address) (*types.Transaction, error) {
	return _TokenProvider.Contract.SetDappboxPermanentAddress(&_TokenProvider.TransactOpts, url, userAddresss)
}

// SetDappboxPermanentAddress is a paid mutator transaction binding the contract method 0x1b078be3.
//
// Solidity: function setDappboxPermanentAddress(string url, address userAddresss) returns(bool)
func (_TokenProvider *TokenProviderTransactorSession) SetDappboxPermanentAddress(url string, userAddresss common.Address) (*types.Transaction, error) {
	return _TokenProvider.Contract.SetDappboxPermanentAddress(&_TokenProvider.TransactOpts, url, userAddresss)
}

// VerifyAndSend is a paid mutator transaction binding the contract method 0x27b3318d.
//
// Solidity: function verifyAndSend(string _url) returns(bool)
func (_TokenProvider *TokenProviderTransactor) VerifyAndSend(opts *bind.TransactOpts, _url string) (*types.Transaction, error) {
	return _TokenProvider.contract.Transact(opts, "verifyAndSend", _url)
}

// VerifyAndSend is a paid mutator transaction binding the contract method 0x27b3318d.
//
// Solidity: function verifyAndSend(string _url) returns(bool)
func (_TokenProvider *TokenProviderSession) VerifyAndSend(_url string) (*types.Transaction, error) {
	return _TokenProvider.Contract.VerifyAndSend(&_TokenProvider.TransactOpts, _url)
}

// VerifyAndSend is a paid mutator transaction binding the contract method 0x27b3318d.
//
// Solidity: function verifyAndSend(string _url) returns(bool)
func (_TokenProvider *TokenProviderTransactorSession) VerifyAndSend(_url string) (*types.Transaction, error) {
	return _TokenProvider.Contract.VerifyAndSend(&_TokenProvider.TransactOpts, _url)
}
