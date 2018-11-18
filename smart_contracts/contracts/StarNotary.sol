pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';


contract StarNotary is ERC721 { 
    string public starName; 
    address public starOwner;

    event starClaimed(address owner, uint256 tokenId);
    event starLookupResult(string name, string story, string dec, string ra, string cent, string mag);
    event starCollectionEvent(uint256[] allStars);
    event checkIfStarExistsResult(bool starExists);
    

    constructor() public { 
        starName = "Awesome Udacity Star";
    }


    struct Star { 
        string name; 
        string story;
        string dec;
        string ra;
        string cent;
        string mag; 
    }

    mapping(uint256 => Star) public tokenIdToStarInfo; 
    mapping(uint256 => uint256) public starsForSale;

    //mapping(uint256 => Star) public Stars;
    uint256[] public starCollection;
    
    // Create a mapping of the hash of the 3 star parameters to the star object
    mapping(bytes32 => Star) public sfdsdfs; //sfdsdfs[key is coordinate hash]

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

        emit starLookupResult(tokenIdToStarInfo[_tokenId].name, tokenIdToStarInfo[_tokenId].story, tokenIdToStarInfo[_tokenId].dec, tokenIdToStarInfo[_tokenId].ra, tokenIdToStarInfo[_tokenId].cent, tokenIdToStarInfo[_tokenId].mag);

        _mint(msg.sender, _tokenId);
        emit starClaimed(msg.sender, _tokenId);        
    }  

    function getStars() view public returns (uint256[]) {
        emit starCollectionEvent(starCollection);
        return starCollection;

    }

    // function getStar(uint256 _tokenID) view public returns (string, string, string, string, string) {
    //     return (Stars[_tokenID].name, Stars[_tokenID].story, Stars[_tokenID].dec, Stars[_tokenID].mag, Stars[_tokenID].cent);
    // }  
    // function getStar(uint256 _tokenID) view public returns (string, string, string, string, string) {
    //     return (Stars[_tokenID]);
    // }         

    function getStarCount() view public returns (uint) {
        return starCollection.length;
    }    

    function checkIfStarExists(string _dec, string _ra, string _cent) view public returns (bool){

        uint256 _tokenId = uint256(getStarHash(_dec, _ra, _cent));
        emit starLookupResult(tokenIdToStarInfo[_tokenId].name, tokenIdToStarInfo[_tokenId].story, tokenIdToStarInfo[_tokenId].dec, tokenIdToStarInfo[_tokenId].ra, tokenIdToStarInfo[_tokenId].cent, tokenIdToStarInfo[_tokenId].mag);

        bool starExists = true;

        if ((keccak256(abi.encodePacked(tokenIdToStarInfo[_tokenId].dec)) == keccak256("")) && 
            (keccak256(abi.encodePacked(tokenIdToStarInfo[_tokenId].ra)) == keccak256("")) &&
            (keccak256(abi.encodePacked(tokenIdToStarInfo[_tokenId].cent)) == keccak256("")))
        starExists = false;

 
        emit checkIfStarExistsResult(starExists);
        return (starExists);
    }



    function getStarInfo(string _dec, string _ra, string _cent) view public {

        uint256 _tokenId = uint256(getStarHash(_dec, _ra, _cent));
        emit starLookupResult(tokenIdToStarInfo[_tokenId].name, tokenIdToStarInfo[_tokenId].story, tokenIdToStarInfo[_tokenId].dec, tokenIdToStarInfo[_tokenId].ra, tokenIdToStarInfo[_tokenId].cent, tokenIdToStarInfo[_tokenId].mag);
        return;
    }



    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender);
        starsForSale[_tokenId] = _price;
    } 

    function claimStar(uint256 _tokenId) public payable { 
        //TODO Use _tokenId
        starOwner = msg.sender;
        //emit starClaimed(msg.sender);
        emit starClaimed(msg.sender, _tokenId); 
    }


    function starName() public view returns(string) { 
        return starName;
    }    

    function starOwner() public view returns(address) { 
        return starOwner;
    }     


    function buyStar(uint256 _tokenId) public payable { 
        require(starsForSale[_tokenId] > 0);

        uint256 starCost = starsForSale[_tokenId];
        //address starOwner = this.ownerOf(_tokenId);
        starOwner = this.ownerOf(_tokenId);
        require(msg.value >= starCost);

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        starOwner.transfer(starCost);

        if(msg.value > starCost) { 
            msg.sender.transfer(msg.value - starCost);
        }
    }

    function getStarHash(string _dec, string _ra, string _cent) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_dec, _ra, _cent));
    }     

    function starsForSale() public view returns (uint256[]) {
        return starCollection;
    }

}