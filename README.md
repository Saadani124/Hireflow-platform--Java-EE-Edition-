# 🚀 HireFlow (Java EE Edition)

> **Note:** This is the Java Enterprise Edition (EE) version of the [Official HireFlow Platform](https://github.com/Saadani124/Hireflow-platform). While not 100% identical to the official FastAPI/Angular version, it serves the same core idea: an AI-powered freelancer marketplace designed for high-performance talent matching, rebuilt natively using Java technologies.

HireFlow is a professional freelance platform designed to connect talented freelancers with potential clients. Built with Java Enterprise Edition (Jakarta EE), it offers a robust, scalable, and maintainable backend architecture.
## Features

- **User Authentication**: Secure login and registration for both Freelancers and Clients.
- **Job Applications**: Freelancers can browse available job posts and apply directly.
- **Freelancer Ratings**: Clients can rate freelancers upon completion of jobs.
- **AI-Powered Chatbot Integration**:
  - Integrated with **OpenRouter AI (GPT-4o-mini)**.
  - Automatically summarize long freelancer bios into concise bullet points.
  - Generates professional freelancer bios based on their skills.
  - Acts as an intelligent platform assistant to find the best freelancer based on ratings, list applicants, and answer general platform questions.
- **Admin Dashboard**: Overview of platform statistics and operations.

## Technology Stack

- **Backend**: Java EE / Jakarta EE (Servlets, JSP, EJB, JPA/Hibernate)
- **Database**: MySQL (configured via JNDI `java:/MysqlXADS`)
- **Frontend**: JSP, HTML, CSS, JavaScript
- **AI Integration**: OpenRouter API REST calls

## Project Structure

- `src/main/java/entities/`: JPA Entity classes mapped to the database.
- `src/main/java/controller/`: Servlets handling HTTP requests (e.g., `ChatServlet`).
- `src/main/java/mvcModel/`: EJB services encapsulating business logic.
- `src/main/java/utils/`: Utility classes (e.g., Password hashing).
- `src/main/webapp/`: JSP pages and static assets (CSS, JS).

## Setup Instructions

### Prerequisites
- JDK 11 or higher
- WildFly / JBoss EAP or any compatible Java EE application server
- MySQL Server

### Configuration
1. **Database Setup**:
   Create a database in MySQL and configure your application server's `standalone.xml` (for WildFly) with a datasource named `java:/MysqlXADS`.
2. **Environment Variables**:
   Set the `OPENROUTER_API_KEY` environment variable in your system or application server environment to enable the AI features.
   ```bash
   export OPENROUTER_API_KEY="your_openrouter_api_key_here"
   ```
3. **Deployment**:
   Deploy the project as a Dynamic Web Project to your server or export it as a `.war` file and place it in the server's deployments directory.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
