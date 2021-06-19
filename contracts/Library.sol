// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
pragma abicoder v2;

import "./Ownable.sol";

contract Library is Ownable{
    
    struct Book {
        uint8 id;
        string title;
        string author;
        uint8 quantity;
    }
    
    mapping(uint8 => uint8) internal availability;
    mapping(uint8 => address[]) internal borrowers;
    mapping(uint8 => uint8) internal bookCollection;
    mapping(address => mapping(uint8 => bool)) internal libraryCard;
    
    uint8[] internal bookIds;
    
    // Checks if book is available 
    modifier enoughCopies(uint8 _id){
        require(availability[_id] >= 1,"Book is not avalailabe.");
        _;
    }
    
    // Check if book exists
    modifier bookExists(uint8 _id){
        require(bookCollection[_id] > 0, "This book does not exist.");
        _;
    }
    
    /*
     * Adds a new book to the Library.Only avaible for the owner.
     * @param book Book struct
     */
    function addBook(Book calldata _book) public onlyOwner {
        require(_book.id > 0, "Book id should be greater than 0.");
        require(_book.quantity > 0, "Book quantity should be greater than 0.");
        if(availability[_book.id] < 1){
            bookIds.push(_book.id); 
        }
        availability[_book.id] = _book.quantity;
        bookCollection[_book.id] = _book.quantity;
    }
    
    /*
     * Returns a book back to the Library. The book can be returned only if taken by the user.
     * @param id of the book
     */
    function returnBook(uint8 _id) public bookExists(_id) {
        require(availability[_id] < bookCollection[_id], "Library already full.");
        require(libraryCard[msg.sender][_id] == true, "This book is not taken from you.");
        availability[_id]++;
        libraryCard[msg.sender][_id] = false;
    }
    
    /*
     * Borrows a book from the Library if avaible and user don't have a copy.
     * @param id of the book
     */
    
    function borrowBook(uint8 _id) public bookExists(_id) enoughCopies(_id) {
        require(libraryCard[msg.sender][_id] == false, "You already borrowed this book.");
        libraryCard[msg.sender][_id] = true;
        borrowers[_id].push(msg.sender);
        availability[_id]--;
    }
    
    /*
     * Gets all addresses that have taken a given book.
     * @param id of the book
     */
    function getBorrowers(uint8 _id) public view bookExists(_id) returns(address[] memory) {
        return borrowers[_id];
        
    }
    
    /*
     * Gets all books ids.
     */
    function getBookCollectionIds() public view returns(uint8[] memory) {
        return bookIds;
    }
}
