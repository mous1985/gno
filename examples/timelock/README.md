# Timelock 

This repository contains the implementation of a Timelock realm. The Timelock contract ensures that certain operations can only be executed after a predefined period, enhancing security and governance.


## Project Structure
p
├── demo
│ ├── accesscontrol
│ │ └── accesscontrol.gno
│ └── timelock
│ │ └── timelock.gno

### 1. Implement the AccessControl Package

Create the `p/demo/accesscontrol/accesscontrol.gno` file to manage roles and permissions. Ensure it supports granting, revoking, and checking roles.

### 2. Implement the Timelock package 

Create the `p/demo/timelock/timelock.gno` file with the following functionalities:
- Set up the timelock mechanism.
- Provide functions to create and release timelocks.
- Ensure only authorized roles can execute critical functions.

## Deployment and Usage

1. **Deploy the AccessControl Package**:
   import `p/demo/accesscontrol` .

2. **Deploy the Timelock Realm**:
   Finally, deploy the `p/demo/timelock`

