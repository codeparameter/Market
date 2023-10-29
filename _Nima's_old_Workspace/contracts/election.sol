// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./abCoin.sol";

contract AbGovernment {
    
    struct Candidate{
        address adr;
        uint256 votes;
        uint index;
    }

    struct Voter {
        address adr;
    }

    struct Election {
        string name;
        uint256 ID;
        // when it's not in the range of start and expiration year,
        // it's not started yet
        uint256 startDate;
        uint256 expireDate;
        //
        uint256 currentCandidateIndex;
        mapping(uint => Candidate) sortedCandidates;
        mapping(address => Candidate) candidates;
        Candidate[] winners;
        //
        uint winnersCount;
        uint winnerMinPercentage;
    }
    
    struct Schedule{
        uint256 ID;
        string name;
        // when it's not in the range of start and expiration year,
        // it's not started yet
        uint256 startDate;
        uint256 expireDate;
        //
        uint256 currentElectionId;
        mapping(uint256 => Election) elections;
        //
        mapping(address => Voter) voters;
        ABCoin token;
    }

    address public owner;
    uint256 public votesPerPerson = 100; 
    uint256 public currentScheduleId = 1;

    mapping(uint256 => Schedule) public schedules;
    // ABCoin internal token = new ABCoin("ABCoin", "ABC");

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    function getSchedule(uint256 scheduleId) internal view returns(Schedule storage){
        require(scheduleId > 0 && scheduleId <= currentScheduleId, "Invalid schedule ID");
        Schedule storage schedule = schedules[scheduleId];
        return schedule;
    }
    
    function getScheduleForVoters(uint256 scheduleId) internal view returns(Schedule storage){
        Schedule storage schedule = getSchedule(scheduleId);
        require(block.timestamp < schedule.startDate, 
            "You can't add voter because the schedule has already started");
        return schedule;
    }
    
    function getElectionInternal(Schedule storage schedule, uint256 electionId) internal view returns(Election storage){
        require(electionId > 0 && electionId <= schedule.currentElectionId, "Invalid election ID");
        Election storage election = schedule.elections[electionId];
        return election;
    }
    
    function getElection(uint256 scheduleId, uint256 electionId) internal view returns(Election storage){
        return getElectionInternal(getSchedule(scheduleId), electionId);
    }
    
    function getElectionForEdite(uint256 scheduleId, uint256 electionId) internal view onlyOwner returns(Election storage){
        Election storage election = getElection(scheduleId, electionId);
        require(block.timestamp < election.startDate, 
            "You can't edit this election because the election has already started");
        return election;
    }
    
    function getElectionForAnnounce(uint256 scheduleId, uint256 electionId) internal view returns(Election storage){
        Election storage election = getElection(scheduleId, electionId);
        require(block.timestamp > election.expireDate,
         "You can't access winners while election continues");
         return election;
    }

    function getCandidateInternal(Election storage election, address candidateAdr) internal view returns(Candidate storage){
        Candidate storage candidate = election.candidates[candidateAdr];
        require(candidate.adr == candidateAdr, "Candidate not found");
        return candidate;
    }

    function getCandidateForEdite(uint256 scheduleId, uint256 electionId, address candidateAdr) internal view onlyOwner returns(Candidate storage){
        Election storage election = getElectionForEdite(scheduleId, electionId);(scheduleId, electionId);
        return getCandidateInternal(election, candidateAdr);
    }
    
    function getVoter(uint256 scheduleId,address voter_adr) internal view returns(Voter storage){
        Schedule storage schedule = getSchedule(scheduleId);
        Voter storage voter = schedule.voters[voter_adr];
        require(voter.adr != address(0), "voter not found");
        return voter;
    }

    // Function to create a new schedule
    function createSchedule(string memory name,
                            uint256 startD,
                            uint expireD) 
                            public onlyOwner {  


        Schedule storage schedule = schedules[currentScheduleId];

        schedule.ID = currentScheduleId;
        schedule.name = name;
        schedule.startDate = startD;
        schedule.expireDate = expireD;
        schedule.currentElectionId = 1;
        schedule.token = new ABCoin(string.concat("ABCoin", name), 
                                    string.concat("ABC", name),
                                    startD,
                                    expireD);

        currentScheduleId++;
    }

    // Function to create a new schedule
    function createSchedule1yearFromNow(string memory name) 
                            public onlyOwner {  
        createSchedule(name, block.timestamp, block.timestamp + 365 days);
    }

    // Function to add a voter and distribute tokens
    function addVoter(uint256 scheduleId, address voterAddress) public onlyOwner {

        Schedule storage schedule = getScheduleForVoters(scheduleId);
        require(schedule.voters[voterAddress].adr != voterAddress, "Voter already added");
        
        schedule.voters[voterAddress] = Voter({
            adr: voterAddress
        });
        
        schedule.token.mint(voterAddress, votesPerPerson);
    }

    // Function to create a new election
    function createElection(uint256 scheduleId,
                            string memory name,
                            uint256 startD,
                            uint256 expireD,
                            uint winnersCount,
                            uint winnerMinPercentage) 
                            public onlyOwner {  

        Schedule storage schedule = getSchedule(scheduleId);
        Election storage election = schedule.elections[schedule.currentElectionId];

        election.ID = schedule.currentElectionId;
        election.name = name;
        election.startDate = startD;
        election.expireDate = expireD;
        election.winnersCount = winnersCount;
        election.winnerMinPercentage = winnerMinPercentage;
        election.currentCandidateIndex = 0;
    
        schedule.currentElectionId++;
    }

    // Function to create a new election
    function createElection1yearFromNow(uint256 scheduleId,
                            string memory name,
                            uint winnersCount,
                            uint winnerMinPercentage) 
                            public onlyOwner {  
                                
        createElection(
            scheduleId, 
            name, 
            block.timestamp, 
            block.timestamp + 365 days, 
            winnersCount, 
            winnerMinPercentage);
    }

    // Function to edite an election
    function editeElection(uint256 scheduleId,
                            uint256 electionId,
                            string memory name,
                            uint256 startD,
                            uint256 expireD,
                            uint winnersCount,
                            uint winnerMinPercentage) public {  
                                
        Election storage election = getElectionForEdite(scheduleId, electionId);

        election.name = name;
        election.startDate = startD;
        election.expireDate = expireD;
        election.winnersCount = winnersCount;
        election.winnerMinPercentage = winnerMinPercentage;
    }

    // Function to edite election name
    function editeElectionName(uint256 scheduleId,
                            uint256 electionId,
                            string memory name) public {  
                                
        Election storage election = getElectionForEdite(scheduleId, electionId);
        election.name = name;
    }

    // Function to edite election start date
    function editeElectionStartD(uint256 scheduleId,
                            uint256 electionId,
                            uint256 startD) public {  
                                
        Election storage election = getElectionForEdite(scheduleId, electionId);
        election.startDate = startD;
    }

    // Function to edite election expiration date
    function editeElectionExpireD(uint256 scheduleId,
                            uint256 electionId,
                            uint256 expireD) public { 
                                
        Election storage election = getElectionForEdite(scheduleId, electionId);
        election.expireDate = expireD;
    }

    // Function to edite election winners count
    function editeElectionWC(uint256 scheduleId,
                            uint256 electionId,
                            uint winnersCount) public {  
                                
        Election storage election = getElectionForEdite(scheduleId, electionId);
        election.winnersCount = winnersCount;
    }

    // Function to edite election winner minimum percentage
    function editeElectionWMP(uint256 scheduleId,
                            uint256 electionId,
                            uint winnerMinPercentage) public {  
                                
        Election storage election = getElectionForEdite(scheduleId, electionId);
        election.winnerMinPercentage = winnerMinPercentage;
    }

    // Function to remove a candidate
    function removeCandidate(uint256 scheduleId, uint256 electionId, address candidateAdr) public  {       
        Candidate storage candidate = getCandidateForEdite(scheduleId, electionId, candidateAdr);
        candidate.adr = address(0);
    }

    // Function to add a candidate to an election
    function addCandidate(uint256 scheduleId, uint256 electionId, address candidate) public {
        Election storage election = getElectionForEdite(scheduleId, electionId);
        require(election.candidates[candidate].adr != candidate, "Candidate already added");

        election.candidates[candidate] = Candidate({
            adr: candidate,
            votes: 0,
            index: election.currentCandidateIndex
        });

        election.currentCandidateIndex++;
    }

    // Function to allow users to spend their votes on a specific election and candidate
    function spendVotes(uint256 scheduleId,
                        uint256 electionId,
                        address candidateAdr, 
                        uint256 votes) 
                        public {

        Schedule storage schedule = getSchedule(scheduleId);
        Election storage election = getElectionInternal(schedule, electionId);
        Candidate storage candidate = getCandidateInternal(election, candidateAdr);(election, candidateAdr);
        
        schedule.token.transferFrom(msg.sender, address(this), votes);
        candidate.votes += votes;

        sortCandidate(election, candidate);
    }

    // function to sort candidates
    function sortCandidate(Election storage election, Candidate storage candidate) internal {

        uint i = candidate.index;
        
        while (candidate.votes > election.sortedCandidates[i-1].votes){
            Candidate storage temp = election.sortedCandidates[i-1];
            temp.index = i;
            election.sortedCandidates[i-1] = candidate;
            election.sortedCandidates[i] = temp;
            i--;
        }
        
        candidate.index = i;
    }
    
    // function to anounce election winners
    function anounceWinners(uint256 scheduleId, uint256 electionId) public onlyOwner {
        Election storage election = getElectionForAnnounce(scheduleId, electionId);
        for (uint i = 0; i < election.winnersCount; i++){
            if(election.sortedCandidates[i].votes < election.winnerMinPercentage){
                break ;
            }
            election.winners.push(election.sortedCandidates[i]);
        }
    }

    // function to see winners
    function seeWinners(uint256 scheduleId, uint256 electionId) public view returns (Candidate[] memory) {
        Election storage election = getElectionForAnnounce(scheduleId, electionId);
        return election.winners;
    }
}