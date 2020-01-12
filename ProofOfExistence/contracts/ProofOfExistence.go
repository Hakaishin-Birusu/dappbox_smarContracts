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

// ProofOfExistenceABI is the input ABI used to generate the binding from.
const ProofOfExistenceABI = "[{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"address\",\"name\":\"dappBoxOrigin\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"fileHash\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"filePathHash\",\"type\":\"string\"}],\"name\":\"GetFileExistenceProof\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"enumProofOfExistence.BlockchainIdentification\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"address\",\"name\":\"dappBoxOrigin\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"_fileHash\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"_filePathHash\",\"type\":\"string\"},{\"internalType\":\"address\",\"name\":\"_contractAddress\",\"type\":\"address\"},{\"internalType\":\"enumProofOfExistence.BlockchainIdentification\",\"name\":\"_identifier\",\"type\":\"uint8\"}],\"name\":\"SetFileExistenceProof\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"address\",\"name\":\"dappBoxOrigin\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"_fileHash\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"_filePathHash\",\"type\":\"string\"},{\"internalType\":\"address\",\"name\":\"_contractAddress\",\"type\":\"address\"},{\"internalType\":\"enumProofOfExistence.BlockchainIdentification\",\"name\":\"_identifier\",\"type\":\"uint8\"}],\"name\":\"addExistenceProofUpdate\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"address\",\"name\":\"dappBoxOrigin\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"fileHash\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"filePathHash\",\"type\":\"string\"}],\"name\":\"getQRCode\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"address\",\"name\":\"dappBoxOrigin\",\"type\":\"address\"},{\"internalType\":\"bytes32\",\"name\":\"QRCodeHash\",\"type\":\"bytes32\"}],\"name\":\"searchExistenceProoUsngQR\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"enumProofOfExistence.BlockchainIdentification\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]"

// ProofOfExistenceFuncSigs maps the 4-byte function signature to its string representation.
var ProofOfExistenceFuncSigs = map[string]string{
	"327b5e98": "GetFileExistenceProof(address,string,string)",
	"846d9491": "SetFileExistenceProof(address,string,string,address,uint8)",
	"eb93d30a": "addExistenceProofUpdate(address,string,string,address,uint8)",
	"7974bc5c": "getQRCode(address,string,string)",
	"3531b98b": "searchExistenceProoUsngQR(address,bytes32)",
}

