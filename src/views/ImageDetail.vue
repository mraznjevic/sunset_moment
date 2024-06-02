<template>
  <div v-if="image">
    <h1>{{ image.description }}</h1>
    <img :src="image.url" :alt="image.description" />
    <div v-for="comment in image.comments" :key="comment.timestamp">
      <p>{{ comment.text }}</p>
      <span>{{ comment.user }}</span>
      <span>{{ formatDate(comment.timestamp) }}</span>
    </div>
    <div>
      <input type="text" v-model="newCommentText" placeholder="Dodaj komentar..." />
      <button @click="addComment">Dodaj komentar</button>
    </div>
  </div>
  <div v-else>
    <p>Učitavanje...</p>
  </div>
</template>

<script>
import { db } from '@/firebase';
import moment from 'moment';

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
