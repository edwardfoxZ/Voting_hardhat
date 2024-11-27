// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract Voting {
    // Events
    event BallotCreated(uint indexed ballotIndex, string question);
    event VoteCast(uint indexed ballotIndex, uint indexed optionIndex, address voter);

    // State variables
    uint public ballotCount;

    struct Ballot {
        string question;
        string[] options;
        uint startTime;
        uint endTime;
        mapping(uint => uint) tally; // Maps option index to votes
        mapping(address => bool) hasVoted; // Tracks whether an address has voted
    }

    mapping(uint => Ballot) private ballots; // Maps ballot index to ballot data

    /**
     * @dev Create a new ballot.
     * @param question The question for the ballot.
     * @param options The options for voting.
     * @param startTime The start time for the ballot.
     * @param duration The duration (in seconds) for the ballot.
     */
    function createBallot(
        string memory question,
        string[] memory options,
        uint startTime,
        uint duration
    ) external {
        require(duration > 0, "Duration must be greater than 0");
        require(startTime > block.timestamp, "Start time must be in the future");
        require(options.length >= 2, "At least two options are required");

        Ballot storage ballot = ballots[ballotCount];
        ballot.question = question;
        ballot.startTime = startTime;
        ballot.endTime = startTime + duration;

        for (uint i = 0; i < options.length; i++) {
            ballot.options.push(options[i]);
        }

        emit BallotCreated(ballotCount, question);
        ballotCount++;
    }

    /**
     * @dev Cast a vote for a specific option in a ballot.
     * @param ballotIndex The index of the ballot.
     * @param optionIndex The index of the option to vote for.
     */
    function castVote(uint ballotIndex, uint optionIndex) external {
        Ballot storage ballot = ballots[ballotIndex];

        require(block.timestamp >= ballot.startTime, "Voting has not started yet");
        require(block.timestamp <= ballot.endTime, "Voting has ended");
        require(!ballot.hasVoted[msg.sender], "You have already voted");
        require(optionIndex < ballot.options.length, "Invalid option index");

        ballot.tally[optionIndex]++;
        ballot.hasVoted[msg.sender] = true;

        emit VoteCast(ballotIndex, optionIndex, msg.sender);
    }

    /**
     * @dev Get the tally of votes for a specific option in a ballot.
     * @param ballotIndex The index of the ballot.
     * @param optionIndex The index of the option.
     * @return The number of votes for the specified option.
     */
    function getTally(uint ballotIndex, uint optionIndex) external view returns (uint) {
        Ballot storage ballot = ballots[ballotIndex];
        return ballot.tally[optionIndex];
    }

    /**
     * @dev Get the results of a ballot.
     * @param ballotIndex The index of the ballot.
     * @return An array containing the number of votes for each option.
     */
    function getResults(uint ballotIndex) external view returns (uint[] memory) {
        Ballot storage ballot = ballots[ballotIndex];
        uint[] memory result = new uint[](ballot.options.length);

        for (uint i = 0; i < ballot.options.length; i++) {
            result[i] = ballot.tally[i];
        }

        return result;
    }

    /**
     * @dev Get the winners of a ballot (can handle ties).
     * @param ballotIndex The index of the ballot.
     * @return An array indicating whether each option is a winner.
     */
    function getWinners(uint ballotIndex) external view returns (bool[] memory) {
        Ballot storage ballot = ballots[ballotIndex];
        uint maxVotes;
        uint[] memory result = new uint[](ballot.options.length);
        bool[] memory winners = new bool[](ballot.options.length);

        // Find the maximum votes
        for (uint i = 0; i < ballot.options.length; i++) {
            result[i] = ballot.tally[i];
            if (result[i] > maxVotes) {
                maxVotes = result[i];
            }
        }

        // Mark the winners
        for (uint i = 0; i < ballot.options.length; i++) {
            if (result[i] == maxVotes) {
                winners[i] = true;
            }
        }

        return winners;
    }

    /**
     * @dev Get the details of a ballot.
     * @param ballotIndex The index of the ballot.
     * @return The question, options, start time, and end time.
     */
    function getBallotDetails(uint ballotIndex)
        external
        view
        returns (
            string memory,
            string[] memory,
            uint,
            uint
        )
    {
        Ballot storage ballot = ballots[ballotIndex];
        return (ballot.question, ballot.options, ballot.startTime, ballot.endTime);
    }
}
