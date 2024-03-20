pragma solidity ^0.8.0;

contract StudentV1 {
    uint256 public registrationCode;

    function register() external returns (uint256) {
        registrationCode = 123;
        return registrationCode;
    }
}
contract StudentV2 {
    function register() external view returns (uint256) {
        return 123;
    }
}
contract StudentV3 {
    function register() external view returns (uint256) {
        return 123;
    }
}
