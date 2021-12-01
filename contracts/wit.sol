//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./@rarible/royalties/contracts/impl/RoyaltiesV2Impl.sol";
import "./@rarible/royalties/contracts/LibPart.sol";
import "./@rarible/royalties/contracts/LibRoyaltiesV2.sol";

contract WhereInTheNFT_AllHandsIn_Drop1_Test is ERC721, Ownable, RoyaltiesV2Impl
{
    using SafeMath for uint256;
	
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
	
    string private _metadataAPI;
	
	uint256 private _maxSupply;

	uint256 private _tokenPrice = 10000000000000000; // 0.01 ETH
	
	address payable public _payments;
		
	string private tokenName = "WhereInTheNFT_AllHandsIn_Drop1_Test";
	
    string private tokenSymbol = "WIT_AHI_1_T";
	
	bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
	
    constructor(
        uint256 maxTokenSupply,
        string memory initMetadataAPI
		//address payable initPayments
	) public ERC721(tokenName, tokenSymbol) 
	{
		_maxSupply = maxTokenSupply;
		_metadataAPI = initMetadataAPI;
		//_payments = initPayments;
		
	}

    function mintNFT(address recipient) public payable returns (uint256)
    {
		require(_tokenIds.current() <= _maxSupply, "Minting is over");
		require( _tokenPrice == msg.value,  "Incorrect ether value");
        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
		_tokenIds.increment();
        return newItemId;
    }
	
	function specialMintNFT(address recipient) public onlyOwner returns (uint256)
	{
		require(_tokenIds.current() <= _maxSupply, "Minting is over");
        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
		_tokenIds.increment();
        return newItemId;
	}
	
	function setMetadataAPI(string memory newMetadataAPI_) public onlyOwner
	{
        _metadataAPI = newMetadataAPI_;
    }
	
	function _baseURI() internal view override returns(string memory)
	{
        return _metadataAPI;
    }
	
    function maxSupply() public view returns (uint256)
	{
        return _maxSupply;
    }
	
	function withdraw() public onlyOwner
	{
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
	
	function setRoyalties(uint _tokenId, address payable _royaltiesReceipientAddress, uint96 _percentageBasisPoints) public onlyOwner
	{
        LibPart.Part[] memory _royalties = new LibPart.Part[](1);
        _royalties[0].value = _percentageBasisPoints;
        _royalties[0].account = _royaltiesReceipientAddress;
        _saveRoyalties(_tokenId, _royalties);
    }
	
	function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount)
	{
        LibPart.Part[] memory _royalties = royalties[_tokenId];
        if(_royalties.length > 0)
		{
            return (_royalties[0].account, (_salePrice * _royalties[0].value)/10000);
        }
        return (address(0), 0);

    }
	
	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool)
	{
        if(interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES)
		{
            return true;
        }
        return super.supportsInterface(interfaceId);
    } 
	
}
