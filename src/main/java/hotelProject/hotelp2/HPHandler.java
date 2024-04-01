package hotelProject.hotelp2;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HPHandler {

    @GetMapping("/example")
    public String example() {
        return "example"; // Returns the HTML file named "example.html"
    }
}
