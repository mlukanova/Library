// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../contracts/Library.sol";

contract LibraryTest {
   
    bytes32[] books;
    
   
    Library libraryToTest;
    function beforeAll () public {
        libraryToTest = new Library();
    }
    
    function checkgetBorrowers() public {
        libraryToTest.getBorrowers(1);
        libraryToTest.getBookCollectionIds();
    }
    
    function checkGetBookCollectionIds () public {
    }
}
