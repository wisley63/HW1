pragma solidity ^0.8.0;

contract StudentV1 {
    uint256 public registrationCode;
    bool cool = false;
    function register() external returns (uint256) {
        if (!cool) {
            cool = true;
            registrationCode = 1000;
        } else {
            registrationCode = 123;
        }
        return registrationCode;
    }
}
interface IV2{
    function isEnrolled() external returns(bool);
}
contract StudentV2 {
    function register() external returns (uint256) {
        if (IV2(msg.sender).isEnrolled()) {
            return 123;
        } else {
            return 1000;
        }
    }
}

contract StudentV3 {
    function register() external view returns (uint256) {
        if (gasleft() == 7194) {
            return 1000;
        } else {
            return 123;
        }
    }
}
