// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConvertor {
    

function getPrice() internal view returns (uint256) {
        (, uint256 price, , , ) = Aggregatorv3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        ).latestRoundData();
        //ethereum chain pricefeed
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();

        uint256 ethPriceInUsd = (ethAmount * ethPrice) / 1e18;
        return ethPriceInUsd;
    }

    function getVersion() internal view returns (uint256) {

        // for anything we required abi and address
        // interface provieds the abi the address is the pricefeed address
        
        return
            Aggregatorv3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();

            
    }
}
    