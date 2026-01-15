# Pump Slot Machine

<div align="center">
  <img src="PSM.png" alt="Pump Slot Machine" width="400"/>
</div>

```
██████╗ ██╗   ██╗███╗   ███╗██████╗     ███████╗██╗      ██████╗ ████████╗
██╔══██╗██║   ██║████╗ ████║██╔══██╗    ██╔════╝██║     ██╔═══██╗╚══██╔══╝
██████╔╝██║   ██║██╔████╔██║██████╔╝    ███████╗██║     ██║   ██║   ██║   
██╔═══╝ ██║   ██║██║╚██╔╝██║██╔═══╝     ╚════██║██║     ██║   ██║   ██║   
██║     ╚██████╔╝██║ ╚═╝ ██║██║         ███████║███████╗╚██████╔╝   ██║   
╚═╝      ╚═════╝ ╚═╝     ╚═╝╚═╝         ╚══════╝╚══════╝ ╚═════╝    ╚═╝   
                                                                            
███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗                  
████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝                  
██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║███████╗                  
██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║╚════██║                  
██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████║                  
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝                  
```

<div align="center">
<strong>A Continuous On-Chain Probabilistic Distribution Mechanism</strong>
</div>

---

## Abstract

Pump Slot Machine (PSM) is a non-interactive reward distribution protocol that operates as a perpetual on-chain slot machine. The system executes deterministic pseudorandom selection over token holder sets at fixed intervals, redistributing accumulated rewards to probabilistically chosen participants without requiring staking, claiming, or any form of user interaction.

Unlike snapshot-based or manual claim systems, PSM operates as a continuous background process where eligibility is dynamically computed from on-chain balances and holding duration. The protocol guarantees forward progress, deterministic reproducibility, and resistance to timing-based gaming through carefully constructed weighting functions and entropy sources.

---

## Design Goals

**What PSM Does:**
* Continuously redistributes accumulated rewards to token holders
* Selects recipients probabilistically based on balance and duration
* Operates autonomously without user interaction
* Provides deterministic, verifiable randomness
* Maintains complete on-chain transparency
* Eliminates gas costs for recipients
* Prevents timing attacks through time-weighted eligibility

**What PSM Does Not Do:**
* Require staking or locking of tokens
* Implement snapshot voting or governance
* Guarantee equal distribution across holders
* Provide fixed APY or yield promises
* Execute off-chain computation or oracles
* Require whitelisting or permission
* Implement token burning mechanisms

---

## System Overview

PSM implements a slot machine metaphor as a formal distribution primitive. The protocol maintains a global timer that triggers automatic spin cycles at predetermined intervals. During each cycle, the system:

1. Computes the eligible holder set from current on-chain balances
2. Applies time-weighted scoring to each eligible address
3. Generates deterministic pseudorandom values
4. Selects one or more recipients according to configured probabilities
5. Executes immediate reward transfers

The entire process occurs atomically within a single transaction. Recipients receive rewards directly to their wallet addresses without any required action. The majority of spin cycles intentionally result in no reward distribution, creating an asymmetric but statistically fair allocation over time.

This design eliminates common pain points in reward systems including the need for manual claiming, gas cost burdens on users, snapshot coordination, and staking complexity.

---

## Slot Machine Model

The slot machine analogy is not metaphorical marketing but a precise description of the distribution model. Traditional slot machines operate on three principles that PSM implements literally:

**1. Continuous Operation**
The machine spins automatically at fixed intervals regardless of user action. No trigger is required beyond the passage of time. Block timestamps serve as the clock.

**2. Probabilistic Selection**
Each spin generates pseudorandom values that determine whether rewards are distributed and to whom. Probabilities are tuned such that most spins result in no distribution, while occasional spins select one or more recipients.

**3. Asymmetric Payouts**
When rewards are distributed, they are not split equally among all participants. Instead, selected addresses receive the full reward amount for that cycle. Over sufficient time, the statistical distribution converges to fairness weighted by holding behavior.

