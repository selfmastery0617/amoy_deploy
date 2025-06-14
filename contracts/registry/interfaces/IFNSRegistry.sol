// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";

import "../../proxy/interfaces/IERC1967.sol";
import "../../storage/interfaces/IRecordStorage.sol";
import "./IReverseOperations.sol";

/// @title IFNSRegistry
interface IFNSRegistry is
    IERC721MetadataUpgradeable,
    IERC721ReceiverUpgradeable,
    IERC1967,
    IRecordStorage,
    IReverseOperations,
    IERC721EnumerableUpgradeable
{
    event NewURI(uint256 indexed tokenId, string uri);

    event NewURIPrefix(string prefix);

    /**
     * @dev Burns the given token Id
     */
    function burn(uint256 tokenId) external;

    /**
     * @dev Get the child token id of the specified token id
     * @param tokenId the "father" token id
     * @param label label of subdomain (eg for `child.freename.web3` it will be `child`)
     * @return The child token ID.
     */
    function childIdOf(
        uint256 tokenId,
        string calldata label
    ) external pure returns (uint256);

    /**
     * @dev Checks if the given token id exists
     * @param tokenId token id to check
     * @return A boolean indicating whether the token exists.
     */
    function exists(uint256 tokenId) external view returns (bool);

    /**
     * @dev Returns if the given address can operate on the the specified token ID.
     * @param spender address
     * @param tokenId token id to check
     * @return A boolean indicating whether the spender is approved or the owner of the token.
     */
    function isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) external view returns (bool);

    /**
     * @dev Mints the token with the address `to` as owner.
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param uri domain URI.
     */
    function mint(address to, uint256 tokenId, string calldata uri) external;

    /**
     * @dev Mints the token with the address `to` as owner and properties
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param uri domain URI
     * @param propertyKeys property keys
     * @param propertyValues property values
     */
    function mintWithProperties(
        address to,
        uint256 tokenId,
        string calldata uri,
        string[] calldata propertyKeys,
        string[] calldata propertyValues
    ) external;

    /**
     * @dev Mints the token with the address `to` as owner and with records
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param keys record keys
     * @param values record values
     * @param uri domain URI
     */
    function mintWithRecords(
        address to,
        uint256 tokenId,
        string calldata uri,
        string[] calldata keys,
        string[] calldata values
    ) external;

    /**
     * @dev Mints the token with the address `to` as owner and with records and properties
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param uri domain URI
     * @param keys record keys
     * @param values record values
     * @param propertyKeys property keys
     * @param propertyValues property values
     */
    function mintWithRecordsAndProperties(
        address to,
        uint256 tokenId,
        string calldata uri,
        string[] calldata keys,
        string[] calldata values,
        string[] calldata propertyKeys,
        string[] calldata propertyValues
    ) external;

    /**
     * @dev Gets the resolver of the specified token id.
     * @param tokenId token id to check
     * @return The resolver address.
     */
    function resolverOf(uint256 tokenId) external view returns (address);

    /**
     * @dev Mints the token with the address `to` as owner.
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param uri domain URI
     */
    function safeMint(
        address to,
        uint256 tokenId,
        string calldata uri
    ) external;

    /**
     * @dev Mints the token with the address `to` as owner.
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param uri domain URI
     * @param data bytes data to safe transfer check
     */
    function safeMint(
        address to,
        uint256 tokenId,
        string calldata uri,
        bytes calldata data
    ) external;

    /**
     * @dev Mints the token with the address `to` as owner and with records
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param keys record keys
     * @param values record values
     * @param uri domain URI
     */
    function safeMintWithRecords(
        address to,
        uint256 tokenId,
        string calldata uri,
        string[] calldata keys,
        string[] calldata values
    ) external;

    /**
     * @dev Mints the token with the address `to` as owner and with records
     * @param to owner of the minted tokenId
     * @param tokenId token id to mint
     * @param keys record keys
     * @param values record values
     * @param uri domain URI
     * @param data bytes data to safe transfer check
     */
    function safeMintWithRecords(
        address to,
        uint256 tokenId,
        string calldata uri,
        string[] calldata keys,
        string[] calldata values,
        bytes calldata data
    ) external;

    /**
     * @dev Transfers the domain to a new owner without resetting domain records.
     * @param to address of the new domain owner
     * @param tokenId the token id to transfer
     */
    function setOwner(address to, uint256 tokenId) external;

    /**
     * @dev sets the token URI Prefix for all tokens.
     * @param prefix new URI
     */
    function setTokenURIPrefix(string calldata prefix) external;
}
