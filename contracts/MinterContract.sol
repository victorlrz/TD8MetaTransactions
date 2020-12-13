// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
import "./GLDToken.sol";

contract MinterContract {
    address public goldAddress;
    bytes32
        public hashToSignToGetWhiteListed = 0x596f75206e65656420746f207369676e207468697320737472696e6700000000;

    // allow for third party metatx account to make transactions through this
    // contract like an identity but make sure the owner has whitelisted the tx
    mapping(address => bool) public whitelist;

    constructor(address _goldAddress) public {
        goldAddress = _goldAddress;
        whitelist[msg.sender] = true;
    }

    function claimAToken(bytes memory _signature) public returns (bool) {
        GLDToken myERC721 = GLDToken(goldAddress);

        // Finding next token id
        uint256 nextTokenToMint = myERC721.nextTokenId();

        // Creating a hash of the concatenation of the ERC721 address and the next token to mint
        bytes32 _hash = keccak256(abi.encode(goldAddress, nextTokenToMint));

        // Checking that the signer of the mint order is authorized
        require(
            signerIsWhitelisted(_hash, _signature),
            "Claim: signer not whitelisted or signature invalid"
        );

        // Checking that the authorized minter is not the claimer
        address tokenMintedBy = extractAddress(_hash, _signature);
        require(
            tokenMintedBy != msg.sender,
            "Minter and sender must be different"
        );

        myERC721.mint(msg.sender);
    }

    function getWhiteListed(bytes memory _signature) public {
        require(
            msg.sender ==
                extractAddress(hashToSignToGetWhiteListed, _signature),
            "signature does not match sender"
        );
        whitelist[msg.sender] = true;
    }

    //borrowed from OpenZeppelin's ESDA stuff:
    //https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/ECDSA.sol
    function signerIsWhitelisted(bytes32 _hash, bytes memory _signature)
        internal
        view
        returns (bool)
    {
        bytes32 r;
        bytes32 s;
        uint8 v;
        // Check the signature length
        if (_signature.length != 65) {
            return false;
        }
        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }
        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return false;
        } else {
            // solium-disable-next-line arg-overflow
            return
                whitelist[ecrecover(
                    keccak256(
                        abi.encodePacked(
                            "\x19Ethereum Signed Message:\n32",
                            _hash
                        )
                    ),
                    v,
                    r,
                    s
                )];
        }
    }

    function extractAddress(bytes32 _hash, bytes memory _signature)
        internal
        pure
        returns (address)
    {
        bytes32 r;
        bytes32 s;
        uint8 v;
        // Check the signature length
        if (_signature.length != 65) {
            return address(0);
        }
        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }
        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return address(0);
        } else {
            // solium-disable-next-line arg-overflow
            return
                ecrecover(
                    keccak256(
                        abi.encodePacked(
                            "\x19Ethereum Signed Message:\n32",
                            _hash
                        )
                    ),
                    v,
                    r,
                    s
                );
        }
    }
}
