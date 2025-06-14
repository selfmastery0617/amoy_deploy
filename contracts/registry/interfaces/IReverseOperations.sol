// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

/**
 * @title Reverse registry interface
 */
interface IReverseOperations {

    /**
    * @dev Triggered when the association of a reverse record is discontinued.
    */
    event RemoveReverse(address indexed addr);

    /**
    * @dev Triggered when a new reverse record association is established.
    */
    event SetReverse(address indexed addr, uint256 indexed tokenId);

    /**
    * @dev Discontinues the reverse record that is associated with the account invoking this function.
    */
    function removeReverse() external;

    /**
    * @dev Retrieves the corresponding token ID of a provided account's reverse record.
    * @param addr The account address whose associated token ID is to be returned.
    * @return tokenId The unique identifier of the token linked to the given account.
    */
    function reverseOf(address addr) external view returns (uint256);

    /**
    * @dev Establishes a reverse record for the account invoking this function.
    * @param tokenId The unique identifier of the token to be associated with the caller's address.
    */
    function setReverse(uint256 tokenId) external;
}
