// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

abstract contract MinterRole is OwnableUpgradeable, AccessControlUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    error callerIsNotMinter();

    modifier onlyMinter() {
        if (!isMinter(_msgSender())) {
            revert callerIsNotMinter();
        }
        _;
    }

    // solhint-disable-next-line func-name-mixedcase
    function __MinterRole_init() internal onlyInitializing {
        __Ownable_init_unchained();
        __AccessControl_init_unchained();
        __MinterRole_init_unchained();
    }

    function _addMinter(address account) internal {
        _setupRole(MINTER_ROLE, account);
    }

    function _removeMinter(address account) internal {
        revokeRole(MINTER_ROLE, account);
    }

    // solhint-disable-next-line func-name-mixedcase
    function __MinterRole_init_unchained() internal onlyInitializing {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    /// @dev transfer ownership and assign DEFAULT_ADMIN_ROLE to new owner
    /// @param newOwner address of the new owner
    function transferOwnership(
        address newOwner
    ) public virtual override onlyOwner {
        super.transferOwnership(newOwner);
        _setupRole(DEFAULT_ADMIN_ROLE, newOwner);
    }

    /// @dev check if account has minter role
    /// @param account address to check
    /// @return true if account has minter role
    function isMinter(address account) public view returns (bool) {
        return hasRole(MINTER_ROLE, account);
    }

    /// @dev add minter role to account. Only owner can call.
    /// @param account address to add minter role
    function addMinter(address account) public onlyOwner {
        _addMinter(account);
    }

    /// @dev add minter role to accounts. Only owner can call.
    /// @param accounts addresses to add minter role
    function addMinters(address[] memory accounts) public onlyOwner {
        uint256 length = accounts.length;

        for (uint256 index = 0; index < length; ) {
            _addMinter(accounts[index]);

            unchecked {
                ++index;
            }
        }
    }

    /// @dev remove minter role from account
    /// @param account address to remove minter role
    function removeMinter(address account) public onlyOwner {
        _removeMinter(account);
    }

    /// @dev remove minter role from accounts
    /// @param accounts addresses to remove minter role
    function removeMinters(address[] memory accounts) public onlyOwner {
        for (uint256 index = 0; index < accounts.length; index++) {
            _removeMinter(accounts[index]);
        }
    }

    /// @dev renounce minter role
    function renounceMinter() public {
        renounceRole(MINTER_ROLE, _msgSender());
    }

    /// @dev Renounce minter account with funds' forwarding
    /// @param receiver address to forward funds
    function closeMinter(address payable receiver) external payable onlyMinter {
        require(receiver != address(0x0), "MinterRole: RECEIVER_IS_EMPTY");

        renounceMinter();
        receiver.transfer(msg.value);
    }

    /// @dev Replace minter account by new account with funds' forwarding
    /// @param receiver address to forward funds
    function rotateMinter(
        address payable receiver
    ) external payable onlyMinter {
        require(receiver != address(0x0), "MinterRole: RECEIVER_IS_EMPTY");

        _addMinter(receiver);
        renounceMinter();
        receiver.transfer(msg.value);
    }
}
