pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract WhitelistSale is ERC721 {
    bytes32 public merkleRoot;
    uint256 public nextTokenId;
    mapping(address => bool) public claimed;

    // constructor(bytes32 _merkleRoot) ERC721("ExampleNFT", "NFT") {
    //   merkleRoot = _merkleRoot;
    // }

    function setAddress(bytes32 _merkleRoot) public payable {
        merkleRoot = _merkleRoot;
    }

    constructor() ERC721("ExampleNFT", "NFT") {}

    function verify(
        bytes32 root,
        bytes32 leaf,
        bytes32[] memory proof
    ) public pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(
                    abi.encodePacked(computedHash, proofElement)
                );
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(
                    abi.encodePacked(proofElement, computedHash)
                );
            }
        }

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == root;
    }

    function mint(bytes32[] calldata merkleProof) public payable {
        require(claimed[msg.sender] == false, "already claimed");
        claimed[msg.sender] = true;
        require(
            MerkleProof.verify(
                merkleProof,
                merkleRoot,
                keccak256(abi.encodePacked(msg.sender))
            ),
            "invalid merkle proof"
        );
        nextTokenId++;
        _mint(msg.sender, nextTokenId);
    }

    function mint2(bytes32[] calldata merkleProof) public payable {
        // function mint2(bytes32[] calldata merkleProof,address sender2) public payable {
        address sender2 = 0x7201Cb17A0f51dd2b5A7C651198D57675400801d;
        // require(claimed[sender2] == false, "already claimed");
        // claimed[sender2] = true;
        require(
            MerkleProof.verify(
                merkleProof,
                merkleRoot,
                keccak256(abi.encodePacked(sender2))
            ),
            "invalid merkle proof"
        );
        // nextTokenId++;
        // _mint(sender2, nextTokenId);
    }

    function mint3(
        bytes32[] calldata merkleProof,
        address sender2,
        bytes32 merkleRootInput
    ) public payable {
        // address sender2 = 0x7201Cb17A0f51dd2b5A7C651198D57675400801d;
        // require(claimed[sender2] == false, "already claimed");
        // claimed[sender2] = true;
        require(
            MerkleProof.verify(
                merkleProof,
                merkleRootInput,
                keccak256(abi.encodePacked(sender2))
            ),
            "invalid merkle proof"
        );
        // nextTokenId++;
        // _mint(sender2, nextTokenId);
    }

    function mint4(
        bytes32[] calldata merkleProof,
        address sender2
    ) public payable {
        // address sender2 = 0x7201Cb17A0f51dd2b5A7C651198D57675400801d;
        // require(claimed[sender2] == false, "already claimed");
        // claimed[sender2] = true;
        require(
            MerkleProof.verify(
                merkleProof,
                merkleRoot,
                keccak256(abi.encodePacked(sender2))
            ),
            "invalid merkle proof"
        );
        // nextTokenId++;
        // _mint(sender2, nextTokenId);
    }
}
