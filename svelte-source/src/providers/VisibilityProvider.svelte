<script lang="ts">
  import { useNuiEvent } from "@hooks/useNuiEvent";
  import { useFetchNui } from "@hooks/useFetchNui";
  import { onMount } from "svelte";
  import { visibility } from "@store/visibility";

  let isVisible: boolean;
  visibility.subscribe((visible) => {
    isVisible = visible;
  });
  useNuiEvent<boolean>("setVisible", (visible) => {
    visibility.set(visible);
  });
  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (isVisible && ["Escape"].includes(e.code)) {
        useFetchNui("hideUI");
        visibility.set(false);
      }
    };
    window.addEventListener("keydown", keyHandler);
    return () => window.removeEventListener("keydown", keyHandler);
  });
</script>

<main>
  {#if isVisible}
    <slot />
  {/if}
</main>
