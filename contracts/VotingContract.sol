// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract VotingSystem {
    address public owner;
    string[] public pollsArray;

    constructor() {
        owner = msg.sender;
    }

    struct poll {
        bool exists;
        uint256 a;
        uint256 b;
        uint256 c;
        mapping(address => bool) Voters;
    }

    event pollUpdated(
        uint256 a,
        uint256 b,
        uint256 c,
        address voter,
        string poll
    );

    mapping(string => poll) private Polls;

    function addPoll(string memory _poll) public {
        require(msg.sender == owner, "Only the Owner Can create polls");
        poll storage newPoll = Polls[_poll];
        newPoll.exists = true;
        pollsArray.push(_poll);
    }

    function vote(string memory _poll, bool _vote) public {
        require(Polls[_poll].exists, "Cannot Vote on this poll");
        require(
            !Polls[_poll].Voters[msg.sender],
            "You have already voted on this poll"
        );

        poll storage p = Polls[_poll];
        p.Voters[msg.sender] = true;

        if (_vote) {
            p.a++;
        } else if (!_vote) {
            p.b++;
        } else {
            p.c++;
        }

        emit pollUpdated(p.a, p.b, p.c, msg.sender, _poll);
    }

    function getVotes(string memory _poll)
        public
        view
        returns (
            uint256 a,
            uint256 b,
            uint256 c
        )
    {
        require(Polls[_poll].exists, "No Such Poll Defined");
        poll storage p = Polls[_poll];
        return (p.a, p.b, p.c);
    }

    
}
