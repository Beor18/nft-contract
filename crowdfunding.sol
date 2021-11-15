// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    string public id;
    string public name;
    string public description;
    
    address payable public author; // variable address payable maneja la cartera que vamos a recibir fondos
    uint public state; // estado del proyeto open o close
    uint public funds;
    uint public fundraisingGoal;

    // Eventos
    // Permite conectar lo que psa dentro de la Blockchain con el exterior porque
    // a traves de un protocolo otras aplicaciones se pueden suscribir a
    // ellos y escuchar todo lo que está pasando en el Smart Contract

    event ProjectFunded(
        string projectId,
        uint value
    );

    event ProjectStateChanged(
        string id,
        uint state
    );

    constructor(string memory _id, string memory _name, string memory _description, uint _fundraisingGoal) {
        id = _id;
        name = _name;
        description = _description;
        fundraisingGoal = _fundraisingGoal;
        author = payable(msg.sender);
    }

    modifier isAuthor() {
        require(author == msg.sender, "Necesitas ser el autor del proyecto");
        _;
    }

    modifier isNotAuthor() {
        require(author != msg.sender, "Como autor no puedes financiar tu propio proyecto");
        _;
    }

    function fundProject() public payable isNotAuthor {
        require(state != 1, "El proyecto no puede recibir fondos"); // valida si el estado es diferente sino envia mensaje error
        require(msg.value > 0, "El valor del fondo debe ser mayor que 0"); // valida si el valor de eth que envia el user es mayor a 0 sino mensaje error
        author.transfer(msg.value);
        funds += msg.value;
        emit ProjectFunded(id, msg.value);
    }

    function changeProjectState(uint newState) public isAuthor {
        require(state != newState, "El nuevo estado debe ser diferente"); // valida si el estado actual es diferente al nuevo estado
        state = newState;
        emit ProjectStateChanged(id, newState);
    }
}