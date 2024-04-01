package hotelProject.hotelp2;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class Hotelp2Application {

	public static void main(String[] args) {
		SpringApplication.run(Hotelp2Application.class, args);
	}

	public String index() {
		return "homepage";
	}
}