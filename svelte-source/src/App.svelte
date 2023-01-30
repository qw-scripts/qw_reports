<script lang="ts">
  import VisibilityProvider from "@providers/VisibilityProvider.svelte";
  import { debugData } from "@utils/debugData";

  debugData([
    {
      action: "setVisible",
      data: true,
    },
  ]);
</script>

<main>
  <VisibilityProvider>
    <div class="container bg-neutral-900 text-neutral-50">
      <h1>testing</h1>
    </div>
  </VisibilityProvider>
</main>

<style>
  .container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    border-radius: 5px;
    min-height: 85%;
    min-width: 85%;
    user-select: none;
  }
</style>
