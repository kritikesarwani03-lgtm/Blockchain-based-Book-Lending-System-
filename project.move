module MyModule::BookLending {
    use aptos_framework::signer;
    
    /// Error codes
    const E_BOOK_ALREADY_BORROWED: u64 = 1;
    
    /// Struct representing a book available for lending
    struct Book has store, key {
        title: vector<u8>,          // Book title
        owner: address,             // Original owner of the book
        is_borrowed: bool,          // Whether the book is currently borrowed
        borrower: address,          // Address of current borrower
        lending_fee: u64,           // Fee required to borrow the book
    }
    
    /// Function to list a book for lending
    public fun list_book(
        owner: &signer, 
        title: vector<u8>, 
        lending_fee: u64
    ) {
        let owner_addr = signer::address_of(owner);
        let book = Book {
            title,
            owner: owner_addr,
            is_borrowed: false,
            borrower: owner_addr,
            lending_fee,
        };
        move_to(owner, book);
    }
    
    /// Function to borrow a book
    public fun borrow_book(
        borrower: &signer, 
        book_owner: address
    ) acquires Book {
        let borrower_addr = signer::address_of(borrower);
        let book = borrow_global_mut<Book>(book_owner);
        
        // Check if book is available
        assert!(!book.is_borrowed, E_BOOK_ALREADY_BORROWED);
        
        // Update book status
        book.is_borrowed = true;
        book.borrower = borrower_addr;
    }
}