// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

import "./IRecordReader.sol";

interface IRecordStorage is IRecordReader {

  event RecordUpdated(
    uint256 indexed tokenId, string indexed keyIndex, string indexed valueIndex, string key, string value
  );

  event KeyCreated(uint256 indexed tokenId, string indexed keyIndex, string key);

  event RecordsCleared(uint256 indexed tokenId);

  /**
  * @dev Establish a new key-value mapping for a particular token id
  * @param key The identifier of the key-value mapping
  * @param value The associated value of the key-value mapping
  * @param tokenId the identifier of the token to link with the mapping
  */
  function setRecord(string calldata key, string calldata value, uint256 tokenId) external;

  /**
  * @dev Establish multiple new key-value mappings for a specified token id
  * @param keys The identifiers of the key-value mappings
  * @param values The associated values of the key-value mappings
  * @param tokenId the identifier of the token to link with the mappings
  */
  function setManyRecords(string[] memory keys, string[] memory values, uint256 tokenId) external;

  /**
  * @dev Establish a new key-value mapping for a specific token id using a hash of the key
  * @param keyHash The hash of the key used in the key-value mapping
  * @param value The associated value of the key-value mapping
  * @param tokenId the identifier of the token to link with the mapping
  */
  function setRecordByHash(uint256 keyHash, string calldata value, uint256 tokenId) external;

  /**
  * @dev Establish multiple new key-value mappings for a specific token id using hashes of the keys
  * @param keyHashes The hashes of the keys used in the key-value mappings
  * @param values The associated values of the key-value mappings
  * @param tokenId the identifier of the token to link with the mappings
  */
  function setManyRecordsByHash(uint256[] calldata keyHashes, string[] calldata values, uint256 tokenId) external;

  /**
  * @dev Overwrite all existing mappings of a specific token id with new ones
  * @param keys The identifiers of the new key-value mappings
  * @param values The associated values of the new key-value mappings
  * @param tokenId the identifier of the token to link with the mappings
  */
  function reconfigure(string[] memory keys, string[] memory values, uint256 tokenId) external;

  /**
  * @dev Eliminate all the mappings related to a specific token id
  * @param tokenId the target token identifier
  */
  function reset(uint256 tokenId) external;
}
