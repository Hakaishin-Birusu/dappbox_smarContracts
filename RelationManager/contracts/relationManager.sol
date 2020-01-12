pragma solidity  ^0.5.0;

contract relationManager {

struct Node {
 bytes32 name;     // name of node
 bytes32 parent;   // parent node’s path
 bytes32 data;     // node’s data
 bytes32[] nodes;  // list of linked nodes’ paths
}

mapping(bytes32 => Node) nodes;
function get(bytes32 _name, bytes32 _parent) public view returns (bytes32, bytes32, bytes32, bytes32[] memory ) {
    Node storage node = nodes[keccak256(abi.encodePacked(_parent, _name))];
    return (node.name, node.parent, node.data, node.nodes);
}
    
function add(bytes32 _name, bytes32 _parent, bytes32 _data) public {
    require(_name.length > 0);
    bytes32 path = keccak256(abi.encodePacked(_parent, _name));
    nodes[path] = Node({
        name: _name, 
        parent: _parent, 
        data: _data, 
        nodes: new bytes32[](0)
    });
    nodes[_parent].nodes.push(path);
}
function update(bytes32 _name, bytes32 _parent, bytes32 _data) public {
    bytes32 path = keccak256(abi.encodePacked(_parent, _name));
    Node storage node = nodes[path];
    node.data = _data;
}
function remove(bytes32 _name, bytes32 _parent) public {
    bytes32 path = keccak256(abi.encodePacked(_parent, _name));
    // allow to remove leaves (node without linked nodes)
    require(nodes[path].nodes.length == 0);
    // removes from nodes
    delete nodes[path];
    
    // removes from parent list of nodes
    bytes32[] storage childs = nodes[_parent].nodes;
    for (uint256 i = getIndex(childs, path); i < childs.length - 1; i++) {
        childs[i] = childs[i + 1];
    }
    delete childs[childs.length - 1];
    childs.length--;
}
function getIndex(bytes32[] memory childs, bytes32 _path) pure internal returns (uint256) {
    for (uint256 i = 0; i < childs.length; i++) {
        if (_path == childs[i]) {
            return i;
        }
    }
    return childs.length - 1;
}
}