<script lang="ts">
  import { useFetchNui } from "@hooks/useFetchNui";
  import { visibility } from "@store/visibility";
  import { isEnvBrowser } from "@utils/misc";
  import { onMount } from "svelte";
  import { cubicOut, cubicIn } from "svelte/easing";
  import { fade } from "svelte/transition";

  interface Report {
    report_title: string;
    report_details: string;
    report_type: string;
    report_src: number;
    report_id: string;
  }

  let reports: Report[] = [];

  async function concludeReport(reportID: string, reportSrc: number) {
    if (isEnvBrowser()) return;

    const response = await useFetchNui("reports/DeleteReport", {
      report_id: reportID,
      report_src: reportSrc,
    });

    if (response === "ok") {
      reports = reports.filter((report) => report.report_id !== reportID);
    }
  }

  async function bringPlayer(reportSrc: number) {
    if (isEnvBrowser()) return;

    const response = await useFetchNui("actions/actionHandler", {
      report_src: reportSrc,
      action: "bring",
    });

    if (response === "ok") {
      visibility.set({ show: false, type: "user" });
      useFetchNui("hideUI");
    }
  }

  async function gotoPlayer(reportSrc: number) {
    if (isEnvBrowser()) return;

    const response = await useFetchNui("actions/actionHandler", {
      report_src: reportSrc,
      action: "goto",
    });

    if (response === "ok") {
      visibility.set({ show: false, type: "user" });
      useFetchNui("hideUI");
    }
  }

  function openChat(reportID: string) {
    console.log(reportID);
    visibility.set({ show: true, type: "chat" });
  }

  onMount(async () => {
    if (isEnvBrowser()) return;

    const currentReports = await useFetchNui<Report[] | []>(
      "reports/GetReports"
    );
    reports = currentReports;
  });
</script>

<div
  class="container bg-gray-800 text-gray-50 rounded-lg"
  in:fade={{ duration: 400, easing: cubicOut }}
  out:fade={{ duration: 400, easing: cubicIn }}
>
  <div
    class="px-2 py-3 rounded-t-lg bg-gray-900 flex items-center justify-between"
  >
    <h1 class="text-2xl font-medium">Active Reports</h1>
    <p class="bg-gray-800 p-1.5 rounded-md text-sm text-gray-500 font-medium">
      {reports.length} total {reports.length > 1 || reports.length == 0
        ? "reports"
        : "report"}
    </p>
  </div>
  <div class="mt-2 px-2 flex flex-col gap-3 h-[90%] overflow-y-auto">
    {#each reports as report}
      <div
        class="bg-gray-700 px-3 py-2 rounded-md shadow-md flex flex-col"
        out:fade={{ duration: 400, easing: cubicIn }}
      >
        <div class="flex items-start justify-between">
          <div>
            <p class="font-medium text-lg">{report.report_title}</p>
            <p class="text-sm text-gray-400">
              {report.report_type} - Player ID: {report.report_src}
            </p>
          </div>
          <p
            class="bg-gray-800 p-1.5 rounded-md text-xs text-gray-500 font-medium"
          >
            {report.report_id}
          </p>
        </div>
        <p class="text-gray-100 text-sm mt-2">
          {report.report_details}
        </p>
        <div class="flex gap-2 items-center justify-between mt-3">
          <div>
            <!-- <button
              class="border border-gray-500 bg-gray-600 px-3 py-2 rounded-md shadow-md font-medium hover:bg-gray-500 transition-all flex gap-2 items-center justify-center disabled:bg-gray-700/80 disabled:cursor-not-allowed text-sm"
              on:click={() => openChat(report.report_id)}
            >
              Open Chat
            </button> -->
          </div>
          <div class="flex gap-2 items-center">
            <button
              class="border border-gray-700 bg-gray-800 px-3 py-2 rounded-md shadow-md font-medium hover:bg-gray-800/80 transition-all flex gap-2 items-center justify-center disabled:bg-gray-700/80 disabled:cursor-not-allowed text-sm"
              on:click={() => bringPlayer(report.report_src)}
            >
              Bring Player
            </button>
            <button
              class="border border-gray-700 bg-gray-800 px-3 py-2 rounded-md shadow-md font-medium hover:bg-gray-800/80 transition-all flex gap-2 items-center justify-center disabled:bg-gray-700/80 disabled:cursor-not-allowed text-sm"
              on:click={() => gotoPlayer(report.report_src)}
            >
              Goto Player
            </button>
            <button
              class="border border-gray-500 bg-gray-600 px-3 py-2 rounded-md shadow-md font-medium hover:bg-gray-500 transition-all flex gap-2 items-center justify-center disabled:bg-gray-700/80 disabled:cursor-not-allowed text-sm"
              on:click={() =>
                concludeReport(report.report_id, report.report_src)}
            >
              Conclude Report
            </button>
          </div>
        </div>
      </div>
    {/each}
  </div>
</div>

<style>
  .container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    height: 65%;
    width: 65%;
    user-select: none;
  }
</style>
