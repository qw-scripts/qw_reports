<script lang="ts">
  import { cubicOut, cubicIn } from "svelte/easing";
  import { fade } from "svelte/transition";

  interface ChatMessage {
    text: string;
    sender: string;
  }

  let message: string = "";

  let chatMessages: ChatMessage[] = [];

  function addChatMessage() {
    if (message !== "") {
      chatMessages = [...chatMessages, { text: message, sender: "testing" }];
      message = "";
    }
  }
</script>

<div
  class="container bg-gray-800 text-gray-50 rounded-lg"
  in:fade={{ duration: 400, easing: cubicOut }}
  out:fade={{ duration: 400, easing: cubicIn }}
>
  <div
    class="px-2 py-3 rounded-t-lg bg-gray-900 flex items-center justify-between"
  >
    <h1 class="text-2xl font-medium">Report Chat</h1>
  </div>
  <div class="mt-2 flex flex-col gap-2 h-[80%] overflow-y-auto px-2">
    {#each chatMessages as message}
      <div>
        <div class="bg-gray-700 p-1.5 rounded-lg shadow-md">
          <span class="font-medium text-gray-300 mb-1 ml-1"
            >{message.sender}</span
          >
          <p class="text-sm text-gray-300">{message.text}</p>
        </div>
      </div>
    {/each}
  </div>
  <div class="mt-2 flex flex-col gap-3 relative bg-gray-900 z-40">
    <form
      class="flex items-center fixed bottom-2 gap-2 w-full px-2"
      on:submit|preventDefault={addChatMessage}
    >
      <input
        bind:value={message}
        type="text"
        placeholder="message..."
        class="border-2 bg-gray-700 px-3 py-2 rounded-md shadow-md border-gray-600 flex-1"
      />
      <button
        type="submit"
        disabled={message === ""}
        class="border-2 border-gray-600 bg-gray-700 px-3 py-2 rounded-md shadow-md font-medium hover:bg-gray-600 transition-all flex gap-2 items-center justify-center disabled:bg-gray-700/80 disabled:cursor-not-allowed"
      >
        Send
      </button>
    </form>
  </div>
</div>

<style>
  .container {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    height: 65%;
    width: 25%;
    user-select: none;
  }
</style>
