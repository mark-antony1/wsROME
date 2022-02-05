// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "ds-test/test.sol";
import { wsROME } from "../../wsROME.sol";

interface Vm {
    function store(address,bytes32,bytes32) external;
    function deal(address who, uint256 amount) external;
}


interface IERC20 {
    function balanceOf(address acount) external returns (uint256);
}

contract FindSlot is DSTest {
		wsROME wsrome;

		function setUp() public {
        wsrome = new wsROME(0x3a3eE61F7c6e1994a2001762250A5E17B2061b6d);
    }

    function find_slot() public {
        Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        address TOKEN = address(0x3a3eE61F7c6e1994a2001762250A5E17B2061b6d);
        IERC20 token = IERC20(TOKEN);

        uint256 index;
        for (uint256 i = 0; i < 100; i++) {
            vm.store(
                TOKEN,
                keccak256(
                    abi.encode(
                        0x3a3eE61F7c6e1994a2001762250A5E17B2061b6d,
                        uint256(i)
                    )
                ),
                bytes32(uint256(10 * 1e6))
            );
            uint256 balance = token.balanceOf(
                0x3a3eE61F7c6e1994a2001762250A5E17B2061b6d
            );
            if (balance == 10 * 1e6) {
                index = i;
                break;
            }
        }

        assertEq(2, index);
    }
}