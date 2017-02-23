<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.guestbook.Upload" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="java.util.List" %>

<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory
            .getBlobstoreService();
%>


<!DOCTYPE html>
<html>
<head>
    <title>Cloud Uploader</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
    <link type="text/css" rel="stylesheet" href="/stylesheets/dashboard.css"/>
    <!-- Bootstrap core CSS -->
    <link href="/stylesheets/bootstrap.min.css" rel="stylesheet">

    <script src="../../assets/js/ie8-responsive-file-warning.js"></script>
    <![endif]-->
    <script src="../../js/ie-emulation-modes-warning.js"></script>
</head>
<body>

<div class="container">

    <div class="header clearfix">
        <ul class="nav nav-pills pull-right">
            <li class="active"><a href="/">Accueil</a></li>
            <li><a href="#list">Liste des annonces</a></li>
            <li><a href="#upload">Ajouter</a></li>
        </ul>
        <h3 class="text-muted">Advertisement Board</h3>
    </div>

    <hr/>

    <div class="jumbotron">
        <h1>
            Vos annonce<br/>dans Advertisement Board
        </h1>
        <p class="lead">En un clic, ajouter votre annonce!</p>
        <a class="btn btn-large btn-success" href="#upload">Ajouter une annonce</a>
        <hr/>


        <form action="/annonce.jsp" method="get" enctype="multipart/form-data">

            <table>

                <tr>
                    <td><label>Prix &nbsp;&nbsp;&nbsp;</label></td>
                    <td><input type="text" name="search" placeholder="Search.."/>&nbsp;&nbsp;&nbsp;</td>
                    <td>
                        <div class="form-actions">
                            <input class="btn-success" type="submit" class="btn"
                                   value="Rechercher"/>
                        </div>
                    </td>
                </tr>

            </table>

        </form>


    </div>

    <hr/>


    <div class="container-fluid">
        <div class="row">


            <div class="row-fluid iconlist" id="list">

                <h2>Liste des annonces</h2>

                <%
                    List<Upload> uploads = (List<Upload>) request.getAttribute("uploads");
                    if (uploads.size() == 0) {
                %>

                <p>
                    <em>Aucune annonce uploadée</em>
                </p>

                <%
                } else {
                %>

                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th>Image</th>
                            <th>Titre</th>
                            <th>Description</th>
                            <th>Prix</th>
                            <th>Date</th>
                            <th>Supprimer</th>
                        </tr>
                        </thead>

                        <%
                            for (Upload upload : uploads) {

                        %>
                        <div class="row">


                            <tbody>
                            <tr>
                                <td><img src="<%=upload.getUrl()%>" alt="Image utilisateur"
                                         class="img-polaroid" style="max-height: 100px; max-width: 100px;"/></td>
                                <td><%=upload.getTitre()%>
                                </td>
                                <td><%=upload.getDescription()%>
                                </td>
                                <td><%=upload.getPrix()%> €</td>
                                <td><%=upload.getDate()%>
                                </td>
                                <td>
                                    <figcaption>
                                        <a class="close" href="/?delete=<%=upload.getKeyString() %>">&times;</a>
                                    </figcaption>
                                </td>
                            </tr>

                            </tbody>
                                <%
                                    }
                                }%>


                    </table>
                </div>

            </div>

        </div>

        <hr/>

        <div class="row-fluid iconlist" id="upload">


            <h2>Ajouter une annonce</h2>


            <form action="<%= blobstoreService.createUploadUrl("/") %>" method="post" enctype="multipart/form-data">

                <table>

                    <tr>
                        <th><label>Image </label></th>
                        <td><input type="file" name="uploadedFile"/></td>
                    </tr>

                    <tr>
                        <th><label>Titre </label></th>
                        <td><input type="text" name="titre"/></td>
                    </tr>
                    <tr>
                        <th><label>Description </label></th>
                        <td>
                            <textarea name="description" rows="3" cols="60"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th><label>Prix </label></th>
                        <td><input type="text" name="prix"/></td>
                    </tr>
                </table>

                <div class="form-actions">
                    <input class="btn btn-large btn-success" type="submit" class="btn"/>
                </div>
            </form>

        </div>

    </div>
</div>
</body>
</html>