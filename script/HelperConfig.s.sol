// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 1. Deploy mocs when we are on local anvil chain
// 2. Keep track of contract adress across different chains

// Sepolia ETH/USD
// Mainnet ETH/USD

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on the local anvil, we deploy mocs
    // Otherwise, grab the existing address from the live network

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 3300e8;

    struct NetworkConfig {
        address priceFeed; // price feed adress for ETH/USD pair
    }

    constructor() {
        if (block.chainid == 11155111) { // sepolia chainid = 11155111
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) { // mainnet eth chainid = 1
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        // price feed address
        NetworkConfig memory mainnetEthConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return mainnetEthConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        // price feed address

        // 1. Deploy the mocs (fake contract)
        // 2. Return the mock address

        // address(0) = 0x0000000000000000000000000000000000000000
        // When a variable of type address is declared but not explicitly initialized, its default value is the null address.

        if (activeNetworkConfig.priceFeed != address(0)) { // the configuration already exists, and the function simply returns this existing configuration.
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}