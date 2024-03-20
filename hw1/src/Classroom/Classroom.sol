// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* Problem 1 Interface & Contract */
contract StudentV1 {
    uint256 public code;

    function register() external returns (uint256) {
        code = 123;
        return code;
    }
}

/* Problem 2 Interface & Contract */
contract StudentV2 {
    function register() external view returns (uint256) {
        return 123;
    }
}

/* Problem 3 Interface & Contract */
contract StudentV3 {
    function register() external view returns (uint256) {
        return 123;
    }
}
