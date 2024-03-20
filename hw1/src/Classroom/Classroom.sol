pragma solidity ^0.8.0;

/* Problem 1 Contract */
contract ClassroomV1 {
    uint256 public code = 1000;
    bool public isEnrolled;

    function enroll(address student) public {
        uint256 studentCode = StudentV1(student).register();
        if (studentCode >= code && !isEnrolled) {
            isEnrolled = true;
            code = studentCode;
        }
    }
}

/* Problem 2 Contract */
contract ClassroomV2 {
    uint256 public code = 1000;
    bool public isEnrolled;

    function enroll(address student) public {
        uint256 studentCode = StudentV2(student).register();
        if (studentCode >= code && !isEnrolled) {
            isEnrolled = true;
            code = studentCode;
        }
    }
}

/* Problem 3 Contract */
contract ClassroomV3 {
    uint256 public code = 1000;
    bool public isEnrolled;

    function enroll(address student) public {
        uint256 studentCode = StudentV3(student).register();
        if (studentCode >= code) {
            isEnrolled = true;
            code = studentCode;
        }
    }
}
