// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

    function getPrice() public view returns (uint) {

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

        (,int price,,,) = priceFeed.latestRoundData();

        return uint(price * 10**10);

        // 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e

    }

    function getVersion() public view returns  (uint) {
            AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
            return priceFeed.version();
    }    

    function getConversionRate(uint ethAmount) public view returns(uint) {
        uint ethPrice = getPrice();
        // 50 dollar => 1/60 eth
        // 3000 dollar =>  1 eth
        uint ethAmountInUSD = (ethPrice * ethAmount) / 1 ether;

        return ethAmountInUSD;
    }

}