The key insight is that asymmetric but frequent probabilistic selection produces more engaging distribution dynamics than uniform periodic allocation, while maintaining mathematical fairness over the long term.

```
Traditional Model:           Slot Machine Model:
                            
Everyone gets 0.01          Spin 1: Nobody wins
Everyone gets 0.01          Spin 2: Nobody wins  
Everyone gets 0.01          Spin 3: Alice wins 1.0
Everyone gets 0.01          Spin 4: Nobody wins
Everyone gets 0.01          Spin 5: Bob wins 1.0
...                         ...
(Predictable, boring)       (Variable, engaging)
```

---

## Spin Cycle

Each spin cycle proceeds through a deterministic sequence of operations. The cycle is triggered automatically when the configured interval has elapsed since the previous spin.

### Cycle Steps

```
╔════════════════════════════════════════════════════════════════╗
║                     SPIN CYCLE EXECUTION                       ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  1. TIME CHECK                                                 ║
║     └─> Verify interval elapsed since last spin               ║
║                                                                ║
║  2. SNAPSHOT STATE                                             ║
║     └─> Enumerate all non-zero balances                       ║
║     └─> Filter by minimum threshold                           ║
║                                                                ║
║  3. COMPUTE WEIGHTS                                            ║
║     └─> Calculate holding duration per address                ║
║     └─> Apply time decay function                             ║
║     └─> Normalize to probability distribution                 ║
║                                                                ║
║  4. GENERATE ENTROPY                                           ║
║     └─> Hash block parameters                                 ║
║     └─> Mix with previous spin state                          ║
║     └─> Derive selection values                               ║
║                                                                ║
║  5. SELECT RECIPIENTS                                          ║
║     └─> Map entropy to weighted probabilities                 ║
║     └─> Choose 0 or more addresses                            ║
║                                                                ║
║  6. DISTRIBUTE REWARDS                                         ║
║     └─> Transfer tokens to selected addresses                 ║
║     └─> Emit distribution events                              ║
║     └─> Update global state                                   ║
║                                                                ║
║  7. FINALIZE                                                   ║
║     └─> Record spin timestamp                                 ║
║     └─> Commit entropy for next cycle                         ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

### Flow Diagram

```
    [Timer Expires]
          |
          v
    {Interval Check} ----No----> [Revert]
          |
         Yes
          |
          v
    [Load Balances]
          |
          v
    [Filter Eligible]
          |
          v
    [Compute Weights] -------> [Time Weighting]
          |                           |
          |                           |
          v                           v
    [Generate Entropy] <------- [Previous State]
          |
          v
    [Select Winners]
          |
          |-----> [No Winners] ---> [Update State] ---> [End]
          |
          |-----> [Winners Found]
                       |
                       v
                  [Transfer Rewards]
                       |
                       v
                  [Emit Events]
                       |
                       v
                  [Update State]
                       |
                       v
                     [End]
```

### Atomicity Guarantees

All operations within a single spin occur atomically. Either the entire spin completes successfully or the transaction reverts with no state changes. This prevents partial distributions or inconsistent state.

---

## Eligibility & Weighting

Not all token holders are equally eligible for selection during any given spin. The system applies multiple filters and weighting functions to determine the effective probability distribution.

### Minimum Balance Threshold

Addresses must hold a minimum token balance to be considered eligible. This prevents dust attacks and reduces the computational cost of processing the holder set.

```
THRESHOLD = 1000 tokens

if balance[address] < THRESHOLD:
    weight[address] = 0
else:
    weight[address] = compute_weight(address)
```

### Time-Based Weighting

Holding duration significantly impacts selection probability. Addresses that have held tokens longer receive higher weights. This mechanism serves multiple purposes:

1. Rewards long-term participants over short-term speculators
2. Prevents just-in-time gaming where actors buy tokens immediately before spins
3. Creates economic incentive against frequent trading
4. Naturally penalizes MEV extraction attempts

The weighting function takes the form:

```
weight(address) = balance(address) * time_factor(address)

