// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DrugSC {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    enum Role { none, manufacturer, supplier, distributor, pharmacy, patient }
    enum Status { Created, inTransit, Delivered }

    struct Drug {
        string name;
        address manufacturer;
        Status status;
        uint price;
        address currentOwner;
        address[] owners;
    }

    modifier OnlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier OnlyRole(Role _role) {
        require(roles[msg.sender] == _role, "Incorrect role");
        _;
    }

    modifier OnlyCurrentOwner(uint id) {
        require(msg.sender == drugs[id].currentOwner, "Not current owner");
        _;
    }

    modifier OnlyAssignedUser() {
        require(roles[msg.sender] != Role.none, "Not an assigned user");
        _;
    }

    mapping(uint => Drug) public drugs;
    mapping(address => Role) public roles;
    uint public drugCounter;

    event DrugRegistered(uint id, address manufacturer);
    event DrugOwnershipTransferred(uint id, address from, address to);
    event DrugStatusUpdated(uint id, Status status);

    function assignRoles(address roleAdd, Role _role) public OnlyAdmin {
        roles[roleAdd] = _role;
    }

    function registerDrug(string memory _name, uint _price) public OnlyRole(Role.manufacturer) {
        // Prevent duplicate drug names from being registered (optional)
        for (uint i = 1; i <= drugCounter; i++) {
            require(
                keccak256(bytes(drugs[i].name)) != keccak256(bytes(_name)),
                "Drug already registered"
            );
        }

        drugCounter++;

        Drug storage d = drugs[drugCounter];
        d.name = _name;
        d.manufacturer = msg.sender;
        d.price = _price;
        d.status = Status.Created;
        d.currentOwner = msg.sender;
        d.owners.push(msg.sender);

        emit DrugRegistered(drugCounter, msg.sender);
    }

    function drugTransferOwnership(uint id, address newOwner) public OnlyCurrentOwner(id) {
        require(roles[newOwner] != Role.none, "New owner must have a role");
        require(roles[msg.sender] != Role.none, "Sender must have a role");
        require(roles[newOwner] != Role.manufacturer, "Manufacturer cannot be new owner");
        require(uint(roles[newOwner]) > uint(roles[msg.sender]), "Invalid role progression");

        Drug storage d = drugs[id];
        d.currentOwner = newOwner;
        d.owners.push(newOwner);
        d.status = Status.inTransit;

        emit DrugOwnershipTransferred(id, msg.sender, newOwner);
    }

    function updateDrugStatus(uint id, Status newStatus) public OnlyCurrentOwner(id) {
        Drug storage d = drugs[id];
        d.status = newStatus;

        emit DrugStatusUpdated(id, newStatus);
    }

    function getOwnershipHistory(uint id) public view OnlyAssignedUser returns (address[] memory) {
        return drugs[id].owners;
    }

    function getCurrentOwner(uint id) public view OnlyAssignedUser returns (address) {
        return drugs[id].currentOwner;
    }

    function getDrugInfo(uint id) public view OnlyAssignedUser returns (string memory, address, uint, Status, address) {
        Drug storage d = drugs[id];
        return (d.name, d.currentOwner, d.price, d.status, d.manufacturer);
    }

    function getDrugCount() public view returns (uint) {
        return drugCounter;
    }
}
