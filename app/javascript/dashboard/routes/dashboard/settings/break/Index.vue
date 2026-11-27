<script setup>
import { computed, onMounted, ref } from 'vue';
import { useStore } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import NextButton from 'dashboard/components-next/button/Button.vue';

const store = useStore();
const inboxes = computed(() => store.getters['inboxes/getInboxes']);
const inboxId = ref('');
const config = ref({ enabled: false, start: '12:00', end: '13:00', days: ['Mon','Tue','Wed','Thu','Fri','Sat'], message: '', message_short: '', timezone: 'Asia/Jakarta' });
const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const selectedInbox = computed(() => inboxes.value.find(item => String(item.id) === String(inboxId.value)));
const loadConfig = () => { config.value = { enabled: false, start: '12:00', end: '13:00', days: ['Mon','Tue','Wed','Thu','Fri','Sat'], message: '', message_short: '', timezone: 'Asia/Jakarta', ...(selectedInbox.value?.break_config || {}) }; };
onMounted(async () => { if (!inboxes.value.length) await store.dispatch('inboxes/get'); inboxId.value = String(inboxes.value[0]?.id || ''); loadConfig(); });
const save = async () => { try { await store.dispatch('inboxes/updateInbox', { id: selectedInbox.value.id, break_config: config.value, channel: {} }); useAlert('Pengaturan jam istirahat tersimpan'); } catch (error) { useAlert(error.message); } };
</script>

<template>
  <section class="w-full max-w-3xl p-6">
    <h1 class="text-heading-1 mb-6">Jam Istirahat</h1>
    <label class="block mb-4">Inbox<select v-model="inboxId" class="form-input" @change="loadConfig"><option v-for="inbox in inboxes" :key="inbox.id" :value="String(inbox.id)">{{ inbox.name }}</option></select></label>
    <div v-if="selectedInbox" class="flex flex-col gap-4">
      <label><input v-model="config.enabled" type="checkbox"> Aktifkan balasan jam istirahat</label>
      <label>Mulai <input v-model="config.start" type="time" class="form-input"></label>
      <label>Selesai <input v-model="config.end" type="time" class="form-input"></label>
      <fieldset><legend>Hari</legend><label v-for="day in days" :key="day" class="inline-flex gap-1 mr-3"><input v-model="config.days" type="checkbox" :value="day">{{ day }}</label></fieldset>
      <label>Pesan balasan<textarea v-model="config.message" class="form-input" rows="4" /></label>
      <NextButton label="Simpan" @click="save" />
    </div>
  </section>
</template>
