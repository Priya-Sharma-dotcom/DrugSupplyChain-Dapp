//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract DrugSC{

    address public admin;

    constructor(){
        admin=msg.sender;
    }

    enum Role{none,manufacturer,supplier,distributor,pharmacy,patient}
    enum Status{Created,inTransit,Delivered}

    struct Drug{
        string name;
        address manufacturer;
        Status status;
        uint price;
        address currentOwner;
        address[] owners;

    }

    modifier OnlyAdmin(){
        require(msg.sender==admin,"not admin so cannot use function");
        _;
    }


    modifier OnlyRole(Role _role){
        require(roles[msg.sender]==_role,"not included in tasks of assigned role");
        _;
    }

    modifier OnlyCurrentOwner(uint id){
        require(msg.sender==drugs[id].currentOwner,"not current owner");
        _;
    }

    mapping ( uint => Drug) public drugs;
    mapping ( address => Role) public roles;


    event DrugRegistered(uint id, address manufacturer);
    event DrugOwnershipTransfered(uint id, address from, address to);
    event DrugStatusUpdated(uint id, Status status);


    function assignRoles(address roleAdd, Role _role)public OnlyAdmin{
        roles[roleAdd]=_role;
    }

    uint public drugCounter;
    function RegisterDrug(string memory _name, uint _price)public OnlyRole(Role.manufacturer){

        drugCounter++;

        Drug storage d=drugs[drugCounter];
        d.name=_name;
        d.manufacturer=msg.sender;
        d.price=_price;
        d.status=Status.Created;
        d.currentOwner=msg.sender;
        d.owners.push(msg.sender);

        emit DrugRegistered(drugCounter, msg.sender);

    }

    function DrugTransferOwnership(uint id, address newOwner)public OnlyCurrentOwner (id){

        require(roles[newOwner]!=Role.none,"no role ");
        require(roles[msg.sender]!=Role.none,"no role of sender");
        require(roles[newOwner]!=Role.manufacturer,"manufacturer cannot own drugs");
        require(uint(roles[newOwner]) > uint(roles[msg.sender]), "Invalid role progression");


        Drug storage d=drugs[id];
        d.currentOwner=newOwner;
        d.owners.push(newOwner);

        d.status=Status.inTransit;

        emit DrugOwnershipTransfered(id,msg.sender,newOwner);

    }

    function UpdateDrugStatus(uint id, Status newStatus)public OnlyCurrentOwner(id){

        Drug storage d= drugs[id];
        d.status=newStatus;

        emit DrugStatusUpdated(id, newStatus);
    }

    function getOwnershipHistory(uint id)public view returns(address [] memory){
        return drugs[id].owners;
    }

    function getCurrentOwner(uint id)public view returns(address){
        return drugs[id].currentOwner;
    }

    function getDrugInfo(uint id)public view returns(string memory,address,uint,Status,address){
        return (drugs[id].name,drugs[id].currentOwner,drugs[id].price,drugs[id].status,drugs[id].manufacturer);
    }

}











