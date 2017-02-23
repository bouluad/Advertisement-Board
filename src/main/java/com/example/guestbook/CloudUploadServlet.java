package com.example.guestbook;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import static com.googlecode.objectify.ObjectifyService.ofy;

@SuppressWarnings("serial")
public class CloudUploadServlet extends HttpServlet {
    static {
        ObjectifyService.register(Upload.class);
    }

    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();  // Find out who the user is.

        BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

        // Récupère les derniers uploads
        List<Upload> uploads = ofy().load().type(Upload.class).order("-date").limit(100).list();
        req.setAttribute("uploads", uploads);

        // Supprime un upload si on l'a demandé
        if (req.getParameter("delete") != null) {
            BlobKey deleteUploadData = new BlobKey(req.getParameter("delete"));
            Upload deleteUploadInfos = ofy().load().type(Upload.class).filter("key", deleteUploadData).first().now();
            deleteUploadInfos.setAuthor_email(user.getEmail());
            if (deleteUploadInfos != null) {
                blobstoreService.delete(deleteUploadData);
                ofy().delete().entity(deleteUploadInfos).now();
            }
        }

        this.getServletContext().getRequestDispatcher("/annonce.jsp").forward(req, resp);
    }


    public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();  // Find out who the user is.

        Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
        List<BlobKey> blobKeys = blobs.get("uploadedFile");

        Upload uploadTitre = new Upload(blobKeys.get(0), req.getParameter("titre"), req.getParameter("description"), req.getParameter("prix"));
        uploadTitre.setAuthor_email(user.getEmail());

        ofy().save().entity(uploadTitre).now();

        resp.sendRedirect("/");

    }
}