<template>
<div class="login-container">
  <div v-if="image" class="image-detail">
    <h1>{{ image.description }}</h1>
    <img :src="image.url" :alt="image.description" class="image"/>
    <div class="comments-section">
      <h2>Komentari</h2>
      <div v-for="comment in image.comments" :key="comment.timestamp" class="comment">
        <p class="comment-text">{{ comment.text }}</p>
        <span class="comment-user">{{ comment.user }}</span>
        <span class="comment-date">{{ formatDate(comment.timestamp) }}</span>
      </div>
    </div>
    <div class="add-comment">
      <input type="text" v-model="newCommentText" placeholder="Dodaj komentar..." class="comment-input"/>
      <button @click="addComment" class="comment-button">Dodaj komentar</button>
    </div>
  </div>
  <div v-else class="loading">
    <p>Učitavanje...</p>
  </div>
  </div>
</template>

<script>
import { db } from '@/firebase';
import moment from 'moment';
import store from '@/store';

export default {
  data() {
    return {
      image: null,
      newCommentText: ''
    };
  },
  created() {
    this.fetchImage();
  },
  methods: {
    fetchImage() {
      const imageId = this.$route.params.id;
      db.collection('posts').doc(imageId).get().then(doc => {
        if (doc.exists) {
          this.image = doc.data();
        } else {
          console.error("Slika nije pronađena");
        }
      }).catch(error => {
        console.error("Greška prilikom dohvaćanja slike:", error);
      });
    },
    addComment() {
      if (!this.newCommentText) return;

      db.collection('posts').doc(this.$route.params.id).update({
        comments: firebase.firestore.FieldValue.arrayUnion({
          user: store.currentUser,
          text: this.newCommentText,
          timestamp: Date.now()
        })
      }).then(() => {
        this.fetchImage();  // Osvježi prikaz slike i komentara nakon dodavanja novog komentara
        this.newCommentText = '';
      }).catch(error => {
        console.error("Greška prilikom dodavanja komentara:", error);
      });
    },
    formatDate(timestamp) {
      return moment(timestamp).format('DD.MM.YYYY HH:mm');
    }
  }
};
</script>

<style scoped>
.image-detail {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  text-align: center;
}

.image {
  max-width: 100%;
  height: auto;
  border-radius: 10px;
  margin-bottom: 20px;
}

.comments-section {
  margin-top: 30px;
}

.comments-section h2 {
  margin-bottom: 15px;
  font-size: 1.5em;
}

.comment {
  background-color: #f9f9f9;
  padding: 10px;
  margin-bottom: 10px;
  border-radius: 5px;
  text-align: left;
}

.comment-text {
  margin: 0 0 5px 0;
}

.comment-user {
  display: block;
  font-weight: bold;
}

.comment-date {
  display: block;
  font-size: 0.9em;
  color: #888;
}

.add-comment {
  margin-top: 20px;
}

.comment-input {
  width: calc(100% - 120px);
  padding: 10px;
  margin-right: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.comment-button {
  padding: 10px 20px;
  background-color: #007bff;
  border: none;
  color: #fff;
  border-radius: 5px;
  cursor: pointer;
}

.comment-button:hover {
  background-color: #0056b3;
}

.loading {
  text-align: center;
  padding: 20px;
}
</style>
