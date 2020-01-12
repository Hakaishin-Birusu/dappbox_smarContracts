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

// RelationManagerABI is the input ABI used to generate the binding from.
const RelationManagerABI = "[{\"constant\":false,\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_name\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"_parent\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"_data\",\"type\":\"bytes32\"}],\"name\":\"add\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_name\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"_parent\",\"type\":\"bytes32\"}],\"name\":\"get\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32[]\",\"name\":\"\",\"type\":\"bytes32[]\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_name\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"_parent\",\"type\":\"bytes32\"}],\"name\":\"remove\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"_name\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"_parent\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"_data\",\"type\":\"bytes32\"}],\"name\":\"update\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"

// RelationManagerFuncSigs maps the 4-byte function signature to its string representation.
var RelationManagerFuncSigs = map[string]string{
	"42de838d": "add(bytes32,bytes32,bytes32)",
	"658cc1f6": "get(bytes32,bytes32)",
	"b10e4172": "remove(bytes32,bytes32)",
	"9c0d2525": "update(bytes32,bytes32,bytes32)",
}

// RelationManagerBin is the compiled bytecode used for deploying new contracts.
var RelationManagerBin = "0x608060405234801561001057600080fd5b506105b9806100206000396000f3fe608060405234801561001057600080fd5b506004361061004c5760003560e01c806342de838d14610051578063658cc1f61461007c5780639c0d252514610108578063b10e417214610131575b600080fd5b61007a6004803603606081101561006757600080fd5b5080359060208101359060400135610154565b005b61009f6004803603604081101561009257600080fd5b508035906020013561020b565b6040518085815260200184815260200183815260200180602001828103825283818151815260200191508051906020019060200280838360005b838110156100f15781810151838201526020016100d9565b505050509050019550505050505060405180910390f35b61007a6004803603606081101561011e57600080fd5b50803590602081013590604001356102cd565b61007a6004803603604081101561014757600080fd5b508035906020013561030c565b6040805160208082018590528183018690528251808303840181526060830180855281519183019190912060e0840185528782526080840187815260a0850187815286516000808252818701895260c090970190815283875286865296909520835181559051600182015593516002850155935180519193926101df926003850192909101906104ac565b505050600092835260208381526040842060030180546001810182559085529320909201919091555050565b60008060006060600080600087896040516020018083815260200182815260200192505050604051602081830303815290604052805190602001208152602001908152602001600020905080600001548160010154826002015483600301808054806020026020016040519081016040528092919081815260200182805480156102b457602002820191906000526020600020905b8154815260200190600101908083116102a0575b5050505050905094509450945094505092959194509250565b60408051602080820194909452808201949094528051808503820181526060909401815283519383019390932060009081529182905291902060020155565b60408051602080820184905281830185905282518083038401815260609092018352815191810191909120600081815291829052919020600301541561035157600080fd5b600081815260208190526040812081815560018101829055600281018290559061037e60038301826104f7565b505060008281526020818152604080832060030180548251818502810185019093528083529093926103e7929185918301828280156103dc57602002820191906000526020600020905b8154815260200190600101908083116103c8575b505050505084610466565b90505b8154600019018110156104315781816001018154811061040657fe5b906000526020600020015482828154811061041d57fe5b6000918252602090912001556001016103ea565b5080548190600019810190811061044457fe5b6000918252602082200155805461045f826000198301610518565b5050505050565b6000805b835181101561049d5783818151811061047f57fe5b60200260200101518314156104955790506104a6565b60010161046a565b50508151600019015b92915050565b8280548282559060005260206000209081019282156104e7579160200282015b828111156104e75782518255916020019190600101906104cc565b506104f3929150610541565b5090565b50805460008255906000526020600020908101906105159190610541565b50565b81548183558181111561053c5760008381526020902061053c918101908301610541565b505050565b61055b91905b808211156104f35760008155600101610547565b9056fea265627a7a72315820d5bb0e0040e33bb22d0257909cbc0d6ed5d27014d82aa68f7416b20bba493a5b64736f6c637828302e352e31332d646576656c6f702e323031392e31312e312b636f6d6d69742e38373830663264350058"