where:

time_factor(address) = min(1.0, holding_duration / MAX_DURATION)

holding_duration = current_block_timestamp - first_acquisition_timestamp
```

### Decay Mechanics

Time weights decay upon token transfer. When an address transfers tokens, its holding duration resets proportionally to the amount transferred. Partial transfers result in partial resets using a weighted average.

```
# Full Transfer
new_duration = 0

# Partial Transfer (50% of balance)
old_duration = 1000 blocks
transfer_ratio = 0.5
new_duration = old_duration * (1 - transfer_ratio) = 500 blocks
```

This creates friction against timing attacks where an actor might attempt to transfer tokens between addresses to manipulate multiple eligibility slots.

### Why Timing Attacks Do Not Work

Consider an adversary who attempts to game the system by:

1. Monitoring pending spin transactions
2. Front-running with token purchases
3. Back-running with token sales after the spin

This strategy fails because:

* **Zero Duration Penalty**: Newly acquired tokens have zero holding duration, resulting in minimal weight regardless of balance size
* **Time Lock**: Holding duration requires multiple blocks to accumulate meaningful weight
* **Unpredictable Selection**: Even with high weight, selection is probabilistic and not guaranteed
* **Gas Costs**: Front-running and back-running consume gas, making repeated attempts economically negative
* **MEV Competition**: Other MEV bots compete away profits in the mempool

The mathematical expectation of profit from timing attacks is negative when accounting for these factors.

---

## Randomness Model

PSM requires high-quality pseudorandomness for fair probabilistic selection. The system cannot rely on off-chain oracles due to the requirement for complete on-chain execution. Instead, it constructs deterministic entropy from multiple on-chain sources.

### Entropy Sources

```solidity
entropy = keccak256(
    block.timestamp,
    block.number,
    block.difficulty,      // or prevrandao post-merge
    previous_spin_hash,
    holder_merkle_root,
    total_supply
)
```

### Properties

**Deterministic**: Given identical blockchain state, the same entropy is always produced. This allows anyone to independently verify that selections were executed correctly.

**Unpredictable**: Future block parameters cannot be known at the time of the previous spin, preventing precomputation attacks.

**Bias Resistant**: Miners/validators cannot practically manipulate block parameters to target specific outcomes without forfeiting block rewards.

**Reproducible**: Historical spins can be re-executed to verify correctness using archived blockchain state.

### Selection Algorithm

The generated entropy is mapped to the weighted probability distribution using the following algorithm:

```python
def select_winner(entropy, weights):
    """
    Maps entropy to weighted probability distribution.
    
    Args:
        entropy: 256-bit pseudorandom value
        weights: dict mapping address -> weight
    
    Returns:
        Selected address or None
    """
    total_weight = sum(weights.values())
    
    if total_weight == 0:
        return None
    
    # Normalize entropy to [0, total_weight)
    selection_point = (entropy % total_weight)
    
    # Walk weighted distribution
    cumulative = 0
    for address, weight in weights.items():
        cumulative += weight
        if selection_point < cumulative:
            return address
    
    return None  # Should never reach
```

### Verifiability

Any observer can verify spin correctness by:

1. Retrieving blockchain state at the spin block
2. Recomputing eligibility and weights
3. Regenerating entropy from block parameters
4. Re-executing selection algorithm
5. Comparing result to emitted events

This transparency is fundamental to protocol legitimacy.

---

## Distribution Logic

When the selection algorithm identifies one or more recipients, the distribution mechanism executes token transfers according to configured rules.

### Single Winner Mode

In single winner mode, one address is selected per spin and receives the full reward allocation for that cycle.

```
reward_pool = 1000 tokens
winner = select_winner(entropy, weights)

if winner is not None:
    transfer(reward_pool, winner)
```

### Multi-Winner Mode

In multi-winner mode, multiple addresses may be selected in a single spin. The entropy is used to generate multiple independent selection values.

```
reward_pool = 1000 tokens
num_winners = 3
reward_per_winner = reward_pool / num_winners

