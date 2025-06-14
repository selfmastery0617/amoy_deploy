// SPDX-License-Identifier: UNLICENSED

// @author Freename

pragma solidity 0.8.19;

interface IERC1967 {
    /**
     * @dev Emitted when the implementation is upgraded.
     * @param implementation The address of the new contract.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Emitted when the admin account has changed.
     * @param previousAdmin The address of the previous admin
     * @param newAdmin The address of the new admin
     */
    event AdminChanged(address previousAdmin, address newAdmin);
}
