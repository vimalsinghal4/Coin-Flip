pragma solidity ^0.8.0;
contract betting{
    
    address payable[] public players;
    mapping (address=>uint256) public bid;
    mapping(address=>uint256) choice;
    mapping(address=>bool) allPlayers;
    address public admin;
    uint256 playerid;
    uint256 time;
    bool started;
    bool ended;
    uint public rate = 100 ;
    mapping(address=>uint256) public balance;
    uint256 public current;
    bytes32 public _ans;
    bool public outCome;
    uint256 public eventid;

    constructor() {
        admin = msg.sender;
        //automatically adds admin on deployment
    }
    modifier onlyOwner() {
        require(admin == msg.sender, "You are not the owner");
        _;
    }
     receive() payable external{
        
     }
     //event for winners
    event Winner(
    uint256 indexed _eventid,
     address indexed _address,
     uint256 _bid
    );



    //Withdraw function to withdrow one token used to buy coins
    function withdraw(uint256 _amount) payable public returns(bool){
     require(balance[msg.sender]-_amount>=100);
     require(address(this).balance>=(_amount/rate)*1000000000000000000);
     balance[msg.sender]-=_amount;
     payable(msg.sender).transfer((_amount*1000000000000000000)/rate);
     return true;
    }



    //free coins for new users
    function FreeCoins() public returns(bool){
      require(msg.sender!=admin);
      require(allPlayers[msg.sender]==false);
      balance[msg.sender]+=100;
      return true;
  }



      //admin can start new event only after previous has ended
    function startevent( uint256 _time) public onlyOwner returns (bool) {
        if (started) {
            revert("One betting is already in action");
        }
        require(_time>0);
        time=_time+block.timestamp;
        started = true;
        ended = false;
        outCome=false;
        eventid++;
        return true;
    } 


//harmony vrf function to produce random values
function generateOutcome() public onlyOwner returns (bytes32 result) {
        require(started);
        if(outCome){
            revert("Outcome already generated");
        }
    uint[1] memory bn;
    bn[0] = block.number;
    assembly {
      let memPtr := mload(0x40)
      if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
        invalid()
      }
      result := mload(memPtr)
    }
    _ans=result;
    current=uint256(_ans)%2;
    outCome=true;
  }


    function enter(uint256 _choice,uint256 _amount) public {
        if(!started){
            revert("NO betting event right now");
        }
        if(time<block.timestamp){
            revert("Betting has ended");
        }
        if(_choice>1||_choice<0){
            revert("Please select zero or one");
        }
        if(msg.sender==admin){
            revert("Sorry but you can't enter betting");
        }
        require(_amount>=10);
        require(balance[msg.sender]>=_amount);
        if(bid[msg.sender]!=0){
            revert("You can't bet more than once");
        }
        balance[msg.sender]-=_amount;
        players.push(payable(msg.sender));
        choice[msg.sender]=_choice;
        bid[msg.sender]=_amount;
    }


    function buycoins(uint256 _amount) payable public returns(bool){
        if(msg.sender==admin){
            revert("Admin can't buy coins");
        }
        require(_amount>=10);
        require(msg.value==(_amount*1000000000000000000)/rate);
        balance[msg.sender]+=_amount;
        return true;
    }



    function endevent() public onlyOwner returns(bool){
        require(started);
        if(block.timestamp<time){
            revert("betting has not ended");
        }
        if(outCome==false){
            revert("Please generate outcome first");
        }
        ended=true;
        started=false;
        uint256 i;
         for(i=0;i<players.length;i++){
            if(choice[players[i]]==current){
                balance[players[i]]+=2*bid[players[i]];   
                emit Winner(eventid,players[i],bid[players[i]]);
            }
            delete(bid[players[i]]);
            delete(choice[players[i]]);
         }
         resetLottery();
        return true;
    }
    


    function getBalance() public view onlyOwner returns(uint){
        // returns the contract balance
        return address(this).balance;
    }


    //resets the players array, removes players from last game.
    function resetLottery() internal {
        players = new address payable[](0);
        started=false;
        ended=true;
    }
}