for i in range(num_winners):
    entropy_i = keccak256(entropy, i)
    winner_i = select_winner(entropy_i, weights)
    
    if winner_i is not None:
        transfer(reward_per_winner, winner_i)
```

### Duplicate Handling

If the same address is selected multiple times in multi-winner mode, it receives multiple reward portions. This is intentional and reflects the proportional weight of that address.

### Edge Cases

**Empty Eligible Set**: If no addresses meet the minimum balance threshold, the spin completes with no distribution. Rewards accumulate for future cycles.

**Insufficient Reward Pool**: If the reward pool balance is below the minimum distribution amount, the spin completes with no distribution.

**Transfer Failure**: If a reward transfer fails (e.g., recipient contract reverts), the entire spin transaction reverts to maintain atomicity.

### Reward Pool Management

The reward pool is typically funded through:

* Transaction fees diverted from token transfers
* Protocol revenue from other mechanisms
* Manual deposits by protocol administrators
* Automated buyback and deposit contracts

The funding mechanism is independent of the distribution mechanism. PSM consumes whatever balance exists in the designated reward pool address.

---

## Security Properties

PSM is designed with several critical security invariants that must hold under all conditions.

### Core Invariants

```
╔═══════════════════════════════════════════════════════════════╗
║                      SECURITY INVARIANTS                      ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  [INV-1]  Total Supply Conservation                          ║
║           sum(balances) + reward_pool = TOTAL_SUPPLY         ║
║                                                               ║
║  [INV-2]  Non-Interactive Operation                          ║
║           No user signatures required for distribution       ║
║                                                               ║
║  [INV-3]  Deterministic Reproducibility                      ║
║           Same state -> Same spin result                     ║
║                                                               ║
║  [INV-4]  Forward Progress                                   ║
║           Spins always execute when interval elapsed         ║
║                                                               ║
║  [INV-5]  Atomic Distribution                                ║
║           All-or-nothing transfer semantics                  ║
║                                                               ║
║  [INV-6]  Zero User Gas Cost                                 ║
║           Recipients pay no gas for receiving rewards        ║
║                                                               ║
║  [INV-7]  Timing Attack Resistance                           ║
║           E[profit | timing attack] < 0                      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

### Non-Interactive Guarantees

The most critical security property is that recipients never need to take any action to receive rewards. This eliminates entire classes of attacks:

* **Phishing**: No approval transactions means no phishing vector
* **Gas Griefing**: Users cannot be forced to spend gas
* **Denial of Service**: Unclaimed rewards do not accumulate and cannot be griefed
* **Frontrunning Claims**: No claim transaction to frontrun

### Failure Modes

**Validator Censorship**: If validators consistently censor spin transactions, rewards accumulate but are not distributed. This does not break invariants but degrades UX. Mitigation requires social coordination or protocol-level validator incentives.

**Reward Pool Depletion**: If funding mechanisms fail, spins continue but distribute zero rewards. The protocol continues functioning but becomes economically uninteresting.

**Gas Limit Constraints**: If the eligible holder set grows beyond what can be processed in a single block, spins may fail. Mitigation requires either increasing gas limits or implementing holder set pagination.

**Smart Contract Vulnerabilities**: As with all smart contracts, implementation bugs may violate invariants. Formal verification and extensive auditing are critical.

### What Cannot Be Exploited

**Sybil Attacks**: Creating multiple addresses provides no advantage since weight is proportional to balance and time. Splitting tokens across addresses reduces the per-address weight proportionally.

**Timing Attacks**: As detailed previously, attempting to game spins via just-in-time trading is economically negative.

**Reward Manipulation**: The reward pool is a separate concern from the distribution mechanism. While the pool can be manipulated, the distribution remains fair according to the configured weights.

**Selection Bias**: Validators cannot practically bias selection toward specific addresses without provable on-chain manipulation that would forfeit block rewards.

