// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ownable.sol";

contract wallet is Ownable {
//  declare price,no of seats and event date
 uint256 public  eth = 0.001 ether;
 uint256 public ethforvip = 0.004 ether;
 uint256 public seats = 100;
 uint256  public vipseats = 50;
 uint256 public  eventDate;

//  mapping 
 mapping (address => uint) public usertoTicket;
 mapping (address => uint) public usertoVipTicket;

// event
  event PurchasedTicket(address indexed buyer,uint ticketno, uint amount);
  event Refund(address indexed user,uint ticketno,uint amount);
  event Withdraw(address indexed withdraweth , uint amount);
  event ticketinfo(address indexed user,uint ticketno);

// struct
    struct Ticket {
      address buyer;
       string name;
       string email;
       uint phoneNo;
       uint  ticketNo;
       bool refunded;
      }

// store user data here
    Ticket[] public details;
    Ticket[] public vipdetails;

// buy ticket here
    function payforticket(string memory _name,
       string memory _email,
       uint _phoneNo) public   payable  {
        require(msg.value == eth, "you have to pay exact amount of eth");
        require(seats > 0,"seats are full");
        require(usertoTicket[msg.sender] == 0 && usertoVipTicket[msg.sender] == 0,"you already own a ticket");
        seats -=1;
        uint TicketNO = details.length +1;
        
        details.push(Ticket({
          buyer:msg.sender,
            name:_name,
            email: _email,
            phoneNo:_phoneNo,
            ticketNo:TicketNO,
            refunded:false
            }));
      usertoTicket[msg.sender] = TicketNO;
      emit PurchasedTicket(msg.sender, TicketNO, eth);
    }

    // refund users eth
    constructor(){
      eventDate = block.timestamp + 7 days;
    }
    function refund() external  {
      uint TicketNo = usertoTicket[msg.sender];
      
      require(block.timestamp < eventDate, "refund period is over");
      require(TicketNo > 0,"you dont own Ticket");
      
      usertoTicket[msg.sender] = 0;
      seats +=1;

      uint256 idx = TicketNo - 1;
      if (idx < details.length){
        details[idx].refunded = true;
      }
      

      (bool sent,) =  payable(msg.sender).call{value: eth}("");
       require(sent,"error:issue with refund");
       
      emit Refund(msg.sender, TicketNo, eth);
    }

     
    
    // vip tickets
   function Buyvipseats(string memory _name,
       string  memory _email,
       uint _phoneNo)  payable public {
        require(msg.value == ethforvip, "you have to pay exact amount of eth");
        require( vipseats > 0,"seats are full");
        require(usertoVipTicket[msg.sender] == 0 && usertoTicket[msg.sender] == 0,"you have to buy one ticket");

      vipseats -=1;
        uint VipTicketNo = vipdetails.length +1;

        vipdetails.push(Ticket({
          buyer:msg.sender,
          name:_name,
          email:_email,
          phoneNo:_phoneNo,
          ticketNo:VipTicketNo,
          refunded:false
        }));
        usertoVipTicket[msg.sender] = VipTicketNo;
        emit PurchasedTicket(msg.sender,VipTicketNo , ethforvip);
   }
  //  refund feature for vip
    function refundforvip() external {
    uint ticketno = usertoVipTicket[msg.sender];

      require(block.timestamp < eventDate, "refund period is over");
      require(ticketno > 0,"you dont own Ticket");
      
      usertoVipTicket[msg.sender] = 0;
      vipseats+=1;

        uint256 idx = ticketno - 1; // convert to 0-based
        if (idx < vipdetails.length) {
            vipdetails[idx].refunded = true;
        }
  
     (bool sent,) = payable(msg.sender).call{value:ethforvip}("");
      require(sent,"error:issue with refund");

      emit Refund(msg.sender, ticketno, ethforvip);
   }

    //  withdraw the eth
      function withdraw() external onlyOwner {
      require(block.timestamp > eventDate,"event is not over");
      uint amount = address(this).balance;
      (bool sent,) =  payable(owner()).call{value: amount}("");
      require(sent,"error:fail to withdraw ether");
      
      emit Withdraw(owner(),amount);
   }

// check user information
   function checkticket() external view  returns  (Ticket memory t) {
    uint Ticketno=usertoTicket[msg.sender];
    require(Ticketno > 0,"you dont own ticket");
    uint256 idx =Ticketno-1;
  require(idx < details.length, " invalid index");
   return details[idx];
   }

// check vip user information
   function checkticketvip() external view  returns  (Ticket memory t) {
    uint Ticketno=usertoVipTicket[msg.sender];
    require(Ticketno > 0,"you dont own ticket");
    uint256 idx =Ticketno-1;
    require(idx < vipdetails.length, " invalid index");
   return vipdetails[idx];
   }

// check no of ticket sold
   function soldticket() external view returns(uint256){
    return  details.length;
   }
// check no of vip ticket sold
   function soldvipticket() external view returns(uint256){
    return vipdetails.length;
   }

// set ticket prize of regular and vip
   function setticketprize(uint _ticket,uint _vipticket) external onlyOwner{
    eth  = _ticket * 1 ether;
    ethforvip = _vipticket * 1 ether;
   }

// set event date 
   function seteventdate(uint256 _eventdate) external onlyOwner{
    eventDate = _eventdate;
   }
} 
