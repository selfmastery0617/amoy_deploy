// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

import "../../proxy/interfaces/IERC1967.sol";

/**
 * @title MintingManager
 * @dev Declares the functions for distribution of Second Level Domains (SLD)s.
 */
interface IMintingManager is IERC1967 {
    event NewTld(uint256 indexed tokenId, string tld);

    /**
     * @dev Mints a Top Level Domain (TLD).
     * @param to address to mint the new TLD to.
     * @param tld TLD to mint.
     */
    function mintTLD(address to, string calldata tld) external;

    /**
     * @dev Bulk mint Top Level Domains (TLDs)
     * @param to address array to mint the new TLD to.
     * @param tld TLD array to mint.
     */
    function bulkMintTLD(address[] calldata to, string[] calldata tld) external;

    /**
     * @dev Mints a Second Level Domain (SLD).
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     */
    function mintSLD(address to, string memory tld, string calldata label) external;

    /**
     * @dev Bulk Mint  Second Level Domains (SLD).
     * @param to address array to mint the new SLD to.
     * @param tld id array of parent token.
     * @param label SLD array label to mint.
     */
    function bulkMintSLD(address[] calldata to, string[] calldata tld, string[] calldata label) external;

    /**
     * @dev Safely mints a Second Level Domain (SLD).
     * Implements a ERC721Receiver check unlike mintSLD.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     */
    function safeMintSLD(address to, string memory tld, string calldata label) external;

    /**
     * @dev Safely bulk mints Second Level Domains (SLD).
     * Implements a ERC721Receiver check unlike mintSLD.
     * @param to address array to mint the new SLD to.
     * @param tld id array of parent token.
     * @param label SLD array label to mint.
     */
    function safeBulkMintSLD(address[] calldata to, string[] calldata tld, string[] calldata label) external;


    /**
     * @dev Safely mints a Second Level Domain (SLD).
     * Implements a ERC721Receiver check unlike mintSLD.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     * @param data bytes data to send along with a safe transfer check.
     */
    function safeMintSLD(address to, string memory tld, string calldata label, bytes calldata data) external;

     /**
     * @dev Safely bulk mints Second Level Domains (SLD).
     * Implements a ERC721Receiver check unlike mintSLD.
     * @param to address array to mint the new SLD to.
     * @param tld id array of parent token.
     * @param label SLD array label to mint.
     * @param data bytes data to send along with a safe transfer check.
     */
    function safeBulkMintSLD(address[] calldata to, string[] calldata tld, string[] calldata label, bytes[] calldata data) external;


    /**
     * @dev Mints a Second Level Domain (SLD) with records.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     * @param keys Record keys.
     * @param values Record values.
     */
    function mintSLDWithRecords(
        address to,
        string memory tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values
    ) external;

    /**
     * @dev Bulk mint of Second Level Domain (SLD) with records.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     * @param keys Record keys.
     * @param values Record values.
     */
    function bulkMintSLDWithRecords(
        address[] calldata to,
        string[] calldata tld,
        string[] calldata label,
        string[][] calldata keys,
        string[][] calldata values
    ) external;


    /**
     * @dev Mints a Second Level Domain (SLD) with records.
     * Implements a ERC721Receiver check unlike mintSLD.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     * @param keys Record keys.
     * @param values Record values.
     */
    function safeMintSLDWithRecords(
        address to,
        string memory tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values
    ) external;

    /**
     * @dev Bulk mint of Second Level Domain (SLD) with records.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     * @param keys Record keys.
     * @param values Record values.
     */
     function safeBulkMintSLDWithRecords(
        address[] calldata to,
        string[] calldata tld,
        string[] calldata label,
        string[][] calldata keys,
        string[][] calldata values
    ) external;

    /**
     * @dev Mints a Second Level Domain (SLD) with records.
     * Implements a ERC721Receiver check unlike mintSLD.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     * @param keys Record keys.
     * @param values Record values.
     * @param data bytes data to send along with a safe transfer check.
     */
    function safeMintSLDWithRecords(
        address to,
        string memory tld,
        string calldata label,
        string[] calldata keys,
        string[] calldata values,
        bytes calldata data
    ) external;

    /**
     * @dev Bulk mint of Second Level Domain (SLD) with records.
     * @param to address to mint the new SLD to.
     * @param tld id of parent token.
     * @param label SLD label to mint.
     * @param keys Record keys.
     * @param values Record values.
     */
     function safeBulkMintSLDWithRecords(
        address[] calldata to,
        string[] calldata tld,
        string[] calldata label,
        string[][] calldata keys,
        string[][] calldata values,
        bytes[] calldata data
    ) external;

    /**
     * @dev Function to set the token URI Prefix for all tokens.
     * @param prefix string URI to assign
     */
    function setTokenURIPrefix(string calldata prefix) external;
}
