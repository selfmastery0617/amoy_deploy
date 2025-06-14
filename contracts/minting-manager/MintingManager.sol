// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

import "../metatx/ERC2771Context.sol";
import "../roles/MinterRole.sol";
import "../utils/Blocklist.sol";
import "../registry/interfaces/IFNSRegistry.sol";
import "./interfaces/IMintingManager.sol";
import "../utils/Pausable.sol";

/**
 * @title MintingManager
 * @dev Defines the functions for distribution of Top Level Domains and Second Level Domains
 */
contract MintingManager is ERC2771Context, MinterRole, Blocklist, Pausable, IMintingManager {
    string public constant NAME = "FNS: Minting Manager";
    string public constant VERSION = "1.4.0";

    string private constant _itemTypeProperty = "itemType";
    string private constant _tldPropertyValue = "TLD";
    string private constant _sldPropertyValue = "SECOND_LEVEL_DOMAIN";

    IFNSRegistry public fnsRegistry;

    function _mintTopLevelDomain(address to, string calldata tld) private {
        uint256 tokenId = _createTokenId(tld);
        _beforeMinting(tokenId);
        fnsRegistry.mintWithProperties(
            to, tokenId, string(abi.encodePacked(tld)), _getItemTypePropertyKey(), _getTLDPropertyValue()
        );
    }

    function _mintTopLevelDomainWithRecords(
        address to,
        string calldata tld,
        string[] calldata keys,
        string[] calldata values
    ) private {
        uint256 tokenId = _createTokenId(tld);
        _beforeMinting(tokenId);

        fnsRegistry.mintWithRecordsAndProperties(
            to, tokenId, string(abi.encodePacked(tld)), keys, values, _getItemTypePropertyKey(), _getTLDPropertyValue()
        );
    }

    function _mintSecondLevelDomain(address to, string calldata tld, string calldata label) private {
        uint256 tokenId = _createTokenId(tld, label);
        _beforeMinting(tokenId);

        fnsRegistry.mintWithProperties(
            to, tokenId, _getUri(tld, label), _getItemTypePropertyKey(), _getSLDPropertyValue()
        );
    }

    function _mintSecondLevelDomainWithRecords(
        address to,
        string calldata tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values
    ) private {
        uint256 tokenId = _createTokenId(tld, label);
        _beforeMinting(tokenId);

        fnsRegistry.mintWithRecordsAndProperties(
            to, tokenId, _getUri(tld, label), keys, values, _getItemTypePropertyKey(), _getSLDPropertyValue()
        );
    }

    function _safeMintSecondLevelDomain(address to, string calldata tld, string calldata label, bytes memory data)
        private
    {
        uint256 tokenId = _createTokenId(tld, label);
        _beforeMinting(tokenId);

        fnsRegistry.safeMint(to, tokenId, _getUri(tld, label), data);
    }

    function _safeMintSecondLevelDomainWithRecords(
        address to,
        string calldata tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values,
        bytes memory data
    ) private {
        uint256 tokenId = _createTokenId(tld, label);
        _beforeMinting(tokenId);

        fnsRegistry.safeMintWithRecords(to, tokenId, _getUri(tld, label), keys, values, data);
    }

    function _createTokenId(string memory tld, string memory label) internal pure returns (uint256) {
        require(bytes(tld).length != 0, "MintingManager: TLD_EMPTY");
        require(bytes(label).length != 0, "MintingManager: LABEL_EMPTY");
        return uint256(keccak256(abi.encodePacked(tld, keccak256(abi.encodePacked(label)))));
    }

    function _createTokenId(string memory tld) internal pure returns (uint256) {
        require(bytes(tld).length != 0, "MintingManager: TLD_EMPTY");
        return uint256(keccak256(abi.encodePacked(tld)));
    }

    function _msgSender() internal view override(ContextUpgradeable, ERC2771Context) returns (address) {
        return super._msgSender();
    }

    function _msgData() internal view override(ContextUpgradeable, ERC2771Context) returns (bytes calldata) {
        return super._msgData();
    }

    function _getUri(string calldata tld, string calldata label) private pure returns (string memory) {
        return string(abi.encodePacked(label, ".", tld));
    }

    function _getFullNameUri(string calldata fullname) private pure returns (string memory) {
        return string(abi.encodePacked(fullname));
    }

    function _beforeMinting(uint256 tokenId) private {
        if (!isBlocklistDisabled()) {
            require(isBlocked(tokenId) == false, "MintingManager: TOKEN_BLOCKED");
            _block(tokenId);
        }
    }

    function _getItemTypePropertyKey() private pure returns (string[] memory) {
        string[] memory propKeys = new string[](1);
        propKeys[0] = _itemTypeProperty;

        return propKeys;
    }

    function _getTLDPropertyValue() private pure returns (string[] memory) {
        string[] memory propKeys = new string[](1);
        propKeys[0] = _tldPropertyValue;

        return propKeys;
    }

    function _getSLDPropertyValue() private pure returns (string[] memory) {
        string[] memory propKeys = new string[](1);
        propKeys[0] = _sldPropertyValue;

        return propKeys;
    }

    /// @dev initializes the contract setting the registry address and the forwarder address.
    /// @param fnsRegistry_ address of the FNSRegistry contract.
    /// @param forwarder address of the forwarder contract.
    function initialize(IFNSRegistry fnsRegistry_, address forwarder) public initializer {
        fnsRegistry = fnsRegistry_;

        __Ownable_init_unchained();
        __MinterRole_init_unchained();
        __ERC2771Context_init_unchained(forwarder);
        __Blocklist_init_unchained();
    }

    /// @dev mint a new top level domain.
    /// @param to address to mint the new TLD to.
    /// @param tld TLD to mint.
    function mintTLD(address to, string calldata tld) external onlyMinter whenNotPaused {
        _mintTopLevelDomain(to, tld);
    }

    /// @inheritdoc IMintingManager
    //returns the list of minted TLDs
    function bulkMintTLD(address[] calldata to, string[] calldata tld)
        external
        override
        onlyMinter
        whenNotPaused
    {
        require(to.length == tld.length, "MintingManager: INVALID_LENGTH");

        uint256 length = to.length;
        for (uint256 i = 0; i < length;) {
            //check if tokenId exists and is minted
            if (!fnsRegistry.exists(_createTokenId(tld[i]))) {
                _mintTopLevelDomain(to[i], tld[i]);
            }

            unchecked {
                ++i;
            }
        }

    }

    /// @inheritdoc IMintingManager
    function mintSLD(address to, string calldata tld, string calldata label)
        external
        override
        onlyMinter
        whenNotPaused
    {
        _mintSecondLevelDomain(to, tld, label);
    }

    /// @inheritdoc IMintingManager
    function bulkMintSLD(address[] calldata to, string[] calldata tld, string[] calldata label)
        external
        override
        onlyMinter
        whenNotPaused
    {
        require(to.length == tld.length, "MintingManager: INVALID_LENGTH");
        require(tld.length == label.length, "MintingManager: INVALID_LENGTH");

        uint256 length = to.length;
        for (uint256 i = 0; i < length;) {
            _mintSecondLevelDomain(to[i], tld[i], label[i]);

            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IMintingManager
    function safeMintSLD(address to, string calldata tld, string calldata label)
        external
        override
        onlyMinter
        whenNotPaused
    {
        _safeMintSecondLevelDomain(to, tld, label, "");
    }

    /// @inheritdoc IMintingManager
    function safeBulkMintSLD(address[] calldata to, string[] calldata tld, string[] calldata label)
        external
        onlyMinter
        whenNotPaused
    {
        require(to.length == tld.length, "MintingManager: INVALID_LENGTH");
        require(tld.length == label.length, "MintingManager: INVALID_LENGTH");

        uint256 length = to.length;
        for (uint256 i = 0; i < length;) {
            _safeMintSecondLevelDomain(to[i], tld[i], label[i], "");

            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IMintingManager
    function safeMintSLD(address to, string calldata tld, string calldata label, bytes calldata data)
        external
        override
        onlyMinter
        whenNotPaused
    {
        _safeMintSecondLevelDomain(to, tld, label, data);
    }

    /// @inheritdoc IMintingManager
    function safeBulkMintSLD(
        address[] calldata to,
        string[] calldata tld,
        string[] calldata label,
        bytes[] calldata data
    ) external onlyMinter whenNotPaused {
        require(to.length == tld.length, "MintingManager: INVALID_LENGTH");
        require(tld.length == label.length, "MintingManager: INVALID_LENGTH");
        require(label.length == data.length, "MintingManager: INVALID_LENGTH");

        uint256 length = to.length;
        for (uint256 i = 0; i < length;) {
            _safeMintSecondLevelDomain(to[i], tld[i], label[i], data[i]);

            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IMintingManager
    function mintSLDWithRecords(
        address to,
        string calldata tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values
    ) external override onlyMinter whenNotPaused {
        _mintSecondLevelDomainWithRecords(to, tld, label, keys, values);
    }

    /// @inheritdoc IMintingManager
    function bulkMintSLDWithRecords(
        address[] calldata to,
        string[] calldata tld,
        string[] calldata label,
        string[][] calldata keys,
        string[][] calldata values
    ) external override onlyMinter whenNotPaused {
        require(to.length == tld.length, "MintingManager: INVALID_LENGTH");
        require(tld.length == label.length, "MintingManager: INVALID_LENGTH");
        require(label.length == keys.length, "MintingManager: INVALID_LENGTH");
        require(keys.length == values.length, "MintingManager: INVALID_LENGTH");

        uint256 length = to.length;
        for (uint256 i = 0; i < length;) {
            //check if tokenId exists and is minted
            if (!fnsRegistry.exists(_createTokenId(tld[i], label[i]))) {
                _mintSecondLevelDomainWithRecords(to[i], tld[i], label[i], keys[i], values[i]);
            } 

            unchecked {
                ++i;
            }
        }

    }

    /// @dev mint a new top level domain with records.
    /// @param to address to mint the new TLD to.
    /// @param tld TLD to mint.
    /// @param keys array of keys for the records.
    /// @param values array of values for the records.
    function mintTLDWithRecords(address to, string calldata tld, string[] calldata keys, string[] calldata values)
        external
        onlyMinter
        whenNotPaused
    {
        _mintTopLevelDomainWithRecords(to, tld, keys, values);
    }

    /// @inheritdoc IMintingManager
    function safeMintSLDWithRecords(
        address to,
        string calldata tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values
    ) external override onlyMinter whenNotPaused {
        _safeMintSecondLevelDomainWithRecords(to, tld, label, keys, values, "");
    }

    /// @inheritdoc IMintingManager
    function safeBulkMintSLDWithRecords(
        address[] calldata to,
        string[] calldata tld,
        string[] calldata label,
        string[][] calldata keys,
        string[][] calldata values
    ) external onlyMinter whenNotPaused {
        require(to.length == tld.length, "MintingManager: INVALID_LENGTH");
        require(tld.length == label.length, "MintingManager: INVALID_LENGTH");
        require(label.length == keys.length, "MintingManager: INVALID_LENGTH");
        require(keys.length == values.length, "MintingManager: INVALID_LENGTH");

        uint256 length = to.length;
        for (uint256 i = 0; i < length;) {
            _safeMintSecondLevelDomainWithRecords(to[i], tld[i], label[i], keys[i], values[i], "");

            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IMintingManager
    function safeMintSLDWithRecords(
        address to,
        string calldata tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values,
        bytes calldata data
    ) external override onlyMinter whenNotPaused {
        _safeMintSecondLevelDomainWithRecords(to, tld, label, keys, values, data);
    }

    /// @inheritdoc IMintingManager
    function safeBulkMintSLDWithRecords(
        address[] calldata to,
        string[] calldata tld,
        string[] calldata label,
        string[][] calldata keys,
        string[][] calldata values,
        bytes[] calldata data
    ) external onlyMinter whenNotPaused {
        require(to.length == tld.length, "MintingManager: INVALID_LENGTH");
        require(tld.length == label.length, "MintingManager: INVALID_LENGTH");
        require(label.length == keys.length, "MintingManager: INVALID_LENGTH");
        require(keys.length == values.length, "MintingManager: INVALID_LENGTH");
        require(values.length == data.length, "MintingManager: INVALID_LENGTH");

        uint256 length = to.length;
        for (uint256 i = 0; i < length;) {
            _safeMintSecondLevelDomainWithRecords(to[i], tld[i], label[i], keys[i], values[i], data[i]);

            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IMintingManager
    function setTokenURIPrefix(string calldata prefix) external override onlyOwner {
        fnsRegistry.setTokenURIPrefix(prefix);
    }

    /// @dev sets the forwarder.
    /// @param forwarder address of the forwarder contract.
    function setForwarder(address forwarder) external onlyOwner {
        _setForwarder(forwarder);
    }

    /// @dev disables the blocklist.
    function disableBlocklist() external onlyOwner {
        _disableBlocklist();
    }

    /// @dev enables the blocklist.
    function enableBlocklist() external onlyOwner {
        _enableBlocklist();
    }

    /// @dev blocks a token.
    function blocklist(uint256 tokenId) external onlyMinter {
        _block(tokenId);
    }

    /// @dev blocks a list of tokens.
    function blocklistAll(uint256[] calldata tokenIds) external onlyMinter {
        _blockAll(tokenIds);
    }

    /// @dev sets pause.
    function pause() external onlyOwner {
        _pause();
    }

    /// @dev sets unpause.
    function unpause() external onlyOwner {
        _unpause();
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private __gap;
}
