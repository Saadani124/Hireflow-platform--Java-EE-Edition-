package controller;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import entities.Application;
import entities.Post;
import mvcModel.ApplicationService;
import mvcModel.PostService;

@WebServlet("/ChatServlet")
public class ChatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ApplicationService applicationService;

    @EJB
    private PostService postService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set request encoding to UTF-8 to prevent mojibake before any getParameter calls
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        // generate bio
        try {
            String userMessage = request.getParameter("message");
            String action = request.getParameter("action");

            if ("generateBio".equals(action)) {
                String skills = request.getParameter("skills");
                String prompt = "You are a professional profile writer. Create a compelling, professional summary for a freelancer based on these skills: "
                        + skills +
                        ". Also consider these details: " + userMessage +
                        ". The summary MUST be in simple phrases (3-4 phrases) with no introductory text.";
                String bio = callOpenRouter(prompt);
                response.getWriter().write(bio);
                return;
            }

            // summarize bio
            if ("summarizeBio".equals(action)) {
                String bio = request.getParameter("bio");
                if (bio == null || bio.trim().isEmpty()) {
                    response.getWriter().write("• No bio provided");
                    return;
                }
                
                String prompt = "Please summarize the following freelancer bio into exactly 3 concise bullet points. Each bullet point MUST be on a new line and start with a standard bullet (•). Do not include any introductory text, concluding text, or emojis.\n\nBio:\n" 
                        + bio;
                String summary = callOpenRouter(prompt);
                response.getWriter().write(summary);
                return;
            }

            if (userMessage == null || userMessage.trim().isEmpty()) {
                response.getWriter().write("Please type a message.");
                return;
            }

            String msg = userMessage.toLowerCase().trim();
            String reply;

            // ================= BUTTON COMMANDS =================
            if (msg.equals("best freelancer")) {
                List<Application> apps = applicationService.getAllApplications();
                reply = getBestFreelancer(apps);
                response.getWriter().write(reply);
                return;
            }

            if (msg.equals("list applicants")) {
                List<Application> apps = applicationService.getAllApplications();
                reply = listApplicants(apps);
                response.getWriter().write(reply);
                return;
            }

            if (msg.equals("how to apply")) {
                response.getWriter().write("To apply, open a job and click Apply.");
                return;
            }

            if (msg.equals("how to rate")) {
                response.getWriter().write("After completing a job, you can rate the freelancer.");
                return;
            }

            // ================= AI MODE =================
            List<Application> apps = applicationService.getAllApplications();
            List<Post> posts = postService.getAllPosts();

            StringBuilder context = new StringBuilder();

            context.append("You are an assistant for a freelance platform.\n\n");

            // ===== JOBS =====
            context.append("Jobs:\n");
            for (Post p : posts) {
                context.append("- ")
                        .append(p.getTitle())
                        .append(", budget: ")
                        .append(p.getBudget())
                        .append("\n");
            }

            // ===== FREELANCERS =====
            context.append("\nFreelancers:\n");

            Set<Integer> seen = new HashSet<>();

            for (Application a : apps) {
                int freelancerId = a.getFreelancer().getUserId();

                if (seen.contains(freelancerId))
                    continue;
                seen.add(freelancerId);

                double avg = applicationService.getAverageRating(freelancerId);

                context.append("- ")
                        .append(a.getFreelancer().getUsername())
                        .append(", rating: ")
                        .append(String.format("%.1f", avg))
                        .append("\n");
            }

            String fullPrompt = context.toString() +
                    "\nUser question: " + userMessage;

            reply = callOpenRouter(fullPrompt);

            response.getWriter().write(reply);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Something went wrong 🤖");
        }
    }

    // ================= BEST FREELANCER =================
    private String getBestFreelancer(List<Application> apps) {

        Application best = null;
        double bestRating = -1;

        for (Application a : apps) {
            double avg = applicationService.getAverageRating(
                    a.getFreelancer().getUserId());

            if (avg > bestRating) {
                bestRating = avg;
                best = a;
            }
        }

        if (best == null)
            return "No freelancer found.";

        return "Best freelancer is " +
                best.getFreelancer().getUsername() +
                " ⭐ (" + String.format("%.1f", bestRating) + ")";
    }

    // ================= LIST APPLICANTS =================
    private String listApplicants(List<Application> apps) {

        StringBuilder sb = new StringBuilder("Here are the applicants:\n");

        Set<Integer> seen = new HashSet<>();

        for (Application a : apps) {
            int freelancerId = a.getFreelancer().getUserId();

            if (seen.contains(freelancerId))
                continue;
            seen.add(freelancerId);

            double avg = applicationService.getAverageRating(freelancerId);

            sb.append("- ")
                    .append(a.getFreelancer().getUsername())
                    .append(" (⭐ ")
                    .append(String.format("%.1f", avg))
                    .append(")\n");
        }

        return sb.toString();
    }

    // ================= OPENROUTER CALL =================
    @SuppressWarnings("deprecation")
    private String callOpenRouter(String prompt) {

        try {
            URL url = new URL("https://openrouter.ai/api/v1/chat/completions");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            String apiKey = System.getenv("OPENROUTER_API_KEY");
            if (apiKey == null || apiKey.isEmpty()) {
                // Fallback for demonstration or prompt the user to set it
                apiKey = "YOUR_OPENROUTER_API_KEY";
            }
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("HTTP-Referer", "http://localhost");
            conn.setRequestProperty("X-Title", "HireFlow");

            conn.setDoOutput(true);

            String jsonInput = "{"
                    + "\"model\":\"openai/gpt-4o-mini\","
                    + "\"messages\":["
                    + "{\"role\":\"system\",\"content\":\"You are an assistant for a freelance platform. Give short, clear answers. Use plain text only. Use line breaks for lists. No explanations unless asked.\"},"
                    + "{\"role\":\"user\",\"content\":\"" + escapeJson(prompt) + "\"}"
                    + "]"
                    + "}";

            OutputStream os = conn.getOutputStream();
            os.write(jsonInput.getBytes("UTF-8"));
            os.close();

            int status = conn.getResponseCode();

            InputStream stream = (status >= 200 && status < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(stream, "UTF-8"));

            StringBuilder response = new StringBuilder();
            String line;

            while ((line = br.readLine()) != null) {
                response.append(line);
            }

            br.close();

            String res = response.toString();

            // ===== SAFE CONTENT EXTRACTION =====
            String marker = "\"content\":\"";
            int start = res.indexOf(marker);

            if (start == -1)
                return "AI error: no content found.";

            start += marker.length();

            StringBuilder content = new StringBuilder();
            boolean escaping = false;

            for (int i = start; i < res.length(); i++) {
                char c = res.charAt(i);

                if (escaping) {
                    if (c == 'n') {
                        content.append('\n'); // FIX newline
                    } else if (c == '"') {
                        content.append('"');
                    } else if (c == '\\') {
                        content.append('\\');
                    } else {
                        content.append(c);
                    }
                    escaping = false;
                } else if (c == '\\') {
                    escaping = true;
                } else if (c == '"') {
                    break;
                } else {
                    content.append(c);
                }
            }

            return content.toString().trim();

        } catch (Exception e) {
            e.printStackTrace();
            return "AI error occurred.";
        }
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
    }

}