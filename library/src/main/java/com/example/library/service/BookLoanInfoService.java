package com.example.library.service;

import com.example.library.model.BookLoanInfo;
import com.example.library.repository.BookLoanInfoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookLoanInfoService {

    private final BookLoanInfoRepository bookLoanInfoRepository;

    public BookLoanInfoService(BookLoanInfoRepository bookLoanInfoRepository) {
        this.bookLoanInfoRepository = bookLoanInfoRepository;
    }

    // 특정 책의 상태를 조회
    public List<BookLoanInfo> getBookStatusByRegistrationNo(String registrationNo) {
        return bookLoanInfoRepository.findByRegistrationNoAndStatus(registrationNo, BookLoanInfo.Status.Borrowed);
    }

    // 새로운 대출 정보 생성
    public BookLoanInfo createBookLoan(BookLoanInfo bookLoanInfo) {
        return bookLoanInfoRepository.save(bookLoanInfo); // JPA 기본 제공 save 메서드
    }

    // 책 반납 처리
    public void returnBook(Long loanId) {
        BookLoanInfo bookLoanInfo = bookLoanInfoRepository.findById(loanId)
                .orElseThrow(() -> new RuntimeException("Book Loan Info not found with ID: " + loanId));

        // 상태를 반납으로 변경
        bookLoanInfo.setStatus(BookLoanInfo.Status.Returned);
        bookLoanInfoRepository.save(bookLoanInfo);
    }
}