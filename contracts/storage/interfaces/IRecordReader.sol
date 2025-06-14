// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

interface IRecordReader {
/**
* @dev Method to retrieve a single record.
* @param key The specific key to fetch the associated value.
* @param tokenId The identifier of the specific token.
* @return The corresponding value string.
*/
function getRecord(string calldata key, uint256 tokenId) external view returns (string memory);

/**
 * @dev Method to fetch several records simultaneously.
 * @param keys The array of keys to fetch their associated values.
 * @param tokenId The identifier of the specific token.
 * @return An array of corresponding values for the input keys.
 */
function getManyRecords(string[] calldata keys, uint256 tokenId) external view returns (string[] memory);

/**
 * @dev Method to fetch a record's key-value pair using a given hash of the key.
 * @param keyHash The hash of the key to fetch its associated record.
 * @param tokenId The identifier of the specific token.
 * @return key The key corresponding to the hash.
 * @return value The value associated with the key.
 */
function getRecordByHash(uint256 keyHash, uint256 tokenId)
    external
    view
    returns (string memory key, string memory value);

/**
 * @dev Method to fetch several records using their key hashes.
 * @param keyHashes The array of key hashes to fetch their associated records.
 * @param tokenId The identifier of the specific token.
 * @return keys An array of keys corresponding to the hashes.
 * @return values An array of values associated with the keys.
 */
function getManyRecordsByHash(uint256[] calldata keyHashes, uint256 tokenId)
    external
    view
    returns (string[] memory keys, string[] memory values);
}

