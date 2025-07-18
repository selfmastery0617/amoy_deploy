// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol";

/**
 * @title ERC2771Context
 * @dev https://eips.ethereum.org/EIPS/eip-2771[EIP 2771] is a standard for native meta transactions.
 *
 * A base contract to be inherited by any contract that want to receive forwarded transactions.
 * The contract designed to be stateless, it supports a scenario when a inherited contract is
 * TrustedForwarder and Recipient at the same time.
 *
 * The contract supports token based nonce, that is why standard calldata extended by tokenId.
 *
 * Forwarded calldata layout: {bytes:data}{address:from}{uint256:tokenId}
 */
abstract contract ERC2771Context is Initializable, ContextUpgradeable {
    // This is the keccak-256 hash of "eip2771.forwarder" subtracted by 1
    bytes32 internal constant _FORWARDER_SLOT =
        0x893ef2ea16c023f61d4f55d3e6ee3fc3f2fbfd478461323dbc2fbf919047086e;

    /**
     * @dev Initializes the ERC2771Context contract.
     * @param forwarder The address of the trusted forwarder contract.
     */
    // solhint-disable-next-line func-name-mixedcase
    function __ERC2771Context_init(
        address forwarder
    ) internal onlyInitializing {
        __Context_init_unchained();
        __ERC2771Context_init_unchained(forwarder);
    }

    /**
     * @dev Internal function to initialize the ERC2771Context contract.
     * @param forwarder The address of the trusted forwarder contract.
     */
    // solhint-disable-next-line func-name-mixedcase
    function __ERC2771Context_init_unchained(
        address forwarder
    ) internal onlyInitializing {
        _setForwarder(forwarder);
    }

    /**
     * @dev Return the tokenId of this call.
     * If the call came through our trusted forwarder, return the original tokenId.
     * otherwise, return zero tokenId.
     * @return tokenId The tokenId of the current call.
     */
    function _msgToken() internal view virtual returns (uint256 tokenId) {
        if (isTrustedForwarder(msg.sender)) {
            assembly {
                tokenId := calldataload(sub(calldatasize(), 32))
            }
        }
    }

    /**
     * @dev Return the sender of this call.
     * If the call came through our trusted forwarder, return the original sender.
     * otherwise, return `msg.sender`.
     * Should be used in the contract anywhere instead of msg.sender
     * @return sender The sender of the current call.
     */
    function _msgSender()
        internal
        view
        virtual
        override
        returns (address sender)
    {
        if (isTrustedForwarder(msg.sender)) {
            // The assembly code is more direct than the Solidity version using `abi.decode`.
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 52)))
            }
        } else {
            return super._msgSender();
        }
    }

    /**
     * @dev Return the data of this call.
     * If the call came through our trusted forwarder, return the original data.
     * otherwise, return `msg.data`.
     * Should be used in the contract anywhere instead of msg.data
     * @return The data of the current call.
     */
    function _msgData()
        internal
        view
        virtual
        override
        returns (bytes calldata)
    {
        if (isTrustedForwarder(msg.sender)) {
            return msg.data[:msg.data.length - 52];
        } else {
            return super._msgData();
        }
    }

    /**
     * @dev Internal function to set the forwarder address.
     * @param forwarder The address of the trusted forwarder contract.
     */
    function _setForwarder(address forwarder) internal virtual {
        StorageSlotUpgradeable
            .getAddressSlot(_FORWARDER_SLOT)
            .value = forwarder;
    }

    /**
     * @dev Return bool whether provided address is the trusted forwarder.
     * @param forwarder The address to check.
     * @return A boolean indicating whether the address is the trusted forwarder.
     */
    function isTrustedForwarder(
        address forwarder
    ) public view virtual returns (bool) {
        return
            forwarder ==
            StorageSlotUpgradeable.getAddressSlot(_FORWARDER_SLOT).value;
    }
}
