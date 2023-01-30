<script lang="ts">
  import { useFetchNui } from "@hooks/useFetchNui";
  import { visibility } from "@store/visibility";
  import { cubicOut, cubicIn } from "svelte/easing";
  import { fade } from "svelte/transition";

  let report: { name: string; discord: string; detail: string } = {
    name: "",
    discord: "",
    detail: "",
  };

  let isSubmitting: boolean = false;
  let error: boolean = false;

  async function submitReport() {
    if (report.name !== "" && report.discord !== "" && report.detail !== "") {
      isSubmitting = true;
      const response = await useFetchNui("reports/CreateReport", report);

      setTimeout(() => {
        isSubmitting = false;
        report = {
          name: "",
          discord: "",
          detail: "",
        };
        useFetchNui("hideUI");
        visibility.set({ show: false, type: "user" });
      }, 1000);
    } else {
      error = true;

      setTimeout(() => {
        error = false;
      }, 1500);
    }
  }
</script>

<div
  class="container bg-gray-800 text-gray-50 rounded-lg"
  in:fade={{ duration: 400, easing: cubicOut }}
  out:fade={{ duration: 400, easing: cubicIn }}
>
  <div class="px-2 py-3 rounded-t-lg bg-gray-900">
    <h1 class="text-2xl font-medium">New Report</h1>
  </div>
  <form
    class="mt-2 flex flex-col items-center justify-center gap-3 p-2"
    on:submit|preventDefault={submitReport}
  >
    <div class="w-3/4 flex flex-col gap-2">
      <label for="report-name" class="font-medium text-sm">Report Name</label>
      <input
        bind:value={report.name}
        type="text"
        placeholder="Im noob..."
        class="border-2 bg-gray-700 px-3 py-2 rounded-md shadow-md {error
          ? 'border-red-500'
          : 'border-gray-600'}"
      />
    </div>
    <div class="w-3/4 flex flex-col gap-2">
      <label for="discord-id" class="font-medium text-sm">Discord ID</label>
      <input
        bind:value={report.discord}
        type="text"
        placeholder="qwadebot#0001"
        class="border-2 bg-gray-700 px-3 py-2 rounded-md shadow-md {error
          ? 'border-red-500'
          : 'border-gray-600'}"
      />
    </div>
    <div class="w-3/4 flex flex-col gap-2">
      <label for="report-details" class="font-medium text-sm"
        >Report Detail</label
      >
      <textarea
        bind:value={report.detail}
        placeholder="report details here..."
        rows="10"
        class="border-2 {error
          ? 'border-red-500'
          : 'border-gray-600'} bg-gray-700 px-3 py-2 rounded-md shadow-md resize-none"
      />
    </div>
    <button
      type="submit"
      disabled={isSubmitting}
      class="border border-gray-600 bg-gray-700 px-3 py-2 rounded-md shadow-md w-3/4 mt-2 font-medium hover:bg-gray-600 transition-all flex gap-2 items-center justify-center disabled:bg-gray-700/80 disabled:cursor-not-allowed"
    >
      {#if isSubmitting}
        <svg
          role="status"
          class="inline mr-3 w-4 h-4 text-gray-50 animate-spin"
          viewBox="0 0 100 101"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
            fill="#E5E7EB"
          />
          <path
            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
            fill="currentColor"
          />
        </svg>
      {/if}
      Send Report
    </button>
  </form>
</div>

<style>
  .container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    height: 62%;
    width: 30%;
    user-select: none;
  }
</style>
