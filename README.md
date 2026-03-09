Eviction Vault Hardening Challenge

Refactor Summary
- Contract split into modular architecture
- Storage separated
- Core user functions isolated
- Governance logic isolated

Security Fixes
- Removed tx.origin
- Replaced transfer with call
- Restricted setMerkleRoot
- Restricted emergencyWithdrawAll

Tests
- Deposit
- Withdraw
- Owner permissions
- Emergency withdraw