package com.example.library.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
public class BookLoanInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // 대출 ID (Primary Key)

    private String registrationNo; // 대출 등록 번호
    private String callNo; // 호출 번호
    private String location; // 도서 위치

    @Enumerated(EnumType.STRING)
    private Status status; // 상태 (대출 중, 예약됨, 반납됨)

    private LocalDate returnDate; // 반납 날짜

    @ManyToOne
    @JoinColumn(name = "user_id") // 사용자와 연결
    private User user; // User 엔티티와의 관계 설정

    // 상태를 나타내는 Enum
    public enum Status {
        Borrowed, Reserved, Returned
    }

    // 기본 생성자 (JPA에서 필요)
    public BookLoanInfo() {}

    // 모든 필드를 포함하는 생성자
    public BookLoanInfo(String registrationNo, String callNo, String location, Status status, LocalDate returnDate, User user) {
        this.registrationNo = registrationNo;
        this.callNo = callNo;
        this.location = location;
        this.status = status;
        this.returnDate = returnDate;
        this.user = user;
    }

    // Getters와 Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRegistrationNo() {
        return registrationNo;
    }

    public void setRegistrationNo(String registrationNo) {
        this.registrationNo = registrationNo;
    }

    public String getCallNo() {
        return callNo;
    }

    public void setCallNo(String callNo) {
        this.callNo = callNo;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
