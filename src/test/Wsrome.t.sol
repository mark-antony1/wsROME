// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "../wsROME.sol";
import "../../interfaces/IERC20.sol";
import "../../interfaces/IROME.sol";
import "../../interfaces/IsROME.sol";

interface Vm {
    function store(address,bytes32,bytes32) external;
    function deal(address who, uint256 amount) external;
    function prank(address sender) external;
    function expectRevert(bytes calldata) external;
}

interface IStaking {
    function stake( uint _amount ) external;
}

interface IwsROME {
    function wrap(uint256 _amount) external returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function unwrap(uint256 _amount) external returns (uint256);
}

contract wsROMETest is DSTest {
    using SafeERC20 for ERC20;
    address wsROME;
    address sROME;
    address ROME;
    address staking;

    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function setUp() public {
        wsROME = 0xCa76543Cf381ebBB277bE79574059e32108e3E65;
        sROME = 0x31932E6e45012476ba3A3A4953cbA62AeE77Fbbe;
        ROME =  0x383518188C0C6d7730D91b2c03a03C837814a899;
        staking = 0xC8C436271f9A6F10a5B80c8b8eD7D0E8f37a612d;
    }

    function testWrap(uint64 x) public {
        vm.prank(0x31F8Cc382c9898b273eff4e0b7626a6987C846E8);
        x = x/(10**18);
        IROME(ROME).mint(address(this), uint256(x));
        uint256 romeBalance = IROME(ROME).balanceOf(address(this));
        assertEq(romeBalance, x);
        IROME(ROME).approve(address(staking), x);

        IStaking(staking).stake(uint256(x));
        uint256 sRomeBalance = IsROME(sROME).balanceOf(address(this));
        assertLe(0, sRomeBalance);

        IwsROME(wsROME).wrap(sRomeBalance);
        uint256 wsRomeBalance = IwsROME(wsROME).balanceOf(address(this));
        assertLe(0, wsRomeBalance);

        IwsROME(wsROME).unwrap(wsRomeBalance);
        wsRomeBalance = IwsROME(wsROME).balanceOf(address(this));
        assertEq(wsRomeBalance, 0);
    }
}