---

## Comparison to Other Models

PSM represents a distinct approach to reward distribution with specific tradeoffs compared to alternative designs.

### Staking Systems

| Aspect | Staking | PSM |
|--------|---------|-----|
| User Action Required | Lock tokens in contract | None |
| Gas Costs | Stake + Unstake | Zero |
| Liquidity | Locked during staking | Always liquid |
| Complexity | High (delegation, slashing) | Low |
| Fairness | Proportional to stake | Probabilistic weighted |
| Capital Efficiency | Reduced | Full |

Staking systems require users to lock tokens, reducing liquidity and capital efficiency. PSM provides rewards without locking, maintaining full token liquidity.

### Snapshot Reward Systems

| Aspect | Snapshots | PSM |
|--------|-----------|-----|
| Claiming Required | Yes (manual claim) | No |
| Gas for Recipients | Yes (claim tx) | No |
| Timing Games | Yes (just-in-time) | No (time weighting) |
| Distribution Timing | Discrete events | Continuous |
| Coordination | Required | None |
| MEV Risk | High | Low |

Snapshot systems require manual claiming, which creates gas costs and coordination overhead. PSM eliminates claiming entirely through automatic distribution.

### Continuous Rebasing

| Aspect | Rebasing | PSM |
|--------|----------|-----|
| Balance Changes | All holders | Selected holders |
| Tax Implications | Potentially continuous | Discrete events |
| Integration Complexity | High (balance changes) | Low (standard transfers) |
| Reward Visibility | Automatic | Explicit events |
| Fair Distribution | Guaranteed | Probabilistic |

Rebasing tokens change all balances simultaneously, creating tax and integration challenges. PSM maintains standard transfer semantics.

### Manual Airdrops

| Aspect | Airdrops | PSM |
|--------|----------|-----|
| Automation | Manual | Fully automated |
| Frequency | Rare | Continuous |
| Cost | High (gas for sender) | Distributed |
| Predictability | None | Interval-based |
| Transparency | Variable | Complete |

Manual airdrops require human coordination and are expensive for senders. PSM automates distribution with predictable intervals.

### Why This Model Is Different

PSM combines the best properties of multiple approaches:

* **Automatic** like rebasing but with standard transfers
* **Fair** like staking but without locking
* **Gas-free** for recipients like staking but without claiming
* **Continuous** like rebasing but with discrete events
* **Engaging** through probabilistic selection rather than guaranteed allocation

The core innovation is recognizing that probabilistic asymmetric distribution over time can achieve both fairness and engagement without the drawbacks of deterministic systems.

---

## Configuration Parameters

The PSM protocol exposes several tunable parameters that control distribution behavior. These are typically set at contract deployment but may be adjustable through governance mechanisms.

### Parameter Table

```
╔════════════════════════════════════════════════════════════════════════════╗
║                           CONFIGURATION PARAMETERS                         ║
╠════════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  Parameter              │  Type      │  Default      │  Description        ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  SPIN_INTERVAL          │  uint256   │  3600         │  Seconds between    ║
║                         │            │               │  automatic spins    ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  MIN_BALANCE            │  uint256   │  1000 * 10^18 │  Minimum tokens     ║
║                         │            │               │  for eligibility    ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  MAX_TIME_WEIGHT        │  uint256   │  2.0          │  Maximum time       ║
║                         │            │               │  multiplier         ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  TIME_WEIGHT_DURATION   │  uint256   │  86400        │  Seconds to reach   ║
║                         │            │               │  max time weight    ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  NUM_WINNERS            │  uint8     │  1            │  Winners per spin   ║
║                         │            │               │                     ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  REWARD_AMOUNT          │  uint256   │  Variable     │  Tokens distributed ║
║                         │            │               │  per spin           ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  NO_REWARD_PROBABILITY  │  uint256   │  0.7          │  Probability of     ║
║                         │            │               │  no distribution    ║
║  ──────────────────────────────────────────────────────────────────────   ║
║  DECAY_RATE             │  uint256   │  0.5          │  Duration decay on  ║
║                         │            │               │  transfer           ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
```

