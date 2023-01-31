
pragma solidity ^0.8.10;

// helper methods for composing attributes for an nft
library Meta {

  function formatNumericTrait(string memory traitType, string memory value) internal pure returns (string memory trait) {
    trait = string(
        abi.encodePacked(
          '{',
            '"trait_type": "',
            traitType,
            '",' 
            '"value": ',
            value,
          '}'
        )
    );
  }

  function formatTrait(string memory traitType, string memory value) internal pure returns (string memory trait) {
    trait = string(
        abi.encodePacked(
          '{',
            '"trait_type": "',
            traitType,
            '",' 
            '"value": "',
            value,
            '"',
          '}'
        )
    );
  }

   function formatDisplay(string memory displayType, string memory traitType, string memory value) internal pure returns (string memory trait) {
    trait = string(
        abi.encodePacked(
          '{',
            '"display_type": "',
            displayType,
            '",'
            '"trait_type": "',
            traitType,
            '",' 
            '"value": "',
            value,
            '"',
          '}'
        )
    );
  }

  function formatTokenAttributes(
    NFTSVG.BlParams memory blParam,
    NFTSVG.HealthParams memory hParam,
    NFTSVG.CltParams memory cltParam) internal pure returns (bytes memory attributes) {
      bytes memory attributes1=
        abi.encodePacked(
                '"attributes": [',
                formatNumericTrait('Collateral Amount', blParam.cBlStr),
                ',',
                formatDisplay('date', 'Last Updated', blParam.lastUpdated),
                ',',
                formatTrait('Collateral', blParam.name),
                ',',
                formatTrait('IOU', 'MeterUSD'),
                ',',                
                formatTrait('HP Status', hParam.HPStatus),
                ',',
                formatNumericTrait('IOU Amount', blParam.dBlStr),
                ','
        );
      attributes = abi.encodePacked(
        attributes1,
        formatNumericTrait('HP', hParam.rawHP.toString()),
        ',',
        formatTrait('Min. Collateral Ratio', 
        string(
          abi.encodePacked(
            cltParam.MCR,
            "%"
          ))),
        ',',
        formatTrait('Liquidation Fee',
        string(
          abi.encodePacked(
            cltParam.LFR,
            "%"
          ))),
        ',',
        formatTrait('Stability Fee',
        string(
          abi.encodePacked(
            cltParam.SFR,
            "%"
          ))),
        ']'
      );
    }

  function formatTokenURI(
    uint256 tokenId,
    NFTSVG.ChainParams memory cParam,
    NFTSVG.BlParams memory blParam,
    NFTSVG.HealthParams memory hParam,
    NFTSVG.CltParams memory cltParam
  ) internal pure returns (string memory) {
    bytes memory image = abi.encodePacked(
      '{"name":"',
      'VaultOne #',
      tokenId.toString(),
      '",',
      '"description":"VaultOne represents the ownership of',
      " one's financial rights written in an immutable smart contract. ",
      "Only the holder can manage and interact with the funds connected to its immutable smart contract",
      '",',
      //https://artsandscience.standard.tech/nft/V1/4/0
      '"image": "https://raw.githubusercontent.com/digitalnativeinc/nft-arts/main/V1/backgrounds/1088.png",',
      '"image_url": "https://artsandscience.standard.tech/nft/V1/',
      cParam.chainId,
      '/',
      tokenId.toString(),
      '.svg",',
      formatTokenAttributes(blParam, hParam, cltParam),
      ','          
    );
    return
      string(
        abi.encodePacked(
          "data:application/json;base64,",
          Base64.encode(
            bytes(
              abi.encodePacked(
                image,
                '"chainId":"',
                cParam.chainId,
                '",',
                '"vault":"',
                blParam.vault,
                '",',
                '"collateral":"',
                cParam.collateral,
                '",',
                '"debt":"',
                cParam.debt,
                '"',
                '}'
              )
            )
          )
        )
      );
  }

  function tokenURI(uint256 tokenId)
    external
    view
    override
    returns (string memory)
  {
    (
      NFTSVG.ChainParams memory cParams,
      NFTSVG.BlParams memory blParams,
      NFTSVG.HealthParams memory hParams,
      NFTSVG.CltParams memory cltParams
    ) = INFTConstructor(NFTConstructor).generateParams(tokenId);
    return formatTokenURI(tokenId, cParams, blParams, hParams, cltParams);
  }
}