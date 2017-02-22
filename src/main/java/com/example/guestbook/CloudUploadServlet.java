package com.example.guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.example.guestbook.Upload;
import com.google.appengine.api.blobstore.*;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class CloudUploadServlet extends HttpServlet {
    static {
        ObjectifyService.register(Upload.class);
    }

    public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

        // Récupère les derniers uploads
        List<Upload> uploads = ofy().load().type(Upload.class).order("-date").limit(9).list();
        req.setAttribute("uploads", uploads);

        // Supprime un upload si on l'a demandé
        if (req.getParameter("delete") != null) {
            BlobKey deleteUploadData = new BlobKey(req.getParameter("delete"));
            Upload deleteUploadInfos = ofy().load().type(Upload.class).filter("key", deleteUploadData).first().now();
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

        Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
        List<BlobKey> blobKeys = blobs.get("uploadedFile");

        Upload uploadTitre = new Upload(blobKeys.get(0), req.getParameter("titre"), req.getParameter("description"), req.getParameter("prix"));
        //Upload uploadPrix = new Upload(blobKeys.get(0), req.getParameter("prix"));
        //Upload uploadDate = new Upload(blobKeys.get(2), req.getParameter("date"));


        ofy().save().entity(uploadTitre).now();
        //ofy().save().entity(uploadPrix).now();
        // ofy().save().entity(uploadDate).now();

        resp.sendRedirect("/");

    }
}