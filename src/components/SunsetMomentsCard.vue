<template>
  <div class="card text-center">
    <div class="card-header">
      {{ info.description }}
    </div>
    <div class="card-body p-0">
      <router-link :to="{ name: 'ImageDetail', params: { id: info.id } }">
        <img class="card-img-top" :src="info.url" />
      </router-link>
    </div>
    <div class="card-footer text-muted">
      {{ postedFromNow }}
    </div>
    <!-- Prikaz postojećih komentara -->
    <div class="comments">
      <div v-for="(comment, index) in info.comments" :key="index" class="comment">
        <p>{{ comment.text }}</p>
        <span>{{ comment.user }}</span>
        <span>{{ formatDate(comment.timestamp) }}</span>
      </div>
    </div>
    <!-- Unos novog komentara -->
    <div class="add-comment">
      <input type="text" v-model="newCommentText" placeholder="Dodaj komentar..." />
      <button @click="addNewComment">Dodaj komentar</button>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
export default {
  props: ["info"],
  name: "SunsetMomentsCard",
  computed: {
    postedFromNow() {
      return moment(this.info.time).fromNow();
    },
  },
  data() {
    return {
      newCommentText: ''
    };
  },
  methods: {
    addNewComment() {
      if (!this.newCommentText) return;
      this.$emit('add-comment', this.info.id, this.newCommentText);
      this.newCommentText = '';
    },
    formatDate(timestamp) {
      return new Date(timestamp).toLocaleString();
    }
  }
};
</script>



<style scoped>
.comments {
  margin-top: 10px;
}

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