// ProofOfExistenceBin is the compiled bytecode used for deploying new contracts.
var ProofOfExistenceBin = "0x608060405234801561001057600080fd5b5060008055611313806100246000396000f3fe608060405234801561001057600080fd5b50600436106100575760003560e01c8063327b5e981461005c5780633531b98b146101f95780637974bc5c14610225578063846d949114610370578063eb93d30a146104ba575b600080fd5b6101956004803603606081101561007257600080fd5b6001600160a01b038235169190810190604081016020820135600160201b81111561009c57600080fd5b8201836020820111156100ae57600080fd5b803590602001918460018302840111600160201b831117156100cf57600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295949360208101935035915050600160201b81111561012157600080fd5b82018360208201111561013357600080fd5b803590602001918460018302840111600160201b8311171561015457600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550610618945050505050565b60405180868152602001856001600160a01b03166001600160a01b03168152602001846001600160a01b03166001600160a01b031681526020018360028111156101db57fe5b60ff1681526020018281526020019550505050505060405180910390f35b6101956004803603604081101561020f57600080fd5b506001600160a01b038135169060200135610930565b61035e6004803603606081101561023b57600080fd5b6001600160a01b038235169190810190604081016020820135600160201b81111561026557600080fd5b82018360208201111561027757600080fd5b803590602001918460018302840111600160201b8311171561029857600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295949360208101935035915050600160201b8111156102ea57600080fd5b8201836020820111156102fc57600080fd5b803590602001918460018302840111600160201b8311171561031d57600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550610b0a945050505050565b60408051918252519081900360200190f35b61035e600480360360a081101561038657600080fd5b6001600160a01b038235169190810190604081016020820135600160201b8111156103b057600080fd5b8201836020820111156103c257600080fd5b803590602001918460018302840111600160201b831117156103e357600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295949360208101935035915050600160201b81111561043557600080fd5b82018360208201111561044757600080fd5b803590602001918460018302840111600160201b8311171561046857600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550505081356001600160a01b03169250506020013560ff16610c09565b610604600480360360a08110156104d057600080fd5b6001600160a01b038235169190810190604081016020820135600160201b8111156104fa57600080fd5b82018360208201111561050c57600080fd5b803590602001918460018302840111600160201b8311171561052d57600080fd5b91908080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920191909152509295949360208101935035915050600160201b81111561057f57600080fd5b82018360208201111561059157600080fd5b803590602001918460018302840111600160201b831117156105b257600080fd5b91908080601f016020809104026020016040519081016040528093929190818152602001838380828437600092019190915250929550505081356001600160a01b03169250506020013560ff16610d8a565b604080519115158252519081900360200190f35b6001600160a01b0383166000908152600160205260408120548190819081908190818082156109215760005b6001600160a01b038c1660009081526001602052604090205481101561091f576001600160a01b038c16600090815260016020526040812080548390811061068857fe5b906000526020600020015490506107598c6002600084815260200190815260200160002084815481106106b757fe5b600091825260209182902060026007909202018101805460408051601f60001961010060018616150201909316949094049182018590048502840185019052808352919290919083018282801561074f5780601f106107245761010080835404028352916020019161074f565b820191906000526020600020905b81548152906001019060200180831161073257829003601f168201915b5050505050610f95565b80156107eb5750600081815260026020526040902080546107eb918d918590811061078057fe5b6000918252602091829020600360079092020101805460408051601f600260001961010060018716150201909416939093049283018590048502810185019091528181529283018282801561074f5780601f106107245761010080835404028352916020019161074f565b925060018315151415610916578093506002600085815260200190815260200160002060008154811061081a57fe5b9060005260206000209060070201600001546002600086815260200190815260200160002060008154811061084b57fe5b600091825260208083206001600790930201919091015487835260029091526040822080546001600160a01b0390921692909161088457fe5b600091825260208083206004600790930201919091015488835260029091526040822080546001600160a01b039092169290916108bd57fe5b6000918252602080832060066007909302019190910154898352600290915260408220805460ff9092169290916108f057fe5b906000526020600020906007020160050154995099509950995099505050505050610925565b50600101610644565b505b5050505b939792965093509350565b6001600160a01b0382166000908152600160205260408120548190819081908190815b81811015610afd576001600160a01b038916600090815260016020526040812080548390811061097f57fe5b906000526020600020015490506002600082815260200190815260200160002082815481106109aa57fe5b906000526020600020906007020160050154891415610af45760008181526002602052604090208054839081106109dd57fe5b906000526020600020906007020160000154600260008381526020019081526020016000208381548110610a0d57fe5b906000526020600020906007020160010160009054906101000a90046001600160a01b0316600260008481526020019081526020016000208481548110610a5057fe5b906000526020600020906007020160040160009054906101000a90046001600160a01b0316600260008581526020019081526020016000208581548110610a9357fe5b906000526020600020906007020160060160009054906101000a900460ff16600260008681526020019081526020016000208681548110610ad057fe5b90600052602060002090600702016005015497509750975097509750505050610b00565b50600101610953565b50505b9295509295909350565b6001600160a01b0383166000908152600160205260408120548015610c005760005b81811015610bfe576001600160a01b0386166000908152600160205260408120805483908110610b5857fe5b906000526020600020015490506000610b89876002600085815260200190815260200160002085815481106106b757fe5b8015610bb0575060008281526002602052604090208054610bb09188918690811061078057fe5b905060018115151415610bf4576000828152600260205260409020805484908110610bd757fe5b906000526020600020906007020160050154945050505050610c02565b5050600101610b2c565b505b505b9392505050565b6000610c136111e1565b426000610c2389898989896110c4565b8284526001600160a01b03808b166020860152604085018a90526060850189905287166080850152905060c08301856002811115610c5d57fe5b90816002811115610c6a57fe5b90525060a083018190526001600160a01b038981166000908152600160208181526040808420845481548086018355918652838620909101558354845260028083528185208054808601808355918752958490208a51600790970201958655838a015194860180546001600160a01b031916959097169490941790955587015180519294889493610d0293918501929091019061121d565b5060608201518051610d1e91600384019160209091019061121d565b5060808201516004820180546001600160a01b0319166001600160a01b0390921691909117905560a0820151600582015560c082015160068201805460ff19166001836002811115610d6c57fe5b02179055505060008054600101905550909998505050505050505050565b600080805b6001600160a01b038816600090815260016020526040902054811015610f8a576001600160a01b0388166000908152600160205260408120805483908110610dd357fe5b90600052602060002001549050610e02886002600084815260200190815260200160002084815481106106b757fe5b8015610e29575060008181526002602052604090208054610e299189918590811061078057fe5b925060018315151415610f8157610e3e6111e1565b6000610e4d8b8b8b8b8b6110c4565b4283526001600160a01b03808d166020850152604084018c9052606084018b905289166080840152905060c08201876002811115610e8757fe5b90816002811115610e9457fe5b90525060a08201819052600080548152600260208181526040808420805460018082018084559287529584902088516007909202019081558388015195810180546001600160a01b0319166001600160a01b0390971696909617909555908601518051919487949093610f0c9391850192019061121d565b5060608201518051610f2891600384019160209091019061121d565b5060808201516004820180546001600160a01b0319166001600160a01b0390921691909117905560a0820151600582015560c082015160068201805460ff19166001836002811115610f7657fe5b021790555050505050505b50600101610d8f565b509695505050505050565b60008151835114610fa8575060006110be565b816040516020018080602001828103825283818151815260200191508051906020019080838360005b83811015610fe9578181015183820152602001610fd1565b50505050905090810190601f1680156110165780820380516001836020036101000a031916815260200191505b509250505060405160208183030381529060405280519060200120836040516020018080602001828103825283818151815260200191508051906020019080838360005b8381101561107257818101518382015260200161105a565b50505050905090810190601f16801561109f5780820380516001836020036101000a031916815260200191505b5092505050604051602081830303815290604052805190602001201490505b92915050565b600080868686868660405160200180866001600160a01b03166001600160a01b031660601b815260140185805190602001908083835b602083106111195780518252601f1990920191602091820191016110fa565b51815160209384036101000a600019018019909216911617905287519190930192870191508083835b602083106111615780518252601f199092019160209182019101611142565b6001836020036101000a038019825116818451168082178552505050505050905001836001600160a01b03166001600160a01b031660601b81526014018260028111156111aa57fe5b60ff1660f81b8152600101955050505050506040516020818303038152906040528051906020012090508091505095945050505050565b6040805160e0810182526000808252602082018190526060928201839052828201929092526080810182905260a081018290529060c082015290565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061125e57805160ff191683800117855561128b565b8280016001018555821561128b579182015b8281111561128b578251825591602001919060010190611270565b5061129792915061129b565b5090565b6112b591905b8082111561129757600081556001016112a1565b9056fea265627a7a723158209d5d74b6680b3e45baa7cc114aab896caf209d038674c3b40a6ff7d337498e5964736f6c637828302e352e31332d646576656c6f702e323031392e31312e312b636f6d6d69742e31626432623230320058"

