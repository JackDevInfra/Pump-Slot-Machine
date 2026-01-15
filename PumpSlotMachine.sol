// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
 Pump Slot Machine

 Continuous probabilistic distribution mechanism.
 No staking. No snapshots. No claims.
*/

contract PumpSlotMachine {
    uint256 public constant SPIN_INTERVAL = 10 minutes;
    uint256 public lastSpinTimestamp;

    address public immutable token;
    uint256 public minimumBalance;

    address[] public holders;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastUpdated;

    event Spin(uint256 indexed timestamp, address indexed winner, uint256 reward);

    constructor(address _token, uint256 _minBalance) {
        token = _token;
        minimumBalance = _minBalance;
        lastSpinTimestamp = block.timestamp;
    }

    function registerHolder(address holder, uint256 balance) external {
        if (balances[holder] == 0 && balance >= minimumBalance) {
            holders.push(holder);
        }
        balances[holder] = balance;
        lastUpdated[holder] = block.timestamp;
    }

    function spin() external {
        require(block.timestamp >= lastSpinTimestamp + SPIN_INTERVAL, "Spin interval not reached");
        require(holders.length > 0, "No eligible holders");

        uint256 entropy = uint256(
            keccak256(
                abi.encodePacked(
                    blockhash(block.number - 1),
                    block.timestamp,
                    holders.length
                )
            )
        );

        uint256 index = entropy % holders.length;
        address winner = holders[index];

        uint256 reward = address(this).balance / 100; // example payout fraction
        payable(winner).transfer(reward);

        lastSpinTimestamp = block.timestamp;

        emit Spin(block.timestamp, winner, reward);
    }

    receive() external payable {}
}