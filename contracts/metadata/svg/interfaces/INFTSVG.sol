

pragma solidity ^0.8.0;

interface INFTSVG {
   function tokenURI(uint256 tokenId) external view returns (string memory);
}