// DeployProofOfExistence deploys a new Ethereum contract, binding an instance of ProofOfExistence to it.
func DeployProofOfExistence(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *ProofOfExistence, error) {
	parsed, err := abi.JSON(strings.NewReader(ProofOfExistenceABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}

	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(ProofOfExistenceBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &ProofOfExistence{ProofOfExistenceCaller: ProofOfExistenceCaller{contract: contract}, ProofOfExistenceTransactor: ProofOfExistenceTransactor{contract: contract}, ProofOfExistenceFilterer: ProofOfExistenceFilterer{contract: contract}}, nil
}

// ProofOfExistence is an auto generated Go binding around an Ethereum contract.
type ProofOfExistence struct {
	ProofOfExistenceCaller     // Read-only binding to the contract
	ProofOfExistenceTransactor // Write-only binding to the contract
	ProofOfExistenceFilterer   // Log filterer for contract events
}

// ProofOfExistenceCaller is an auto generated read-only Go binding around an Ethereum contract.
type ProofOfExistenceCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ProofOfExistenceTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ProofOfExistenceTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ProofOfExistenceFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ProofOfExistenceFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ProofOfExistenceSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ProofOfExistenceSession struct {
	Contract     *ProofOfExistence // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ProofOfExistenceCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ProofOfExistenceCallerSession struct {
	Contract *ProofOfExistenceCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts           // Call options to use throughout this session
}

// ProofOfExistenceTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ProofOfExistenceTransactorSession struct {
	Contract     *ProofOfExistenceTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts           // Transaction auth options to use throughout this session
}

// ProofOfExistenceRaw is an auto generated low-level Go binding around an Ethereum contract.
type ProofOfExistenceRaw struct {
	Contract *ProofOfExistence // Generic contract binding to access the raw methods on
}

// ProofOfExistenceCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ProofOfExistenceCallerRaw struct {
	Contract *ProofOfExistenceCaller // Generic read-only contract binding to access the raw methods on
}

// ProofOfExistenceTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ProofOfExistenceTransactorRaw struct {
	Contract *ProofOfExistenceTransactor // Generic write-only contract binding to access the raw methods on
}

// NewProofOfExistence creates a new instance of ProofOfExistence, bound to a specific deployed contract.
func NewProofOfExistence(address common.Address, backend bind.ContractBackend) (*ProofOfExistence, error) {
	contract, err := bindProofOfExistence(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &ProofOfExistence{ProofOfExistenceCaller: ProofOfExistenceCaller{contract: contract}, ProofOfExistenceTransactor: ProofOfExistenceTransactor{contract: contract}, ProofOfExistenceFilterer: ProofOfExistenceFilterer{contract: contract}}, nil
}

// NewProofOfExistenceCaller creates a new read-only instance of ProofOfExistence, bound to a specific deployed contract.
func NewProofOfExistenceCaller(address common.Address, caller bind.ContractCaller) (*ProofOfExistenceCaller, error) {
	contract, err := bindProofOfExistence(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ProofOfExistenceCaller{contract: contract}, nil
}

// NewProofOfExistenceTransactor creates a new write-only instance of ProofOfExistence, bound to a specific deployed contract.
func NewProofOfExistenceTransactor(address common.Address, transactor bind.ContractTransactor) (*ProofOfExistenceTransactor, error) {
	contract, err := bindProofOfExistence(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ProofOfExistenceTransactor{contract: contract}, nil
}

// NewProofOfExistenceFilterer creates a new log filterer instance of ProofOfExistence, bound to a specific deployed contract.
func NewProofOfExistenceFilterer(address common.Address, filterer bind.ContractFilterer) (*ProofOfExistenceFilterer, error) {
	contract, err := bindProofOfExistence(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ProofOfExistenceFilterer{contract: contract}, nil
}

// bindProofOfExistence binds a generic wrapper to an already deployed contract.
func bindProofOfExistence(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(ProofOfExistenceABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ProofOfExistence *ProofOfExistenceRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _ProofOfExistence.Contract.ProofOfExistenceCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ProofOfExistence *ProofOfExistenceRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.ProofOfExistenceTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ProofOfExistence *ProofOfExistenceRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.ProofOfExistenceTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_ProofOfExistence *ProofOfExistenceCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _ProofOfExistence.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_ProofOfExistence *ProofOfExistenceTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_ProofOfExistence *ProofOfExistenceTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.contract.Transact(opts, method, params...)
}

// GetFileExistenceProof is a free data retrieval call binding the contract method 0x327b5e98.
//
// Solidity: function GetFileExistenceProof(address dappBoxOrigin, string fileHash, string filePathHash) constant returns(uint256, address, address, uint8, bytes32)
func (_ProofOfExistence *ProofOfExistenceCaller) GetFileExistenceProof(opts *bind.CallOpts, dappBoxOrigin common.Address, fileHash string, filePathHash string) (*big.Int, common.Address, common.Address, uint8, [32]byte, error) {
	var (
		ret0 = new(*big.Int)
		ret1 = new(common.Address)
		ret2 = new(common.Address)
		ret3 = new(uint8)
		ret4 = new([32]byte)
	)
	out := &[]interface{}{
		ret0,
		ret1,
		ret2,
		ret3,
		ret4,
	}
	err := _ProofOfExistence.contract.Call(opts, out, "GetFileExistenceProof", dappBoxOrigin, fileHash, filePathHash)
	return *ret0, *ret1, *ret2, *ret3, *ret4, err
}

// GetFileExistenceProof is a free data retrieval call binding the contract method 0x327b5e98.
//
// Solidity: function GetFileExistenceProof(address dappBoxOrigin, string fileHash, string filePathHash) constant returns(uint256, address, address, uint8, bytes32)
func (_ProofOfExistence *ProofOfExistenceSession) GetFileExistenceProof(dappBoxOrigin common.Address, fileHash string, filePathHash string) (*big.Int, common.Address, common.Address, uint8, [32]byte, error) {
	return _ProofOfExistence.Contract.GetFileExistenceProof(&_ProofOfExistence.CallOpts, dappBoxOrigin, fileHash, filePathHash)
}

// GetFileExistenceProof is a free data retrieval call binding the contract method 0x327b5e98.
//
// Solidity: function GetFileExistenceProof(address dappBoxOrigin, string fileHash, string filePathHash) constant returns(uint256, address, address, uint8, bytes32)
func (_ProofOfExistence *ProofOfExistenceCallerSession) GetFileExistenceProof(dappBoxOrigin common.Address, fileHash string, filePathHash string) (*big.Int, common.Address, common.Address, uint8, [32]byte, error) {
	return _ProofOfExistence.Contract.GetFileExistenceProof(&_ProofOfExistence.CallOpts, dappBoxOrigin, fileHash, filePathHash)
}

// GetQRCode is a free data retrieval call binding the contract method 0x7974bc5c.
//
// Solidity: function getQRCode(address dappBoxOrigin, string fileHash, string filePathHash) constant returns(bytes32)
func (_ProofOfExistence *ProofOfExistenceCaller) GetQRCode(opts *bind.CallOpts, dappBoxOrigin common.Address, fileHash string, filePathHash string) ([32]byte, error) {
	var (
		ret0 = new([32]byte)
	)
	out := ret0
	err := _ProofOfExistence.contract.Call(opts, out, "getQRCode", dappBoxOrigin, fileHash, filePathHash)
	return *ret0, err
}

// GetQRCode is a free data retrieval call binding the contract method 0x7974bc5c.
//
// Solidity: function getQRCode(address dappBoxOrigin, string fileHash, string filePathHash) constant returns(bytes32)
func (_ProofOfExistence *ProofOfExistenceSession) GetQRCode(dappBoxOrigin common.Address, fileHash string, filePathHash string) ([32]byte, error) {
	return _ProofOfExistence.Contract.GetQRCode(&_ProofOfExistence.CallOpts, dappBoxOrigin, fileHash, filePathHash)
}

// GetQRCode is a free data retrieval call binding the contract method 0x7974bc5c.
//
// Solidity: function getQRCode(address dappBoxOrigin, string fileHash, string filePathHash) constant returns(bytes32)
func (_ProofOfExistence *ProofOfExistenceCallerSession) GetQRCode(dappBoxOrigin common.Address, fileHash string, filePathHash string) ([32]byte, error) {
	return _ProofOfExistence.Contract.GetQRCode(&_ProofOfExistence.CallOpts, dappBoxOrigin, fileHash, filePathHash)
}

// SearchExistenceProoUsngQR is a free data retrieval call binding the contract method 0x3531b98b.
//
// Solidity: function searchExistenceProoUsngQR(address dappBoxOrigin, bytes32 QRCodeHash) constant returns(uint256, address, address, uint8, bytes32)
func (_ProofOfExistence *ProofOfExistenceCaller) SearchExistenceProoUsngQR(opts *bind.CallOpts, dappBoxOrigin common.Address, QRCodeHash [32]byte) (*big.Int, common.Address, common.Address, uint8, [32]byte, error) {
	var (
		ret0 = new(*big.Int)
		ret1 = new(common.Address)
		ret2 = new(common.Address)
		ret3 = new(uint8)
		ret4 = new([32]byte)
	)
	out := &[]interface{}{
		ret0,
		ret1,
		ret2,
		ret3,
		ret4,
	}
	err := _ProofOfExistence.contract.Call(opts, out, "searchExistenceProoUsngQR", dappBoxOrigin, QRCodeHash)
	return *ret0, *ret1, *ret2, *ret3, *ret4, err
}

// SearchExistenceProoUsngQR is a free data retrieval call binding the contract method 0x3531b98b.
//
// Solidity: function searchExistenceProoUsngQR(address dappBoxOrigin, bytes32 QRCodeHash) constant returns(uint256, address, address, uint8, bytes32)
func (_ProofOfExistence *ProofOfExistenceSession) SearchExistenceProoUsngQR(dappBoxOrigin common.Address, QRCodeHash [32]byte) (*big.Int, common.Address, common.Address, uint8, [32]byte, error) {
	return _ProofOfExistence.Contract.SearchExistenceProoUsngQR(&_ProofOfExistence.CallOpts, dappBoxOrigin, QRCodeHash)
}

// SearchExistenceProoUsngQR is a free data retrieval call binding the contract method 0x3531b98b.
//
// Solidity: function searchExistenceProoUsngQR(address dappBoxOrigin, bytes32 QRCodeHash) constant returns(uint256, address, address, uint8, bytes32)
func (_ProofOfExistence *ProofOfExistenceCallerSession) SearchExistenceProoUsngQR(dappBoxOrigin common.Address, QRCodeHash [32]byte) (*big.Int, common.Address, common.Address, uint8, [32]byte, error) {
	return _ProofOfExistence.Contract.SearchExistenceProoUsngQR(&_ProofOfExistence.CallOpts, dappBoxOrigin, QRCodeHash)
}

// SetFileExistenceProof is a paid mutator transaction binding the contract method 0x846d9491.
//
// Solidity: function SetFileExistenceProof(address dappBoxOrigin, string _fileHash, string _filePathHash, address _contractAddress, uint8 _identifier) returns(bytes32)
func (_ProofOfExistence *ProofOfExistenceTransactor) SetFileExistenceProof(opts *bind.TransactOpts, dappBoxOrigin common.Address, _fileHash string, _filePathHash string, _contractAddress common.Address, _identifier uint8) (*types.Transaction, error) {
	return _ProofOfExistence.contract.Transact(opts, "SetFileExistenceProof", dappBoxOrigin, _fileHash, _filePathHash, _contractAddress, _identifier)
}

// SetFileExistenceProof is a paid mutator transaction binding the contract method 0x846d9491.
//
// Solidity: function SetFileExistenceProof(address dappBoxOrigin, string _fileHash, string _filePathHash, address _contractAddress, uint8 _identifier) returns(bytes32)
func (_ProofOfExistence *ProofOfExistenceSession) SetFileExistenceProof(dappBoxOrigin common.Address, _fileHash string, _filePathHash string, _contractAddress common.Address, _identifier uint8) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.SetFileExistenceProof(&_ProofOfExistence.TransactOpts, dappBoxOrigin, _fileHash, _filePathHash, _contractAddress, _identifier)
}

// SetFileExistenceProof is a paid mutator transaction binding the contract method 0x846d9491.
//
// Solidity: function SetFileExistenceProof(address dappBoxOrigin, string _fileHash, string _filePathHash, address _contractAddress, uint8 _identifier) returns(bytes32)
func (_ProofOfExistence *ProofOfExistenceTransactorSession) SetFileExistenceProof(dappBoxOrigin common.Address, _fileHash string, _filePathHash string, _contractAddress common.Address, _identifier uint8) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.SetFileExistenceProof(&_ProofOfExistence.TransactOpts, dappBoxOrigin, _fileHash, _filePathHash, _contractAddress, _identifier)
}

// AddExistenceProofUpdate is a paid mutator transaction binding the contract method 0xeb93d30a.
//
// Solidity: function addExistenceProofUpdate(address dappBoxOrigin, string _fileHash, string _filePathHash, address _contractAddress, uint8 _identifier) returns(bool)
func (_ProofOfExistence *ProofOfExistenceTransactor) AddExistenceProofUpdate(opts *bind.TransactOpts, dappBoxOrigin common.Address, _fileHash string, _filePathHash string, _contractAddress common.Address, _identifier uint8) (*types.Transaction, error) {
	return _ProofOfExistence.contract.Transact(opts, "addExistenceProofUpdate", dappBoxOrigin, _fileHash, _filePathHash, _contractAddress, _identifier)
}

// AddExistenceProofUpdate is a paid mutator transaction binding the contract method 0xeb93d30a.
//
// Solidity: function addExistenceProofUpdate(address dappBoxOrigin, string _fileHash, string _filePathHash, address _contractAddress, uint8 _identifier) returns(bool)
func (_ProofOfExistence *ProofOfExistenceSession) AddExistenceProofUpdate(dappBoxOrigin common.Address, _fileHash string, _filePathHash string, _contractAddress common.Address, _identifier uint8) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.AddExistenceProofUpdate(&_ProofOfExistence.TransactOpts, dappBoxOrigin, _fileHash, _filePathHash, _contractAddress, _identifier)
}

// AddExistenceProofUpdate is a paid mutator transaction binding the contract method 0xeb93d30a.
//
// Solidity: function addExistenceProofUpdate(address dappBoxOrigin, string _fileHash, string _filePathHash, address _contractAddress, uint8 _identifier) returns(bool)
func (_ProofOfExistence *ProofOfExistenceTransactorSession) AddExistenceProofUpdate(dappBoxOrigin common.Address, _fileHash string, _filePathHash string, _contractAddress common.Address, _identifier uint8) (*types.Transaction, error) {
	return _ProofOfExistence.Contract.AddExistenceProofUpdate(&_ProofOfExistence.TransactOpts, dappBoxOrigin, _fileHash, _filePathHash, _contractAddress, _identifier)
}
