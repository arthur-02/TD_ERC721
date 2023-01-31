pragma solidity ^0.6.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./IExerciceSolution.sol";

contract ExerciceSolution is IExerciceSolution, ERC721 {


    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct Animal{
        uint256 sex;
        uint256 legs;
        bool wings;
        string name;
    }

    struct Parents {
        uint256 parent1;
        uint256 parent2;
    }

    struct Reproduction {
        bool CanReproduce;
        uint256 price;
    }
    mapping(address=>mapping(uint=>uint))public ownerindex;
    mapping(uint256 => Animal) public animals;
    address[] public BreederCustomers;

    mapping(uint256 => bool) public isDispoToSell;
    mapping(uint256 => uint256) public isPrice;

    mapping(uint256 => Parents) public parents;

    mapping(uint256 => Reproduction) public reproduction;
    mapping(uint =>address)public autorizereproduce;
    constructor() ERC721("ARTHURL", "AL") public {
        _mint(0x4538fA1B83872e981E1a91aF385B45F7bEdc10ab,10);
        _mint(0xf84BA7aD45418F36A35dfD664445D6e5fbC4f2ab,11);
        reproduction[10]=Reproduction(true, 0.00001 ether);
        ownerindex[0x4538fA1B83872e981E1a91aF385B45F7bEdc10ab][0]=10; 
        ownerindex[0xf84BA7aD45418F36A35dfD664445D6e5fbC4f2ab][0]=11;  
        autorizereproduce[10]=0x4538fA1B83872e981E1a91aF385B45F7bEdc10ab;  
         autorizereproduce[11]=0xf84BA7aD45418F36A35dfD664445D6e5fbC4f2ab;  
      // _mint(address(0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0), 1);
       //_mint(msg.sender, 2);
     //  isDispoToSell[2]=true;
      // isPrice[2]=0.0000001 ether;
       // _mint(address(0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0), 4);
        // AssociateAnimalToHolder(4, 1, 1, false, "J3Lh1HPZpVQhIEN");
       // BreederCustomers.push(0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0);
    }



	function AssociateAnimalToHolder(uint animalNumber, uint sex, uint legs, bool wings, string memory name) public {
        Animal memory animal=Animal(sex,legs,wings,name);
        animals[animalNumber]=animal;
    }

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(to, tokenId);
    }

    // Breeding function
	function isBreeder(address account) external override returns (bool) {
        for(uint i=0;i<BreederCustomers.length;i++){
            if(BreederCustomers[i]==account){
                return true;
      }
    }
        return false;
    }

	function registrationPrice() external override returns (uint256) {
        return 0.000001 ether;
    }

	function registerMeAsBreeder() external override payable {
        BreederCustomers.push(0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0);
    }

	function declareAnimal(uint sex, uint legs, bool wings, string calldata name) external override returns (uint256) {  
        _mint(address(0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0), 4);
        AssociateAnimalToHolder(4, sex, legs, wings, name);
        return 4;
    }

	function getAnimalCharacteristics(uint animalNumber) external override returns (string memory _name, bool _wings, uint _legs, uint _sex) {
        Animal memory animal=animals[animalNumber];
        return (animal.name, animal.wings, animal.legs, animal.sex);    
    }

	function declareDeadAnimal(uint animalNumber) external override {
        require (ownerOf(animalNumber) == msg.sender, "You are not the owner of this animal");
        _transfer(msg.sender,0x000000000000000000000000000000000000dEaD, animalNumber);
        AssociateAnimalToHolder(animalNumber, 0, 0, false, "");
    }

	function tokenOfOwnerByIndex(address owner, uint256 index) public view override(IExerciceSolution, ERC721) returns (uint256){
         return ownerindex[owner][index];   
    }

	// Selling functions
	function isAnimalForSale(uint animalNumber) external view override returns (bool) {
        return isDispoToSell[animalNumber];
    }

	function animalPrice(uint animalNumber) external view override returns (uint256) {
        return isPrice[animalNumber];
    }

	function buyAnimal(uint animalNumber) external override payable{
        require(isDispoToSell[animalNumber]==true, "This animal is not for sale");
       // require(balanceOf(0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0)>isPrice[animalNumber], "Insufficent balance");
        _transfer(ownerOf(animalNumber),0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0, animalNumber);
    }

	function offerForSale(uint animalNumber, uint price) external override {
        require(ownerOf(animalNumber)==msg.sender, "You are not the owner of this animal");
        isDispoToSell[animalNumber]=true;
        isPrice[animalNumber]=price;
    }

	// Reproduction functions

	function declareAnimalWithParents(uint sex, uint legs, bool wings, string calldata name, uint parent1, uint parent2) external override returns (uint256) {
        require (autorizereproduce[parent2] == msg.sender, "You are not the owner of this animal");   
        require (autorizereproduce[parent1] == msg.sender, "You are not the owner of this animal");
        uint256 animalNumber=_tokenIdCounter.current();
        safeMint(address(0xf84BA7aD45418F36A35dfD664445D6e5fbC4f2ab));
        parents[animalNumber]=Parents(parent1, parent2);
        animals[animalNumber]=Animal(sex,legs,wings,name);
        autorizereproduce[parent2]=0x4538fA1B83872e981E1a91aF385B45F7bEdc10ab;    
        
        return animalNumber;
    }

	function getParents(uint animalNumber) external override returns (uint256, uint256) {
        return (parents[animalNumber].parent1, parents[animalNumber].parent2);
    }

	function canReproduce(uint animalNumber) external override returns (bool) {

        return reproduction[animalNumber].CanReproduce;
    }

	function reproductionPrice(uint animalNumber) external view override returns (uint256) {
        return reproduction[animalNumber].price;
    }

	function offerForReproduction(uint animalNumber, uint priceOfReproduction) external override returns (uint256) {
        require(ownerOf(animalNumber)==msg.sender, "You are not the owner of this animal");
        reproduction[animalNumber]=Reproduction(true, priceOfReproduction);
        return 0;
    }

	function authorizedBreederToReproduce(uint animalNumber) external override returns (address) {
        return autorizereproduce[animalNumber];
    }

	function payForReproduction(uint animalNumber) external override payable{
        autorizereproduce[animalNumber]=msg.sender;

    }
}