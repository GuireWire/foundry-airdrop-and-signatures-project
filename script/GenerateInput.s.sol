// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

// Merkle tree input file generator script
contract GenerateInput is Script {
    uint256 private constant AMOUNT = 25 * 1e18; //setting the amount we want our addresses to be able to claim
    string[] types = new string[](2); // types of the values in the trees - in this case it'll be address, and amount
    uint256 count; //number of addresses able to claim
    string[] whitelist = new string[](4); //an array of addresses which is going to be setting as the addresses which will be able to claim
    string private constant INPUT_PATH = "/script/target/input.json"; //this prints our MerkleTree inputs to the location of input.json file

    function run() public {
        types[0] = "address";
        types[1] = "uint";
        whitelist[0] = "0xe909C3c8eC96C25Dc663B784040C4Eb99276E801"; //this is sepolia account1 address //0-3 are the 4 addresses we are saying that they can airdrop the BagelTokens
        whitelist[1] = "0x1b694f02481c9680035AE9E4B37be3DC7F738e8B"; //this is sepolia account2 address
        whitelist[2] = "0xe2601b2c271c94602ac95dDd68ab5f3CDbccb8Bf"; //this is zksync account1 address
        whitelist[3] = "0x718e48BC353433b0bAfbbe47Ed9404D8A0E326ab"; //this is zksync account2 address
        count = whitelist.length;
        string memory input = _createJSON(); //this creates the input.json file
        // this writes to the output file the stringified output json tree dumpus
        vm.writeFile(string.concat(vm.projectRoot(), INPUT_PATH), input);

        console.log("DONE: The output is found at %s", INPUT_PATH);
    }

    function _createJSON() internal view returns (string memory) {
        string memory countString = vm.toString(count); // convert count to string
        string memory amountString = vm.toString(AMOUNT); // convert amount to string
        string memory json = string.concat('{ "types": ["address", "uint"], "count":', countString, ',"values": {');
        for (uint256 i = 0; i < whitelist.length; i++) {
            if (i == whitelist.length - 1) {
                json = string.concat(
                    json,
                    '"',
                    vm.toString(i),
                    '"',
                    ': { "0":',
                    '"',
                    whitelist[i],
                    '"',
                    ', "1":',
                    '"',
                    amountString,
                    '"',
                    " }"
                );
            } else {
                json = string.concat(
                    json,
                    '"',
                    vm.toString(i),
                    '"',
                    ': { "0":',
                    '"',
                    whitelist[i],
                    '"',
                    ', "1":',
                    '"',
                    amountString,
                    '"',
                    " },"
                );
            }
        }
        json = string.concat(json, "} }");

        return json;
    }
}
