// SPDX-License-Identifier: Apache-2.0

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Meta is ERC1155, AccessControl {

    // meta data index for each subscription
    uint256 index;

    // address of the membership contract
    address membership;

    mapping(uint256 => Meta) meta; 
    mapping(address => uint256) profile;

    struct Meta {
        bytes uri;
        bool isAddr;
    }

    constructor() public ERC1155("https://arts.standard.tech/") {
         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setMembership(address membership_) public onlyRole(DEFAULT_ADMIN_ROLE) {
        membership = membership_;
    }

    function setDefaultURI(string memory newuri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _setURI(newuri);
    }

    function setMetaURI(uint256 metaId, bytes memory newMeta, bool isAddr) public onlyRole(DEFAULT_ADMIN_ROLE) {
        meta[metaId] =Meta({
            uri: newMeta,
            isAddr: isAddr
        });
    }

    // Set profile picture
    function setPFP(uint256 metaId, address sender) public {
        // can only be called by membership contract
        require(msg.sender == membership, "IA");
        // set metaId to the user profile
        profile[sender] = metaId;
    }

    function mint(address to, uint256 metaId) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(to, metaId, 1, "");
    }
    
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1155) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            interfaceId == type(IAccessControl).interfaceId ||
            super.supportsInterface(interfaceId);
    }

}