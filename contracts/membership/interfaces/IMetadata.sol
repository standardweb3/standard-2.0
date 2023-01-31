
pragma solidity ^0.8.10;

interface IMetadata {
    function uri(uint256 _id) external view returns (string memory);
}