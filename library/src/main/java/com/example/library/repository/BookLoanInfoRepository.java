package com.example.library.repository;

import com.example.library.model.BookLoanInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookLoanInfoRepository extends JpaRepository<BookLoanInfo, Long> {
    // 등록 번호와 상태로 책 대출 정보 조회
    List<BookLoanInfo> findByRegistrationNoAndStatus(String registrationNo, BookLoanInfo.Status status);
}