// DeployRelationManager deploys a new Ethereum contract, binding an instance of RelationManager to it.
func DeployRelationManager(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.Transaction, *RelationManager, error) {
	parsed, err := abi.JSON(strings.NewReader(RelationManagerABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}

	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(RelationManagerBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &RelationManager{RelationManagerCaller: RelationManagerCaller{contract: contract}, RelationManagerTransactor: RelationManagerTransactor{contract: contract}, RelationManagerFilterer: RelationManagerFilterer{contract: contract}}, nil
}

// RelationManager is an auto generated Go binding around an Ethereum contract.
type RelationManager struct {
	RelationManagerCaller     // Read-only binding to the contract
	RelationManagerTransactor // Write-only binding to the contract
	RelationManagerFilterer   // Log filterer for contract events
}

// RelationManagerCaller is an auto generated read-only Go binding around an Ethereum contract.
type RelationManagerCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// RelationManagerTransactor is an auto generated write-only Go binding around an Ethereum contract.
type RelationManagerTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// RelationManagerFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type RelationManagerFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// RelationManagerSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type RelationManagerSession struct {
	Contract     *RelationManager  // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// RelationManagerCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type RelationManagerCallerSession struct {
	Contract *RelationManagerCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts          // Call options to use throughout this session
}

// RelationManagerTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type RelationManagerTransactorSession struct {
	Contract     *RelationManagerTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts          // Transaction auth options to use throughout this session
}

// RelationManagerRaw is an auto generated low-level Go binding around an Ethereum contract.
type RelationManagerRaw struct {
	Contract *RelationManager // Generic contract binding to access the raw methods on
}

// RelationManagerCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type RelationManagerCallerRaw struct {
	Contract *RelationManagerCaller // Generic read-only contract binding to access the raw methods on
}

// RelationManagerTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type RelationManagerTransactorRaw struct {
	Contract *RelationManagerTransactor // Generic write-only contract binding to access the raw methods on
}

