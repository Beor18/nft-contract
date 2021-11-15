// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {

    // Enum type para guardar los posibles valores del estado de nuestro proyecto
    enum FundState { Opened, Closed }

    // Se define la estructura
    struct Project {
        string id;
        string name;
        string description;

        address payable author; // variable address payable maneja la cartera que vamos a recibir fondos
        FundState state; // estado del proyeto open o close
        uint funds;
        uint fundraisingGoal;
    }

    // la estructura se pone como public
    Project public project;

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
        FundState state
    );

    constructor(string memory _id, string memory _name, string memory _description, uint _fundraisingGoal) {
        project = Project(_id, _name, _description, payable(msg.sender), FundState.Opened, 0, _fundraisingGoal);
    }

    modifier isAuthor() {
        require(project.author == msg.sender, "Necesitas ser el autor del proyecto");
        _;
    }

    modifier isNotAuthor() {
        require(project.author != msg.sender, "Como autor no puedes financiar tu propio proyecto");
        _;
    }

    function fundProject() public payable isNotAuthor {
        require(project.state != FundState.Closed, "El proyecto no puede recibir fondos"); // valida si el estado es diferente sino envia mensaje error
        require(msg.value > 0, "El valor del fondo debe ser mayor que 0"); // valida si el valor de eth que envia el user es mayor a 0 sino mensaje error
        project.author.transfer(msg.value);
        project.funds += msg.value;
        emit ProjectFunded(project.id, msg.value);
    }

    function changeProjectState(FundState newState) public isAuthor {
        require(project.state != newState, "El nuevo estado debe ser diferente"); // valida si el estado actual es diferente al nuevo estado
        project.state = newState;
        emit ProjectStateChanged(project.id, newState);
    }
}