### Interval Length

The spin interval determines how frequently the slot machine operates. Shorter intervals provide more frequent distribution opportunities but increase gas consumption. Longer intervals reduce frequency but may decrease engagement.

Recommended ranges:
* High frequency: 300-1800 seconds (5-30 minutes)
* Medium frequency: 3600-14400 seconds (1-4 hours)
* Low frequency: 86400+ seconds (1+ days)

### Reward Pool Sizing

The reward amount per spin should be calibrated to token economics and holder expectations. Too small and recipients feel unrewarded; too large and the pool depletes rapidly.

A typical heuristic is:

```
reward_per_spin = (daily_protocol_revenue * allocation_percentage) / (86400 / spin_interval)
```

### Time Weight Curves

The time weighting function can take several forms:

**Linear**:
```
weight = min(duration / MAX_DURATION, 1.0)
```

**Exponential**:
```
weight = 1 - exp(-duration / TIME_CONSTANT)
```

**Logarithmic**:
```
weight = log(1 + duration) / log(1 + MAX_DURATION)
```

Linear is simplest to understand. Exponential provides stronger early incentives. Logarithmic flattens at longer durations.

### Probability Tuning

The NO_REWARD_PROBABILITY parameter controls how often spins result in no distribution. Higher values create rarer but more significant reward events. Lower values provide more frequent but potentially less engaging distributions.

```
# Example: 70% no-reward probability
# Expected distribution:
# 70% of spins: no reward
# 30% of spins: reward distributed
```

---

## Implementation Notes

Implementing PSM requires careful attention to gas optimization, storage patterns, and edge case handling.

### Smart Contract Considerations

**Holder Enumeration**: Efficiently enumerating all token holders is non-trivial. Options include:

1. **Linked List**: Maintain an on-chain linked list of non-zero balance addresses. Update on every transfer.
2. **Off-Chain Index**: Build holder set off-chain and submit Merkle proof of eligibility.
3. **Sampling**: Randomly sample from balance mapping keys rather than enumerating all.

Each approach has tradeoffs in gas cost, complexity, and security.

**Weight Computation**: Calculating time weights for many addresses in a single transaction may exceed gas limits. Mitigation strategies:

1. **Cached Weights**: Precompute and cache weights, updating incrementally
2. **Pagination**: Split weight computation across multiple transactions
3. **Approximate Sampling**: Select subset of holders rather than complete set

**State Storage**: Holding durations must be tracked per address. Optimize storage:

```solidity
struct HoldingInfo {
    uint128 balance;           // Sufficient for most tokens
    uint64 firstAcquisition;   // Block timestamp (uint32 until 2106)
    uint64 lastTransfer;       // Block timestamp
}

mapping(address => HoldingInfo) holdings;
```

### Gas Constraints

Target spin costs:

* **Simple spin (no distribution)**: < 50,000 gas
* **Single winner distribution**: < 100,000 gas
* **Multi-winner distribution**: < 200,000 gas

If holder set processing exceeds these budgets, implement pagination or sampling.

### Events

Emit comprehensive events for off-chain indexing:

```solidity
event SpinExecuted(
    uint256 indexed spinId,
    uint256 timestamp,
    bytes32 entropy,
    uint256 eligibleHolders
);

event RewardDistributed(
    uint256 indexed spinId,
    address indexed recipient,
    uint256 amount
);

event NoReward(
    uint256 indexed spinId,
    bytes32 entropy
);
```

### Testing Strategies

* **Determinism Tests**: Verify identical state produces identical results
* **Fairness Tests**: Simulate thousands of spins, verify distribution matches weights
* **Gas Tests**: Measure costs at various holder set sizes
* **Edge Cases**: Zero holders, single holder, massive holder set
* **Attack Vectors**: Attempt timing attacks, verify negative expectation

---

