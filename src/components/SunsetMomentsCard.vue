<template>
  <div class="card text-center">
    <div class="card-header">
      {{ info.description }}
    </div>
    <div class="card-body p-0">
      <img class="card-img-top" :src="info.url" alt="Image" />
    </div>
    <div class="card-footer text-muted">
      {{ info.time }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'SunsetMomentsCard',
  props: {
    info: {
      type: Object,
      required: true
    }
  }
};
</script>

<style scoped>
.card-img-top {
  width: 100%;
  height: auto;
}
</style>