// NewRelationManager creates a new instance of RelationManager, bound to a specific deployed contract.
func NewRelationManager(address common.Address, backend bind.ContractBackend) (*RelationManager, error) {
	contract, err := bindRelationManager(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &RelationManager{RelationManagerCaller: RelationManagerCaller{contract: contract}, RelationManagerTransactor: RelationManagerTransactor{contract: contract}, RelationManagerFilterer: RelationManagerFilterer{contract: contract}}, nil
}

// NewRelationManagerCaller creates a new read-only instance of RelationManager, bound to a specific deployed contract.
func NewRelationManagerCaller(address common.Address, caller bind.ContractCaller) (*RelationManagerCaller, error) {
	contract, err := bindRelationManager(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &RelationManagerCaller{contract: contract}, nil
}

// NewRelationManagerTransactor creates a new write-only instance of RelationManager, bound to a specific deployed contract.
func NewRelationManagerTransactor(address common.Address, transactor bind.ContractTransactor) (*RelationManagerTransactor, error) {
	contract, err := bindRelationManager(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &RelationManagerTransactor{contract: contract}, nil
}

// NewRelationManagerFilterer creates a new log filterer instance of RelationManager, bound to a specific deployed contract.
func NewRelationManagerFilterer(address common.Address, filterer bind.ContractFilterer) (*RelationManagerFilterer, error) {
	contract, err := bindRelationManager(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &RelationManagerFilterer{contract: contract}, nil
}

// bindRelationManager binds a generic wrapper to an already deployed contract.
func bindRelationManager(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(RelationManagerABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_RelationManager *RelationManagerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _RelationManager.Contract.RelationManagerCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_RelationManager *RelationManagerRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _RelationManager.Contract.RelationManagerTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_RelationManager *RelationManagerRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _RelationManager.Contract.RelationManagerTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_RelationManager *RelationManagerCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _RelationManager.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_RelationManager *RelationManagerTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _RelationManager.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_RelationManager *RelationManagerTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _RelationManager.Contract.contract.Transact(opts, method, params...)
}

// Get is a free data retrieval call binding the contract method 0x658cc1f6.
//
// Solidity: function get(bytes32 _name, bytes32 _parent) constant returns(bytes32, bytes32, bytes32, bytes32[])
func (_RelationManager *RelationManagerCaller) Get(opts *bind.CallOpts, _name [32]byte, _parent [32]byte) ([32]byte, [32]byte, [32]byte, [][32]byte, error) {
	var (
		ret0 = new([32]byte)
		ret1 = new([32]byte)
		ret2 = new([32]byte)
		ret3 = new([][32]byte)
	)
	out := &[]interface{}{
		ret0,
		ret1,
		ret2,
		ret3,
	}
	err := _RelationManager.contract.Call(opts, out, "get", _name, _parent)
	return *ret0, *ret1, *ret2, *ret3, err
}

// Get is a free data retrieval call binding the contract method 0x658cc1f6.
//
// Solidity: function get(bytes32 _name, bytes32 _parent) constant returns(bytes32, bytes32, bytes32, bytes32[])
func (_RelationManager *RelationManagerSession) Get(_name [32]byte, _parent [32]byte) ([32]byte, [32]byte, [32]byte, [][32]byte, error) {
	return _RelationManager.Contract.Get(&_RelationManager.CallOpts, _name, _parent)
}

// Get is a free data retrieval call binding the contract method 0x658cc1f6.
//
// Solidity: function get(bytes32 _name, bytes32 _parent) constant returns(bytes32, bytes32, bytes32, bytes32[])
func (_RelationManager *RelationManagerCallerSession) Get(_name [32]byte, _parent [32]byte) ([32]byte, [32]byte, [32]byte, [][32]byte, error) {
	return _RelationManager.Contract.Get(&_RelationManager.CallOpts, _name, _parent)
}

// Add is a paid mutator transaction binding the contract method 0x42de838d.
//
// Solidity: function add(bytes32 _name, bytes32 _parent, bytes32 _data) returns()
func (_RelationManager *RelationManagerTransactor) Add(opts *bind.TransactOpts, _name [32]byte, _parent [32]byte, _data [32]byte) (*types.Transaction, error) {
	return _RelationManager.contract.Transact(opts, "add", _name, _parent, _data)
}

// Add is a paid mutator transaction binding the contract method 0x42de838d.
//
// Solidity: function add(bytes32 _name, bytes32 _parent, bytes32 _data) returns()
func (_RelationManager *RelationManagerSession) Add(_name [32]byte, _parent [32]byte, _data [32]byte) (*types.Transaction, error) {
	return _RelationManager.Contract.Add(&_RelationManager.TransactOpts, _name, _parent, _data)
}

// Add is a paid mutator transaction binding the contract method 0x42de838d.
//
// Solidity: function add(bytes32 _name, bytes32 _parent, bytes32 _data) returns()
func (_RelationManager *RelationManagerTransactorSession) Add(_name [32]byte, _parent [32]byte, _data [32]byte) (*types.Transaction, error) {
	return _RelationManager.Contract.Add(&_RelationManager.TransactOpts, _name, _parent, _data)
}

// Remove is a paid mutator transaction binding the contract method 0xb10e4172.
//
// Solidity: function remove(bytes32 _name, bytes32 _parent) returns()
func (_RelationManager *RelationManagerTransactor) Remove(opts *bind.TransactOpts, _name [32]byte, _parent [32]byte) (*types.Transaction, error) {
	return _RelationManager.contract.Transact(opts, "remove", _name, _parent)
}

// Remove is a paid mutator transaction binding the contract method 0xb10e4172.
//
// Solidity: function remove(bytes32 _name, bytes32 _parent) returns()
func (_RelationManager *RelationManagerSession) Remove(_name [32]byte, _parent [32]byte) (*types.Transaction, error) {
	return _RelationManager.Contract.Remove(&_RelationManager.TransactOpts, _name, _parent)
}

// Remove is a paid mutator transaction binding the contract method 0xb10e4172.
//
// Solidity: function remove(bytes32 _name, bytes32 _parent) returns()
func (_RelationManager *RelationManagerTransactorSession) Remove(_name [32]byte, _parent [32]byte) (*types.Transaction, error) {
	return _RelationManager.Contract.Remove(&_RelationManager.TransactOpts, _name, _parent)
}

// Update is a paid mutator transaction binding the contract method 0x9c0d2525.
//
// Solidity: function update(bytes32 _name, bytes32 _parent, bytes32 _data) returns()
func (_RelationManager *RelationManagerTransactor) Update(opts *bind.TransactOpts, _name [32]byte, _parent [32]byte, _data [32]byte) (*types.Transaction, error) {
	return _RelationManager.contract.Transact(opts, "update", _name, _parent, _data)
}

// Update is a paid mutator transaction binding the contract method 0x9c0d2525.
//
// Solidity: function update(bytes32 _name, bytes32 _parent, bytes32 _data) returns()
func (_RelationManager *RelationManagerSession) Update(_name [32]byte, _parent [32]byte, _data [32]byte) (*types.Transaction, error) {
	return _RelationManager.Contract.Update(&_RelationManager.TransactOpts, _name, _parent, _data)
}

// Update is a paid mutator transaction binding the contract method 0x9c0d2525.
//
// Solidity: function update(bytes32 _name, bytes32 _parent, bytes32 _data) returns()
func (_RelationManager *RelationManagerTransactorSession) Update(_name [32]byte, _parent [32]byte, _data [32]byte) (*types.Transaction, error) {
	return _RelationManager.Contract.Update(&_RelationManager.TransactOpts, _name, _parent, _data)
}
