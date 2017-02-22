<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.blobstore.*"%>
<%@ page import="com.example.guestbook.Upload"%>

<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory
            .getBlobstoreService();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cloud Uploader</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="css/style.css" rel="stylesheet" media="screen">
</head>
<body>

<div class="container-narrow">

    <div class="masthead">
        <ul class="nav nav-pills pull-right">
            <li class="active"><a href="/">Accueil</a></li>
            <li><a href="#list">Liste des icônes</a></li>
            <li><a href="#upload">Upload</a></li>
        </ul>
        <h3 class="muted">Cloud Uploader</h3>
    </div>

    <hr />

    <div class="jumbotron">
        <h1>
            Vos icônes<br />dans le Cloud
        </h1>
        <p class="lead">En un clic, uploadez vos icônes dans le Cloud de
            Google et votez pour votre icône préférée !</p>
        <a class="btn btn-large btn-success" href="#upload">Uploader une
            icône</a>
    </div>

    <hr />

    <div class="row-fluid iconlist" id="list">

        <h2>Liste des icônes</h2>

        <p>
            <span class="label">Note</span> Seules les 9 dernières icônes
            uploadées sont présentées ici.
        </p>

        <%
            List<Upload> uploads = (List<Upload>) request.getAttribute("uploads");
            if (uploads.size() == 0) {
        %>

        <p>
            <em>Aucune icône uploadée</em>
        </p>

        <%
        }
        else {
            int i = 0;
            for (Upload upload : uploads) {
                if ((i % 3) == 0) {
        %>
        <div class="row">
            <% } %>

            <div class="span4">
                <figure>
                    <img src="<%=upload.getUrl()%>" alt="Image utilisateur"
                         class="img-polaroid" style="max-width: 100px;" />
                    <figcaption><a class="close" href="/?delete=<%=upload.getKeyString() %>">&times;</a> <%=upload.getDescription()%></figcaption>
                </figure>
            </div>

            <%
                if ((i % 3) == 2 || i == uploads.size() - 1) {
            %>
        </div>
        <%			}
            i++;
        }
        }%>

    </div>

    <hr />

    <div class="row-fluid iconlist" id="upload">

        <h2>Uploader une icône</h2>

        <form
                action="<%= blobstoreService.createUploadUrl("/") %>"
                method="post" enctype="multipart/form-data">
            <p>
                <label>Fichier à envoyer : <input type="file"
                                                  name="uploadedFile" /></label>
            </p>
            <p>
                <label>Description du fichier : <input type="text"
                                                       name="description" /></label>
            </p>
            <div class="form-actions">
                <input type="submit" class="btn" />
            </div>
        </form>
    </div>

</div>
<script src="http://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
</body>
</html>