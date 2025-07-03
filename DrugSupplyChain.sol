// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrugSupplyChain {

    enum Role { none, Manufacturer, Supplier, Distributor, Pharmacy, Consumer }
    enum Status { Created, InTransit, Delivered }

    struct Drug {
        uint id;
        string name;
        Status status;
        address[] history;
        address currentOwner;
    }

    uint public drugCounter = 0;

    mapping(uint => Drug) public drugs;
    mapping(address => Role) public roles;

    modifier OnlyRole(Role _role) {
        require(roles[msg.sender] == _role, "Unauthorized: Incorrect Role");
        _;
    }

    modifier OnlyCurrentOwner(uint id) {
        require(msg.sender == drugs[id].currentOwner, "Only current owner can perform this action");
        _;
    }

    event DrugRegistered(uint id, string name, address manufacturer);
    event DrugTransferred(uint id, address from, address to);
    event StatusUpdated(uint id, Status status);

    function assignRoles(address user, Role _role) public {
        roles[user] = _role;
    }

    function drugRegistered(string memory _name) public OnlyRole(Role.Manufacturer) {
        drugCounter++;
        Drug storage drug = drugs[drugCounter];
        drug.id = drugCounter;
        drug.name = _name;
        drug.status = Status.Created;
        drug.currentOwner = msg.sender;
        drug.history.push(msg.sender);

        emit DrugRegistered(drugCounter, _name, msg.sender);
    }

    function TransferDrugs(uint id, address newOwner) public OnlyCurrentOwner(id) {
        require(roles[newOwner] != Role.none, "New owner must have a valid role");

        Drug storage drug = drugs[id];
        drug.currentOwner = newOwner;
        drug.history.push(newOwner);
        drug.status = Status.InTransit;

        emit DrugTransferred(id, msg.sender, newOwner);
    }

    function UpdateStatus(uint id, Status _status) public OnlyCurrentOwner(id) {
        drugs[id].status = _status;

        emit StatusUpdated(id, _status);
    }

    function getDrugHistory(uint id) public view returns (address[] memory) {
        return drugs[id].history;
    }

    function getDrugsDetails(uint drugID) public view returns (
        string memory, Status, address, address[] memory
    ) {
        Drug storage d = drugs[drugID];
        return (d.name, d.status, d.currentOwner, d.history);
    }
}
