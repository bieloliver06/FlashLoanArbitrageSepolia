// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IDex {
    function depositUSD(uint256 _amount) external;

    function depositDAI(uint256 _amount) external;

    function buyDAI() external;

    function sellDAI() external;
}

contract FlashLoanSepolia is FlashLoanSimpleReceiverBase {
    address payable owner;

    // Aave ERC20 Görli token addresses
    address private immutable daiAddress = 0x68194a729C2450ad26072b3D33ADaCbcef39D574;
    address private immutable usdcAddress = 0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f;
    address private dexAddress;

    IERC20 private dai;
    IERC20 private usdc;
    IDex private dex;

    constructor(address _addressProvider, address dexAddress) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
        dexAddress = dexAddress;

        dai = IERC20(daiAddress);
        usdc = IERC20(usdcAddress);
        dex = IDex(dexAddress);
    }

    function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
    ) external returns (bool) {
        dex.depositUSD(10000000000000);
        dex.buyDAI();
        dex.depositDAI(dai.balanceOf(address(this)));
        dex.sellDAI();

        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public onlyOwner {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function approveUSDC(uint256 _amount) external returns (bool) {
        return usdc.approve(dexAddress, _amount);
    }

    function allowanceUSDC() external view returns (uint256) {
        return usdc.allowance(address(this), dexAddress);
    }

    function approveDAI(uint256 _amount) external returns (bool) {
        return dai.approve(dexAddress, _amount);
    }

    function allowanceDAI() external view returns (uint256) {
        return dai.allowance(address(this), dexAddress);
    }

    function getBalance(address _token) external view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function withdraw(address _token) external onlyOwner {
        IERC20 token = IERC20(_token);
        IERC20(_token).transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    receive() external payable {}

}