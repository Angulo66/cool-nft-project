// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./base/ERC721Checkpointable.sol";
import "./OwnableInitializable.sol";
import "operator-filter-registry/src/upgradeable/DefaultOperatorFiltererUpgradeable.sol";

contract Contract is
    OwnableInitializable,
    ERC721Checkpointable,
    DefaultOperatorFiltererUpgradeable
{
    using Strings for uint256;
    event Minted(address _to, uint256 _type);

    string private baseTokenURI;

    mapping(address => bool) public enabledMinter;

    uint256 public maxSupply;
    bool public paused;
    bool public initialized;

    mapping(uint256 => uint256) public miscSetting;

    function init(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI,
        uint256 _maxSupply,
        bool _paused
    ) public initializer {
        require(!initialized, "already initialized");
        ERC721.initialize(_name, _symbol);
        OwnableInitializable._init();
        baseTokenURI = _initBaseURI;
        maxSupply = _maxSupply;
        paused = _paused;
        initialized = true;
        _setDefaultRoyalty(msg.sender, 10);
        __DefaultOperatorFilterer_init();
    }

    function setDefaultRoyalty(
        address _receiver,
        uint96 _feeNumerator
    ) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(
        address operator,
        uint256 tokenId
    ) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, data);
    }

    function _mint(address _to, uint256 _mintNumber) public {
        require(enabledMinter[msg.sender], "!minter");
        require(!paused, "paused");

        uint256 supply = totalSupply();
        require(supply + 1 <= maxSupply, "OverMaxSupply");

        _safeMint(address(0), _to, _mintNumber, "");

        emit Minted(_to, _mintNumber);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _value) public onlyOwner {
        baseTokenURI = _value;
    }

    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }

    function setMinter(address _minter, bool _option) public onlyOwner {
        enabledMinter[_minter] = _option;
    }

    function setMisc(
        uint256[] calldata _ids,
        uint256[] calldata _values
    ) public onlyOwner {
        require(
            _ids.length == _values.length,
            "Must provide equal ids and values"
        );
        for (uint256 i = 0; i < _ids.length; i++) {
            miscSetting[_ids[i]] = _values[i];
        }
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }
}