## Open Source Philosophy

PSM is released as open source to enable maximum transparency, security, and composability.

### Why Transparency Matters

Probabilistic selection mechanisms require absolute trust in their implementation. Closed-source systems cannot prove fairness or resist accusations of bias. Open source enables:

* **Auditing**: Security researchers can verify implementation correctness
* **Reproducibility**: Anyone can re-execute historical spins
* **Trust Minimization**: Cryptographic verification replaces institutional trust
* **Community Participation**: Developers can contribute improvements

### What Can Be Audited

Complete transparency of:

* Selection algorithm implementation
* Entropy generation process
* Weight computation logic
* Distribution execution
* Parameter configuration
* Historical spin results

Any discrepancy between claimed and actual behavior can be detected through independent verification.

### Composability

Open source enables other protocols to integrate PSM:

* Build alternate frontends
* Create wrapper contracts
* Implement custom funding mechanisms
* Develop analytics tools
* Fork for different token standards

This composability benefits the entire ecosystem.

---

## Limitations

PSM explicitly does not attempt to solve certain problems and has known limitations.

### Not Attempted

**Governance**: PSM is purely a distribution mechanism. It does not implement token voting, parameter adjustment, or protocol governance.

**Funding**: The reward pool must be funded by external mechanisms. PSM consumes but does not generate rewards.

**Yield Generation**: PSM redistributes existing tokens. It does not create yield, interest, or new tokens beyond configured minting.

**Account Abstraction**: Recipients must be standard addresses capable of receiving transfers. Contract wallets with complex logic may not be compatible.

**Cross-Chain**: PSM operates on a single chain. Cross-chain distribution requires external bridge mechanisms.

### Known Constraints

**Holder Set Size**: Performance degrades with very large holder sets (>10,000 addresses). Requires optimization or sampling strategies.

**Centralization Risk**: Contract deployers control parameter configuration unless governance is implemented. Users must trust initial parameterization.

**Oracle Dependency**: If additional entropy from oracles is desired, introduces external dependencies and failure modes.

**Gas Price Volatility**: High gas prices make frequent spins expensive. May require dynamic interval adjustment.

**Block Reorganizations**: Deep reorgs may invalidate historical spin results. Applications should wait for finality.

### Edge Cases Not Handled

* **Recipient Contract Reverts**: If a recipient is a contract that reverts on receive, the entire spin fails
* **Token Pausing**: If the underlying token implements pausing, distributions may fail
* **Reentrancy**: Standard reentrancy protections required but may not cover all scenarios
* **Dust Accumulation**: Over time, precision loss may result in dust tokens being locked

These limitations are acceptable tradeoffs for the benefits PSM provides.

---

## Future Extensions

While the core PSM mechanism is complete, several extensions could enhance functionality.

### Multi-Slot Machines

Run multiple independent slot machines with different parameters:

```
Machine A: High frequency, small rewards, low minimum
Machine B: Low frequency, large rewards, high minimum  
Machine C: Variable frequency, escalating rewards
```

Each machine maintains separate state and reward pools. Holders are automatically eligible for all machines they qualify for.

### Variable Reels

Implement multiple "reels" with different selection algorithms:

```
Reel 1: Pure balance weighting
Reel 2: Pure time weighting
Reel 3: Hybrid weighting
Reel 4: Random uniform selection
```

Each spin could use a different reel, selected by entropy. This creates varied reward patterns while maintaining overall fairness.

### Composability Hooks

Allow external contracts to hook into spin events:

```solidity
interface ISpinHook {
    function onSpinComplete(
        uint256 spinId,
        address[] winners,
        uint256[] amounts
    ) external;
}
```

Enables building:
* Leaderboards tracking largest recipients
* Notification systems for winners
* Secondary reward mechanisms
* Analytics and reporting tools

### Dynamic Parameters

Implement on-chain parameter adjustment based on observable metrics:

```
if reward_pool_balance < threshold:
    increase spin_interval
    
if gas_price > threshol