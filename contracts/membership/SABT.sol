
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


/// @author Hyungsuk Kang <hskang9@github.com>
/// @title Standard Account Bound Token
contract SABT is ERC1155, AccessControl {

    /// @dev memberStatus: The status of the SABT. 0 for unregistered, 1 for registered, 2 for subscribed
    mapping (uint256 => uint256) public status;

    constructor() public ERC1155("https://arts.standard.tech/") {
         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @dev uri: Return the uri of the token
    function uri(uint256) public view virtual override returns (string memory) {
        return IMetadata(metadata).uri();
    }

    /// @dev mintCustom: Mint a new custom SABT for customized membership
    /// @param to_ The address to mint the token to
    /// @param id_ The id of the token to mint
    function mintCustom(address to_, uint256 id_) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(to_, id_, 1, "");
    }

    /// @dev mint: Mint a new SABT for a new member
    /// @param to_ The address to mint the token to
    function mint(address to_) public onlyRole(DEFAULT_ADMIN_ROLE) returns (uint256) {
        _mint(to_, 0, 1, "");
        return id;
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1155) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            interfaceId == type(IAccessControl).interfaceId ||
            super.supportsInterface(interfaceId);
    }

}