<script lang="ts">
  import { useNuiEvent } from "@hooks/useNuiEvent";
  import { useFetchNui } from "@hooks/useFetchNui";
  import { onMount } from "svelte";
  import { visibility } from "@store/visibility";
  import AdminReports from "@components/AdminReports.svelte";
  import NewReport from "@components/NewReport.svelte";
  import Chat from "@components/Chat.svelte";

  let isVisible: boolean;
  let currentAccess: string;

  visibility.subscribe((visible) => {
    isVisible = visible.show;
    currentAccess = visible.type;
  });
  useNuiEvent<{ show: boolean; type: "admin" | "user" | "chat" }>(
    "setVisible",
    (data: { show: boolean; type: "admin" | "user" | "chat" }) => {
      visibility.set({ show: data.show, type: data.type });
    }
  );
  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (isVisible && ["Escape"].includes(e.code)) {
        useFetchNui("hideUI");
        visibility.set({ show: false, type: "user" });
      }
    };
    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  });
</script>

<main>
  {#if isVisible}
    {#if currentAccess === "admin"}
      <AdminReports />
    {:else if currentAccess === "user"}
      <NewReport />
    {:else}
      <Chat />
    {/if}
  {/if}
</main>
