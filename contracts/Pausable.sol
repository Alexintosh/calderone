// SPDX-License-Identifier: MIT
pragma solidity >=0.7.6;
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 */
abstract contract Shutdownable is Pausable {
    event Shutdown(address account);
    event Open(address account);

    bool public stopEverything;

    modifier whenNotShutdown() {
        require(!stopEverything, "Shutdownable: is shutdown");
        _;
    }

    modifier whenShutdown() {
        require(stopEverything, "Pausable: not shutdown");
        _;
    }

    /// @dev Shutdown contract operations, if not already shutdown.
    function _shutdown() internal virtual whenNotShutdown {
        stopEverything = true;
        _pause();
        emit Shutdown(_msgSender());
    }

    /// @dev Open contract operations, if contract is in shutdown state, keeps it paused
    function _open() internal virtual whenShutdown {
        stopEverything = false;
        emit Open(_msgSender());
    }
}
