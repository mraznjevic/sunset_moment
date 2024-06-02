<template>
  <div>
    <h2>{{ image.description }}</h2>
    <img :src="image.url" :alt="image.description" style="max-width: 100%; max-height: 80vh;">
    <div v-if="image.comments && image.comments.length">
      <h3>Komentari</h3>
      <div v-for="(comment, index) in image.comments" :key="index" class="comment">
        <p>{{ comment.text }}</p>
        <span>{{ comment.user }}</span>
        <span>{{ formatDate(comment.timestamp) }}</span>
      </div>
    </div>
    <div class="add-comment">
      <input type="text" v-model="newCommentText" placeholder="Dodaj komentar..." />
      <button @click="addNewComment">Dodaj komentar</button>
    </div>
  </div>
</template>

<script>
import { db } from "@/firebase";
import store from '@/store';
import firebase from 'firebase/app';

export default {
  data() {
    return {
      image: null,
      newCommentText: '',
    };
  },
  created() {
    this.fetchImage();
  },
  methods: {
    fetchImage() {
      const imageId = this.$route.params.id;
      db.collection("posts").doc(imageId).get().then((doc) => {
        if (doc.exists) {
          this.image = { ...doc.data(), id: doc.id };
        } else {
          console.error("Ne postoji slika s ID-om:", imageId);
        }
      }).catch((error) => {
        console.error("Greška prilikom dobijanja slike:", error);
      });
    },
    addNewComment() {
      if (!this.newCommentText) return;

      db.collection("posts").doc(this.image.id).update({
        comments: firebase.firestore.FieldValue.arrayUnion({
          user: store.currentUser,
          text: this.newCommentText,
          timestamp: Date.now()
        })
      }).then(() => {
        console.log("Komentar uspješno dodan");
        this.fetchImage(); // Osvježiti prikaz slike ili komentara nakon dodavanja komentara
        this.newCommentText = '';
      }).catch((error) => {
        console.error("Greška prilikom dodavanja komentara:", error);
      });
    },
    formatDate(timestamp) {
      return new Date(timestamp).toLocaleString();
    }
  }
};
</script>

<style scoped>
.comment {
  margin-bottom: 10px;
}

.add-comment {
  margin-top: 20px;
}

.add-comment input {
  width: 70%;
  margin-right: 10px;
}

.add-comment button {
  background-color: #007bff;
  color: #fff;
  border: none;
  padding: 5px 10px;
  border-radius: 5px;
}

.add-comment button:hover {
  background-color: #0056b3;
}
</style>
