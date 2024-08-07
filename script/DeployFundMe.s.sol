// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    // In a deployment script, run contains the logic to deploy contracts, manage transactions, and set up the environment.
    function run() external returns(FundMe) {
        // Before startBroadcast isn't included in real transaction
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast(); // Signals the start of recording transactions. This is a Foundry-specific function that tells the Foundry virtual machine (VM) to start recording all transactions. It allows the script to perform actions that can be replayed or analyzed.
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast(); // Signals the end of the transaction recording. This stops the recording of transactions.
        return fundMe;
    }
}