// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24; 

import 'hardhat/console.sol';
import './dependencies/IERC20.sol';
import './dependencies/IStaking.sol';


contract LoanBoard is IERC20 {

  IERC20 public token;
  address public owner;

  constructor(
      address _token
  ) {
      owner = msg.sender;
      token = IERC20(_token);
  }

  struct Employer{
    uint employerId;
    address empAddress;
  }

  struct User {
    uint userId;
    address userAddress;
    uint salary;
  }

  struct Loan {
    Employer employer;
    User user;
    string applystatus;
    uint amount;
    uint repayPeriod;
    uint rate;
  }


  mapping(uint => (Loan)) public loans;
  uint public loanCount;
   
  event LoanPosted(
    uint loanId,
    address employer;
    address user;
    string memory applystatus;
    uint amount;
    uint repayPeriod;
    uint rate;
  );

  event LoanApplied(
    uint loanId,
    address employer;
    address user;
    string memory applystatus;
    uint amount;
    uint repayPeriod;
    uint rate;
  );

  event LoanRejected(
    uint loanId,
    address employer;
    address user;
    string memory applystatus;
    uint amount;
    uint repayPeriod;
    uint rate;
  );
  
  event LoanRemited(
    uint loanId,
    address employer;
    address user;
    string memory applystatus;
    uint amount;
    uint repayPeriod;
    uint rate;
  );

  modifier onlyOwner() {
    require(msg.sender == owner, 'not authorized');
    _;
  }

  modifier onlyTokenHolder(uint limit) {
    uint tokenAmount = mainToken.balanceOf(msg.sender);
    require(tokenAmount > limit, 'Insufficient Token Balance.');
    _;
  }


  function trasnferOwner(address _address) public onlyOwner {
    owner = _address;
  }

  function postLoan(
    Employer _employer;
    User _user;
    uint _amount,
    uint _repayPeriod,
    uint _rate
  ) external onlyTokenHolder(tokenAmountForPosting){
    Loan storage newLoan =  loans[loanCount]
    newLoan.employer = _employer;
    newLoan.user = _user;
    newLoan.applystatus = "pending";
    newLoan.amount = _amount;
    newLoan.repayPeriod = _repayPeriod;
    newLoan.rate = _rate;

    emit LoanPosted(
      loanCount,
      _employer.empAddress,
      _user.userAddress,
      newLoan.applystatus,
      _amount,
      _repayPeriod,
      _rate
    );

    loanCount++;
  }

  function getAllloans(
    address _address
  ) external view returns (Loan[] memory) {
    Loan[] memory loanList = new loanList[](loanCount);
    for (uint i = 0; i < loanCount; i++) {
      loanList[i].employer = loans[i].employer;
      loanList[i].user = loans[i].user;
      loanList[i].applystatus = loans[i].applystatus;
      loanList[i].amount = loans[i].amount;
      loanList[i].repayPeriod = loans[i].repayPeriod;
      loanList[i].rate = loans[i].rate;
    }
    return loanList;
  }

  function getEmploans(
    address _address
  ) external view returns (Loan[] memory) {
    Loan[] memory loanList = new loanList[](loanCount);
    for (uint i = 0; i < loanCount; i++) {
      if(loans[i].employer.empAddress == _address){
        loanList[i].employer = loans[i].employer;
        loanList[i].user = loans[i].user;
        loanList[i].applystatus = loans[i].applystatus;
        loanList[i].amount = loans[i].amount;
        loanList[i].repayPeriod = loans[i].repayPeriod;
        loanList[i].rate = loans[i].rate;
      }
    }
    return loanList;
  }

  function getUserloans(
    address _address
  ) external view returns (Loan[] memory) {
    Loan[] memory loanList = new loanList[](loanCount);
    for (uint i = 0; i < loanCount; i++) {
      if(loans[i].employer.empAddress == _address){
        loanList[i].employer = loans[i].employer;
        loanList[i].user = loans[i].user;
        loanList[i].applystatus = loans[i].applystatus;
        loanList[i].amount = loans[i].amount;
        loanList[i].repayPeriod = loans[i].repayPeriod;
        loanList[i].rate = loans[i].rate;
      }
    }
    return loanList;
  }

  function applyLoan(
    User memory user,
    Employer memory employer,
    IERC20 token,
    uint amount,
  ) external {
    uint memory id;
    for (uint i = 0; i < loanCount; i++){
      if(loans[i].employer.empAddress == employer.empAddress && loans[i].user.userAddress == loans[i].userAddress)
      {
        loans[i].applystatus = "applied";
        id = i;
      }
    }

    bool sent = token.transferFrom(employer.empAddress, user.userAddress, amount);

    require(sent, "Token transfer failed");

    emit LoanApplied(
      id,
      loans[id].employer.empAddress,
      loans[id].user.userAddress,
      loans[id].applystatus,
      loans[id].amount,
      loans[id].repayPeriod,
      loans[id].rate
    );
    
  }

  function onedayReduced(
    IERC20 token,
  ) external {

    for (uint i = 0; i < loanCount; i++){
        loans[i].repayPeriod--;
    }
    
  }


  function rejectLoan(
    User memory user,
    Employer memory employer,
    IERC20 token,
    uint amount,
  ) external {
    uint memory id;
    for (uint i = 0; i < loanCount; i++){
      if(loans[i].employer.empAddress == employer.empAddress && loans[i].user.userAddress == loans[i].userAddress)
      {
        loans[i].applystatus = "rejected";
        id = i;
      }
    }

    emit LoanRejected(
      id,
      loans[id].employer.empAddress,
      loans[id].user.userAddress,
      loans[id].applystatus,
      loans[id].amount,
      loans[id].repayPeriod,
      loans[id].rate
    );
    
  }

  function remitLoan(
    address memory user,
    address memory employer,
    IERC20 token,
    uint amount,
  ) external {
    uint memory id;
    for (uint i = 0; i < loanCount; i++){
      if(loans[i].employer.empAddress == employer.empAddress && loans[i].user.userAddress == loans[i].userAddress)
      {
        loans[i].applystatus = "remited";
        id = i;
      }
    }

    bool sent = token.transferFrom(user, employer, amount);
    require(sent, "Token transfer failed");

    emit LoanRemited(
      id,
      loans[id].employer.empAddress,
      loans[id].user.userAddress,
      loans[id].applystatus,
      loans[id].amount,
      loans[id].repayPeriod,
      loans[id].rate
    );
  }


}