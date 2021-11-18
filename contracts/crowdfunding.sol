// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.4;

contract CrowdFunding {

    // Enum type para guardar los posibles valores del estado de nuestro proyecto
    enum FundState { Opened, Closed }

    struct Contribution {
        address contributor;
        uint value;
    }

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
    Project[] public projects;

    mapping(string => Contribution[]) public contributions;

    // Eventos
    // Permite conectar lo que psa dentro de la Blockchain con el exterior porque
    // a traves de un protocolo otras aplicaciones se pueden suscribir a
    // ellos y escuchar todo lo que está pasando en el Smart Contract

    event ProjectCreated(
        string projectId,
        string name,
        string description,
        uint fundState
    );

    event ProjectFunded(
        string projectId,
        uint value
    );

    event ProjectStateChanged(
        string id,
        FundState state
    );

    modifier isAuthor(uint projectIndex) {
        require(projects[projectIndex].author == msg.sender, "Necesitas ser el autor del proyecto");
        _;
    }

    modifier isNotAuthor(uint projectIndex) {
        require(projects[projectIndex].author != msg.sender, "Como autor no puedes financiar tu propio proyecto");
        _;
    }

    function createProject(string calldata id, string calldata name, string calldata description, uint fundraisingState) public {
        require(fundraisingState > 0, "");
        Project memory project = Project(id, name, description, payable(msg.sender), FundState.Opened, 0, fundraisingState);
        projects.push(project);
        emit ProjectCreated(id, name, description, fundraisingState);
    }

    function fundProject(uint projectIndex) public payable isNotAuthor(projectIndex) {
        Project memory project = projects[projectIndex];
        require(project.state != FundState.Closed, "El proyecto no puede recibir fondos"); // valida si el estado es diferente sino envia mensaje error
        require(msg.value > 0, "El valor del fondo debe ser mayor que 0"); // valida si el valor de eth que envia el user es mayor a 0 sino mensaje error
        project.author.transfer(msg.value);
        project.funds += msg.value;
        projects[projectIndex] = project;

        contributions[project.id].push(Contribution(msg.sender, msg.value));

        emit ProjectFunded(project.id, msg.value);
    }

    function changeProjectState(FundState newState, uint projectIndex) public isAuthor(projectIndex) {
        Project memory project = projects[projectIndex];
        require(project.state != newState, "El nuevo estado debe ser diferente"); // valida si el estado actual es diferente al nuevo estado
        project.state = newState;
        projects[projectIndex] = project;
        emit ProjectStateChanged(project.id, newState);
    }
}