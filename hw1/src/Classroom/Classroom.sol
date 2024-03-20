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

/* Testing contract */
contract ClassroomTest {
    ClassroomV1 internal class1;
    ClassroomV2 internal class2;
    ClassroomV3 internal class3;

    address internal user;

    constructor() {
        class1 = new ClassroomV1();
        class2 = new ClassroomV2();
        class3 = new ClassroomV3();

        user = address(this);
        // Assuming some initialization needs to be done for user
    }

    /* Problem 1 Test */
    function test_check_student_v1() public {
        StudentV1 student = new StudentV1();
        class1.enroll(address(student));

        assert(class1.code() == 123);
        // Log or emit events for better debugging
    }

    /* Problem 2 Test */
    function test_check_student_v2() public {
        StudentV2 student = new StudentV2();
        class2.enroll(address(student));

        assert(class2.code() == 123);
        // Log or emit events for better debugging
    }

    /* Problem 3 Test */
    function test_check_student_v3() public {
        StudentV3 student = new StudentV3();
        class3.enroll(address(student));

        assert(class3.code() == 123);
        // Log or emit events for better debugging
    }
}
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
