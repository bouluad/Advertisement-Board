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
    <title>Annonces Cloud </title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/stylesheets/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <link href="/stylesheets/css/main.css" rel="stylesheet" media="screen">
</head>
<body>

<div class="container-narrow">

    <div class="masthead">
        <ul class="nav nav-pills pull-right">
            <li class="active"><a href="/">Accueil</a></li>
            <li><a href="#list">Les annonces </a></li>
            <li><a href="#upload">Upload annonce</a></li>
        </ul>
        <h3 class="muted">Annonces Uploader</h3>
    </div>

    <div class="row-fluid iconlist" id="list">

        <h2>Liste des annonces</h2>

        <p>
            <span class="label">Note</span> Seules les 9 dernières icônes
            uploadées sont présentées ici.
        </p>

        <%
            List<Upload> uploads = (List<Upload>) request.getAttribute("uploads");
            if (uploads.size() == 0) {
        %>

        <p>
            <em>Aucune annonce uploadée</em>
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
                    <figcaption>
                        <a class="close" href="/?delete=<%=upload.getKeyString() %>">&times;</a>

                    </figcaption>
                    <div>
                        <p>
                            <%=upload.getTitre()%>
                        </p>
                        <p>
                            <%=upload.getDescription()%>
                        </p>
                        <p>
                            <%=upload.getPrix()%> €
                        </p>
                        <p>
                            <%=upload.getDate()%>
                        </p>
                    </div>

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

        <h2>Uploader une annonce</h2>

        <form action="<%= blobstoreService.createUploadUrl("/") %>" method="post" enctype="multipart/form-data">

            <div>
                <p>
                    <label>Fichier à envoyer : <input type="file" name="uploadedFile" /></label> <br/>
                </p>

                <p>
                <label>Titre de l'annonce : <input type="text" name="titre" /></label> <br/>
                </p>

                <p>
                <label>Prix : <input type="text" name="prix" /></label> <br/>
                </p>

                <p>
                <label>Description :<textarea name="description" rows="3" cols="60"></textarea>
                </label> <br/>
                </p>
            </div>


            <div class="form-actions">
                <input type="submit" class="btn" />
            </div> <br/>
        </form>
    </div>

</div>
<script src="http://code.jquery.com/jquery.js"></script>
<script src="/stylesheets/js/bootstrap.min.js"></script>
</body>
</html>