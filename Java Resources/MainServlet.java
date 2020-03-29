
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class MainServlet extends HttpServlet {

	String path;

	public void init() throws ServletException {
		path = "/jsps/main.jsp";
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession (true);

		ServletContext servletContext = getServletContext();
		RequestDispatcher requestDispatcher = servletContext.getRequestDispatcher(path);
		requestDispatcher.forward(request, response);

	}

}
