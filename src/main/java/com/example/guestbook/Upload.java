package com.example.guestbook;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.ServingUrlOptions;
import com.googlecode.objectify.annotation.Cache;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

import java.util.Date;


@Entity
@Cache
public class Upload {
    public String author_email;
    public String author_id;
    @Id
    Long id;
    @Index
    Date date;
    String url;
    @Index
    BlobKey key;
    String titre;
    String description;
    String prix;

    private Upload() {
    }

    public Upload(BlobKey key, String titre, String description, String prix) {
        ImagesService imagesService = ImagesServiceFactory.getImagesService();
        this.date = new Date();
        this.titre = titre;
        this.key = key;
        this.url = imagesService.getServingUrl(ServingUrlOptions.Builder.withBlobKey(key));
        this.description = description;
        this.prix = prix;
    }

    public String getAuthor_email() {
        return author_email;
    }

    public void setAuthor_email(String author_email) {
        this.author_email = author_email;
    }

    public String getAuthor_id() {
        return author_id;
    }

    public void setAuthor_id(String author_id) {
        this.author_id = author_id;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getPrix() {
        return prix;
    }

    public void setPrix(String prix) {
        this.prix = prix;
    }

    public String getUrl() {
        return url;
    }

    public BlobKey getKey() {
        return key;
    }

    public String getKeyString() {
        return key.getKeyString();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

}