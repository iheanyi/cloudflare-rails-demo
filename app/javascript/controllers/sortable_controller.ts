import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = {
    boardId: Number
  }

  declare boardIdValue: number
  private sortable: Sortable | null = null

  connect() {
    this.sortable = Sortable.create(this.element as HTMLElement, {
      group: "board",
      animation: 200,
      easing: "cubic-bezier(0.25, 1, 0.5, 1)",
      ghostClass: "sortable-ghost",
      chosenClass: "sortable-chosen",
      dragClass: "sortable-drag",
      handle: ".card-handle",
      filter: "a, button, input, textarea, select, form",
      preventOnFilter: false,
      forceFallback: true,
      fallbackClass: "sortable-fallback",
      fallbackOnBody: true,
      swapThreshold: 0.65,
      onStart: this.onStart.bind(this),
      onEnd: this.onEnd.bind(this)
    })
  }

  disconnect() {
    this.sortable?.destroy()
    this.sortable = null
  }

  private onStart() {
    document.body.classList.add("is-dragging")
    document.querySelectorAll('[data-controller="sortable"]').forEach(el => {
      el.classList.add("sortable-drop-zone")
    })
  }

  private async onEnd(event: Sortable.SortableEvent) {
    document.body.classList.remove("is-dragging")
    document.querySelectorAll(".sortable-drop-zone").forEach(el => {
      el.classList.remove("sortable-drop-zone")
    })

    const cardId = event.item.dataset.cardId
    const newColumnId = (event.to as HTMLElement).dataset.columnId
    const newPosition = event.newIndex !== undefined ? event.newIndex + 1 : 1

    if (!cardId || !newColumnId) return

    const csrfToken = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.content

    try {
      const response = await fetch(`/boards/${this.boardIdValue}/cards/${cardId}/move`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken || "",
          "Accept": "text/vnd.turbo-stream.html"
        },
        body: JSON.stringify({
          card: { board_column_id: newColumnId, position: newPosition }
        })
      })

      if (!response.ok) {
        console.error("Move failed:", response.status)
        window.location.reload()
      }
    } catch (error) {
      console.error("Move error:", error)
      window.location.reload()
    }
  }
}
