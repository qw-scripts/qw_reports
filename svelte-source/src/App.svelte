<script lang="ts">
  import VisibilityProvider from "@providers/VisibilityProvider.svelte";
  import { debugData } from "@utils/debugData";

  debugData([
    {
      action: "setVisible",
      data: {
        show: true,
        type: "admin",
      },
    },
  ]);
</script>

<VisibilityProvider />
