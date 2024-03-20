// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}

interface IERC721TokenReceiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4);
}

contract NFinTech is IERC721 {
    string private _name;
    string private _symbol;

    uint256 private _tokenId;

    mapping(uint256 => address) private _owner;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApproval;
    mapping(address => bool) private isClaim;
    mapping(address => mapping(address => bool)) private _operatorApproval;

    error ZeroAddress();
    error NotApprovedForTransfer();

    constructor(string memory name_, string memory symbol_) payable {
        _name = name_;
        _symbol = symbol_;
    }

    function claim() public {
        if (isClaim[msg.sender] == false) {
            uint256 id = _tokenId;
            _owner[id] = msg.sender;

            _balances[msg.sender] += 1;
            isClaim[msg.sender] = true;

            _tokenId += 1;
        }
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function balanceOf(address owner) public view returns (uint256) {
        if (owner == address(0)) revert ZeroAddress();
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owner[tokenId];
        if (owner == address(0)) revert ZeroAddress();
        return owner;
    }


    function setApprovalForAll(address operator, bool approved) external {
        require(operator != address(0), "ERC721: setting approve to the zero address");
        require(msg.sender != operator, "ERC721: setting approval status for self");

        _operatorApproval[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
         return _operatorApproval[owner][operator];
    }

    function approve(address to, uint256 tokenId) external {
        address owner = _owner[tokenId];
        require(owner == msg.sender || isApprovedForAll(owner, msg.sender), "ERC721: approve caller is not owner nor approved for all");
        require(owner != address(0), "ERC721: approval to non-existent token");

        _tokenApproval[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address operator) {
        require(_owner[tokenId] != address(0), "ERC721: approved query for nonexistent token");
        return _tokenApproval[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        address owner = ownerOf(tokenId);
        require(from == owner, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        address approved = getApproved(tokenId);
        require(msg.sender == owner || msg.sender == approved || isApprovedForAll(owner, msg.sender),
            "ERC721: transfer caller is not owner nor approved");

        _tokenApproval[tokenId] = address(0);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public override {
        _safeTransferFrom(from, to, tokenId, data);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override {
        _safeTransferFrom(from, to, tokenId, bytes(""));
    }

    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) internal {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) private returns (bool) {
         if (isContract(to)) {
            try IERC721TokenReceiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721TokenReceiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function isContract(address addr) private view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
}