package com.example.library.controller;

import com.example.library.model.BookLoanInfo;
import com.example.library.service.BookLoanInfoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/book-loans")
public class BookLoanInfoController {

    private final BookLoanInfoService bookLoanInfoService;

    public BookLoanInfoController(BookLoanInfoService bookLoanInfoService) {
        this.bookLoanInfoService = bookLoanInfoService;
    }

    // 사용자가 대출 중인 책 조회
    @GetMapping("/book/{registrationNo}/status")
    public ResponseEntity<List<BookLoanInfo>> getBookStatus(@PathVariable String registrationNo) {
        return ResponseEntity.ok(bookLoanInfoService.getBookStatusByRegistrationNo(registrationNo));
    }

    // 새로운 대출 생성
    @PostMapping
    public ResponseEntity<BookLoanInfo> createBookLoan(@RequestBody BookLoanInfo bookLoanInfo) {
        return ResponseEntity.ok(bookLoanInfoService.createBookLoan(bookLoanInfo));
    }

    // 책 반납 처리
    @PutMapping("/{loanId}/return")
    public ResponseEntity<Void> returnBook(@PathVariable Long loanId) {
        bookLoanInfoService.returnBook(loanId);
        return ResponseEntity.noContent().build();
    }
}
