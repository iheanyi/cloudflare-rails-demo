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
      animation: 150,
      ghostClass: "sortable-ghost",
      dragClass: "sortable-drag",
      handle: ".card-handle",
      filter: "a, button, input, textarea, select",
      preventOnFilter: false,
      onEnd: this.onEnd.bind(this)
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }

  private async onEnd(event: Sortable.SortableEvent) {
    const cardId = event.item.dataset.cardId
    const newColumnId = (event.to as HTMLElement).dataset.columnId
    const newPosition = event.newIndex !== undefined ? event.newIndex + 1 : 1

    if (!cardId || !newColumnId) return

    const csrfToken = document.querySelector<HTMLMetaElement>('meta[name="csrf-token"]')?.content

    await fetch(`/boards/${this.boardIdValue}/cards/${cardId}/move`, {
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
  }
}
