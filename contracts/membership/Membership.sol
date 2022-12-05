// SPDX-License-Identifier: Apache-2.0

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Membership is ERC1155, AccessControl {

    uint256 immutable one = 1;

    constructor() public ERC1155("https://arts.standard.tech/") {
         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setDefaultURI(string memory newuri) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _setURI(newuri);
    }

    function mint(address to) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(to, one, 1, "");
    }

    function setProfile(uint256 id, uint256 metaId) public {
        require(balanceOf(msg.sender, id) == 1, "not owned");
        // sender is subscribed

        // Then Call Meta contract to set profile
    }


    
    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC1155) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            interfaceId == type(IAccessControl).interfaceId ||
            super.supportsInterface(interfaceId);
    }

}