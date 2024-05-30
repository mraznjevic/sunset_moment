<template>
  <div class="login-container">
    <div class="row">
      <div class="col-1"></div>
      <div class="col-10">
        <form @submit.prevent="postNewImage" class="mb-5">
          <div class="form-group">
            <croppa
              :width="400"
              :height="400"
              placeholder="Učitaj sliku..."
              v-model="imageReference"
            ></croppa>
          </div>
          <div class="form-group">
            <label for="imageDescription">Description</label>
            <input
              v-model="newImageDescription"
              type="text"
              class="form-control ml-2"
              placeholder="Enter the image description"
              id="imageDescription"
            />
          </div>
          <button type="submit" class="btn btn-primary ml-2">Post image</button>
        </form>
        <sunset-moments-card
          v-for="card in filteredCards"
          :key="card.id"
          :info="card"
        />
      </div>
      <div class="col-1">... ovo je 3. stupac!</div>
    </div>
  </div>
</template>

<script>
import SunsetMomentsCard from "@/components/SunsetMomentsCard.vue";
import store from "@/store";
import { db, storage } from "@/firebase";

//cards = [
// {url: require("@/assets/images/sunset1.jpg"),description: "evening sunset",time: "few minutes ago...",},
// {url: require("@/assets/images/sunset2.jpg"),description: "nature sunset",time: "hour ago...",},
//{url: require("@/assets/images/sunset3.jpg"),description: "mountain sunset",time: "few hours ago...",},
// {url: require("@/assets/images/sunset4.jpg"),description: "relax moments",time: "9 hours ago...",},
//];

export default {
  name: "home",
  data() {
    return {
      cards: [],
      store: store,
      newImageUrl: "", // url nove slike
      newImageDescription: "", // opis nove slike
      imageReference: null,
    };
  },
  mounted() {
    this.getPosts();
  },
  methods: {
    getPosts() {
      console.log("firebase dohvat...");
      db.collection("posts")
        .orderBy("posted_at", "desc")
        .limit(10)
        .get()
        .then((query) => {
          this.cards = [];
          query.forEach((doc) => {
            const data = doc.data();
            this.cards.push({
              id: doc.id,
              time: data.posted_at,
              description: data.description,
              url: data.url,
            });
          });
        });
    },
    postNewImage() {
      this.imageReference.generateBlob((blobData) => {
        console.log(blobData);

        let imageName =
          "posts/" + store.currentUser + "/" + Date.now() + ".png";

        storage
          .ref(imageName)
          .put(blobData)
          .then((result) => {
            // ... uspješno spremanje
            result.ref
              .getDownloadURL()
              .then((url) => {
                // čuva this
                console.log("Javni link", url);

                const imageDescription = this.newImageDescription;

                db.collection("posts")
                  .add({
                    url: url,
                    description: imageDescription,
                    email: store.currentUser,
                    posted_at: Date.now(),
                  })
                  .then((doc) => {
                    console.log("Spremljeno", doc);
                    this.newImageDescription = "";
                    this.imageReference=null;
                    this.getPosts();
                  })
                  .catch((e) => {
                    console.error(e);
                  });
              })
              .catch((e) => {
                console.error(e);
              });
          })
          .catch((e) => {
            console.error(e);
          });
      });
    },
  },
  computed: {
    filteredCards() {
      let termin = this.store.searchTerm;
      return this.cards.filter((card) => card.description.indexOf(termin) >= 0);
    },
  },
  components: {
    SunsetMomentsCard,
  },
};
</script>
