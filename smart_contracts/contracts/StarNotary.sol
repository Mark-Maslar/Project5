pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';


contract StarNotary is ERC721 { 
    // string public starName; 
    // address public starOwner;

    event starClaimed(address owner, uint256 tokenId);
    event starLookupResult(string name, string story, string dec, string ra, string cent, string mag);
    event starCollectionEvent(uint256[] createdStars);
    event checkIfStarExistsResult(bool starExists);
    

    constructor() public { 
        //starName = "Awesome Udacity Star";
    }


    struct Star { 
        string name; 
        string story;
        string dec;
        string ra;
        string cent;
        string mag; 
    }

    
    mapping(uint256 => Star) public tokenIdToStarInfo; // Map TokenID to Star properties
    mapping(uint256 => uint256) public starsForSale; // Map stars up for sale
    mapping(uint256 => bool) public createdStars; // Map all stars that have been created
    mapping(uint256 => address) public starOwner; // Map TokenID to Star Owner

    //mapping(uint256 => Star) public Stars;
    // uint256[] public starCollection;
    


    function createStar(string _name, string _story, string _dec, string _ra, string _cent, string _mag) public { 
        require(bytes(_name).length > 0, "Required Parameter: Star Name.");
        require(bytes(_story).length > 0, "Required Parameter: Star Story.");
        require(bytes(_dec).length > 0, "Required Parameter: Star dec ");
        require(bytes(_ra).length > 0, "Required Parameter: Star ra ");
        require(bytes(_cent).length > 0, "Required Parameter: Star cent ");
        require(bytes(_mag).length > 0, "Required Parameter: Star mag ");   
        //require(checkIfStarExists(_dec, _ra, _cent), "Star already exists.");   

        uint256 _tokenId = uint256(getStarHash(_dec, _ra, _cent));
        Star memory newStar = Star(_name, _story, _dec, _ra, _cent, _mag);
        
        tokenIdToStarInfo[_tokenId] = newStar;
        createdStars[_tokenId] = true;
        starOwner[_tokenId] = msg.sender;
 
        emit starLookupResult(tokenIdToStarInfo[_tokenId].name, tokenIdToStarInfo[_tokenId].story, tokenIdToStarInfo[_tokenId].dec, tokenIdToStarInfo[_tokenId].ra, tokenIdToStarInfo[_tokenId].cent, tokenIdToStarInfo[_tokenId].mag);

        _mint(msg.sender, _tokenId);
        emit starClaimed(msg.sender, _tokenId);        
    }  

    function checkIfStarExists(string _dec, string _ra, string _cent) public view returns (bool){
        uint256 _tokenId = uint256(getStarHash(_dec, _ra, _cent));
        emit starLookupResult(tokenIdToStarInfo[_tokenId].name, tokenIdToStarInfo[_tokenId].story, tokenIdToStarInfo[_tokenId].dec, tokenIdToStarInfo[_tokenId].ra, tokenIdToStarInfo[_tokenId].cent, tokenIdToStarInfo[_tokenId].mag);

        //bool starExists = true;

        // if ((keccak256(abi.encodePacked(tokenIdToStarInfo[_tokenId].dec)) == keccak256("")) && 
        //     (keccak256(abi.encodePacked(tokenIdToStarInfo[_tokenId].ra)) == keccak256("")) &&
        //     (keccak256(abi.encodePacked(tokenIdToStarInfo[_tokenId].cent)) == keccak256("")))
        // starExists = false;
        bool starExists = createdStars[_tokenId];
 
        emit checkIfStarExistsResult(starExists);
        return (starExists);
    }


    function getStarInfo(string _dec, string _ra, string _cent) view public {
        uint256 _tokenId = uint256(getStarHash(_dec, _ra, _cent));
        emit starLookupResult(tokenIdToStarInfo[_tokenId].name, tokenIdToStarInfo[_tokenId].story, tokenIdToStarInfo[_tokenId].dec, tokenIdToStarInfo[_tokenId].ra, tokenIdToStarInfo[_tokenId].cent, tokenIdToStarInfo[_tokenId].mag);
        return;
    }

    function ownerOf(uint256 _tokenId) public view returns (address){
        return (starOwner[_tokenId]);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender);
        starsForSale[_tokenId] = _price;
    } 

    function approve(uint256 _tokenId) public view returns(bool){
        require(starOwner[_tokenId] == msg.sender, "You dont' own this star.");
        //You're approved!  
        return true;      
    }

    // function starName() public view returns(string) { 
    //     return starName;
    // }    

    // function starOwner() public view returns(address) { 
    //     return starOwner;
    // }     


    function buyStar(uint256 _tokenId) public payable { 
        require(starsForSale[_tokenId] > 0, "This star isn't for sale.");
        require(approve(_tokenId));

        //TODO Check the Price offered?

        uint256 starCost = starsForSale[_tokenId];
        address owner = this.ownerOf(_tokenId);
        
        require(msg.value >= starCost);

        _removeTokenFrom(owner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        owner.transfer(starCost);
        //safeTransferFrom(owner, msg.sender, _tokenId, starCost);

        if(msg.value > starCost) { 
            msg.sender.transfer(msg.value - starCost);
        }
    }

    function getStarHash(string _dec, string _ra, string _cent) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_dec, _ra, _cent));
    }     

    function starsForSale(uint256 _tokenId) public view returns (uint256) {
        return starsForSale[_tokenId];
    }

    // function safeTransferFrom(address _currentStarOwner, address _newStarOwner, uint256 _tokenId, uint256 _starCost) public {
    //     _removeTokenFrom(_currentStarOwner, _tokenId);
    //     _addTokenTo(_newStarOwner, _tokenId);

    //     _currentStarOwner.transfer(_starCost);
    // }

}