// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol";

/**
 * @dev Mechanism blocks tokens' minting
 */
abstract contract Blocklist is Initializable, ContextUpgradeable {
    /**
     * @dev Emitted when the `tokenId` added to blocklist.
     * @param tokenId The token ID that is added to the blocklist.
     */
    event Blocked(uint256 tokenId);

    /**
     * @dev Emitted when the blocklist is disabled by `account`.
     * @param account The account that disabled the blocklist.
     */
    event BlocklistDisabled(address account);

    /**
     * @dev Emitted when the blocklist is enabled by `account`.
     * @param account The account that enabled the blocklist.
     */
    event BlocklistEnabled(address account);

    // This is the keccak-256 hash of "fns.blocklist." subtracted by 1
    bytes32 internal constant _BLOCKLIST_PREFIX_SLOT =
        0x88ff182299c9f3069e873b4fa8b81f26a234fcbef5ccaf7fb77939baf8231b8d;

    // This is the keccak-256 hash of "fns.blocklist.disabled" subtracted by 1
    bytes32 internal constant _BLOCKLIST_DISABLED_SLOT =
        0x84a2a770ff63a9035359759da3e870adca4016a59d29682552e31429b5e7122b;

    error blocklistIsDisabled();
    error blocklistIsEnabled();

    /**
     * @dev Modifier to make a function callable only when the blocklist is enabled.
     *
     * Requirements:
     *
     * - The blocklist must be enabled.
     */
    modifier whenEnabled() {
        if (isBlocklistDisabled()) {
            revert blocklistIsDisabled();
        }
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the blocklist is disabled.
     *
     * Requirements:
     *
     * - The blocklist must be disabled.
     */
    modifier whenDisabled() {
        if (!isBlocklistDisabled()) {
            revert blocklistIsEnabled();
        }
        _;
    }

    /**
     * @dev Initializes the blocklist in enabled state.
     */
    function __Blocklist_init() internal onlyInitializing {
        __Context_init_unchained();
        __Blocklist_init_unchained();
    }

    /**
     * @dev Internal function to initialize the blocklist contract.
     */
    function __Blocklist_init_unchained() internal onlyInitializing {
        StorageSlotUpgradeable
            .getBooleanSlot(_BLOCKLIST_DISABLED_SLOT)
            .value = false;
    }

    /**
     * @dev Internal function to block a specific `tokenId`.
     * @param tokenId The token ID to block.
     */
    function _block(uint256 tokenId) internal whenEnabled {
        StorageSlotUpgradeable
            .getBooleanSlot(
                keccak256(abi.encodePacked(_BLOCKLIST_PREFIX_SLOT, tokenId))
            )
            .value = true;
        emit Blocked(tokenId);
    }

    /**
     * @dev Internal function to block multiple token IDs.
     * @param tokenIds The array of token IDs to block.
     */
    function _blockAll(uint256[] calldata tokenIds) internal {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _block(tokenIds[i]);
        }
    }

    /**
     * @dev Internal function to disable the blocklist.
     */
    function _disableBlocklist() internal whenEnabled {
        StorageSlotUpgradeable
            .getBooleanSlot(_BLOCKLIST_DISABLED_SLOT)
            .value = true;
        emit BlocklistDisabled(_msgSender());
    }

    /**
     * @dev Internal function to enable the blocklist.
     */
    function _enableBlocklist() internal whenDisabled {
        StorageSlotUpgradeable
            .getBooleanSlot(_BLOCKLIST_DISABLED_SLOT)
            .value = false;
        emit BlocklistEnabled(_msgSender());
    }

    /**
     * @dev Returns a boolean indicating whether the blocklist is disabled.
     * @return A boolean indicating whether the blocklist is disabled.
     */
    function isBlocklistDisabled() public view returns (bool) {
        return
            StorageSlotUpgradeable
                .getBooleanSlot(_BLOCKLIST_DISABLED_SLOT)
                .value;
    }

    /**
     * @dev Returns a boolean indicating whether a specific `tokenId` is blocked.
     * @param tokenId The token ID to check.
     * @return A boolean indicating whether the token ID is blocked.
     */
    function isBlocked(uint256 tokenId) public view returns (bool) {
        return
            !isBlocklistDisabled() &&
            StorageSlotUpgradeable
                .getBooleanSlot(
                    keccak256(abi.encodePacked(_BLOCKLIST_PREFIX_SLOT, tokenId))
                )
                .value;
    }

    /**
     * @dev Returns an array of booleans indicating whether each `tokenId` is blocked or not.
     * @param tokenIds The array of token IDs to check.
     * @return values An array of booleans indicating whether each token ID is blocked or not.
     */
    function areBlocked(
        uint256[] calldata tokenIds
    ) public view returns (bool[] memory values) {
        values = new bool[](tokenIds.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            values[i] = isBlocked(tokenIds[i]);
        }
    }
}
