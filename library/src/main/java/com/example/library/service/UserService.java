package com.example.library.service;

import com.example.library.model.User;
import com.example.library.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // ID로 사용자 조회
    public User getUserById(String id) {
        return userRepository.findById(id).orElse(null);
    }

    // 모든 사용자 조회
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // 사용자 인증
    public boolean authenticateUser(String id, String password) {
        User user = userRepository.findById(id).orElse(null);
        return user != null && user.getPassword().equals(password);
    }
}