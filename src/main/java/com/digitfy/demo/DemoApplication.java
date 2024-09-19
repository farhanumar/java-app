package com.digitfy.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController

public class DemoApplication {


    @RequestMapping("/")
        public String index() {
            return "This is the index!\n";
        }
    @RequestMapping("/hello")
        public String index2() {

            return "Hello, World!\n";
        }


	public String SpringStart() {
		return "HelloWorld Springboot!!!!";
	}

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

}
