import { writable } from "svelte/store";

export const visibility = writable<{
  show: boolean;
  type: "admin" | "user" | "chat";
}>({
  show: false,
  type: "user",
});
